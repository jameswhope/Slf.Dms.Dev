/ * * * * * *   O b j e c t :     S t o r e d P r o c e d u r e   [ d b o ] . [ s t p _ R e p o r t G e t A g e n c y B a t c h e s _ a l l ]         S c r i p t   D a t e :   1 1 / 1 9 / 2 0 0 7   1 5 : 2 7 : 3 9   * * * * * * /  
 D R O P   P R O C E D U R E   [ d b o ] . [ s t p _ R e p o r t G e t A g e n c y B a t c h e s ]  
 G O  
 S E T   A N S I _ N U L L S   O N  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O N  
 G O  
 C R E A T E   p r o c e d u r e   [ d b o ] . [ s t p _ R e p o r t G e t A g e n c y B a t c h e s ]  
 (  
 	 @ d a t e 1   d a t e t i m e ,  
 	 @ d a t e 2   d a t e t i m e ,  
 	 @ c o m m r e c i d s   n v a r c h a r ( 5 0 0 ) ,  
 	 @ c o m p a n y i d   v a r c h a r ( 3 )  
 )  
 a s  
  
 e x e c   ( '  
 S E L E C T  
 	 b . C o m m B a t c h I D ,  
 	 b . B a t c h D a t e ,  
 	 s u m ( b t . A m o u n t )   a s   A m o u n t  
 F R O M  
 	 t b l c o m m b a t c h   b   i n n e r   j o i n  
 	 t b l c o m m b a t c h t r a n s f e r   b t   o n   b . c o m m b a t c h i d   =   b t . c o m m b a t c h i d   a n d   b t . A m o u n t   >   0   a n d   b t . c o m p a n y i d   =   '   +   @ C o m p a n y I D   +   '   j o i n  
 	 t b l c o m m r e c   r   o n   b t . c o m m r e c i d   =   r . c o m m r e c i d   a n d   r . C o m m R e c I d   I N   ( '   +   @ C o m m R e c I d s   +   ' )  
 W H E R E  
 	 (   C A S T ( C O N V E R T ( v a r c h a r ( 1 0 ) ,   b . B a t c h D a t e ,   1 0 1 )   A S   d a t e t i m e )   > =   ' ' '   +   @ d a t e 1   +   ' ' '   )   a n d  
 	 (   C A S T ( C O N V E R T ( v a r c h a r ( 1 0 ) ,   b . B a t c h D a t e ,   1 0 1 )   A S   d a t e t i m e )   < =   ' ' '   +   @ d a t e 2   +   ' ' '   )  
 G R O U P   B Y  
 	 b . C o m m B a t c h I D ,  
 	 b . B a t c h D a t e  
 O R D E R   B Y  
 	 b . B a t c h D a t e   D E S C  
 ' )  
 G O  
 