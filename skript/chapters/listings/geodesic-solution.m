function solution = geodesic(x0, s)
        [solution, istate, msg] = lsode("dgeodesic", x0, s);
        if istate != 2
                printf("integration failed. %s\n", msg);
        endif
        solution = cat(2, s', solution);
endfunction
