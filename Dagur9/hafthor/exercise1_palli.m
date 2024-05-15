close all; clear; clc

rng default

N = 200;
pc = 0.8;
pm = 0.01;
share_res = false;
mate_res = true;
Beta = 3;
Alpha = 1;

% the first function
f = @ft;
n = 3;
lims = [0.5 1 % n_1
        -2 2 % n_2
        -2 2]; % n_3
plot_axis = [0.5 1 0 5];
mea(f,N,n,lims,pc,pm,share_res,mate_res,Beta,Alpha,plot_axis)

% the second function
f = @ff;
n = 8;
lims = repmat([-2 2],n,1);
plot_axis = [0 1 0 1];
mea(f,N,n,lims,pc,pm,share_res,mate_res,Beta,Alpha,plot_axis)

function R = child(P1,P2)
    % parents P1 and P2, child R
    r = rand; % method selection
    n = length(P1); % dimensions
    if r < 1/3 % use discrete
        for i = 1:n
            c = randi(2); % choose parent
            if c == 1 % P1 chosen
                R(1,i) = P1(1,i);
            else % P2 chosen
                R(1,i) = P2(1,i);
            end
        end
    elseif r < 2/3 % use intermediate
        for i = 1:n
            c = rand; % random combination
            R(1,i) = c*P1(1,i)+(1-c)*P2(1,i); % make combination
        end
    else % use arithmetric
        c = rand;
        R = c*P1+(1-c)*P2; % make full combination
    end
end


function [term,p,Eold,Efold,domold,p_term] = convergance(p,ev,k,Eold,E,Efval,Efold,domold,plot_axis)
    if ~exist('p','var')
        p = [];
    end

    % evaluates if termination conditions are fulfilled
    term = false; % don't terminate
    if ev >= 20000 || k >= 100 % function evaluations 1000 or 100 generations
        term = true; % terminate
    end

    [~,~,~,dom] = pareto_ranking(E,[],[],plot_axis,Efval);
    P1 = E(dom,:); % only dominating in generation k
    P2 = Eold(domold,:); % only dominating in generation k-1
    f1 = Efval(dom==1,:); % f for generation k
    f2 = Efold(domold==1,:); % f for generation k-1

    N_bar = 0;
    for i = 1:size(P1,1)
        [~,~,~,tmp_dom] = pareto_ranking([P1(i,:); P2],[],[],plot_axis,[f1(i,:); f2]);
        if tmp_dom(1)
            if sum(dom == 0) ~= 0
                N_bar = N_bar+1;
            end
        end
    end

    Nnotdom = sum(dom); % count undominated points in k set

%     [~,~,~,dom] = pareto_ranking(E,[],[],Efval);
%     sum(dom)
%     Nnotdom = sum(dom); % count undominated points in k set
    % both P and Pold values are dominating in their set
%     P1 = E(dom,:); % only dominating in generation k
%     P2 = Eold(domold,:); % only dominating in generation k-1
%     f1 = Efval(dom==1,:); % f for generation k
%     f2 = Efold(domold==1,:); % f for generation k-1
%     % ranking of the combination:
%     [~,~,~,domcomb] = pareto_ranking([P1;P2],1,ev,[f1;f2]);
%     N_u = sum(domcomb(length(P1(:,1))+1:end)==1); 
    p(end+1) = N_bar/Nnotdom(end);
    if k > 8
        p_term = sum(p(end-5:end))/6;
        if p_term < 0.1
            term = true;
        end
    else
        p_term = nan;
    end
    Eold = E;
    Efold = Efval;
    domold = dom;
end

function R = crossover(P,pc,lims) 
    [N,n] = size(P); % get population size and input dimensions
    for j = 1:N/2 % make population size half (children)
        if rand < pc % if there is a crossover
            c = randi(N,1,2); % select two random parents
            R(j,:) = child(P(c(1),:),P(c(2),:)); % generate child
        else % if there is no crossover
            R(j,:) = P(2*j,:); % just take "old" values
        end 
        for i = 1:n
            R(j,i) = max(R(j,i),lims(n,1)); % within boundaries
            R(j,i) = min(R(j,i),lims(n,2));
        end
    end
end


