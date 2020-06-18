% Author: Mohammad Nabi Omidvar
% email : mn.omidvar AT gmail.com
%
% ------------
% Description:
% ------------
% dg - This function runs the differential grouping
%      procedure to identify the non-separable groups
%      in cec'2010 benchmark problems.o
%
% -------
% Inputs:
% -------
%    fun        : the function suite for which the interaction structure 
%                 is going to be identified in this case benchmark_func 
%                 of cec'2010.
%
%    fun_number : the function number.
%
%    options    : this variable contains the options such as problem
%                 dimensionality, upper and lower bounds and the parameter 
%                 epsilon used by differential grouping.
%    input3 - Description
%
% --------
% Outputs:
% --------
%    sep      : a vector of all separable variables.
%    allgroups: a cell array containing all non-separable groups.
%    FEs      : the total number of fitness evaluations used.
%
% --------
% License:
% --------
% This program is to be used under the terms of the GNU General Public License 
% (http://www.gnu.org/copyleft/gpl.html).
% Author: Mohammad Nabi Omidvar
% e-mail: mn.omidvar AT gmail.com
% Copyright notice: (c) 2013 Mohammad Nabi Omidvar


% Intraction Structure Matrix
function [delta, lambda, evaluations] = ism(fun, options);
   ub        = options.ubound;
   lb        = options.lbound;
   dim       = options.dim;
   FEs       = 0;
   temp      = (ub + lb)/2;

   ind0     = dim + 1;
   f_archive    = zeros(dim, dim) * NaN;
   fhat_archive = zeros(dim, 1) * NaN;
   delta1 = zeros(dim, dim) * NaN;
   delta2 = zeros(dim, dim) * NaN;
   lambda = zeros(dim, dim) * NaN;

   p1 = lb * ones(1,dim);
   fp1 = feval(fun, p1);
   FEs = FEs + 1;

   for i=1:dim-1
       %fprintf(1, '%d\n', i);

       if(~isnan(fhat_archive(i)))
           fp2 = fhat_archive(i);
       else
           p2 = p1;
           p2(i) = temp;
           fp2 =  feval(fun, p2);
           FEs = FEs + 1;
           fhat_archive(i) = fp2;
       end

       for j=i+1:dim
           if(~isnan(fhat_archive(j)))
               fp3 = fhat_archive(j);
           else
               p3 = p1;
               p3(j) = temp;
               fp3 =  feval(fun, p3);
               FEs = FEs + 1;
               fhat_archive(j) = fp3;
           end

           p4 = p1;
           p4(i) = temp;
           p4(j) = temp;
           fp4 =  feval(fun, p4);
           FEs = FEs + 1;
           f_archive(i, j) = fp4;
           f_archive(j, i) = fp4;

           d1 = fp2 - fp1;
           d2 = fp4 - fp3;

           delta1(i, j) = d1;
           delta2(i, j) = d2;
           lambda(i, j) = abs(d1 - d2);

       end
   end
   evaluations.base = fp1;
   evaluations.fhat = fhat_archive;
   evaluations.F    = f_archive;
   evaluations.count= FEs;
   delta.delta1 = delta1;
   delta.delta2 = delta2;
end
