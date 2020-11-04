#include <stdio.h>
#include <pthread.h>

#define N 100000

volatile int counter = 0;
pthread_t threads[2];

extern void lock(long i);
extern void unlock(long i);

void* count(void* vid) {
    long id = (long)vid;
    printf("Starting thread %ld\n", id);
    for (int i = 0; i < N; ++i) {
        lock(id);
        counter++; 
        unlock(id);
    }
    printf("Exiting thread %ld\n", id);
}

int main(void) {
    printf("Start\n");
    for (long i = 0; i < 2; ++i)
        pthread_create(&threads[i], NULL, count, (void*)i);
    for (long i = 0; i < 2; ++i)
        pthread_join(threads[i], NULL);
    printf("%d\n", counter);
    printf("End\n");
}
