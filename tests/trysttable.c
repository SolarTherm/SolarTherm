#include <st_tables.h>

int main(void){
	void *t = st_table_init(10,10);
	if(t==NULL){
		return 127;
	}
	st_table_free(t);
	return 0;
}

