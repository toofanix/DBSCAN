%%
%Written by Jigar Bandaria
%--------------------------------------------------------------------------
%%
filename='test1';
filename1=strcat(filename,'.txt');
a=dlmread(filename1,'\t',1,0);
N = a(:,(4:5));% X and Y coordinates

% k = 50 and eps = 0.26
%Picking these 2 parameters are the major limitations of DBSCAN.
%If the clusters are not of same density or of different sizes, then
%the results may vary from expectation.
%While DBSCAN works in most cases, OPTICS or HDBSCAN are better
%alternatives.
[class,type]=dbscan(N,50,0.26);
M=N(find(class>-1),:);
c=class(find(class>-1));

%--------------------------------------------------------------------------
%Plotting the clusters
scatter (M(:,1),M(:,2),25,c)
hold on
scatter (N(:,1),N(:,2),'.k')
hold off

%[class,type]=dbscan(N,50,0.3);
t2=toc
Clus=M(find(c==2),:);

figure (2);
scatter (Clus(:,1),Clus(:,2),'.r')

figure(3);
scatter (M(:,1),M(:,2),25,c)
