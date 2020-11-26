function passiveXY = GeneratePassiveXY(numPassives,environmentSize,particleDiameter)
    
    k = 1;
    passiveXY = [];
    while k <= numPassives
        colliding = true;
        while colliding == true
            colliding = false;
            passiveXY(k,:) = -environmentSize + 2 * environmentSize * rand(1,2);
            for i = 1:(k-1)
                if sqrt(sum((passiveXY(i,:) - passiveXY(k,:)).^2)) < particleDiameter && i~=k
                    colliding = true;
                    break
                end
            end
        end
        k = k + 1;
    end
end

