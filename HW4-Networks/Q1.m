clear all
N = 10;
p = .3;

G = ErdosRenyi(N,p);
subplot(1,2,1)
plot(G,':','LineWidth',.005)
title(strcat('N = ',num2str(N),'     p = ',num2str(p)))
data = degree(G)';

tab = tabulate(data);
x = tab(:,1);
y = tab(:,3) / 100;
iGood = y~=0;
x = x(iGood);
y = y(iGood);

subplot(1,2,2)
loglog(x,y,'r*')

Pk = [];
for k = x'
    Pk = [Pk nchoosek(N-1,k) * (p^k) * (1-p)^(N-1-k)];
end
hold on
loglog(x,Pk,'blue')
hold off
legend('Experimental','Theoretical','Location','Best')
xlabel('Degree')
ylabel('P(degree)')
% xlim([0 100])