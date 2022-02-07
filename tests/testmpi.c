#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    int rank, max_len;
    char processorname[MPI_MAX_PROCESSOR_NAME];
    MPI_Init(&argc,&argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Get_processor_name(processorname,&max_len);
    printf("Hello world!  I am process number: %d on processor %s\n", rank, processorname);
    MPI_Finalize();
    return 0;
}
