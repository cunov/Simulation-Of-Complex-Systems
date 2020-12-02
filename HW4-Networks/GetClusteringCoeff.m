function clusteringCoeff = GetClusteringCoeff(A)
    numTriangles = trace(A^3)/6;
    G = graph(A);
    d = degree(G);
    numTriples = 0;
    for i = 1:numnodes(G)
        numTriples = numTriples + d(i) * (d(i)-1)/2;
    end
    clusteringCoeff = numTriangles * 3 / numTriples;
end

