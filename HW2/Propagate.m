function [forest, toPropagate, fireSize] = Propagate(forest,toPropagate,fireSize)
    N = length(forest);
    tmpToPropagate = [];
    i = toPropagate(1,1);
    j = toPropagate(1,2);

    addToPropagation = [];
    
    if forest(i,j) == 1
        fireSize = fireSize + 1;
        forest(i,j) = 0;
        if i - 1 > 0
            if forest(i-1,j) == 1
                tmpToPropagate = [tmpToPropagate; [i-1,j]];
            end
        else
            if forest(N,j) == 1
                tmpToPropagate = [tmpToPropagate; [N,j]];
            end
        end

        if i + 1 <= N
            if forest(i+1,j) == 1
                tmpToPropagate = [tmpToPropagate; [i+1,j]];
            end
        else
            if forest(1,j) == 1
                tmpToPropagate = [tmpToPropagate; [1,j]];
            end
        end

        if j - 1 > 0
            if forest(i,j-1) == 1
                tmpToPropagate = [tmpToPropagate; [i,j-1]];
            end
        else
            if forest(i,N) == 1
                tmpToPropagate = [tmpToPropagate; [i,N]];
            end
        end

        if j + 1 <= N
            if forest(i,j+1) == 1
                tmpToPropagate = [tmpToPropagate; [i,j+1]];
            end
        else
            if forest(i,1) == 1
                tmpToPropagate = [tmpToPropagate; [i,1]];
            end
        end
    
        for i = 1:size(tmpToPropagate,1)
            if ~ismember(tmpToPropagate(i,:),toPropagate,'rows')
                addToPropagation = [addToPropagation; tmpToPropagate(i,:)];
            end
        end
    end
    
    toPropagate = [toPropagate(2:end,:); addToPropagation];
    
end

