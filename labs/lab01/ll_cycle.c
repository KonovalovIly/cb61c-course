#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head)
{
    if (head == NULL)
    {
        return 0;
    }

    /* your code here */
    node *turt = head;
    node *rabbit = head->next;
    while (1)
    {
        if (turt == rabbit)
        {
            return 1;
        }
        if (turt->next == NULL)
        {
            return 0;
        }
        if (rabbit->next == NULL || rabbit->next->next == NULL)
        {
            return 0;
        }
        rabbit = rabbit->next->next;
        turt = turt->next;
    }
    return 0;
}
