function torque = CalculateTorque(xy,theta,...
    passiveXY,n,T0,rC)

    activeParticles = 1:size(xy,1);
    passiveParticles = 1:size(passiveXY,1);
    
    vNhat = [cos(theta) sin(theta) 0];
    torque = 0;
    for i = activeParticles(activeParticles ~= n)
        rNI = [xy(i,:) - xy(n,:), 0];
        if norm(rNI) < rC
            rNIhat = rNI / norm(rNI);
            numerator = dot(vNhat,rNIhat);
            quotient = numerator / norm(rNI)^2;
            left = quotient * vNhat;
            crossProduct = cross(left,rNI);
            torque = torque + T0 * dot(crossProduct,[0 0 1]);
        end
    end

    for m = passiveParticles
        rNM = [passiveXY(m,:) - xy(n,:) 0];
        if norm(rNM) < rC
            rNMhat = rNM / norm(rNM);
            numerator = dot(vNhat,rNMhat);
            quotient = numerator / norm(rNM)^2;
            left = quotient * vNhat;
            crossProduct = cross(left,rNM);
            torque = torque - T0 * dot(crossProduct,[0 0 1]);
        end 
    end
end

