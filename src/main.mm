namespace node {
    int Start(int argc, char* argv[]);
}

int main(int argc, char *argv[]){
    @autoreleasepool {
        NSLog(@"Node.js CLI starting on iOS");

        // Call the real Node.js main
        return node::Start(argc, argv);
    }
}