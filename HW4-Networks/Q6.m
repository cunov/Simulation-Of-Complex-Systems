clear all
S={};
A={};
G={};

k = {};
y = {};
avgPath = [];
diameter = [];
clusteringCoeff = [];
for i = 1:3
    S{i} = LoadNetworks(i);
    G{i} = graph(S{i}(:,1),S{i}(:,2));
    A{i} = adjacency(G{i});
    [avgPath(i), diameter(i)] = GetDistanceMetrics(A{i});
    clusteringCoeff(i) = GetClusteringCoeff(A{i});
    [k{i},y{i}] = PlotDegreeDistn(G{i});
    subplot(3,2,(i-1)*2 +1)
    loglog(k{i},y{i},'.')
    title('Degree distribution')
    subplot(3,2,(i-1)*2+2)
    plot(G{i},':','LineWidth',.005)
    title(strcat('Network (',num2str(i),')'))
end
Network = [1 2 3]';
table(Network,avgPath',diameter',clusteringCoeff','VariableNames',{'Network','Average Path','Diameter','Clustering Coeff'})
% C={};
% x={};
% y={};
% for i = 1:3
%     C{i} = centrality(G{i},'betweenness');
%     tmp = tabulate(C{i});
%     x{i} = tmp(:,1);
%     y{i} = tmp(:,3) / 100;
%     subplot(3,1,i)
%     plot(x{i},y{i});
% end