function fit = dynamic_sharing(fit,fval,sigma_share,N,share_res,Alpha)
    if ~share_res % if there are sharing restrictions we dont use the sharing function
        return
    end
    SF = nan(N,N);
    for i = 1:N
        for j = 1:N
            d = norm(diff([fval(i,:); fval(j,:)])); % distance between Pi and Pj
            if d < sigma_share
                SF(i,j) = 1 - (d/sigma_share)^Alpha;
            else
                SF(i,j) = 0;
            end
        end
        fit(i) = fit(i) / sum(SF(i,:)); % decreasing fitness
    end
end


function [E,Efval,Out,Outfit] = elites(P,fval,E,Efval,N,sigma_share,share_res,Alpha,k,plot_axis)
    X = [E;P];
    Xfval = [Efval;fval];
    Xfit = pareto_ranking(X,[],[],plot_axis,Xfval);
    Xfit = dynamic_sharing(Xfit,Xfval,sigma_share,N,share_res,Alpha); % create X set
    [~,I] = sort(Xfit,'descend');
    best = I(1:N);
    E = X(best,:);
    Efval = Xfval(best,:); % Create E set
    plot_best(Efval,k);
    R = randperm(2*N,N);
    Out = X(R,:);
    Outfit = Xfit(R); % Chosing random values from X set as the population
end


function [ff1,ff2] = ff(x)
    ff1 = 1 - exp(-sum((x - 1/sqrt(8)).^2));
    ff2 = 1 - exp(-sum((x + 1/sqrt(8)).^2));
end

function [ft1,ft2] = ft(x)
    ft1 = x(1);
    ft2 = (1/x(1)) * (1 + (x(2)^2+x(3)^2)^0.25 * (sin(50 * (x(2)^2+x(3)^2)^0.1)^2 + 1));
end

function P = initialize_population(n,N,lims)
    P = nan(N,n);
    for i = 1:N
        for j = 1:n
            %        [0, 1]   lim(2)- lim(1)    lim(1)
            P(i,j) = rand() * diff(lims(j,:)) + lims(j,1);
        end
    end
end


function mea(f,N,n,lims,pc,pm,share_res,mate_res,Beta,Alpha,plot_axis)
    % f: objective function
    % N: number of individuals
    % n: number of input dimensions
    % lims: row(upper and lower limits) col(dimension)
    % pc: crossover probability
    % pm: mutation probability
    % share_res: sharing restriction
    % mate_res: mating restriction
    % sigma_mate: sharing function range
    % sigma_mate: mating range
    % Beta: mution distribution
    % Alpha: sharing function distribution
    ev = 0; % 0 evaluations
    k = 1; % 1st generation
    P = initialize_population(n,N,lims); % initialization
    [fit,ev,fval,dom] = pareto_ranking(P,f,ev,plot_axis); % rank
    [sigma_share, sigma_mate] = update_sigma(fval,N);
    fit = dynamic_sharing(fit,fval,sigma_share,N,share_res,Alpha);
    E = P; Efval = fval;
    Eold = E; Efold = Efval; p = []; domold = dom;
    termination = false;
    while ~termination
        k = k+1;
        Ptemp = selection(P,fit,sigma_mate,mate_res,dom);
        P = crossover(Ptemp,pc,lims);
        P = mutation(P,pm,Beta,lims);
        [~,ev,fval,dom] = pareto_ranking(P,f,ev,plot_axis); % rank
        [sigma_share, sigma_mate] = update_sigma(Efval,N);
        [E,Efval,P,fit] = elites(P,fval,E,Efval,N,sigma_share,share_res,Alpha,k,plot_axis);
        [termination,p,Eold,Efold,domold,p_term] = convergance(p,ev,k,Eold,E,Efval,Efold,domold,plot_axis);
        fprintf('iterations: %d, function calls: %d, Convergence(p_k): %.2f\n',k,ev,p_term)
    end
end

function P = mutation(P,pm,Beta,lims) 
    [N,n] = size(P);
    for j = 1:N 
        for k = 1:n 
            int = lims(k,:); % take lims for particular dimension
            if rand < pm % make mutation
                c = rand;
                if c > 0.5 % mutation values
                    delta_x = (int(2)-P(j,k))*(2*(c-0.5))^Beta;
                else
                    delta_x = (int(1)-P(j,k))*(2*(0.5-c))^Beta;
                end
                c = randi([1,2]);
                if c == 1 % add
                    P(j,k) = P(j,k)+delta_x;
                else % subtract
                    P(j,k) = P(j,k)-delta_x;
                end
                P(j,k) = max(P(j,k),int(1)); % within boundaries
                P(j,k) = min(P(j,k),int(2));
            end 
        end
    end
