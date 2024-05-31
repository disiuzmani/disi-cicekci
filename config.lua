Config = {

    Traders = {

        ['Cicekci'] = {
            model = 'cs_hunter',
            coords = {
                vector4(2168.07, 3331.05, 46.5, 28.31),
            },
            scenario = 'WORLD_HUMAN_COP_IDLES',
            voice = 'G_M_Y_Lost_02_WHITE_FULL_01', 
            paymentMethod = 'blackmoney',
            sellItems = false,
            buyItems = true,
            license = {false, label = ''}, 
            blip = { 
                Show = false, 
                Name = 'Export Handel',
                Color = 0, 
                Scale = 0.7, 
                Type = 141
            },

            items = {

                buy = {
                    {
                        item = 'meth',
                        price = 200
                    },
                    {
                        item = 'wmeth',
                        price = 200
                    },
                    {
                        item = 'coke_brick',
                        price = 170
                    },
                    {
                        item = 'heroin',
                        price = 150
                    },
                    {
                        item = 'joint',
                        price = 150
                    },
                    
                },

                sell = {
                   
                },
        
            }
        }
   }

}
