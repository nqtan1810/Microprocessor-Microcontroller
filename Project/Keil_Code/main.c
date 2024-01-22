#include <stdio.h>
#include <regx52.h>

void init();
void command(unsigned int);
void write_data(unsigned char);
void ms_delay(unsigned int);
char get_key(int, int, int, int, char, char, char, char);
void num_generator(char, unsigned int*);
void write_result(unsigned int, char*);

sbit EN = P3^2;		// Enable LCD to display data: HIGH -> LOW
sbit RW = P3^3;		// WRITE = 0; READ = 1
sbit RS = P3^4;		// Register Select: RS = 0 -> Command mode, RS = 1 -> Data mode

unsigned int *operand;
unsigned int operand1 = 0;
unsigned int operand2 = 0;
unsigned int result = 0;
int num_operand, num_operator;

void main(){
	
	int i, j;
	int en_arr[4][4] = {{0,1,1,1},
											{1,0,1,1},
											{1,1,0,1},
											{1,1,1,0}};
	
	char c_arr[4][4] = {{'7','4','1','C'},
											{'8','5','2','0'},
											{'9','6','3','='},
											{'/','*','-','+'}};

	char error[10] = {'M','A','T','H',' ','E','R','R','O','R'};
	char pressed_key, operator1, negative = 'N';
	
	P1 = 0xFF;
	operand = &operand1;
	
	init();
	num_operand = 0;
	num_operator = 0;
	while(1){
		for(i = 0; i < 4; i++){
			
			pressed_key = get_key(en_arr[i][0], en_arr[i][1], en_arr[i][2], en_arr[i][3], c_arr[i][0], c_arr[i][1], c_arr[i][2], c_arr[i][3]);
			
			if(pressed_key=='/' || pressed_key=='*' || pressed_key=='-' || pressed_key=='+'){
				if(num_operand == 1) operand = &operand2;
				operator1 = pressed_key;
				num_operator++;
			}
			
			if((pressed_key != 'Z') && (pressed_key != '=') && (pressed_key != '/') && (pressed_key != '*') && (pressed_key != '-') && (pressed_key != '+')){
				num_generator(pressed_key, operand);
				if((num_operand == 1 && num_operator == 1 && operand == &operand2) || (num_operand == 0)) 
					num_operand++;
			}
			
			if(pressed_key == '='){
				
				if(num_operand == 0 && num_operator == 0){
					init();
				}
				
				else 
				if(!(num_operand == 1 && num_operator == 0) && !(num_operand == 2 && num_operator == 1)){
					init();
					for(j = 0; j < 10; j++)
						write_data(error[j]);
					ms_delay(500);
					init();
				}
					
				else{
					if(operator1 == '*')
						result = operand1 * operand2;
					
					else
					if(operator1 == '/'){
						if(operand2 == 0){
							init();
							for(j = 0; j < 10; j++)
								write_data(error[j]);
							ms_delay(500);
							init();
							continue;
							
						} else
								result = operand1 / operand2;		
					}
					
					else
						if(operator1 == '-'){
							if(operand1 < operand2){
								negative = 'Y';
								result = operand2 - operand1;
							} else
								result = operand1 - operand2;
						}
					else
							result = operand1 + operand2;

					write_result(result, &negative);
					
					ms_delay(1000);
					init();
				}
					
			}
			
		}
	}
	
}

void init(){
	
	operand = &operand1;
	operand1 = 0;
	operand2 = 0;
	result = 0;
	num_operand = 0;
	num_operator = 0;
	
	command(0x0F);
	
	command(0x38);
	
	command(0x01);
	
	ms_delay(50);
	
}

void command(unsigned int comm){
	
	RW = 0;
	RS = 0;
	P2 = comm;
	EN = 1;
	ms_delay(50);
	EN = 0;
	
}

void write_data(unsigned char c){
	
	RW = 0;
	RS = 1;
	P2 = c;
	EN = 1;
	ms_delay(50);
	EN = 0;
	
}

void ms_delay(unsigned int time){
	
	TMOD = 0x10;
	TL1 = 0x18;
	TH1 = 0xFC;
	TR1 = 1;
	
	while(time--){
		
		while(TF1 == 0);
		TF1 = 0;
		TL1 = 0x18;
		TH1 = 0xFC;
		
	}
	
	TR1 = 0;
}

char get_key(int c1, int c2, int c3, int c4, char data1, char data2, char data3, char data4){
	
	char c = 'Z';
	P1_0 = c1;
	P1_1 = c2;
	P1_2 = c3;
	P1_3 = c4;
	
	if(P1_4 == 0)
		c = data1;
	
	else
	if(P1_5 == 0)
		c = data2;
	
	else
	if(P1_6 == 0)
		c = data3;
	
	else
	if(P1_7 == 0)
		if(data4 == 'C')
			init();
		else
			c = data4;
	
	if(c != 'Z'){
		write_data(c);
		ms_delay(200);
	}
	
	return c;
}

void num_generator(char c, unsigned int* operand){
	
	int digit = 0;
	digit = c - '0';
	*operand = digit + (*operand * 10);
		
}

void write_result(unsigned int result, char *neg){
	
	int i = 0, j = 0, tmp = 0;
	char rev_num[20];
	
	command(0xC0);
	
	if(*neg == 'Y'){
		write_data('-');
		*neg = 'N';
	}
	
	do{
		tmp = result % 10;
		result /= 10;
		rev_num[i++] = tmp + '0';
	} while(result > 0);
	
	for(j = i-1; j >= 0; j--)
		write_data(rev_num[j]);
		
}

