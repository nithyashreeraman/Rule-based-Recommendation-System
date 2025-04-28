garment(g1, top, red, vintage, summer).
garment(g2, bottom, beige, vintage, summer).
garment(g19, top, maroon, vintage, fall).
garment(g20, bottom, olive, vintage, fall).
garment(g3, top, black, modern, winter).
garment(g4, bottom, grey, modern, winter).
garment(g23, top, charcoal, modern, all_season).
garment(g24, bottom, white, modern, all_season).
garment(g5, dress, floral, boho, spring).
garment(g10, skirt, pastel, boho, spring).
garment(g13, top, yellow, boho, all_season).
garment(g14, bottom, olive, boho, all_season).
garment(g25, dress, turquoise, boho, summer).
garment(g26, top, coral, boho, summer).
garment(g27, bottom, mint, boho, summer).
garment(g15, top, black, streetwear, all_season).
garment(g16, bottom, grey, streetwear, all_season).
garment(g21, top, grey, streetwear, summer).
garment(g22, bottom, black, streetwear, summer).
garment(g17, top, beige, sustainable, all_season).
garment(g18, bottom, tan, sustainable, all_season).
garment(g30, top, forest, sustainable, winter).
garment(g31, bottom, stone, sustainable, winter).
garment(g32, top, clay, sustainable, spring).
garment(g33, bottom, moss, sustainable, spring).
garment(g8, top, white, minimal, summer).
garment(g12, bottom, blue, minimal, all_season).
garment(g28, top, nude, minimal, all_season).
garment(g29, bottom, sand, minimal, all_season).

compatible(g1, g2). 
compatible(g19, g20). 
compatible(g3, g4). 
compatible(g23, g24).
compatible(g8, g12). 
compatible(g28, g29).
compatible(g5, g10). 
%compatible(g13, g14). 
%compatible(g26, g27).
compatible(g15, g16). 
compatible(g21, g22).
compatible(g17, g18). 
compatible(g30, g31). 
compatible(g32, g33).


stylish(vintage, casual). 
stylish(vintage, party).
stylish(streetwear, party). 
stylish(streetwear, casual).
stylish(modern, work). 
stylish(modern, formal).
stylish(boho, formal). 
stylish(boho, casual).
stylish(minimal, casual). 
stylish(minimal, formal).
stylish(sustainable, everyday).


suitable_for(G, Season) :- garment(G, _, _, _, Season).
suitable_for(G, Season) :- garment(G, _, _, _, all_season), Season \= winter.


find_outfits(Style, Occasion, Season, List) :-
    stylish(Style, Occasion),
    findall(Desc,
        (
            compatible(Top, Bottom),
            garment(Top, top, Color1, Style, _),
            garment(Bottom, bottom, Color2, Style, _),
            suitable_for(Top, Season),
            suitable_for(Bottom, Season),
            atomic_list_concat([Color1, Style, 'top with', Color2, Style, 'bottom'], ' ', Desc)
        ),
    RawList),
    sort(RawList, Sorted),
    findall(D, (nth0(Index, Sorted, D), Index < 3), List).


recommend_dress(Style, Occasion, Season, Description) :-
    stylish(Style, Occasion),
    garment(Dress, dress, Color, Style, DressSeason),
    suitable_for(Dress, Season),
    atomic_list_concat(['One-piece', Color, Style, 'dress'], ' ', Description).


infer_outfit_by_input(Style, Occasion, Season, List) :-
    find_outfits(Style, Occasion, Season, List), List \= [], !.
infer_outfit_by_input(Style, Occasion, Season, [Description]) :-
    recommend_dress(Style, Occasion, Season, Description), !.
infer_outfit_by_input(_, _, _, ['No suitable outfit found.']).