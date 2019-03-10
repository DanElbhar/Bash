#!/bin/bash
function quit {
    echo "$(tput setaf 1)Test result: $(tput sgr 0)"
    result=$((4*Array[0]+2*Array[1]+Array[2]))
    echo "Compilation       Memory leaks      Thread race"
    echo "   ${Array2[0]}              ${Array2[1]}             ${Array2[2]}"
}

cd $1
Array=(1 1 1)
Array2=(FAIL FAIL FAIL)

    make &> \out.txt
    if [ "$?" -eq 0 ]; then
        if [ ! -e $2 ]; then
        quit
        exit $result
        fi

        Array[0]=0
        Array2[0]=PASS

        arg1="$2"
        shift 2
            
        echo "checking memcheck tool..."
        valgrind --tool=memcheck --leak-check=full --error-exitcode=3  ./$arg1 "$@" &>> \out.txt
        if [ "$?" -eq 0 ]; then
            Array[1]=0
            Array2[1]=PASS
        fi
        echo "checking helgrind tool..."
        valgrind --tool=helgrind  --error-exitcode=4 ./$arg1 "$@" &>> \out.txt
        if [ "$?" -eq 0 ]; then
            Array[2]=0
            Array2[2]=PASS
        fi
        quit
        exit $result
    else
        quit
        exit $result
    fi
