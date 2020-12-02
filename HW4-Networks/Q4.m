clear all
A = LoadSmallWorldExample();
G = graph(A);
plot(G)
numTriangles = trace(A^3)/6;
d = degree(G);
numTriples = 0;
for i = 1:numnodes(G)
    numTriples = numTriples + d(i) * (d(i)-1)/2;
end
clusteringCoeff = numTriangles * 3 / numTriples;
title(strcat('CC = ',num2str(clusteringCoeff)));