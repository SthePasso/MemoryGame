## JOGO DA MEMÓRIA ##
## Sthefanie Jofer Gomes Passo e Débora de Paula Guerreiro##
.data
	char_arr: .asciiz "ABCDEEACDB"                
	string: .asciiz "A B C D E E A C D B"     
	titulo: .asciiz "******************** JOGO DA MEMORIA ********************\n"
	parabens: .asciiz "\n******************** PARABENS VOCE VENCEU!!! ********************\n"
	errou: .asciiz "\n******************** TU E LESO, E???? ********************\n"
	cartas: .asciiz "\n0 1 2 3 4 5 6 7 8 9 "
	acerto: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	space: .asciiz " "
	linha: .asciiz "\n"
	segredo: .asciiz "? "
 
.text
	main: 
	########################### Impressoes, leituras e pulos de linha ############################ 
	                             
 	.macro printJogo()					# Imprime o título
 		la $a0, titulo
 		li $v0, 4
 		syscall
 	.end_macro

 	.macro printParabens()					# Imprime o parabéns
 		la $a0, parabens
 		li $v0, 4
 		syscall
 	.end_macro
 	
 	.macro printErrou()					# Imprime o errou
 		la $a0, errou
 		li $v0, 4
 		syscall
 	.end_macro
 	 	 	
 	.macro printNcartas() 					# Imprime array de números
      		la $a0, cartas                    
  	    	li $v0, 4
  	    	syscall
  	.end_macro
 	
	.macro print_char(%ch)					# Imprime array de letras por elemento
      		move $a0, %ch
  	 	li $v0, 11
  	    	syscall
 	.end_macro
 	
 	.macro impressaostring()				# Imprime string
 		la $a0, string
    		li $v0, 4
		syscall
 	.end_macro
  
  	.macro sn() 						# Imprime o espaço
      		la $a0, space                    
  	    	li $v0, 4
  	    	syscall
  	.end_macro

	.macro ln() 						# Imprime o pulo de linha
      		la $a0, linha                    
  	    	li $v0, 4
  	    	syscall
  	.end_macro

	.macro canguru() 					# Imprime pulo de 32 linhas pra ficar bonita a interaçao
      		li $t0, 0                                 	# Contador 
		li $t1, 29 
			loop2:
    				bge $t0, $t1, end_loop2                 	            	
    					ln()
    				add $t0, $t0, 1                 # Incrementa contador
    				j loop2
  			end_loop2:
  	.end_macro

   	.macro segredo() 					# Imprime o ponto de interrogaçao
      		la $a0, segredo                    
  	    	li $v0, 4
  	    	syscall
  	.end_macro
  	
  	.macro leia() 	 					# Le as entradas   	
  		li $v0, 5					# Entrada 1
		syscall
		move $t2, $v0
		
		ble $t2,-1,SAIR					# Caso a entrada 1 for menor ou igual a -1
		bgt $t2,9,SAIR					# Caso a entrada 1 for maior que 9
		j sair
		SAIR:
			printErrou()				
			exit()					# Imprime que errou e encerra o programa
		sair:
		
		li $v0, 5
		syscall
		move $t3, $v0
		
		ble $t3,-1,SAIR2				# Caso a entrada 2 for menor ou igual a -1
		bgt $t3,9,SAIR2					# Caso a entrada 2 for maior que 9
		j sair2
		SAIR2:
			printErrou()
			exit()					# Imprime que errou e encerra o programa
		sair2:
		
        .end_macro
        
        ########################### Logica do Programa ############################
        
        .macro PeloamordeDeus(%a, %b)				# Coloca 1 no vetor acerto na posicao aonde as letras sao iguais
      		li $s0, 1				
		sb $s0, acerto(%a)
							
		li $s1, 1				
		sb $s1, acerto(%b)												
			    		
        .end_macro
        
        .macro quandoAcertei(%a, %b)				# Analisa se as letras nas posicoes de entrada sao iguais
		lb $s0, char_arr(%a)			  
		lb $s1, char_arr(%b)	
  		beq $s0, $s1, IGUAL3
  		j done
  			IGUAL3:
  				PeloamordeDeus(%a, %b)
  				j done
  		done:
  				  						 
	.end_macro
        
        .macro compara(%posi,%a, %b, %ch)			
         	beq %b, %a, ACERTO				# if($a0==$t3) print ($a0)
         	beq %posi, %a, IGUAL				# if($a0==$t3) print ($a0)
         	beq %posi, %b, IGUAL				# if($a0==$t3) print ($a0)
       		bne %posi, %a, DIF                   		# if($a0!=$t3) print (segredo)
       		bne %posi, %b, DIF                   		# if($a0!=$t3) print (segredo)
		j done
		ACERTO:
		  	la $s6, acerto 
		  	add $s6, $s6, %posi                     # $s6 = posi   
		  	lb $s7, ($s6)                      	# Percorrer o vetor acerto[$s6] ?????
			add $s7, $s7, 1	     			# acerto[$s6] = 1 ?????
		IGUAL:
			print_char(%ch)
    			sn()                         		# Imprime o valor do vetor
			j done
       		DIF:
       			la $s6, acerto                          # Carrega o endereco do array list
			add $s6, $s6, %posi                    
			lb $s7, ($s6)				
       			beq $s7, 1, IGUAL
       			segredo()				# else print (segredo)
 			j done
		done:		
        .end_macro
        
        .macro compara(%acert, %ch)
                beq %acert, 1, IGUAL				# if($a0==$t3) print ($a0)
     		bne %acert, 1, DIF                   		# if($a0==$t3) print (segredo)
		j done
		IGUAL:
			print_char(%ch)
    			sn()                         		# Imprime o valor do vetor
			j done
       		DIF:
       			segredo()				# else print (segredo)
 			j done
		done:		
        .end_macro
        
            
        .macro mostrarCartas()
	        la $s5, char_arr                             	# Carrega o endereco do array list
  		li $t0, 0                                 	# Contador 
		li $t1, 10                                 	    
		loop:
    			bge $t0, $t1, end_loop                 	# Se contador for maior que tamanho do vetor pare

			lb $s0, ($s5)				# Variavel na posição ($s5) do vetor	
			compara($t0,$t2,$t3,$s0)
		    			
    			add $s5, $s5, 1                       	
    			add $t0, $t0, 1                        	# Incrementa contador
    			j loop
  		end_loop:
        .end_macro
        
        .macro mostrarCertas()
        	la $s4, char_arr
        	la $s5, acerto                             	# Carrega o endereco do array list
  		li $t4, 0                                 	# Contador 
		li $t5, 10                                 		   
		ln()
		loop:
    			bge $t4, $t5, end_loop                  # Se contador for maior que tamanho do vetor pare
			
			lb $s1, ($s4)
			lb $s0, ($s5)				# Variavel na posição ($s5) do vetor	
			compara($s0, $s1)
		    		
		    	add $s4, $s4, 1	
    			add $s5, $s5, 1                       		
    			add $t4, $t4, 1                        	# Incrementa contador
    			j loop
  		end_loop:
        .end_macro
        
        .macro inicio()						# Inicia o jogo
    		printJogo()
    		printNcartas()
    		ln()
    		impressaostring()
    		ln()
    		ln()
    		
    		li $t0, 0                                 	# Timer para exibbir a resposta inicial
		li $t1, 1500000                                    
			loop1:
    				bge $t0, $t1, end_loop1         # Se contador for maior que tamanho do vetor pare                   		# Tamanho do caractere é  1 bytes
    				add $t0, $t0, 1                 # Incrementa contador
    				j loop1
  			end_loop1:
  			
  		canguru()
    	.end_macro
           
     	.macro exit()						# Encerra excucao
    		li $v0, 10                
      		syscall
    	.end_macro
 
 	########################### Execuçao do Programa ############################
 	
 	inicio()						# Inicia mostrando as cartas corretas
 	printJogo()						# Imprime o titulo
 	printNcartas()						# Imprime interrogacoes e começa leitura
	mostrarCertas()						# Imprime as interrogaçoes, caso sem entrada

  	la $s6, acerto                            		# Carrega o endereco do array ACERTO
  	li $t7, 0                                 		# Contador 
	li $t8, 10 
      	loop:
    		bge $t7, $t8, end_loop                  	# Se contador for maior que tamanho do vetor pare

      			ln()					# Impressao de linha
      			leia() 					# Leitura 
  			mostrarCartas()				# Impressao das cartas na posicao lida
  			ln() 					# Impressao de linha
  			printNcartas()				# Impressao do arra de posicao
  	 		quandoAcertei($t2,$t3)			# Analisa quando acertei
			mostrarCertas()				# Imprime quando acertei
			canguru()				# Impressao de linha
			
      			lb $s0, char_arr($t3)			  	
			lb $s1, char_arr($t2)	
  			beq $s0, $s1, IGUAL
  			j igual
  				IGUAL:       			       		
    					add $t7, $t7, 2                        		
    					j igual
    			igual:
    				j loop
  	end_loop:
  	
	printParabens()						# Imprime final do Jogo
	
exit()								# Encerra o Jogo

		
