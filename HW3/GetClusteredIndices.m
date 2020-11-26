function blues = GetClusteredIndices(xy,particleDiameter)
    pairWiseDX = abs(xy(:,1) - xy(:,1)');
    pairWiseDY = abs(xy(:,2) - xy(:,2)');
    absDifs = sqrt(pairWiseDX.^2 + pairWiseDY.^2);
    numParticles = size(xy(:,1),1);
    absDifs = triu(absDifs) - eye(numParticles);
    clustered = ( absDifs < (1.1* particleDiameter) ) - eye(numParticles);
    clustered = triu(clustered);
    [iClustered,jClustered] = find(clustered == 1);
    blues = unique([iClustered;jClustered]);
end

