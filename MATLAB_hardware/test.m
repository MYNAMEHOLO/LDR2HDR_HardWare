% 初始化輸出變數為 single 型態
    output_onepxl_R = single(0);
    output_onepxl_G = single(0);
    output_onepxl_B = single(0);
    
    input_cell = [1, 1, 1;
                  1, 5, 1;
                  1, 1, 1];
    
    %% weighting for road one here
    % Kernel 1
    kernel_1_1_R = [-0.06060344, -0.13098375, -0.07995155;
                    -0.03396509, -0.05015077, -0.08161981;
                    -0.07301063, -0.18122287, -0.08938497];

    kernel_1_1_G = [-0.20460482, -0.18236682, -0.17219122;
                    -0.14037307, -0.21383542, -0.24753736;
                    -0.20476876, -0.21282151, -0.18235026];

    kernel_1_1_B = [-0.08648768, -0.04203524, -0.34147492;
                    -0.4418903 , -0.32623577, -0.29881635;
                    -0.09956616, -0.20071869, -0.3513788 ];

    
    % Kernel 2
    kernel_1_2_R = [-0.11982842, -0.1017948, -0.18122852;
                   -0.10999158, -0.23689528, -0.03173373;
                   -0.10676891, -0.09051172, -0.14550157];
    
    kernel_1_2_G = [-0.16076611, -0.17278977, -0.2741138;
                   -0.18700002, -0.41602486, -0.20483203;
                   -0.1609501, -0.31856722, -0.2958981];
    
    kernel_1_2_B = [-0.15279952, -0.08266857, -0.19576831;
                   -0.474123, -0.3944591, -0.43647957;
                    0.01821824,  0.05868365, -0.35680166];

    
    % Kernel 3
    kernel_1_3_R = [-0.12349594, -0.23301889, -0.15040772;
                   -0.10655447, -0.12091178, -0.17626177;
                   -0.10382496, -0.23597006, -0.13692373];
    
    kernel_1_3_G = [-0.1662659, -0.40170017, -0.1945282;
                   -0.15637524, -0.29637155, -0.29933086;
                   -0.25569212, -0.27617544, -0.16659334];
    
    kernel_1_3_B = [-0.05847446, -0.05558959, -0.03569927;
                   -0.4309419, -0.18779853, -0.58591115;
                    0.01267383,  0.08157416, -0.2798427];

    
    % biases
    biases_res_1_1 = single(-0.00010128);
    biases_res_1_2 = single(-0.01732344);
    biases_res_1_3 = single(-0.05164022);
    
    
    
    %% weighting for road two here
    % Kernel 1
    kernel_2_1_R = [-0.12420122,  0.0042517, -0.07323586;
                   -0.02794806, -0.06258836, -0.16781892;
                   -0.24400057, -0.25503471, -0.17756239];
    
    kernel_2_1_G = [-0.31055775, -0.34045333, -0.38995138;
                   -0.48241475, -0.17396103, -0.3525624;
                   -0.3752533, -0.35843426, -0.29209444];
    
    kernel_2_1_B = [-0.6091077, -0.8115962, -0.68804544;
                   -0.7952045, -0.80040103, -0.44838083;
                   -0.6364181, -0.6788668, -0.7040479];

    
    % Kernel 2
    kernel_2_2_R = [-0.18980305, -0.06903154, -0.07775745;
                   -0.32650828, -0.2455786, -0.36686757;
                   -0.13823384, -0.09725386, -0.28155798];
    
    kernel_2_2_G = [-0.20623444, -0.15056552, -0.2920185;
                   -0.26293766, -0.15141924, -0.25122055;
                   -0.5559223, -0.69811046, -0.5660013];
    
    kernel_2_2_B = [-0.78560597, -0.73135257, -0.3603318;
                   -0.7148962, -0.3922815, 0.18371072;
                   -0.78363043, -0.73330337, -0.3682009];
    
    
    % Kernel 3
    kernel_2_3_R = [-0.09721049, -0.28195062, -0.03210959;
                   -0.28080982, -0.37070075, -0.31613562;
                   -0.25647956, -0.35727176, -0.31320935];
    
    kernel_2_3_G = [-0.2647271, -0.31135088, -0.20943713;
                   -0.50719297, -0.58555406, -0.5814902;
                   -0.5112833, -0.62352717, -0.7209257];
    
    kernel_2_3_B = [-0.23284753, -0.5620714, -0.31887877;
                   -0.44556144, -0.53446686, -0.04479552;
                   -0.2868186, -0.43127704, -0.3855296];
    
    % biases
    biases_res_2_1 = single(-0.13931017);
    biases_res_2_2 = single(-0.39969534);
    biases_res_2_3 = single(-0.45995504);

    %% operation here
    test_ker = [1, 1, 1;
                1, 1, 1;
                1, 1, 1];
    after_conv = custom_conv2(input_cell,test_ker);
    disp(after_conv);