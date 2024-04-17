%% Import from VPSC
%
%%
% <https://public.lanl.gov/lebenso/ VPSC> is a crystal plasticity code
% originally written by Ricardo Lebensohn and Carlos Tome from Los Alamos
% National Laboratory - USA.
% 
% Original code can be requested to lebenso@lanl.gov
%
% https://public.lanl.gov/lebenso/
%
%% Import the orientations generated by VPSC
%
% Running a simulation in VPSC usually results in an output file
% |TEX_PH1.OUT| which contains multiple sets of orientations for different
% strain levels. As these files does not contain any information on the
% crystal symmetry we need to specify it first

cs = crystalSymmetry('222', [4.762 10.225 5.994],'mineral', 'olivine');

%%
% In the next step the orientations are imported and converted into a list
% of <SO3Fun.SO3Fun.html ODFs> using the command <ODF.load.html |ODF.load|>.

% put in here the path to the VPSC output files
path2file = [mtexDataPath filesep 'VPSC'];

odf = SO3Fun.load([path2file filesep 'TEX_PH1.OUT'],'halfwidth',10*degree,'CS',cs)

%%
% The individual ODFs can be accessed by |odf{id}|

% lets plot the second ODF
plotSection(odf{2},'sigma','figSize','normal')

%%
% The information about the strain are stored as additional properties
% within each ODF variable

odf{1}.opt

%% Compare pole figures during deformation
%
% Next we examine the evaluation of the ODF during the deformation by
% plotting strain depended pole figures. 

% define some crystal directions
h = Miller({1,0,0},{0,1,0},{0,0,1},cs,'uvw');

% generate some figure
fig = newMtexFigure('layout',[4,3],'figSize','huge');
subSet = 1:4;

% plot pole figures for different strain steps
for n = subSet
  nextAxis
  plotPDF(odf{n},h,'lower','contourf','doNotDraw');
  ylabel(fig.children(end-2),['\epsilon = ',xnum2str(odf{n}.opt.strain)]);
end
setColorRange('equal')
mtexColorbar

%% Visualize slip system activity
% 
% Alongside with the orientation data VPSC also outputs a file
% |ACT_PH1.OUT| which contains the activity of the different slip systems
% during the deformation. Lets read this file as a table

ACT = readtable([path2file filesep 'ACT_PH1.OUT'],'FileType','text')

%%
% and plot the slip activity with respect to the strain for the different
% modes

% loop though the columns MODE1 ... MOD11
close all
for n = 3: size(ACT,2)
 
  % perform the plotting
  plot(ACT.STRAIN, table2array(ACT(:,n)),'linewidth',2,...
    'DisplayName',['Slip mode ',num2str(n-2)])
  hold on;
end
hold off

% some styling
xlabel('Strain');
ylabel('Slip activity');
legend('show','location','NorthEastOutside');

set(gca,'Ylim',[-0.005 1])
set(gcf,'MenuBar','none','units','normalized','position',[0.25 0.25 0.5 0.5]);

%for only one mode plot, e.g.,mode 3: cs = csapi(STRAIN,MODE{3});fnplt(cs,3,'color','b');hold off;