
int factorial(int n)
{
    if (n == 0)
        return 1;
    else
        return n * factorial(n-1);
}

void main ()
{
    int f = 9;
    printf("Factorial of %d = %d\n", f, factorial(f));
}