end

function [fit,ev,fval,dom] = pareto_ranking(x,f,ev,plot_axis,varargin)
    % x ... point values as a matrix columns: [x1,x2,...,xn] (dimension n)
    %       different points as matrix rows (population N)
    % f ... objective function as a vector [f1(x),f2(x),...,fm(x)]
    % fit ... fitness of points as a vector
    N = length(x(:,1)); % get size
    n = length(x(1,:)); % get size
    if nargin==4 % also evaluate function values
        for i = 1:N
            [fval(i,1),fval(i,2)] = f(x(i,:)); % save values in a vector
            ev = ev+1;
        end
        plot_current_gen(fval,plot_axis)
    else % use inputted function values
        fval = varargin{1};
    end
    c = 1; % rank counter
    I = 1:N;
    while ~isempty(I) % go through all points that have not been ranked yet
        r(I) = ones(length(I),1)*c; % current ranking
        for i = I
            for j = I % compare i to all points
                for k = 1:n
                    if i~=j && fval(i,1) > fval(j,1) && fval(i,2) > fval(j,2)
                        r(i) = 0; % rank set to 0 because conditions not fulfilled
                    elseif fval(i,1) == fval(j,1) && fval(i,2) > fval(j,2)
                        r(i) = 0;
                    elseif fval(i,2) == fval(j,2) && fval(i,1) > fval(j,1)
                        r(i) = 0;
                    elseif i~=j && fval(i,1) == fval(j,1) && fval(i,2) == fval(j,2)
                        r(i) = 1000; % set rank to very high number
                    end
                end
            end
        end
        I = find(r==0); % not yet ranked members
        c = c+1;
    end
    fit = 1./r;
    dom = r==1; % undominated points
end

function plot_best(Efval,k)
    plot(Efval(:,1),Efval(:,2),'rx')
    title(sprintf('Iteration: %d',k))
    hold off
    pause(0.1)
end


function plot_current_gen(fval,plot_axis)
    plot(fval(:,1),fval(:,2),'bo'), hold on
    axis(plot_axis)
end

function Ptemp=selection(P,fit,sigma_mate,mate_res,dom) %change to fitness %mr is mating range 0 to inf %each row is an individual, column dimension
%input is Population P and Ranking R
N=length(P(:,1));  %Number of points in P
n=length(P(1,:)) ; %dimension of P

        for i=1:2*N %double amount for parents
            c1=ceil(N*rand()); %2 random values out of set N
            c2=ceil(N*rand());
            cond=false;
            lim=100;
            counter=0;
            if mate_res==1
                for j=1:lim  %tries out lim number of times to find a partner, if unsuccessful matches with random point
                
                    c2=ceil(N*rand());
                    %diff=P(c1,:)-P(c2,:); %for calculating distance between points
                    r=norm(P(c1,:)-P(c2,:)); %distance between points
                        if r<sigma_mate
                          break
                        else
                        counter=counter+1;
                        end
                end
            end
        %     if counter==lim
        %         c2=ceil(N*rand());
        %     end
            c1_dominated = false; c2_dominated = false;
            %if r<sigma_mate
                if dom(c1)==0    %check if the c(1) is dominated
                    c1_dominated = true;
                end
                if dom(c2) ==0   %check if c(2) is dominated
                 c2_dominated = true;
                end
                if c1_dominated == c2_dominated %if both or neither are dominated check fitness
                    if fit(c1) > fit(c2)
                    s = c1;
                    else
                    s = c2;
                    end
                else
                    if c1_dominated == false
                        s = c1;
                    else
                        s = c2;  
                    end
                end
            Ptemp(i,:)=P(s,:); %output the better point
        end


end


function [sigma_share, sigma_mate] = update_sigma(fval,N)
    [~,y] = max(fval(:,1));
    [~,x] = max(fval(:,2));
    d = diff([fval(y,:); fval(x,:)]);
    d_min = norm(d);
    d_max = sum(abs(d));
    sigma_share = N^(1/(1-2)) * (d_min+d_max)/2;
    sigma_mate = sigma_share*3;
end