function [a1,t,d1,d2]=levmarq(O)
%function [sol,fval,d1,d2]=levmarq(O)
%
%minimize a nonlinear functional (assuming that 2nd derivatives exist) using Levenberg-Marquadt with
%   numerical 1st and full 2nd derivative info.
%
%fval is function value at minimum or best try,
%sol is the solution (shape is same as input variable shape),
%d1, d2 are 1st and 2nd derivative info for variables that can vary (see below for fixed/variable "variables").
%
%O is a structure of options:
%O.Function is the handle of the function to be evaluated (use O.Function=@your_func().
%O.Variables is the array of independent variables of the function to be minimized.
%   Note that O.Variables can be of any shape convenient to the problem.
%O.Fixed is a boolean array as the same size as O.Variables. If an element of O.Fixed is set to 1,
%   the corresponding variable is held fixed.
%O.Parameters are any auxiliary parameters used by the function. They are passed without inspection
%   to the function whenever called.
%O.DerivDelta is the delta used in evaluating 1st and 2nd derivatives (centered-difference method).
%O.Lambda is the starting value of the Levenberg-Marquadt stability parameter used to dynamically adjust
%   step size (default 1E-8).
%O.RelTol is the relative tolerance (function decrease/function value) to terminate the algorithm.
%O.AbsTol is the absolute function decrease that terminates the algorithm.
%
%To gather statistics on performance, use: global LevMarqPath FuncEvals:
%   LevMarqPath is a (N+1)xM array, where N is the number of variables, and M is the number of L-M iterations.
%   FuncEvals tells the number of times the objective function was evaluated.
global LevMarqPath FuncEvals LamHist
FuncEvals=0;
if nargin==0
    O.Lambda=1e-8;
    O.DisplayLambda=0;
    O.NumberIterations=20;
    O.RelTol=1e-4;
    O.AbsTol=1e-8;
    O.Function=0;
    O.Variables=0;
    O.Parameters=0;
    O.DerivDelta=.001;
    a1=O;
    return
end

try
    func_handle=O.Function;
catch
    error('no function to minimize (missing Options.Function)');
end
if ~isfield(O,'Fixed')
    O.Fixed=zeros(size(O.Variables));
end
if ~isfield(O,'DerivDelta')
    O.DerivDelta=.001*ones(size(O.Variables));
end
if ~isfield(O,'Lambda')
    lam=.001;
else
    lam=O.Lambda;
end
LamHist=O.Lambda;
if ~isfield(O,'DisplayLambda')
    O.DisplayLambda=0;
end
if length(lam)==0
    lam=.01*max(max(abs(d2)));
end
if isfield(O,'NumberIterations')
    N=O.NumberIterations;
else
    N=40;
end
if isfield(O,'RelTol')
    reltol=O.RelTol;
else
    reltol=.0001;
end
if isfield(O,'AbsTol')
    abstol=O.AbsTol;
else
    abstol=1e-8;
end
try
    x=O.Variables;
catch
    error('no variables defined (Options.Variables)');
end
try
    fx=O.Fixed;
catch
    fx=zeros(size(x));
    O.Fixed=fx;
end
O.Shape=size(x);
x=flatten(x);
fx=flatten(fx);
O.fix_ix=find(fx);
O.var_ix=find(~fx);
xfix=x(O.fix_ix);
[d1,d2]=partial_derivatives(O);
LevMarqPath=[x;0];
done=0;
if O.Lambda==0
    t=feval(func_handle,reshape(x,O.Shape),O);
    a1=O.Variables;
    return
end
t=feval(func_handle,reshape(x,O.Shape),O);
if O.DisplayLambda
    disp([t,lam])
end
for j=1:N
    FuncEvals=FuncEvals+1;
    if j>1
        t=feval(func_handle,reshape(x,O.Shape),O);
    end
    for i=1:20
        a1=x(O.var_ix)-(d2+lam*eye(length(O.var_ix)))\d1;
        ae(O.fix_ix)=xfix;
        ae(O.var_ix)=a1;
        FuncEvals=FuncEvals+1;
        t1=feval(func_handle,reshape(ae,O.Shape),O);
        if t1<t
            break
        end
        lam=lam*10;
        LamHist(end+1)=lam;
    end
    if i<20
        if lam/max(max(abs(d2)))>1e-6
            lam=lam/10;
            LamHist(end+1)=lam;
        end
    else
        done=1;
    end
    x(O.var_ix)=a1;
    try
        LevMarqPath(:,j+1)=[x;t1];
    catch
    end
    if O.DisplayLambda
        disp([min(t,t1),i,lam])
    end
    O.Variables=reshape(x,O.Shape);
    [d1,d2]=partial_derivatives(O);
    if done
        break;
    end
    if abs(t1-t)<abs(t*reltol)
        done=2;
        break
    end
    if abs(t1-t)<abstol
        done=3;
        break;
    end
end
if O.DisplayLambda
    cond={'lam too large','rel tol','abs tol'};
    disp(sprintf('exit condition %s',cond{done}))
end
O.Lambda=0;
O.Variables=reshape(x,O.Shape);
%[d1,d2]=partial_derivatives(O);
a1=reshape(ae,size(O.Variables));