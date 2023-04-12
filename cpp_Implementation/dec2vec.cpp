#include <vector>

// Function to convert a single decimal state to vector representation.
std::vector<int> dec2vec(int dec, int n) {
    assert(dec <= pow(2, n)-1 && "dec too big for register size n!");
    std::vector<int> phi(pow(2, n), 0);
    phi[dec] = 1; 
    return phi;
}
