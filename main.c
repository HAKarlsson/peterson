// Author: Henrik Karlsson
#include <stdio.h>
#include <pthread.h>

#define N 1000000

int counter = 0;
pthread_t threads[2];

volatile long t1;
volatile long t2;

extern void lock(long i);
extern void unlock(long i);

void* count(void* vid) {
    long id = (long)vid;
    for (int i = 0; i < N; ++i) {
        lock(id);
        counter++; 
        unlock(id);
    }
}

int main(void) {
    printf("Start\n");
    pthread_create(&threads[0], NULL, count, (void*)0L);
    pthread_create(&threads[1], NULL, count, (void*)1L);
    pthread_join(threads[0], NULL);
    pthread_join(threads[1], NULL);
    printf("%d\n", counter);
    printf("End\n");
}
