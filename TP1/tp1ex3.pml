int array[5] = {1, 20, 3, 4, 5};

proctype printSum(int i){
    int sum = 0;
    int j = 0;
    do
    :: j <= i -> 
        sum = sum + j; 
        j = j + 1;
    od;
}

proctype printMaxArray(int size){
    int max = 0;
    int i = 0;
    do
    :: i < size -> 
        if
        :: array[i] > max -> max = array[i];
        fi;
        i = i + 1;
    od;
}

init{
    run printSum(10);
    run printMaxArray(5);
}