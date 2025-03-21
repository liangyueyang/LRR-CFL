function IF = CFL(I1,I2,D0,opts)

[~,~,Ie1,Ie2,D1,D2,A1,A2] = perform_Corr_Ind_Decomp(I1,I2,D0,D0,opts); % Deocomposition
IF = Fuse_grey(Ie1,Ie2,D1,D2,A1,A2); % Fusion