function [before, after] = WattsStrogatz(N,C,p)
    s = repmat(1:N,C-1,1);
    for i = 2:C-1
        s(i,:) = [s(i,i:end), s(i,1:i-1)];
    end

    t = reshape(s(2:end,:),1,[]);
    s = sort(repmat(s(1,:),1,C/2),'ascend');
    before = graph(s,t);

    edges = before.Edges{:,1};
    numEdges = length(edges);
    A = adjacency(before);
    for t = 1:numEdges
        if rand < p
            i = 1;
            j = 1;
            while i == j
                i = randi([1 N]);
                j = randi([1 N]);
            end
            if i < j
                A(i,j) = 1;
            else
                A(j,i) = 1;
            end
        end
    end
    after = graph(A,'upper');
end