#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>

int main()
{
    const char* env_name = "TEST_ENV";
    const char* env_value = "PASSED";
    setenv(env_name, env_value, 1);
    printf("%s:%s=?%s", env_name, getenv(env_name), env_value);
    assert(strcmp(getenv(env_name), env_value)==0);

    //system("setenv TEST_ENV FAILED");
    system("echo $TEST_ENV");
    return 0;
}
