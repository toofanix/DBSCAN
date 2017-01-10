%%
%Written by Jigar Bandaria
%--------------------------------------------------------------------------
%References:
% M. Ester et. al. A density-based algorithm for discovering clusters
% in Large Spatial Databases with Noise. Proceeding 2nd international
% conference on Knowledge Deiscovery and Data Mining, 1996.

%function : [point_class, point_type] = dbscan(x,k,eps)
%where x is the data set with X and Y corrdinates, k is minimum number
%of points near a given point, eps -radius
%point_class - cluster to which the point belongs to
%point_type - point is inner :1, periphery :0 or noise : -1

%%
%If eps not given estimate eps.
function [point_class, point_type] = dbscan(x,k,eps)
[m,n] = size(x) %Number of points in the dataset
    
if nargin < 3 || isempty(eps)
    [eps] = ((prod(max(x)-min(x))*k*gamma(.5*n+1))/(m*sqrt(pi.^n))).^(1/n);
end

x = [[1:m]' x];
n = n+1;
point_type = zeros(1,m);
nearby = zeros(m,1);
cluster_no = 1;

for i=1:m
    if nearby(i)==0;
       pt=x(i,:); %picking the i_th point 
       D=edist(pt(2:n),x(:,2:n));%calculating to all other points
       ind=find(D<=eps); %points that are nearer than eps
    
       if length(ind)>1 & length(ind)<k+1       
          point_type(i)=0;%point is on periphery
          point_class(i)=0;
       end
       if length(ind)==1
          point_type(i)=-1;%point is noise
          point_class(i)=-1;  
          nearby(i)=1;
       end

       if length(ind)>=k+1; 
          point_type(i)=1;%point is inner point in a cluster
          point_class(ind)=ones(length(ind),1)*max(cluster_no);%cluster assignment
          
          while ~isempty(ind)%check for each point that is close.
                pt=x(ind(1),:);
                nearby(ind(1))=1;
                ind(1)=[];
                D=edist(pt(2:n),x(:,2:n));
                i1=find(D<=eps);
     
                if length(i1)>1
                   point_class(i1)=cluster_no;%cluster_assign
                   if length(i1)>=k+1;
                      point_type(pt(1))=1;%inner point
                   else
                      point_type(pt(1))=0;%periphery point
                   end

                   for i=1:length(i1)
                       if nearby(i1(i))==0
                          nearby(i1(i))=1;
                          ind=[ind i1(i)];   
                          point_class(i1(i))=cluster_no;%cluster assign
                       end                    
                   end
                end
          end
          cluster_no=cluster_no+1; %increment cluster number for next iteration
       end
   end
end

i1=find(point_class==0);
point_class(i1)=-1;
end

    
%%
function [D] = edist(point,all_points)
[m,n]=size(all_points);
D=sqrt(sum((((ones(m,1)*point)-all_points).^2)')); %similar idea to repmat
end