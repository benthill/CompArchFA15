<h2>is_prime README</h2>
Our Assembly test, `is_prime`, takes an input and searches for any possible multiples and factors to determine if the input is prime.

Input on `$a0` as any number. 
Output on `$v0` as a flag to show prime or not prime.

If no factors are found, then the number is prime and `$v0` is set to `0xb`. Otherwise, if the number is not prime, then `$v0` is set to `0xa`.
