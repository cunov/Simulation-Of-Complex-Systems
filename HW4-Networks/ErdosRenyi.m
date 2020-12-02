function G = ErdosRenyi(N,p)
    A = rand(N,N) < p;
    A = triu(A) - diag(diag(A));
    A = A + triu(A)';
    G = graph(A,split(num2str(1:N)),'upper');
end

