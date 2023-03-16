int f(int a){
    return 3*a;
    a=9;
}

int g(int a, int b){
    int x;
    x=f(a)+a+b;
    return x;
}

int main(){
    int a,b;
    a=5;
    b=2;
    a=g(a,b);
    println(a);
    println(b);
    return 0;
}

