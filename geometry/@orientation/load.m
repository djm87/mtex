function [ori,interface,options] = load(fname,varargin)
% import orientation data from data files
%
% Description
%
% orientation.load is a high level method for importing orientations from
% column aligned text files or excel spread sheets. In those cases it is
% neccesary to tell MTEX the column positions of the spatial coordinates,
% the phase information as well as Euler angles.
%
% Syntax
%  ori = orientation.load(fname,cs,'ColumnNames',{'phi1','Phi','phi2'})
%
% Input
%  fname - filename
%  cs    - @crystalSymmetry
%  ss    - @specimenSymmetry (optional)
%
% Options
%  columnNames       - names of the colums to be imported, mandatory are euler 1, euler 2, euler 3
%  columns           - postions of the columns to be imported
%  radians           - treat input in radiand
%  delimiter         - delimiter between numbers
%  header            - number of header lines
%  Bunge             - [phi1 Phi phi2] Euler angle in Bunge convention (default)
%  passive           -
%
% Output
%  ori - @orientation
%
% See also
% orientation_index

if iscell(fname), fname = fname{1};end

%  determine interface 
if ~check_option(varargin,'interface')
  [interface,options] = check_interfaces(fname,'Orientation',varargin{:});
elseif check_option(varargin,'columnNames')
  interface = 'generic';
  options = varargin;
else
  interface = get_option(varargin,'interface');
  options = delete_option(varargin,'interface',1);
  if isempty(interface), return; end
end

% call specific interface
ori = feval(['loadOrientation_',char(interface)],fname,options{:});
