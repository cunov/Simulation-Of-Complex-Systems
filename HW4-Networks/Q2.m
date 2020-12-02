N = 600;
C = 4;
P = .1;
[before, after] = WattsStrogatz(N,C,P);
subplot(1,2,1)
plot(before,'layout','circle')
title(strcat('Before shortcuts   (N = ',num2str(N),')   C = (',num2str(C),')   P = (',num2str(P),')'))
subplot(1,2,2)
plot(after,'layout','circle')
title('After shortcuts')