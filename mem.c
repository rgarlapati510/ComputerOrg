#include <stdio.h>

struct header {         /* block header */
    struct header *next; /* next block if on free list */
    unsigned size;     /* size of this block in Headersize units */
};
typedef struct header Header;

static Header base;             /* Anchor block so list is never empty */
static Header *freep = NULL;    /* starting of free list to search */
#define ALIGNBOUNDARY   16      /* align memory on 16 byte boundaries */
static int Headersize /* rounded up; use in place of sizeof(Header) */
                = ((sizeof(Header) - 1) / ALIGNBOUNDARY + 1) * ALIGNBOUNDARY; 

static Header *morecore(unsigned long);

/* malloc:  general-purpose storage allocator */
void *_malloc(unsigned long nbytes)
{
    Header *p, *prevp;
    unsigned long nunits;

    /* Allocate memory in Headersize units, so round up request */
    nunits = (nbytes + Headersize - 1) / Headersize + 1; 

    /* If no free list, initialize anchor block and add a block from the OS */
    if (freep  == NULL) { 
        freep = &base;
        base.size = 0;
        base.next = &base;
        if (morecore(nunits) == NULL)
            return NULL;    /* none left; give up */
    }

    /* Search the circular list for the next block that's big enough */
    for (prevp = freep, p = prevp->next; p->size < nunits;
                                        prevp = p, p = p->next) {
        /* If we've wrapped, ask the system for another block of memory */
        if (p == freep) 
            if ((p = morecore(nunits)) == NULL)
                return NULL;    /* none left; give up */
    }

    if (p->size == nunits)  
        /* Exact fit; remove the whole block from the free list */
        prevp->next = p->next;
    else {              
        /* Allocate the space at the tail of the block: make a header for */
        /* the new tail block and deduct its size from the existing block */
        p->size -= nunits;
        p += p->size;
        p->size = nunits;
    }
    /* Give the caller a pointer to the memory area after the Header */
    freep = prevp;
    return (char *)p + Headersize;
}

#define NALLOC  1024   /* minimum #units to request */

/* free:  put block ap in free list */
void _free(void *ap)
{
    Header *bp, *p;

    /* We gave a pointer to memory after the Header; back up to the Header */
    bp = (Header *)(ap - Headersize);

    /* Find p such that the freed block is between p and p->next */
    for (p = freep; !(p < bp && bp < p->next); p = p->next)
        /* is *bp at either end of the arena? */
        if (p >= p->next && (bp > p || bp < p->next))
            /* (Since the list is kept in order, if the next pointer */
            /* points back and the freed block is after p or before p->next, */
            /* then we're outside the current arena ) */
            break;  

    /* Look to see if we're adjacent to the block after the freed block */
    if ((char *)bp + bp->size * Headersize == (char *)p->next) {     
        /* add the block after to the freed block */
        bp->size += p->next->size;
        bp->next = p->next->next;
    } else
        bp->next = p->next;

    /* Look to see if we're adjacent to the block before the freed block */
    if ((char *)p + p->size * Headersize == (char *)bp) {
        /* add the freed block to the block at p */
        p->size += bp->size;
        p->next = bp->next;
    } else
        p->next = bp;
    /* Start the next search from this block */
    freep = p;
}

/* morecore:  ask system for more memory */
static Header *morecore(unsigned long nu)
{
    void *cp, *sbrk(int);
    Header *up;
    /* Don't ask for any less than NALLOC */
    if (nu < NALLOC)
        nu = NALLOC;
    cp = sbrk(nu * Headersize);
    if (cp == (void *) -1) /* no space available from the system */
        return NULL;

    /* Take the new block, add a header, and free() it */
    up = (Header *) cp;
    up->size = nu;
    _free((char *)up + Headersize);
    return freep;
}


/* showfreelist: print out the free list starting with freep */
void showfreelist(char *msg)
{
    Header *p;

    printf("\nFree list(%s):\n", msg);
    printf("%-10p size=%d ptr=%p\n", &base, base.size, base.next);
    for (p = base.next; p != NULL && p != &base; p = p->next) {
        printf("%-10p size=%d ptr=%p\n", p, p->size, p->next);
    }
}
