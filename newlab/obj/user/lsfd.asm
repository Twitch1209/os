
obj/user/lsfd.debug：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 40 20 80 00       	push   $0x802040
  80003e:	e8 c3 01 00 00       	call   800206 <cprintf>
	exit();
  800043:	e8 0f 01 00 00       	call   800157 <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 6e 0d 00 00       	call   800dda <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 82 0d 00 00       	call   800e0a <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 f7                	mov    %esi,%edi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8000b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	68 54 20 80 00       	push   $0x802054
  8000c2:	e8 3f 01 00 00       	call   800206 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 31 13 00 00       	call   80140d <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 ff                	test   %edi,%edi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	pushl  0x4(%eax)
  8000f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	68 54 20 80 00       	push   $0x802054
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 03 17 00 00       	call   801807 <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80011c:	e8 8a 0a 00 00       	call   800bab <sys_getenvid>
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800129:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	85 db                	test   %ebx,%ebx
  800135:	7e 07                	jle    80013e <libmain+0x2d>
		binaryname = argv[0];
  800137:	8b 06                	mov    (%esi),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	e8 05 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800148:	e8 0a 00 00 00       	call   800157 <exit>
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015d:	e8 a2 0f 00 00       	call   801104 <close_all>
	sys_env_destroy(0);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	6a 00                	push   $0x0
  800167:	e8 fe 09 00 00       	call   800b6a <sys_env_destroy>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	53                   	push   %ebx
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017b:	8b 13                	mov    (%ebx),%edx
  80017d:	8d 42 01             	lea    0x1(%edx),%eax
  800180:	89 03                	mov    %eax,(%ebx)
  800182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800185:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800189:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018e:	74 09                	je     800199 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800190:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800197:	c9                   	leave  
  800198:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	68 ff 00 00 00       	push   $0xff
  8001a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a4:	50                   	push   %eax
  8001a5:	e8 83 09 00 00       	call   800b2d <sys_cputs>
		b->idx = 0;
  8001aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb db                	jmp    800190 <putch+0x1f>

008001b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c5:	00 00 00 
	b.cnt = 0;
  8001c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	ff 75 08             	pushl  0x8(%ebp)
  8001d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001de:	50                   	push   %eax
  8001df:	68 71 01 80 00       	push   $0x800171
  8001e4:	e8 1a 01 00 00       	call   800303 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e9:	83 c4 08             	add    $0x8,%esp
  8001ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f8:	50                   	push   %eax
  8001f9:	e8 2f 09 00 00       	call   800b2d <sys_cputs>

	return b.cnt;
}
  8001fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020f:	50                   	push   %eax
  800210:	ff 75 08             	pushl  0x8(%ebp)
  800213:	e8 9d ff ff ff       	call   8001b5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	57                   	push   %edi
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	83 ec 1c             	sub    $0x1c,%esp
  800223:	89 c7                	mov    %eax,%edi
  800225:	89 d6                	mov    %edx,%esi
  800227:	8b 45 08             	mov    0x8(%ebp),%eax
  80022a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800230:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800233:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800241:	39 d3                	cmp    %edx,%ebx
  800243:	72 05                	jb     80024a <printnum+0x30>
  800245:	39 45 10             	cmp    %eax,0x10(%ebp)
  800248:	77 7a                	ja     8002c4 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	ff 75 18             	pushl  0x18(%ebp)
  800250:	8b 45 14             	mov    0x14(%ebp),%eax
  800253:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800256:	53                   	push   %ebx
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800260:	ff 75 e0             	pushl  -0x20(%ebp)
  800263:	ff 75 dc             	pushl  -0x24(%ebp)
  800266:	ff 75 d8             	pushl  -0x28(%ebp)
  800269:	e8 82 1b 00 00       	call   801df0 <__udivdi3>
  80026e:	83 c4 18             	add    $0x18,%esp
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	89 f2                	mov    %esi,%edx
  800275:	89 f8                	mov    %edi,%eax
  800277:	e8 9e ff ff ff       	call   80021a <printnum>
  80027c:	83 c4 20             	add    $0x20,%esp
  80027f:	eb 13                	jmp    800294 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800281:	83 ec 08             	sub    $0x8,%esp
  800284:	56                   	push   %esi
  800285:	ff 75 18             	pushl  0x18(%ebp)
  800288:	ff d7                	call   *%edi
  80028a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80028d:	83 eb 01             	sub    $0x1,%ebx
  800290:	85 db                	test   %ebx,%ebx
  800292:	7f ed                	jg     800281 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	56                   	push   %esi
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029e:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a7:	e8 64 1c 00 00       	call   801f10 <__umoddi3>
  8002ac:	83 c4 14             	add    $0x14,%esp
  8002af:	0f be 80 86 20 80 00 	movsbl 0x802086(%eax),%eax
  8002b6:	50                   	push   %eax
  8002b7:	ff d7                	call   *%edi
}
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    
  8002c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c7:	eb c4                	jmp    80028d <printnum+0x73>

008002c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d3:	8b 10                	mov    (%eax),%edx
  8002d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d8:	73 0a                	jae    8002e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dd:	89 08                	mov    %ecx,(%eax)
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	88 02                	mov    %al,(%edx)
}
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <printfmt>:
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ef:	50                   	push   %eax
  8002f0:	ff 75 10             	pushl  0x10(%ebp)
  8002f3:	ff 75 0c             	pushl  0xc(%ebp)
  8002f6:	ff 75 08             	pushl  0x8(%ebp)
  8002f9:	e8 05 00 00 00       	call   800303 <vprintfmt>
}
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <vprintfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 2c             	sub    $0x2c,%esp
  80030c:	8b 75 08             	mov    0x8(%ebp),%esi
  80030f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800312:	8b 7d 10             	mov    0x10(%ebp),%edi
  800315:	e9 8c 03 00 00       	jmp    8006a6 <vprintfmt+0x3a3>
		padc = ' ';
  80031a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80031e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800325:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80032c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800333:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800338:	8d 47 01             	lea    0x1(%edi),%eax
  80033b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033e:	0f b6 17             	movzbl (%edi),%edx
  800341:	8d 42 dd             	lea    -0x23(%edx),%eax
  800344:	3c 55                	cmp    $0x55,%al
  800346:	0f 87 dd 03 00 00    	ja     800729 <vprintfmt+0x426>
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	ff 24 85 c0 21 80 00 	jmp    *0x8021c0(,%eax,4)
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800359:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80035d:	eb d9                	jmp    800338 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800362:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800366:	eb d0                	jmp    800338 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800368:	0f b6 d2             	movzbl %dl,%edx
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80036e:	b8 00 00 00 00       	mov    $0x0,%eax
  800373:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800376:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800379:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80037d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800380:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800383:	83 f9 09             	cmp    $0x9,%ecx
  800386:	77 55                	ja     8003dd <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800388:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038b:	eb e9                	jmp    800376 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80038d:	8b 45 14             	mov    0x14(%ebp),%eax
  800390:	8b 00                	mov    (%eax),%eax
  800392:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800395:	8b 45 14             	mov    0x14(%ebp),%eax
  800398:	8d 40 04             	lea    0x4(%eax),%eax
  80039b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a5:	79 91                	jns    800338 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ad:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b4:	eb 82                	jmp    800338 <vprintfmt+0x35>
  8003b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b9:	85 c0                	test   %eax,%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	0f 49 d0             	cmovns %eax,%edx
  8003c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c9:	e9 6a ff ff ff       	jmp    800338 <vprintfmt+0x35>
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d8:	e9 5b ff ff ff       	jmp    800338 <vprintfmt+0x35>
  8003dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e3:	eb bc                	jmp    8003a1 <vprintfmt+0x9e>
			lflag++;
  8003e5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003eb:	e9 48 ff ff ff       	jmp    800338 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f3:	8d 78 04             	lea    0x4(%eax),%edi
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	53                   	push   %ebx
  8003fa:	ff 30                	pushl  (%eax)
  8003fc:	ff d6                	call   *%esi
			break;
  8003fe:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800401:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800404:	e9 9a 02 00 00       	jmp    8006a3 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	8d 78 04             	lea    0x4(%eax),%edi
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	99                   	cltd   
  800412:	31 d0                	xor    %edx,%eax
  800414:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800416:	83 f8 0f             	cmp    $0xf,%eax
  800419:	7f 23                	jg     80043e <vprintfmt+0x13b>
  80041b:	8b 14 85 20 23 80 00 	mov    0x802320(,%eax,4),%edx
  800422:	85 d2                	test   %edx,%edx
  800424:	74 18                	je     80043e <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800426:	52                   	push   %edx
  800427:	68 51 24 80 00       	push   $0x802451
  80042c:	53                   	push   %ebx
  80042d:	56                   	push   %esi
  80042e:	e8 b3 fe ff ff       	call   8002e6 <printfmt>
  800433:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800436:	89 7d 14             	mov    %edi,0x14(%ebp)
  800439:	e9 65 02 00 00       	jmp    8006a3 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80043e:	50                   	push   %eax
  80043f:	68 9e 20 80 00       	push   $0x80209e
  800444:	53                   	push   %ebx
  800445:	56                   	push   %esi
  800446:	e8 9b fe ff ff       	call   8002e6 <printfmt>
  80044b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800451:	e9 4d 02 00 00       	jmp    8006a3 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800456:	8b 45 14             	mov    0x14(%ebp),%eax
  800459:	83 c0 04             	add    $0x4,%eax
  80045c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800464:	85 ff                	test   %edi,%edi
  800466:	b8 97 20 80 00       	mov    $0x802097,%eax
  80046b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80046e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800472:	0f 8e bd 00 00 00    	jle    800535 <vprintfmt+0x232>
  800478:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80047c:	75 0e                	jne    80048c <vprintfmt+0x189>
  80047e:	89 75 08             	mov    %esi,0x8(%ebp)
  800481:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800484:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800487:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80048a:	eb 6d                	jmp    8004f9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 d0             	pushl  -0x30(%ebp)
  800492:	57                   	push   %edi
  800493:	e8 39 03 00 00       	call   8007d1 <strnlen>
  800498:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049b:	29 c1                	sub    %eax,%ecx
  80049d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004a0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004a3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004aa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ad:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004af:	eb 0f                	jmp    8004c0 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	53                   	push   %ebx
  8004b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ed                	jg     8004b1 <vprintfmt+0x1ae>
  8004c4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004c7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004ca:	85 c9                	test   %ecx,%ecx
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	0f 49 c1             	cmovns %ecx,%eax
  8004d4:	29 c1                	sub    %eax,%ecx
  8004d6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004dc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004df:	89 cb                	mov    %ecx,%ebx
  8004e1:	eb 16                	jmp    8004f9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e7:	75 31                	jne    80051a <vprintfmt+0x217>
					putch(ch, putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	ff 75 0c             	pushl  0xc(%ebp)
  8004ef:	50                   	push   %eax
  8004f0:	ff 55 08             	call   *0x8(%ebp)
  8004f3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f6:	83 eb 01             	sub    $0x1,%ebx
  8004f9:	83 c7 01             	add    $0x1,%edi
  8004fc:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800500:	0f be c2             	movsbl %dl,%eax
  800503:	85 c0                	test   %eax,%eax
  800505:	74 59                	je     800560 <vprintfmt+0x25d>
  800507:	85 f6                	test   %esi,%esi
  800509:	78 d8                	js     8004e3 <vprintfmt+0x1e0>
  80050b:	83 ee 01             	sub    $0x1,%esi
  80050e:	79 d3                	jns    8004e3 <vprintfmt+0x1e0>
  800510:	89 df                	mov    %ebx,%edi
  800512:	8b 75 08             	mov    0x8(%ebp),%esi
  800515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800518:	eb 37                	jmp    800551 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80051a:	0f be d2             	movsbl %dl,%edx
  80051d:	83 ea 20             	sub    $0x20,%edx
  800520:	83 fa 5e             	cmp    $0x5e,%edx
  800523:	76 c4                	jbe    8004e9 <vprintfmt+0x1e6>
					putch('?', putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 0c             	pushl  0xc(%ebp)
  80052b:	6a 3f                	push   $0x3f
  80052d:	ff 55 08             	call   *0x8(%ebp)
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	eb c1                	jmp    8004f6 <vprintfmt+0x1f3>
  800535:	89 75 08             	mov    %esi,0x8(%ebp)
  800538:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800541:	eb b6                	jmp    8004f9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 20                	push   $0x20
  800549:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ee                	jg     800543 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	e9 43 01 00 00       	jmp    8006a3 <vprintfmt+0x3a0>
  800560:	89 df                	mov    %ebx,%edi
  800562:	8b 75 08             	mov    0x8(%ebp),%esi
  800565:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800568:	eb e7                	jmp    800551 <vprintfmt+0x24e>
	if (lflag >= 2)
  80056a:	83 f9 01             	cmp    $0x1,%ecx
  80056d:	7e 3f                	jle    8005ae <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 50 04             	mov    0x4(%eax),%edx
  800575:	8b 00                	mov    (%eax),%eax
  800577:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 40 08             	lea    0x8(%eax),%eax
  800583:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800586:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80058a:	79 5c                	jns    8005e8 <vprintfmt+0x2e5>
				putch('-', putdat);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	53                   	push   %ebx
  800590:	6a 2d                	push   $0x2d
  800592:	ff d6                	call   *%esi
				num = -(long long) num;
  800594:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800597:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80059a:	f7 da                	neg    %edx
  80059c:	83 d1 00             	adc    $0x0,%ecx
  80059f:	f7 d9                	neg    %ecx
  8005a1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a9:	e9 db 00 00 00       	jmp    800689 <vprintfmt+0x386>
	else if (lflag)
  8005ae:	85 c9                	test   %ecx,%ecx
  8005b0:	75 1b                	jne    8005cd <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	89 c1                	mov    %eax,%ecx
  8005bc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005bf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cb:	eb b9                	jmp    800586 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	89 c1                	mov    %eax,%ecx
  8005d7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	eb 9e                	jmp    800586 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005eb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f3:	e9 91 00 00 00       	jmp    800689 <vprintfmt+0x386>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 15                	jle    800612 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 10                	mov    (%eax),%edx
  800602:	8b 48 04             	mov    0x4(%eax),%ecx
  800605:	8d 40 08             	lea    0x8(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	eb 77                	jmp    800689 <vprintfmt+0x386>
	else if (lflag)
  800612:	85 c9                	test   %ecx,%ecx
  800614:	75 17                	jne    80062d <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 10                	mov    (%eax),%edx
  80061b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800620:	8d 40 04             	lea    0x4(%eax),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800626:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062b:	eb 5c                	jmp    800689 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 10                	mov    (%eax),%edx
  800632:	b9 00 00 00 00       	mov    $0x0,%ecx
  800637:	8d 40 04             	lea    0x4(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800642:	eb 45                	jmp    800689 <vprintfmt+0x386>
			putch('X', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 58                	push   $0x58
  80064a:	ff d6                	call   *%esi
			putch('X', putdat);
  80064c:	83 c4 08             	add    $0x8,%esp
  80064f:	53                   	push   %ebx
  800650:	6a 58                	push   $0x58
  800652:	ff d6                	call   *%esi
			putch('X', putdat);
  800654:	83 c4 08             	add    $0x8,%esp
  800657:	53                   	push   %ebx
  800658:	6a 58                	push   $0x58
  80065a:	ff d6                	call   *%esi
			break;
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	eb 42                	jmp    8006a3 <vprintfmt+0x3a0>
			putch('0', putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	6a 30                	push   $0x30
  800667:	ff d6                	call   *%esi
			putch('x', putdat);
  800669:	83 c4 08             	add    $0x8,%esp
  80066c:	53                   	push   %ebx
  80066d:	6a 78                	push   $0x78
  80066f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80067b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800684:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800690:	57                   	push   %edi
  800691:	ff 75 e0             	pushl  -0x20(%ebp)
  800694:	50                   	push   %eax
  800695:	51                   	push   %ecx
  800696:	52                   	push   %edx
  800697:	89 da                	mov    %ebx,%edx
  800699:	89 f0                	mov    %esi,%eax
  80069b:	e8 7a fb ff ff       	call   80021a <printnum>
			break;
  8006a0:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a6:	83 c7 01             	add    $0x1,%edi
  8006a9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ad:	83 f8 25             	cmp    $0x25,%eax
  8006b0:	0f 84 64 fc ff ff    	je     80031a <vprintfmt+0x17>
			if (ch == '\0')
  8006b6:	85 c0                	test   %eax,%eax
  8006b8:	0f 84 8b 00 00 00    	je     800749 <vprintfmt+0x446>
			putch(ch, putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	53                   	push   %ebx
  8006c2:	50                   	push   %eax
  8006c3:	ff d6                	call   *%esi
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	eb dc                	jmp    8006a6 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8006ca:	83 f9 01             	cmp    $0x1,%ecx
  8006cd:	7e 15                	jle    8006e4 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 10                	mov    (%eax),%edx
  8006d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006d7:	8d 40 08             	lea    0x8(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e2:	eb a5                	jmp    800689 <vprintfmt+0x386>
	else if (lflag)
  8006e4:	85 c9                	test   %ecx,%ecx
  8006e6:	75 17                	jne    8006ff <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 10                	mov    (%eax),%edx
  8006ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fd:	eb 8a                	jmp    800689 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	b9 00 00 00 00       	mov    $0x0,%ecx
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070f:	b8 10 00 00 00       	mov    $0x10,%eax
  800714:	e9 70 ff ff ff       	jmp    800689 <vprintfmt+0x386>
			putch(ch, putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 25                	push   $0x25
  80071f:	ff d6                	call   *%esi
			break;
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	e9 7a ff ff ff       	jmp    8006a3 <vprintfmt+0x3a0>
			putch('%', putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	53                   	push   %ebx
  80072d:	6a 25                	push   $0x25
  80072f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	89 f8                	mov    %edi,%eax
  800736:	eb 03                	jmp    80073b <vprintfmt+0x438>
  800738:	83 e8 01             	sub    $0x1,%eax
  80073b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80073f:	75 f7                	jne    800738 <vprintfmt+0x435>
  800741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800744:	e9 5a ff ff ff       	jmp    8006a3 <vprintfmt+0x3a0>
}
  800749:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074c:	5b                   	pop    %ebx
  80074d:	5e                   	pop    %esi
  80074e:	5f                   	pop    %edi
  80074f:	5d                   	pop    %ebp
  800750:	c3                   	ret    

00800751 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	83 ec 18             	sub    $0x18,%esp
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800760:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800764:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800767:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 26                	je     800798 <vsnprintf+0x47>
  800772:	85 d2                	test   %edx,%edx
  800774:	7e 22                	jle    800798 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800776:	ff 75 14             	pushl  0x14(%ebp)
  800779:	ff 75 10             	pushl  0x10(%ebp)
  80077c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077f:	50                   	push   %eax
  800780:	68 c9 02 80 00       	push   $0x8002c9
  800785:	e8 79 fb ff ff       	call   800303 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80078a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800793:	83 c4 10             	add    $0x10,%esp
}
  800796:	c9                   	leave  
  800797:	c3                   	ret    
		return -E_INVAL;
  800798:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079d:	eb f7                	jmp    800796 <vsnprintf+0x45>

0080079f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a8:	50                   	push   %eax
  8007a9:	ff 75 10             	pushl  0x10(%ebp)
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	ff 75 08             	pushl  0x8(%ebp)
  8007b2:	e8 9a ff ff ff       	call   800751 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	eb 03                	jmp    8007c9 <strlen+0x10>
		n++;
  8007c6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007c9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007cd:	75 f7                	jne    8007c6 <strlen+0xd>
	return n;
}
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	eb 03                	jmp    8007e4 <strnlen+0x13>
		n++;
  8007e1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e4:	39 d0                	cmp    %edx,%eax
  8007e6:	74 06                	je     8007ee <strnlen+0x1d>
  8007e8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007ec:	75 f3                	jne    8007e1 <strnlen+0x10>
	return n;
}
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	53                   	push   %ebx
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	83 c1 01             	add    $0x1,%ecx
  8007ff:	83 c2 01             	add    $0x1,%edx
  800802:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800806:	88 5a ff             	mov    %bl,-0x1(%edx)
  800809:	84 db                	test   %bl,%bl
  80080b:	75 ef                	jne    8007fc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80080d:	5b                   	pop    %ebx
  80080e:	5d                   	pop    %ebp
  80080f:	c3                   	ret    

00800810 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	53                   	push   %ebx
  800814:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800817:	53                   	push   %ebx
  800818:	e8 9c ff ff ff       	call   8007b9 <strlen>
  80081d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	01 d8                	add    %ebx,%eax
  800825:	50                   	push   %eax
  800826:	e8 c5 ff ff ff       	call   8007f0 <strcpy>
	return dst;
}
  80082b:	89 d8                	mov    %ebx,%eax
  80082d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	56                   	push   %esi
  800836:	53                   	push   %ebx
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083d:	89 f3                	mov    %esi,%ebx
  80083f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800842:	89 f2                	mov    %esi,%edx
  800844:	eb 0f                	jmp    800855 <strncpy+0x23>
		*dst++ = *src;
  800846:	83 c2 01             	add    $0x1,%edx
  800849:	0f b6 01             	movzbl (%ecx),%eax
  80084c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80084f:	80 39 01             	cmpb   $0x1,(%ecx)
  800852:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800855:	39 da                	cmp    %ebx,%edx
  800857:	75 ed                	jne    800846 <strncpy+0x14>
	}
	return ret;
}
  800859:	89 f0                	mov    %esi,%eax
  80085b:	5b                   	pop    %ebx
  80085c:	5e                   	pop    %esi
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	56                   	push   %esi
  800863:	53                   	push   %ebx
  800864:	8b 75 08             	mov    0x8(%ebp),%esi
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80086d:	89 f0                	mov    %esi,%eax
  80086f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800873:	85 c9                	test   %ecx,%ecx
  800875:	75 0b                	jne    800882 <strlcpy+0x23>
  800877:	eb 17                	jmp    800890 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800879:	83 c2 01             	add    $0x1,%edx
  80087c:	83 c0 01             	add    $0x1,%eax
  80087f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800882:	39 d8                	cmp    %ebx,%eax
  800884:	74 07                	je     80088d <strlcpy+0x2e>
  800886:	0f b6 0a             	movzbl (%edx),%ecx
  800889:	84 c9                	test   %cl,%cl
  80088b:	75 ec                	jne    800879 <strlcpy+0x1a>
		*dst = '\0';
  80088d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800890:	29 f0                	sub    %esi,%eax
}
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089f:	eb 06                	jmp    8008a7 <strcmp+0x11>
		p++, q++;
  8008a1:	83 c1 01             	add    $0x1,%ecx
  8008a4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008a7:	0f b6 01             	movzbl (%ecx),%eax
  8008aa:	84 c0                	test   %al,%al
  8008ac:	74 04                	je     8008b2 <strcmp+0x1c>
  8008ae:	3a 02                	cmp    (%edx),%al
  8008b0:	74 ef                	je     8008a1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b2:	0f b6 c0             	movzbl %al,%eax
  8008b5:	0f b6 12             	movzbl (%edx),%edx
  8008b8:	29 d0                	sub    %edx,%eax
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	53                   	push   %ebx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c6:	89 c3                	mov    %eax,%ebx
  8008c8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008cb:	eb 06                	jmp    8008d3 <strncmp+0x17>
		n--, p++, q++;
  8008cd:	83 c0 01             	add    $0x1,%eax
  8008d0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008d3:	39 d8                	cmp    %ebx,%eax
  8008d5:	74 16                	je     8008ed <strncmp+0x31>
  8008d7:	0f b6 08             	movzbl (%eax),%ecx
  8008da:	84 c9                	test   %cl,%cl
  8008dc:	74 04                	je     8008e2 <strncmp+0x26>
  8008de:	3a 0a                	cmp    (%edx),%cl
  8008e0:	74 eb                	je     8008cd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e2:	0f b6 00             	movzbl (%eax),%eax
  8008e5:	0f b6 12             	movzbl (%edx),%edx
  8008e8:	29 d0                	sub    %edx,%eax
}
  8008ea:	5b                   	pop    %ebx
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    
		return 0;
  8008ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f2:	eb f6                	jmp    8008ea <strncmp+0x2e>

008008f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fe:	0f b6 10             	movzbl (%eax),%edx
  800901:	84 d2                	test   %dl,%dl
  800903:	74 09                	je     80090e <strchr+0x1a>
		if (*s == c)
  800905:	38 ca                	cmp    %cl,%dl
  800907:	74 0a                	je     800913 <strchr+0x1f>
	for (; *s; s++)
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	eb f0                	jmp    8008fe <strchr+0xa>
			return (char *) s;
	return 0;
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091f:	eb 03                	jmp    800924 <strfind+0xf>
  800921:	83 c0 01             	add    $0x1,%eax
  800924:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800927:	38 ca                	cmp    %cl,%dl
  800929:	74 04                	je     80092f <strfind+0x1a>
  80092b:	84 d2                	test   %dl,%dl
  80092d:	75 f2                	jne    800921 <strfind+0xc>
			break;
	return (char *) s;
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	57                   	push   %edi
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 7d 08             	mov    0x8(%ebp),%edi
  80093a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80093d:	85 c9                	test   %ecx,%ecx
  80093f:	74 13                	je     800954 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800941:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800947:	75 05                	jne    80094e <memset+0x1d>
  800949:	f6 c1 03             	test   $0x3,%cl
  80094c:	74 0d                	je     80095b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	fc                   	cld    
  800952:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800954:	89 f8                	mov    %edi,%eax
  800956:	5b                   	pop    %ebx
  800957:	5e                   	pop    %esi
  800958:	5f                   	pop    %edi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    
		c &= 0xFF;
  80095b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095f:	89 d3                	mov    %edx,%ebx
  800961:	c1 e3 08             	shl    $0x8,%ebx
  800964:	89 d0                	mov    %edx,%eax
  800966:	c1 e0 18             	shl    $0x18,%eax
  800969:	89 d6                	mov    %edx,%esi
  80096b:	c1 e6 10             	shl    $0x10,%esi
  80096e:	09 f0                	or     %esi,%eax
  800970:	09 c2                	or     %eax,%edx
  800972:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800974:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800977:	89 d0                	mov    %edx,%eax
  800979:	fc                   	cld    
  80097a:	f3 ab                	rep stos %eax,%es:(%edi)
  80097c:	eb d6                	jmp    800954 <memset+0x23>

0080097e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	57                   	push   %edi
  800982:	56                   	push   %esi
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 75 0c             	mov    0xc(%ebp),%esi
  800989:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80098c:	39 c6                	cmp    %eax,%esi
  80098e:	73 35                	jae    8009c5 <memmove+0x47>
  800990:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800993:	39 c2                	cmp    %eax,%edx
  800995:	76 2e                	jbe    8009c5 <memmove+0x47>
		s += n;
		d += n;
  800997:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099a:	89 d6                	mov    %edx,%esi
  80099c:	09 fe                	or     %edi,%esi
  80099e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009a4:	74 0c                	je     8009b2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a6:	83 ef 01             	sub    $0x1,%edi
  8009a9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ac:	fd                   	std    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009af:	fc                   	cld    
  8009b0:	eb 21                	jmp    8009d3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	f6 c1 03             	test   $0x3,%cl
  8009b5:	75 ef                	jne    8009a6 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b7:	83 ef 04             	sub    $0x4,%edi
  8009ba:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c3:	eb ea                	jmp    8009af <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c5:	89 f2                	mov    %esi,%edx
  8009c7:	09 c2                	or     %eax,%edx
  8009c9:	f6 c2 03             	test   $0x3,%dl
  8009cc:	74 09                	je     8009d7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ce:	89 c7                	mov    %eax,%edi
  8009d0:	fc                   	cld    
  8009d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d3:	5e                   	pop    %esi
  8009d4:	5f                   	pop    %edi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d7:	f6 c1 03             	test   $0x3,%cl
  8009da:	75 f2                	jne    8009ce <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e4:	eb ed                	jmp    8009d3 <memmove+0x55>

008009e6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009e9:	ff 75 10             	pushl  0x10(%ebp)
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	ff 75 08             	pushl  0x8(%ebp)
  8009f2:	e8 87 ff ff ff       	call   80097e <memmove>
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	56                   	push   %esi
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a04:	89 c6                	mov    %eax,%esi
  800a06:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a09:	39 f0                	cmp    %esi,%eax
  800a0b:	74 1c                	je     800a29 <memcmp+0x30>
		if (*s1 != *s2)
  800a0d:	0f b6 08             	movzbl (%eax),%ecx
  800a10:	0f b6 1a             	movzbl (%edx),%ebx
  800a13:	38 d9                	cmp    %bl,%cl
  800a15:	75 08                	jne    800a1f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	83 c2 01             	add    $0x1,%edx
  800a1d:	eb ea                	jmp    800a09 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a1f:	0f b6 c1             	movzbl %cl,%eax
  800a22:	0f b6 db             	movzbl %bl,%ebx
  800a25:	29 d8                	sub    %ebx,%eax
  800a27:	eb 05                	jmp    800a2e <memcmp+0x35>
	}

	return 0;
  800a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2e:	5b                   	pop    %ebx
  800a2f:	5e                   	pop    %esi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a40:	39 d0                	cmp    %edx,%eax
  800a42:	73 09                	jae    800a4d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a44:	38 08                	cmp    %cl,(%eax)
  800a46:	74 05                	je     800a4d <memfind+0x1b>
	for (; s < ends; s++)
  800a48:	83 c0 01             	add    $0x1,%eax
  800a4b:	eb f3                	jmp    800a40 <memfind+0xe>
			break;
	return (void *) s;
}
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	57                   	push   %edi
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5b:	eb 03                	jmp    800a60 <strtol+0x11>
		s++;
  800a5d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a60:	0f b6 01             	movzbl (%ecx),%eax
  800a63:	3c 20                	cmp    $0x20,%al
  800a65:	74 f6                	je     800a5d <strtol+0xe>
  800a67:	3c 09                	cmp    $0x9,%al
  800a69:	74 f2                	je     800a5d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a6b:	3c 2b                	cmp    $0x2b,%al
  800a6d:	74 2e                	je     800a9d <strtol+0x4e>
	int neg = 0;
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a74:	3c 2d                	cmp    $0x2d,%al
  800a76:	74 2f                	je     800aa7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a78:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7e:	75 05                	jne    800a85 <strtol+0x36>
  800a80:	80 39 30             	cmpb   $0x30,(%ecx)
  800a83:	74 2c                	je     800ab1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a85:	85 db                	test   %ebx,%ebx
  800a87:	75 0a                	jne    800a93 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a89:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a8e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a91:	74 28                	je     800abb <strtol+0x6c>
		base = 10;
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
  800a98:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a9b:	eb 50                	jmp    800aed <strtol+0x9e>
		s++;
  800a9d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aa0:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa5:	eb d1                	jmp    800a78 <strtol+0x29>
		s++, neg = 1;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	bf 01 00 00 00       	mov    $0x1,%edi
  800aaf:	eb c7                	jmp    800a78 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab5:	74 0e                	je     800ac5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab7:	85 db                	test   %ebx,%ebx
  800ab9:	75 d8                	jne    800a93 <strtol+0x44>
		s++, base = 8;
  800abb:	83 c1 01             	add    $0x1,%ecx
  800abe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ac3:	eb ce                	jmp    800a93 <strtol+0x44>
		s += 2, base = 16;
  800ac5:	83 c1 02             	add    $0x2,%ecx
  800ac8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800acd:	eb c4                	jmp    800a93 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800acf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ad2:	89 f3                	mov    %esi,%ebx
  800ad4:	80 fb 19             	cmp    $0x19,%bl
  800ad7:	77 29                	ja     800b02 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad9:	0f be d2             	movsbl %dl,%edx
  800adc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800adf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae2:	7d 30                	jge    800b14 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae4:	83 c1 01             	add    $0x1,%ecx
  800ae7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aeb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aed:	0f b6 11             	movzbl (%ecx),%edx
  800af0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af3:	89 f3                	mov    %esi,%ebx
  800af5:	80 fb 09             	cmp    $0x9,%bl
  800af8:	77 d5                	ja     800acf <strtol+0x80>
			dig = *s - '0';
  800afa:	0f be d2             	movsbl %dl,%edx
  800afd:	83 ea 30             	sub    $0x30,%edx
  800b00:	eb dd                	jmp    800adf <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b02:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b05:	89 f3                	mov    %esi,%ebx
  800b07:	80 fb 19             	cmp    $0x19,%bl
  800b0a:	77 08                	ja     800b14 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b0c:	0f be d2             	movsbl %dl,%edx
  800b0f:	83 ea 37             	sub    $0x37,%edx
  800b12:	eb cb                	jmp    800adf <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b18:	74 05                	je     800b1f <strtol+0xd0>
		*endptr = (char *) s;
  800b1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b1f:	89 c2                	mov    %eax,%edx
  800b21:	f7 da                	neg    %edx
  800b23:	85 ff                	test   %edi,%edi
  800b25:	0f 45 c2             	cmovne %edx,%eax
}
  800b28:	5b                   	pop    %ebx
  800b29:	5e                   	pop    %esi
  800b2a:	5f                   	pop    %edi
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	57                   	push   %edi
  800b31:	56                   	push   %esi
  800b32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b33:	b8 00 00 00 00       	mov    $0x0,%eax
  800b38:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3e:	89 c3                	mov    %eax,%ebx
  800b40:	89 c7                	mov    %eax,%edi
  800b42:	89 c6                	mov    %eax,%esi
  800b44:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b46:	5b                   	pop    %ebx
  800b47:	5e                   	pop    %esi
  800b48:	5f                   	pop    %edi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	57                   	push   %edi
  800b4f:	56                   	push   %esi
  800b50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b51:	ba 00 00 00 00       	mov    $0x0,%edx
  800b56:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5b:	89 d1                	mov    %edx,%ecx
  800b5d:	89 d3                	mov    %edx,%ebx
  800b5f:	89 d7                	mov    %edx,%edi
  800b61:	89 d6                	mov    %edx,%esi
  800b63:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5f                   	pop    %edi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b78:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b80:	89 cb                	mov    %ecx,%ebx
  800b82:	89 cf                	mov    %ecx,%edi
  800b84:	89 ce                	mov    %ecx,%esi
  800b86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b88:	85 c0                	test   %eax,%eax
  800b8a:	7f 08                	jg     800b94 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b94:	83 ec 0c             	sub    $0xc,%esp
  800b97:	50                   	push   %eax
  800b98:	6a 03                	push   $0x3
  800b9a:	68 7f 23 80 00       	push   $0x80237f
  800b9f:	6a 23                	push   $0x23
  800ba1:	68 9c 23 80 00       	push   $0x80239c
  800ba6:	e8 53 11 00 00       	call   801cfe <_panic>

00800bab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	57                   	push   %edi
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb6:	b8 02 00 00 00       	mov    $0x2,%eax
  800bbb:	89 d1                	mov    %edx,%ecx
  800bbd:	89 d3                	mov    %edx,%ebx
  800bbf:	89 d7                	mov    %edx,%edi
  800bc1:	89 d6                	mov    %edx,%esi
  800bc3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <sys_yield>:

void
sys_yield(void)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bda:	89 d1                	mov    %edx,%ecx
  800bdc:	89 d3                	mov    %edx,%ebx
  800bde:	89 d7                	mov    %edx,%edi
  800be0:	89 d6                	mov    %edx,%esi
  800be2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf2:	be 00 00 00 00       	mov    $0x0,%esi
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfd:	b8 04 00 00 00       	mov    $0x4,%eax
  800c02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c05:	89 f7                	mov    %esi,%edi
  800c07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	7f 08                	jg     800c15 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	6a 04                	push   $0x4
  800c1b:	68 7f 23 80 00       	push   $0x80237f
  800c20:	6a 23                	push   $0x23
  800c22:	68 9c 23 80 00       	push   $0x80239c
  800c27:	e8 d2 10 00 00       	call   801cfe <_panic>

00800c2c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c35:	8b 55 08             	mov    0x8(%ebp),%edx
  800c38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3b:	b8 05 00 00 00       	mov    $0x5,%eax
  800c40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c46:	8b 75 18             	mov    0x18(%ebp),%esi
  800c49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	7f 08                	jg     800c57 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	50                   	push   %eax
  800c5b:	6a 05                	push   $0x5
  800c5d:	68 7f 23 80 00       	push   $0x80237f
  800c62:	6a 23                	push   $0x23
  800c64:	68 9c 23 80 00       	push   $0x80239c
  800c69:	e8 90 10 00 00       	call   801cfe <_panic>

00800c6e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 06 00 00 00       	mov    $0x6,%eax
  800c87:	89 df                	mov    %ebx,%edi
  800c89:	89 de                	mov    %ebx,%esi
  800c8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	7f 08                	jg     800c99 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c99:	83 ec 0c             	sub    $0xc,%esp
  800c9c:	50                   	push   %eax
  800c9d:	6a 06                	push   $0x6
  800c9f:	68 7f 23 80 00       	push   $0x80237f
  800ca4:	6a 23                	push   $0x23
  800ca6:	68 9c 23 80 00       	push   $0x80239c
  800cab:	e8 4e 10 00 00       	call   801cfe <_panic>

00800cb0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc9:	89 df                	mov    %ebx,%edi
  800ccb:	89 de                	mov    %ebx,%esi
  800ccd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 08                	push   $0x8
  800ce1:	68 7f 23 80 00       	push   $0x80237f
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 9c 23 80 00       	push   $0x80239c
  800ced:	e8 0c 10 00 00       	call   801cfe <_panic>

00800cf2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0b:	89 df                	mov    %ebx,%edi
  800d0d:	89 de                	mov    %ebx,%esi
  800d0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d11:	85 c0                	test   %eax,%eax
  800d13:	7f 08                	jg     800d1d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	83 ec 0c             	sub    $0xc,%esp
  800d20:	50                   	push   %eax
  800d21:	6a 09                	push   $0x9
  800d23:	68 7f 23 80 00       	push   $0x80237f
  800d28:	6a 23                	push   $0x23
  800d2a:	68 9c 23 80 00       	push   $0x80239c
  800d2f:	e8 ca 0f 00 00       	call   801cfe <_panic>

00800d34 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d4d:	89 df                	mov    %ebx,%edi
  800d4f:	89 de                	mov    %ebx,%esi
  800d51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	7f 08                	jg     800d5f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5f:	83 ec 0c             	sub    $0xc,%esp
  800d62:	50                   	push   %eax
  800d63:	6a 0a                	push   $0xa
  800d65:	68 7f 23 80 00       	push   $0x80237f
  800d6a:	6a 23                	push   $0x23
  800d6c:	68 9c 23 80 00       	push   $0x80239c
  800d71:	e8 88 0f 00 00       	call   801cfe <_panic>

00800d76 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	57                   	push   %edi
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d82:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d87:	be 00 00 00 00       	mov    $0x0,%esi
  800d8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d92:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	b8 0d 00 00 00       	mov    $0xd,%eax
  800daf:	89 cb                	mov    %ecx,%ebx
  800db1:	89 cf                	mov    %ecx,%edi
  800db3:	89 ce                	mov    %ecx,%esi
  800db5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 0d                	push   $0xd
  800dc9:	68 7f 23 80 00       	push   $0x80237f
  800dce:	6a 23                	push   $0x23
  800dd0:	68 9c 23 80 00       	push   $0x80239c
  800dd5:	e8 24 0f 00 00       	call   801cfe <_panic>

00800dda <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800de6:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800de8:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800deb:	83 3a 01             	cmpl   $0x1,(%edx)
  800dee:	7e 09                	jle    800df9 <argstart+0x1f>
  800df0:	ba 51 20 80 00       	mov    $0x802051,%edx
  800df5:	85 c9                	test   %ecx,%ecx
  800df7:	75 05                	jne    800dfe <argstart+0x24>
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800e01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <argnext>:

int
argnext(struct Argstate *args)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800e14:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800e1b:	8b 43 08             	mov    0x8(%ebx),%eax
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	74 72                	je     800e94 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  800e22:	80 38 00             	cmpb   $0x0,(%eax)
  800e25:	75 48                	jne    800e6f <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800e27:	8b 0b                	mov    (%ebx),%ecx
  800e29:	83 39 01             	cmpl   $0x1,(%ecx)
  800e2c:	74 58                	je     800e86 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  800e2e:	8b 53 04             	mov    0x4(%ebx),%edx
  800e31:	8b 42 04             	mov    0x4(%edx),%eax
  800e34:	80 38 2d             	cmpb   $0x2d,(%eax)
  800e37:	75 4d                	jne    800e86 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  800e39:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800e3d:	74 47                	je     800e86 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800e3f:	83 c0 01             	add    $0x1,%eax
  800e42:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800e45:	83 ec 04             	sub    $0x4,%esp
  800e48:	8b 01                	mov    (%ecx),%eax
  800e4a:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800e51:	50                   	push   %eax
  800e52:	8d 42 08             	lea    0x8(%edx),%eax
  800e55:	50                   	push   %eax
  800e56:	83 c2 04             	add    $0x4,%edx
  800e59:	52                   	push   %edx
  800e5a:	e8 1f fb ff ff       	call   80097e <memmove>
		(*args->argc)--;
  800e5f:	8b 03                	mov    (%ebx),%eax
  800e61:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800e64:	8b 43 08             	mov    0x8(%ebx),%eax
  800e67:	83 c4 10             	add    $0x10,%esp
  800e6a:	80 38 2d             	cmpb   $0x2d,(%eax)
  800e6d:	74 11                	je     800e80 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800e6f:	8b 53 08             	mov    0x8(%ebx),%edx
  800e72:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800e75:	83 c2 01             	add    $0x1,%edx
  800e78:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800e80:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800e84:	75 e9                	jne    800e6f <argnext+0x65>
	args->curarg = 0;
  800e86:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800e92:	eb e7                	jmp    800e7b <argnext+0x71>
		return -1;
  800e94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800e99:	eb e0                	jmp    800e7b <argnext+0x71>

00800e9b <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800ea5:	8b 43 08             	mov    0x8(%ebx),%eax
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	74 5b                	je     800f07 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  800eac:	80 38 00             	cmpb   $0x0,(%eax)
  800eaf:	74 12                	je     800ec3 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  800eb1:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800eb4:	c7 43 08 51 20 80 00 	movl   $0x802051,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800ebb:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800ebe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ec1:	c9                   	leave  
  800ec2:	c3                   	ret    
	} else if (*args->argc > 1) {
  800ec3:	8b 13                	mov    (%ebx),%edx
  800ec5:	83 3a 01             	cmpl   $0x1,(%edx)
  800ec8:	7f 10                	jg     800eda <argnextvalue+0x3f>
		args->argvalue = 0;
  800eca:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800ed1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800ed8:	eb e1                	jmp    800ebb <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  800eda:	8b 43 04             	mov    0x4(%ebx),%eax
  800edd:	8b 48 04             	mov    0x4(%eax),%ecx
  800ee0:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800ee3:	83 ec 04             	sub    $0x4,%esp
  800ee6:	8b 12                	mov    (%edx),%edx
  800ee8:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800eef:	52                   	push   %edx
  800ef0:	8d 50 08             	lea    0x8(%eax),%edx
  800ef3:	52                   	push   %edx
  800ef4:	83 c0 04             	add    $0x4,%eax
  800ef7:	50                   	push   %eax
  800ef8:	e8 81 fa ff ff       	call   80097e <memmove>
		(*args->argc)--;
  800efd:	8b 03                	mov    (%ebx),%eax
  800eff:	83 28 01             	subl   $0x1,(%eax)
  800f02:	83 c4 10             	add    $0x10,%esp
  800f05:	eb b4                	jmp    800ebb <argnextvalue+0x20>
		return 0;
  800f07:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0c:	eb b0                	jmp    800ebe <argnextvalue+0x23>

00800f0e <argvalue>:
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 08             	sub    $0x8,%esp
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800f17:	8b 42 0c             	mov    0xc(%edx),%eax
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	74 02                	je     800f20 <argvalue+0x12>
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800f20:	83 ec 0c             	sub    $0xc,%esp
  800f23:	52                   	push   %edx
  800f24:	e8 72 ff ff ff       	call   800e9b <argnextvalue>
  800f29:	83 c4 10             	add    $0x10,%esp
  800f2c:	eb f0                	jmp    800f1e <argvalue+0x10>

00800f2e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	05 00 00 00 30       	add    $0x30000000,%eax
  800f39:	c1 e8 0c             	shr    $0xc,%eax
}
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f4e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f60:	89 c2                	mov    %eax,%edx
  800f62:	c1 ea 16             	shr    $0x16,%edx
  800f65:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f6c:	f6 c2 01             	test   $0x1,%dl
  800f6f:	74 2a                	je     800f9b <fd_alloc+0x46>
  800f71:	89 c2                	mov    %eax,%edx
  800f73:	c1 ea 0c             	shr    $0xc,%edx
  800f76:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f7d:	f6 c2 01             	test   $0x1,%dl
  800f80:	74 19                	je     800f9b <fd_alloc+0x46>
  800f82:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f87:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f8c:	75 d2                	jne    800f60 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f8e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f94:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f99:	eb 07                	jmp    800fa2 <fd_alloc+0x4d>
			*fd_store = fd;
  800f9b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800faa:	83 f8 1f             	cmp    $0x1f,%eax
  800fad:	77 36                	ja     800fe5 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800faf:	c1 e0 0c             	shl    $0xc,%eax
  800fb2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fb7:	89 c2                	mov    %eax,%edx
  800fb9:	c1 ea 16             	shr    $0x16,%edx
  800fbc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fc3:	f6 c2 01             	test   $0x1,%dl
  800fc6:	74 24                	je     800fec <fd_lookup+0x48>
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	c1 ea 0c             	shr    $0xc,%edx
  800fcd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fd4:	f6 c2 01             	test   $0x1,%dl
  800fd7:	74 1a                	je     800ff3 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdc:	89 02                	mov    %eax,(%edx)
	return 0;
  800fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    
		return -E_INVAL;
  800fe5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fea:	eb f7                	jmp    800fe3 <fd_lookup+0x3f>
		return -E_INVAL;
  800fec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff1:	eb f0                	jmp    800fe3 <fd_lookup+0x3f>
  800ff3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff8:	eb e9                	jmp    800fe3 <fd_lookup+0x3f>

00800ffa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 08             	sub    $0x8,%esp
  801000:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801003:	ba 28 24 80 00       	mov    $0x802428,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801008:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80100d:	39 08                	cmp    %ecx,(%eax)
  80100f:	74 33                	je     801044 <dev_lookup+0x4a>
  801011:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801014:	8b 02                	mov    (%edx),%eax
  801016:	85 c0                	test   %eax,%eax
  801018:	75 f3                	jne    80100d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80101a:	a1 04 40 80 00       	mov    0x804004,%eax
  80101f:	8b 40 48             	mov    0x48(%eax),%eax
  801022:	83 ec 04             	sub    $0x4,%esp
  801025:	51                   	push   %ecx
  801026:	50                   	push   %eax
  801027:	68 ac 23 80 00       	push   $0x8023ac
  80102c:	e8 d5 f1 ff ff       	call   800206 <cprintf>
	*dev = 0;
  801031:	8b 45 0c             	mov    0xc(%ebp),%eax
  801034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    
			*dev = devtab[i];
  801044:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801047:	89 01                	mov    %eax,(%ecx)
			return 0;
  801049:	b8 00 00 00 00       	mov    $0x0,%eax
  80104e:	eb f2                	jmp    801042 <dev_lookup+0x48>

00801050 <fd_close>:
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	57                   	push   %edi
  801054:	56                   	push   %esi
  801055:	53                   	push   %ebx
  801056:	83 ec 1c             	sub    $0x1c,%esp
  801059:	8b 75 08             	mov    0x8(%ebp),%esi
  80105c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80105f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801062:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801063:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801069:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80106c:	50                   	push   %eax
  80106d:	e8 32 ff ff ff       	call   800fa4 <fd_lookup>
  801072:	89 c3                	mov    %eax,%ebx
  801074:	83 c4 08             	add    $0x8,%esp
  801077:	85 c0                	test   %eax,%eax
  801079:	78 05                	js     801080 <fd_close+0x30>
	    || fd != fd2)
  80107b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80107e:	74 16                	je     801096 <fd_close+0x46>
		return (must_exist ? r : 0);
  801080:	89 f8                	mov    %edi,%eax
  801082:	84 c0                	test   %al,%al
  801084:	b8 00 00 00 00       	mov    $0x0,%eax
  801089:	0f 44 d8             	cmove  %eax,%ebx
}
  80108c:	89 d8                	mov    %ebx,%eax
  80108e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801096:	83 ec 08             	sub    $0x8,%esp
  801099:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80109c:	50                   	push   %eax
  80109d:	ff 36                	pushl  (%esi)
  80109f:	e8 56 ff ff ff       	call   800ffa <dev_lookup>
  8010a4:	89 c3                	mov    %eax,%ebx
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	78 15                	js     8010c2 <fd_close+0x72>
		if (dev->dev_close)
  8010ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b0:	8b 40 10             	mov    0x10(%eax),%eax
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	74 1b                	je     8010d2 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8010b7:	83 ec 0c             	sub    $0xc,%esp
  8010ba:	56                   	push   %esi
  8010bb:	ff d0                	call   *%eax
  8010bd:	89 c3                	mov    %eax,%ebx
  8010bf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	56                   	push   %esi
  8010c6:	6a 00                	push   $0x0
  8010c8:	e8 a1 fb ff ff       	call   800c6e <sys_page_unmap>
	return r;
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	eb ba                	jmp    80108c <fd_close+0x3c>
			r = 0;
  8010d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d7:	eb e9                	jmp    8010c2 <fd_close+0x72>

008010d9 <close>:

int
close(int fdnum)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e2:	50                   	push   %eax
  8010e3:	ff 75 08             	pushl  0x8(%ebp)
  8010e6:	e8 b9 fe ff ff       	call   800fa4 <fd_lookup>
  8010eb:	83 c4 08             	add    $0x8,%esp
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	78 10                	js     801102 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010f2:	83 ec 08             	sub    $0x8,%esp
  8010f5:	6a 01                	push   $0x1
  8010f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010fa:	e8 51 ff ff ff       	call   801050 <fd_close>
  8010ff:	83 c4 10             	add    $0x10,%esp
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <close_all>:

void
close_all(void)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80110b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801110:	83 ec 0c             	sub    $0xc,%esp
  801113:	53                   	push   %ebx
  801114:	e8 c0 ff ff ff       	call   8010d9 <close>
	for (i = 0; i < MAXFD; i++)
  801119:	83 c3 01             	add    $0x1,%ebx
  80111c:	83 c4 10             	add    $0x10,%esp
  80111f:	83 fb 20             	cmp    $0x20,%ebx
  801122:	75 ec                	jne    801110 <close_all+0xc>
}
  801124:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801127:	c9                   	leave  
  801128:	c3                   	ret    

00801129 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	57                   	push   %edi
  80112d:	56                   	push   %esi
  80112e:	53                   	push   %ebx
  80112f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801132:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801135:	50                   	push   %eax
  801136:	ff 75 08             	pushl  0x8(%ebp)
  801139:	e8 66 fe ff ff       	call   800fa4 <fd_lookup>
  80113e:	89 c3                	mov    %eax,%ebx
  801140:	83 c4 08             	add    $0x8,%esp
  801143:	85 c0                	test   %eax,%eax
  801145:	0f 88 81 00 00 00    	js     8011cc <dup+0xa3>
		return r;
	close(newfdnum);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	ff 75 0c             	pushl  0xc(%ebp)
  801151:	e8 83 ff ff ff       	call   8010d9 <close>

	newfd = INDEX2FD(newfdnum);
  801156:	8b 75 0c             	mov    0xc(%ebp),%esi
  801159:	c1 e6 0c             	shl    $0xc,%esi
  80115c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801162:	83 c4 04             	add    $0x4,%esp
  801165:	ff 75 e4             	pushl  -0x1c(%ebp)
  801168:	e8 d1 fd ff ff       	call   800f3e <fd2data>
  80116d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80116f:	89 34 24             	mov    %esi,(%esp)
  801172:	e8 c7 fd ff ff       	call   800f3e <fd2data>
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80117c:	89 d8                	mov    %ebx,%eax
  80117e:	c1 e8 16             	shr    $0x16,%eax
  801181:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801188:	a8 01                	test   $0x1,%al
  80118a:	74 11                	je     80119d <dup+0x74>
  80118c:	89 d8                	mov    %ebx,%eax
  80118e:	c1 e8 0c             	shr    $0xc,%eax
  801191:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801198:	f6 c2 01             	test   $0x1,%dl
  80119b:	75 39                	jne    8011d6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80119d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011a0:	89 d0                	mov    %edx,%eax
  8011a2:	c1 e8 0c             	shr    $0xc,%eax
  8011a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ac:	83 ec 0c             	sub    $0xc,%esp
  8011af:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b4:	50                   	push   %eax
  8011b5:	56                   	push   %esi
  8011b6:	6a 00                	push   $0x0
  8011b8:	52                   	push   %edx
  8011b9:	6a 00                	push   $0x0
  8011bb:	e8 6c fa ff ff       	call   800c2c <sys_page_map>
  8011c0:	89 c3                	mov    %eax,%ebx
  8011c2:	83 c4 20             	add    $0x20,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	78 31                	js     8011fa <dup+0xd1>
		goto err;

	return newfdnum;
  8011c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011cc:	89 d8                	mov    %ebx,%eax
  8011ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d1:	5b                   	pop    %ebx
  8011d2:	5e                   	pop    %esi
  8011d3:	5f                   	pop    %edi
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8011e5:	50                   	push   %eax
  8011e6:	57                   	push   %edi
  8011e7:	6a 00                	push   $0x0
  8011e9:	53                   	push   %ebx
  8011ea:	6a 00                	push   $0x0
  8011ec:	e8 3b fa ff ff       	call   800c2c <sys_page_map>
  8011f1:	89 c3                	mov    %eax,%ebx
  8011f3:	83 c4 20             	add    $0x20,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	79 a3                	jns    80119d <dup+0x74>
	sys_page_unmap(0, newfd);
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	56                   	push   %esi
  8011fe:	6a 00                	push   $0x0
  801200:	e8 69 fa ff ff       	call   800c6e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801205:	83 c4 08             	add    $0x8,%esp
  801208:	57                   	push   %edi
  801209:	6a 00                	push   $0x0
  80120b:	e8 5e fa ff ff       	call   800c6e <sys_page_unmap>
	return r;
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	eb b7                	jmp    8011cc <dup+0xa3>

00801215 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	53                   	push   %ebx
  801219:	83 ec 14             	sub    $0x14,%esp
  80121c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80121f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801222:	50                   	push   %eax
  801223:	53                   	push   %ebx
  801224:	e8 7b fd ff ff       	call   800fa4 <fd_lookup>
  801229:	83 c4 08             	add    $0x8,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	78 3f                	js     80126f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801230:	83 ec 08             	sub    $0x8,%esp
  801233:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801236:	50                   	push   %eax
  801237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123a:	ff 30                	pushl  (%eax)
  80123c:	e8 b9 fd ff ff       	call   800ffa <dev_lookup>
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	85 c0                	test   %eax,%eax
  801246:	78 27                	js     80126f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	8b 42 08             	mov    0x8(%edx),%eax
  80124e:	83 e0 03             	and    $0x3,%eax
  801251:	83 f8 01             	cmp    $0x1,%eax
  801254:	74 1e                	je     801274 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801259:	8b 40 08             	mov    0x8(%eax),%eax
  80125c:	85 c0                	test   %eax,%eax
  80125e:	74 35                	je     801295 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801260:	83 ec 04             	sub    $0x4,%esp
  801263:	ff 75 10             	pushl  0x10(%ebp)
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	52                   	push   %edx
  80126a:	ff d0                	call   *%eax
  80126c:	83 c4 10             	add    $0x10,%esp
}
  80126f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801272:	c9                   	leave  
  801273:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801274:	a1 04 40 80 00       	mov    0x804004,%eax
  801279:	8b 40 48             	mov    0x48(%eax),%eax
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	53                   	push   %ebx
  801280:	50                   	push   %eax
  801281:	68 ed 23 80 00       	push   $0x8023ed
  801286:	e8 7b ef ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801293:	eb da                	jmp    80126f <read+0x5a>
		return -E_NOT_SUPP;
  801295:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80129a:	eb d3                	jmp    80126f <read+0x5a>

0080129c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b0:	39 f3                	cmp    %esi,%ebx
  8012b2:	73 25                	jae    8012d9 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	89 f0                	mov    %esi,%eax
  8012b9:	29 d8                	sub    %ebx,%eax
  8012bb:	50                   	push   %eax
  8012bc:	89 d8                	mov    %ebx,%eax
  8012be:	03 45 0c             	add    0xc(%ebp),%eax
  8012c1:	50                   	push   %eax
  8012c2:	57                   	push   %edi
  8012c3:	e8 4d ff ff ff       	call   801215 <read>
		if (m < 0)
  8012c8:	83 c4 10             	add    $0x10,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	78 08                	js     8012d7 <readn+0x3b>
			return m;
		if (m == 0)
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	74 06                	je     8012d9 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012d3:	01 c3                	add    %eax,%ebx
  8012d5:	eb d9                	jmp    8012b0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012d7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012d9:	89 d8                	mov    %ebx,%eax
  8012db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012de:	5b                   	pop    %ebx
  8012df:	5e                   	pop    %esi
  8012e0:	5f                   	pop    %edi
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	53                   	push   %ebx
  8012e7:	83 ec 14             	sub    $0x14,%esp
  8012ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f0:	50                   	push   %eax
  8012f1:	53                   	push   %ebx
  8012f2:	e8 ad fc ff ff       	call   800fa4 <fd_lookup>
  8012f7:	83 c4 08             	add    $0x8,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 3a                	js     801338 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012fe:	83 ec 08             	sub    $0x8,%esp
  801301:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801304:	50                   	push   %eax
  801305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801308:	ff 30                	pushl  (%eax)
  80130a:	e8 eb fc ff ff       	call   800ffa <dev_lookup>
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	78 22                	js     801338 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801319:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80131d:	74 1e                	je     80133d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80131f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801322:	8b 52 0c             	mov    0xc(%edx),%edx
  801325:	85 d2                	test   %edx,%edx
  801327:	74 35                	je     80135e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	ff 75 10             	pushl  0x10(%ebp)
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	50                   	push   %eax
  801333:	ff d2                	call   *%edx
  801335:	83 c4 10             	add    $0x10,%esp
}
  801338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80133d:	a1 04 40 80 00       	mov    0x804004,%eax
  801342:	8b 40 48             	mov    0x48(%eax),%eax
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	53                   	push   %ebx
  801349:	50                   	push   %eax
  80134a:	68 09 24 80 00       	push   $0x802409
  80134f:	e8 b2 ee ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  801354:	83 c4 10             	add    $0x10,%esp
  801357:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135c:	eb da                	jmp    801338 <write+0x55>
		return -E_NOT_SUPP;
  80135e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801363:	eb d3                	jmp    801338 <write+0x55>

00801365 <seek>:

int
seek(int fdnum, off_t offset)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80136b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80136e:	50                   	push   %eax
  80136f:	ff 75 08             	pushl  0x8(%ebp)
  801372:	e8 2d fc ff ff       	call   800fa4 <fd_lookup>
  801377:	83 c4 08             	add    $0x8,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 0e                	js     80138c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80137e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801384:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	53                   	push   %ebx
  801392:	83 ec 14             	sub    $0x14,%esp
  801395:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801398:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	53                   	push   %ebx
  80139d:	e8 02 fc ff ff       	call   800fa4 <fd_lookup>
  8013a2:	83 c4 08             	add    $0x8,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 37                	js     8013e0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013af:	50                   	push   %eax
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	ff 30                	pushl  (%eax)
  8013b5:	e8 40 fc ff ff       	call   800ffa <dev_lookup>
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 1f                	js     8013e0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013c8:	74 1b                	je     8013e5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cd:	8b 52 18             	mov    0x18(%edx),%edx
  8013d0:	85 d2                	test   %edx,%edx
  8013d2:	74 32                	je     801406 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	ff 75 0c             	pushl  0xc(%ebp)
  8013da:	50                   	push   %eax
  8013db:	ff d2                	call   *%edx
  8013dd:	83 c4 10             	add    $0x10,%esp
}
  8013e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013e5:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013ea:	8b 40 48             	mov    0x48(%eax),%eax
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	53                   	push   %ebx
  8013f1:	50                   	push   %eax
  8013f2:	68 cc 23 80 00       	push   $0x8023cc
  8013f7:	e8 0a ee ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  8013fc:	83 c4 10             	add    $0x10,%esp
  8013ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801404:	eb da                	jmp    8013e0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801406:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140b:	eb d3                	jmp    8013e0 <ftruncate+0x52>

0080140d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	53                   	push   %ebx
  801411:	83 ec 14             	sub    $0x14,%esp
  801414:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801417:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141a:	50                   	push   %eax
  80141b:	ff 75 08             	pushl  0x8(%ebp)
  80141e:	e8 81 fb ff ff       	call   800fa4 <fd_lookup>
  801423:	83 c4 08             	add    $0x8,%esp
  801426:	85 c0                	test   %eax,%eax
  801428:	78 4b                	js     801475 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142a:	83 ec 08             	sub    $0x8,%esp
  80142d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801430:	50                   	push   %eax
  801431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801434:	ff 30                	pushl  (%eax)
  801436:	e8 bf fb ff ff       	call   800ffa <dev_lookup>
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 33                	js     801475 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801445:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801449:	74 2f                	je     80147a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80144b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80144e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801455:	00 00 00 
	stat->st_isdir = 0;
  801458:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80145f:	00 00 00 
	stat->st_dev = dev;
  801462:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801468:	83 ec 08             	sub    $0x8,%esp
  80146b:	53                   	push   %ebx
  80146c:	ff 75 f0             	pushl  -0x10(%ebp)
  80146f:	ff 50 14             	call   *0x14(%eax)
  801472:	83 c4 10             	add    $0x10,%esp
}
  801475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801478:	c9                   	leave  
  801479:	c3                   	ret    
		return -E_NOT_SUPP;
  80147a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80147f:	eb f4                	jmp    801475 <fstat+0x68>

00801481 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	56                   	push   %esi
  801485:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801486:	83 ec 08             	sub    $0x8,%esp
  801489:	6a 00                	push   $0x0
  80148b:	ff 75 08             	pushl  0x8(%ebp)
  80148e:	e8 e7 01 00 00       	call   80167a <open>
  801493:	89 c3                	mov    %eax,%ebx
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	85 c0                	test   %eax,%eax
  80149a:	78 1b                	js     8014b7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	50                   	push   %eax
  8014a3:	e8 65 ff ff ff       	call   80140d <fstat>
  8014a8:	89 c6                	mov    %eax,%esi
	close(fd);
  8014aa:	89 1c 24             	mov    %ebx,(%esp)
  8014ad:	e8 27 fc ff ff       	call   8010d9 <close>
	return r;
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	89 f3                	mov    %esi,%ebx
}
  8014b7:	89 d8                	mov    %ebx,%eax
  8014b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014bc:	5b                   	pop    %ebx
  8014bd:	5e                   	pop    %esi
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	56                   	push   %esi
  8014c4:	53                   	push   %ebx
  8014c5:	89 c6                	mov    %eax,%esi
  8014c7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014c9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014d0:	74 27                	je     8014f9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014d2:	6a 07                	push   $0x7
  8014d4:	68 00 50 80 00       	push   $0x805000
  8014d9:	56                   	push   %esi
  8014da:	ff 35 00 40 80 00    	pushl  0x804000
  8014e0:	e8 76 08 00 00       	call   801d5b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014e5:	83 c4 0c             	add    $0xc,%esp
  8014e8:	6a 00                	push   $0x0
  8014ea:	53                   	push   %ebx
  8014eb:	6a 00                	push   $0x0
  8014ed:	e8 52 08 00 00       	call   801d44 <ipc_recv>
}
  8014f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f5:	5b                   	pop    %ebx
  8014f6:	5e                   	pop    %esi
  8014f7:	5d                   	pop    %ebp
  8014f8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	6a 01                	push   $0x1
  8014fe:	e8 6f 08 00 00       	call   801d72 <ipc_find_env>
  801503:	a3 00 40 80 00       	mov    %eax,0x804000
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	eb c5                	jmp    8014d2 <fsipc+0x12>

0080150d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8b 40 0c             	mov    0xc(%eax),%eax
  801519:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80151e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801521:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801526:	ba 00 00 00 00       	mov    $0x0,%edx
  80152b:	b8 02 00 00 00       	mov    $0x2,%eax
  801530:	e8 8b ff ff ff       	call   8014c0 <fsipc>
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <devfile_flush>:
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8b 40 0c             	mov    0xc(%eax),%eax
  801543:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801548:	ba 00 00 00 00       	mov    $0x0,%edx
  80154d:	b8 06 00 00 00       	mov    $0x6,%eax
  801552:	e8 69 ff ff ff       	call   8014c0 <fsipc>
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <devfile_stat>:
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	53                   	push   %ebx
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	8b 40 0c             	mov    0xc(%eax),%eax
  801569:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80156e:	ba 00 00 00 00       	mov    $0x0,%edx
  801573:	b8 05 00 00 00       	mov    $0x5,%eax
  801578:	e8 43 ff ff ff       	call   8014c0 <fsipc>
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 2c                	js     8015ad <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	68 00 50 80 00       	push   $0x805000
  801589:	53                   	push   %ebx
  80158a:	e8 61 f2 ff ff       	call   8007f0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80158f:	a1 80 50 80 00       	mov    0x805080,%eax
  801594:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80159a:	a1 84 50 80 00       	mov    0x805084,%eax
  80159f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <devfile_write>:
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 0c             	sub    $0xc,%esp
  8015b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bb:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8015c0:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8015c5:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cb:	8b 52 0c             	mov    0xc(%edx),%edx
  8015ce:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8015d4:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8015d9:	50                   	push   %eax
  8015da:	ff 75 0c             	pushl  0xc(%ebp)
  8015dd:	68 08 50 80 00       	push   $0x805008
  8015e2:	e8 97 f3 ff ff       	call   80097e <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8015e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ec:	b8 04 00 00 00       	mov    $0x4,%eax
  8015f1:	e8 ca fe ff ff       	call   8014c0 <fsipc>
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <devfile_read>:
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	56                   	push   %esi
  8015fc:	53                   	push   %ebx
  8015fd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	8b 40 0c             	mov    0xc(%eax),%eax
  801606:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80160b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801611:	ba 00 00 00 00       	mov    $0x0,%edx
  801616:	b8 03 00 00 00       	mov    $0x3,%eax
  80161b:	e8 a0 fe ff ff       	call   8014c0 <fsipc>
  801620:	89 c3                	mov    %eax,%ebx
  801622:	85 c0                	test   %eax,%eax
  801624:	78 1f                	js     801645 <devfile_read+0x4d>
	assert(r <= n);
  801626:	39 f0                	cmp    %esi,%eax
  801628:	77 24                	ja     80164e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80162a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80162f:	7f 33                	jg     801664 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	50                   	push   %eax
  801635:	68 00 50 80 00       	push   $0x805000
  80163a:	ff 75 0c             	pushl  0xc(%ebp)
  80163d:	e8 3c f3 ff ff       	call   80097e <memmove>
	return r;
  801642:	83 c4 10             	add    $0x10,%esp
}
  801645:	89 d8                	mov    %ebx,%eax
  801647:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164a:	5b                   	pop    %ebx
  80164b:	5e                   	pop    %esi
  80164c:	5d                   	pop    %ebp
  80164d:	c3                   	ret    
	assert(r <= n);
  80164e:	68 38 24 80 00       	push   $0x802438
  801653:	68 3f 24 80 00       	push   $0x80243f
  801658:	6a 7c                	push   $0x7c
  80165a:	68 54 24 80 00       	push   $0x802454
  80165f:	e8 9a 06 00 00       	call   801cfe <_panic>
	assert(r <= PGSIZE);
  801664:	68 5f 24 80 00       	push   $0x80245f
  801669:	68 3f 24 80 00       	push   $0x80243f
  80166e:	6a 7d                	push   $0x7d
  801670:	68 54 24 80 00       	push   $0x802454
  801675:	e8 84 06 00 00       	call   801cfe <_panic>

0080167a <open>:
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	56                   	push   %esi
  80167e:	53                   	push   %ebx
  80167f:	83 ec 1c             	sub    $0x1c,%esp
  801682:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801685:	56                   	push   %esi
  801686:	e8 2e f1 ff ff       	call   8007b9 <strlen>
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801693:	7f 6c                	jg     801701 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801695:	83 ec 0c             	sub    $0xc,%esp
  801698:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	e8 b4 f8 ff ff       	call   800f55 <fd_alloc>
  8016a1:	89 c3                	mov    %eax,%ebx
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	78 3c                	js     8016e6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016aa:	83 ec 08             	sub    $0x8,%esp
  8016ad:	56                   	push   %esi
  8016ae:	68 00 50 80 00       	push   $0x805000
  8016b3:	e8 38 f1 ff ff       	call   8007f0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016c8:	e8 f3 fd ff ff       	call   8014c0 <fsipc>
  8016cd:	89 c3                	mov    %eax,%ebx
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 19                	js     8016ef <open+0x75>
	return fd2num(fd);
  8016d6:	83 ec 0c             	sub    $0xc,%esp
  8016d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8016dc:	e8 4d f8 ff ff       	call   800f2e <fd2num>
  8016e1:	89 c3                	mov    %eax,%ebx
  8016e3:	83 c4 10             	add    $0x10,%esp
}
  8016e6:	89 d8                	mov    %ebx,%eax
  8016e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5d                   	pop    %ebp
  8016ee:	c3                   	ret    
		fd_close(fd, 0);
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f7:	e8 54 f9 ff ff       	call   801050 <fd_close>
		return r;
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	eb e5                	jmp    8016e6 <open+0x6c>
		return -E_BAD_PATH;
  801701:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801706:	eb de                	jmp    8016e6 <open+0x6c>

00801708 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80170e:	ba 00 00 00 00       	mov    $0x0,%edx
  801713:	b8 08 00 00 00       	mov    $0x8,%eax
  801718:	e8 a3 fd ff ff       	call   8014c0 <fsipc>
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80171f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801723:	7e 38                	jle    80175d <writebuf+0x3e>
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	53                   	push   %ebx
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80172e:	ff 70 04             	pushl  0x4(%eax)
  801731:	8d 40 10             	lea    0x10(%eax),%eax
  801734:	50                   	push   %eax
  801735:	ff 33                	pushl  (%ebx)
  801737:	e8 a7 fb ff ff       	call   8012e3 <write>
		if (result > 0)
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	85 c0                	test   %eax,%eax
  801741:	7e 03                	jle    801746 <writebuf+0x27>
			b->result += result;
  801743:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801746:	39 43 04             	cmp    %eax,0x4(%ebx)
  801749:	74 0d                	je     801758 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80174b:	85 c0                	test   %eax,%eax
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	0f 4f c2             	cmovg  %edx,%eax
  801755:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801758:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    
  80175d:	f3 c3                	repz ret 

0080175f <putch>:

static void
putch(int ch, void *thunk)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	53                   	push   %ebx
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801769:	8b 53 04             	mov    0x4(%ebx),%edx
  80176c:	8d 42 01             	lea    0x1(%edx),%eax
  80176f:	89 43 04             	mov    %eax,0x4(%ebx)
  801772:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801775:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801779:	3d 00 01 00 00       	cmp    $0x100,%eax
  80177e:	74 06                	je     801786 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801780:	83 c4 04             	add    $0x4,%esp
  801783:	5b                   	pop    %ebx
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    
		writebuf(b);
  801786:	89 d8                	mov    %ebx,%eax
  801788:	e8 92 ff ff ff       	call   80171f <writebuf>
		b->idx = 0;
  80178d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801794:	eb ea                	jmp    801780 <putch+0x21>

00801796 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017a8:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8017af:	00 00 00 
	b.result = 0;
  8017b2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017b9:	00 00 00 
	b.error = 1;
  8017bc:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8017c3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8017c6:	ff 75 10             	pushl  0x10(%ebp)
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017d2:	50                   	push   %eax
  8017d3:	68 5f 17 80 00       	push   $0x80175f
  8017d8:	e8 26 eb ff ff       	call   800303 <vprintfmt>
	if (b.idx > 0)
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8017e7:	7f 11                	jg     8017fa <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8017e9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    
		writebuf(&b);
  8017fa:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801800:	e8 1a ff ff ff       	call   80171f <writebuf>
  801805:	eb e2                	jmp    8017e9 <vfprintf+0x53>

00801807 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80180d:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801810:	50                   	push   %eax
  801811:	ff 75 0c             	pushl  0xc(%ebp)
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	e8 7a ff ff ff       	call   801796 <vfprintf>
	va_end(ap);

	return cnt;
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <printf>:

int
printf(const char *fmt, ...)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801824:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801827:	50                   	push   %eax
  801828:	ff 75 08             	pushl  0x8(%ebp)
  80182b:	6a 01                	push   $0x1
  80182d:	e8 64 ff ff ff       	call   801796 <vfprintf>
	va_end(ap);

	return cnt;
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
  801839:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80183c:	83 ec 0c             	sub    $0xc,%esp
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 f7 f6 ff ff       	call   800f3e <fd2data>
  801847:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801849:	83 c4 08             	add    $0x8,%esp
  80184c:	68 6b 24 80 00       	push   $0x80246b
  801851:	53                   	push   %ebx
  801852:	e8 99 ef ff ff       	call   8007f0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801857:	8b 46 04             	mov    0x4(%esi),%eax
  80185a:	2b 06                	sub    (%esi),%eax
  80185c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801862:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801869:	00 00 00 
	stat->st_dev = &devpipe;
  80186c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801873:	30 80 00 
	return 0;
}
  801876:	b8 00 00 00 00       	mov    $0x0,%eax
  80187b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5e                   	pop    %esi
  801880:	5d                   	pop    %ebp
  801881:	c3                   	ret    

00801882 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	53                   	push   %ebx
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80188c:	53                   	push   %ebx
  80188d:	6a 00                	push   $0x0
  80188f:	e8 da f3 ff ff       	call   800c6e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801894:	89 1c 24             	mov    %ebx,(%esp)
  801897:	e8 a2 f6 ff ff       	call   800f3e <fd2data>
  80189c:	83 c4 08             	add    $0x8,%esp
  80189f:	50                   	push   %eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	e8 c7 f3 ff ff       	call   800c6e <sys_page_unmap>
}
  8018a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <_pipeisclosed>:
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	57                   	push   %edi
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 1c             	sub    $0x1c,%esp
  8018b5:	89 c7                	mov    %eax,%edi
  8018b7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8018b9:	a1 04 40 80 00       	mov    0x804004,%eax
  8018be:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018c1:	83 ec 0c             	sub    $0xc,%esp
  8018c4:	57                   	push   %edi
  8018c5:	e8 e1 04 00 00       	call   801dab <pageref>
  8018ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018cd:	89 34 24             	mov    %esi,(%esp)
  8018d0:	e8 d6 04 00 00       	call   801dab <pageref>
		nn = thisenv->env_runs;
  8018d5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8018db:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	39 cb                	cmp    %ecx,%ebx
  8018e3:	74 1b                	je     801900 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8018e5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018e8:	75 cf                	jne    8018b9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018ea:	8b 42 58             	mov    0x58(%edx),%eax
  8018ed:	6a 01                	push   $0x1
  8018ef:	50                   	push   %eax
  8018f0:	53                   	push   %ebx
  8018f1:	68 72 24 80 00       	push   $0x802472
  8018f6:	e8 0b e9 ff ff       	call   800206 <cprintf>
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	eb b9                	jmp    8018b9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801900:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801903:	0f 94 c0             	sete   %al
  801906:	0f b6 c0             	movzbl %al,%eax
}
  801909:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190c:	5b                   	pop    %ebx
  80190d:	5e                   	pop    %esi
  80190e:	5f                   	pop    %edi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    

00801911 <devpipe_write>:
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	57                   	push   %edi
  801915:	56                   	push   %esi
  801916:	53                   	push   %ebx
  801917:	83 ec 28             	sub    $0x28,%esp
  80191a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80191d:	56                   	push   %esi
  80191e:	e8 1b f6 ff ff       	call   800f3e <fd2data>
  801923:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	bf 00 00 00 00       	mov    $0x0,%edi
  80192d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801930:	74 4f                	je     801981 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801932:	8b 43 04             	mov    0x4(%ebx),%eax
  801935:	8b 0b                	mov    (%ebx),%ecx
  801937:	8d 51 20             	lea    0x20(%ecx),%edx
  80193a:	39 d0                	cmp    %edx,%eax
  80193c:	72 14                	jb     801952 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80193e:	89 da                	mov    %ebx,%edx
  801940:	89 f0                	mov    %esi,%eax
  801942:	e8 65 ff ff ff       	call   8018ac <_pipeisclosed>
  801947:	85 c0                	test   %eax,%eax
  801949:	75 3a                	jne    801985 <devpipe_write+0x74>
			sys_yield();
  80194b:	e8 7a f2 ff ff       	call   800bca <sys_yield>
  801950:	eb e0                	jmp    801932 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801952:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801955:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801959:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80195c:	89 c2                	mov    %eax,%edx
  80195e:	c1 fa 1f             	sar    $0x1f,%edx
  801961:	89 d1                	mov    %edx,%ecx
  801963:	c1 e9 1b             	shr    $0x1b,%ecx
  801966:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801969:	83 e2 1f             	and    $0x1f,%edx
  80196c:	29 ca                	sub    %ecx,%edx
  80196e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801972:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801976:	83 c0 01             	add    $0x1,%eax
  801979:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80197c:	83 c7 01             	add    $0x1,%edi
  80197f:	eb ac                	jmp    80192d <devpipe_write+0x1c>
	return i;
  801981:	89 f8                	mov    %edi,%eax
  801983:	eb 05                	jmp    80198a <devpipe_write+0x79>
				return 0;
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5e                   	pop    %esi
  80198f:	5f                   	pop    %edi
  801990:	5d                   	pop    %ebp
  801991:	c3                   	ret    

00801992 <devpipe_read>:
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	57                   	push   %edi
  801996:	56                   	push   %esi
  801997:	53                   	push   %ebx
  801998:	83 ec 18             	sub    $0x18,%esp
  80199b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80199e:	57                   	push   %edi
  80199f:	e8 9a f5 ff ff       	call   800f3e <fd2data>
  8019a4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	be 00 00 00 00       	mov    $0x0,%esi
  8019ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019b1:	74 47                	je     8019fa <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8019b3:	8b 03                	mov    (%ebx),%eax
  8019b5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019b8:	75 22                	jne    8019dc <devpipe_read+0x4a>
			if (i > 0)
  8019ba:	85 f6                	test   %esi,%esi
  8019bc:	75 14                	jne    8019d2 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8019be:	89 da                	mov    %ebx,%edx
  8019c0:	89 f8                	mov    %edi,%eax
  8019c2:	e8 e5 fe ff ff       	call   8018ac <_pipeisclosed>
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	75 33                	jne    8019fe <devpipe_read+0x6c>
			sys_yield();
  8019cb:	e8 fa f1 ff ff       	call   800bca <sys_yield>
  8019d0:	eb e1                	jmp    8019b3 <devpipe_read+0x21>
				return i;
  8019d2:	89 f0                	mov    %esi,%eax
}
  8019d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5f                   	pop    %edi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019dc:	99                   	cltd   
  8019dd:	c1 ea 1b             	shr    $0x1b,%edx
  8019e0:	01 d0                	add    %edx,%eax
  8019e2:	83 e0 1f             	and    $0x1f,%eax
  8019e5:	29 d0                	sub    %edx,%eax
  8019e7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ef:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8019f2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8019f5:	83 c6 01             	add    $0x1,%esi
  8019f8:	eb b4                	jmp    8019ae <devpipe_read+0x1c>
	return i;
  8019fa:	89 f0                	mov    %esi,%eax
  8019fc:	eb d6                	jmp    8019d4 <devpipe_read+0x42>
				return 0;
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801a03:	eb cf                	jmp    8019d4 <devpipe_read+0x42>

00801a05 <pipe>:
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	56                   	push   %esi
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a10:	50                   	push   %eax
  801a11:	e8 3f f5 ff ff       	call   800f55 <fd_alloc>
  801a16:	89 c3                	mov    %eax,%ebx
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 5b                	js     801a7a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a1f:	83 ec 04             	sub    $0x4,%esp
  801a22:	68 07 04 00 00       	push   $0x407
  801a27:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2a:	6a 00                	push   $0x0
  801a2c:	e8 b8 f1 ff ff       	call   800be9 <sys_page_alloc>
  801a31:	89 c3                	mov    %eax,%ebx
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 40                	js     801a7a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a40:	50                   	push   %eax
  801a41:	e8 0f f5 ff ff       	call   800f55 <fd_alloc>
  801a46:	89 c3                	mov    %eax,%ebx
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 1b                	js     801a6a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	68 07 04 00 00       	push   $0x407
  801a57:	ff 75 f0             	pushl  -0x10(%ebp)
  801a5a:	6a 00                	push   $0x0
  801a5c:	e8 88 f1 ff ff       	call   800be9 <sys_page_alloc>
  801a61:	89 c3                	mov    %eax,%ebx
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 c0                	test   %eax,%eax
  801a68:	79 19                	jns    801a83 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801a6a:	83 ec 08             	sub    $0x8,%esp
  801a6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a70:	6a 00                	push   $0x0
  801a72:	e8 f7 f1 ff ff       	call   800c6e <sys_page_unmap>
  801a77:	83 c4 10             	add    $0x10,%esp
}
  801a7a:	89 d8                	mov    %ebx,%eax
  801a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    
	va = fd2data(fd0);
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	ff 75 f4             	pushl  -0xc(%ebp)
  801a89:	e8 b0 f4 ff ff       	call   800f3e <fd2data>
  801a8e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a90:	83 c4 0c             	add    $0xc,%esp
  801a93:	68 07 04 00 00       	push   $0x407
  801a98:	50                   	push   %eax
  801a99:	6a 00                	push   $0x0
  801a9b:	e8 49 f1 ff ff       	call   800be9 <sys_page_alloc>
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	0f 88 8c 00 00 00    	js     801b39 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aad:	83 ec 0c             	sub    $0xc,%esp
  801ab0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab3:	e8 86 f4 ff ff       	call   800f3e <fd2data>
  801ab8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801abf:	50                   	push   %eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	56                   	push   %esi
  801ac3:	6a 00                	push   $0x0
  801ac5:	e8 62 f1 ff ff       	call   800c2c <sys_page_map>
  801aca:	89 c3                	mov    %eax,%ebx
  801acc:	83 c4 20             	add    $0x20,%esp
  801acf:	85 c0                	test   %eax,%eax
  801ad1:	78 58                	js     801b2b <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801adc:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aeb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801af1:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	ff 75 f4             	pushl  -0xc(%ebp)
  801b03:	e8 26 f4 ff ff       	call   800f2e <fd2num>
  801b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b0b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b0d:	83 c4 04             	add    $0x4,%esp
  801b10:	ff 75 f0             	pushl  -0x10(%ebp)
  801b13:	e8 16 f4 ff ff       	call   800f2e <fd2num>
  801b18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b1b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b26:	e9 4f ff ff ff       	jmp    801a7a <pipe+0x75>
	sys_page_unmap(0, va);
  801b2b:	83 ec 08             	sub    $0x8,%esp
  801b2e:	56                   	push   %esi
  801b2f:	6a 00                	push   $0x0
  801b31:	e8 38 f1 ff ff       	call   800c6e <sys_page_unmap>
  801b36:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b39:	83 ec 08             	sub    $0x8,%esp
  801b3c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b3f:	6a 00                	push   $0x0
  801b41:	e8 28 f1 ff ff       	call   800c6e <sys_page_unmap>
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	e9 1c ff ff ff       	jmp    801a6a <pipe+0x65>

00801b4e <pipeisclosed>:
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b57:	50                   	push   %eax
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	e8 44 f4 ff ff       	call   800fa4 <fd_lookup>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 18                	js     801b7f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b67:	83 ec 0c             	sub    $0xc,%esp
  801b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6d:	e8 cc f3 ff ff       	call   800f3e <fd2data>
	return _pipeisclosed(fd, p);
  801b72:	89 c2                	mov    %eax,%edx
  801b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b77:	e8 30 fd ff ff       	call   8018ac <_pipeisclosed>
  801b7c:	83 c4 10             	add    $0x10,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b84:	b8 00 00 00 00       	mov    $0x0,%eax
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    

00801b8b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b91:	68 8a 24 80 00       	push   $0x80248a
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	e8 52 ec ff ff       	call   8007f0 <strcpy>
	return 0;
}
  801b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <devcons_write>:
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	57                   	push   %edi
  801ba9:	56                   	push   %esi
  801baa:	53                   	push   %ebx
  801bab:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801bb1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801bb6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801bbc:	eb 2f                	jmp    801bed <devcons_write+0x48>
		m = n - tot;
  801bbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bc1:	29 f3                	sub    %esi,%ebx
  801bc3:	83 fb 7f             	cmp    $0x7f,%ebx
  801bc6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801bcb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	53                   	push   %ebx
  801bd2:	89 f0                	mov    %esi,%eax
  801bd4:	03 45 0c             	add    0xc(%ebp),%eax
  801bd7:	50                   	push   %eax
  801bd8:	57                   	push   %edi
  801bd9:	e8 a0 ed ff ff       	call   80097e <memmove>
		sys_cputs(buf, m);
  801bde:	83 c4 08             	add    $0x8,%esp
  801be1:	53                   	push   %ebx
  801be2:	57                   	push   %edi
  801be3:	e8 45 ef ff ff       	call   800b2d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801be8:	01 de                	add    %ebx,%esi
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bf0:	72 cc                	jb     801bbe <devcons_write+0x19>
}
  801bf2:	89 f0                	mov    %esi,%eax
  801bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    

00801bfc <devcons_read>:
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c0b:	75 07                	jne    801c14 <devcons_read+0x18>
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    
		sys_yield();
  801c0f:	e8 b6 ef ff ff       	call   800bca <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801c14:	e8 32 ef ff ff       	call   800b4b <sys_cgetc>
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	74 f2                	je     801c0f <devcons_read+0x13>
	if (c < 0)
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	78 ec                	js     801c0d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801c21:	83 f8 04             	cmp    $0x4,%eax
  801c24:	74 0c                	je     801c32 <devcons_read+0x36>
	*(char*)vbuf = c;
  801c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c29:	88 02                	mov    %al,(%edx)
	return 1;
  801c2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c30:	eb db                	jmp    801c0d <devcons_read+0x11>
		return 0;
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	eb d4                	jmp    801c0d <devcons_read+0x11>

00801c39 <cputchar>:
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c45:	6a 01                	push   $0x1
  801c47:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c4a:	50                   	push   %eax
  801c4b:	e8 dd ee ff ff       	call   800b2d <sys_cputs>
}
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <getchar>:
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c5b:	6a 01                	push   $0x1
  801c5d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c60:	50                   	push   %eax
  801c61:	6a 00                	push   $0x0
  801c63:	e8 ad f5 ff ff       	call   801215 <read>
	if (r < 0)
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 08                	js     801c77 <getchar+0x22>
	if (r < 1)
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	7e 06                	jle    801c79 <getchar+0x24>
	return c;
  801c73:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    
		return -E_EOF;
  801c79:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c7e:	eb f7                	jmp    801c77 <getchar+0x22>

00801c80 <iscons>:
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c89:	50                   	push   %eax
  801c8a:	ff 75 08             	pushl  0x8(%ebp)
  801c8d:	e8 12 f3 ff ff       	call   800fa4 <fd_lookup>
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	85 c0                	test   %eax,%eax
  801c97:	78 11                	js     801caa <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ca2:	39 10                	cmp    %edx,(%eax)
  801ca4:	0f 94 c0             	sete   %al
  801ca7:	0f b6 c0             	movzbl %al,%eax
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <opencons>:
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801cb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb5:	50                   	push   %eax
  801cb6:	e8 9a f2 ff ff       	call   800f55 <fd_alloc>
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	78 3a                	js     801cfc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	68 07 04 00 00       	push   $0x407
  801cca:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccd:	6a 00                	push   $0x0
  801ccf:	e8 15 ef ff ff       	call   800be9 <sys_page_alloc>
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	78 21                	js     801cfc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cde:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ce4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cf0:	83 ec 0c             	sub    $0xc,%esp
  801cf3:	50                   	push   %eax
  801cf4:	e8 35 f2 ff ff       	call   800f2e <fd2num>
  801cf9:	83 c4 10             	add    $0x10,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801d03:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d06:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801d0c:	e8 9a ee ff ff       	call   800bab <sys_getenvid>
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	ff 75 0c             	pushl  0xc(%ebp)
  801d17:	ff 75 08             	pushl  0x8(%ebp)
  801d1a:	56                   	push   %esi
  801d1b:	50                   	push   %eax
  801d1c:	68 98 24 80 00       	push   $0x802498
  801d21:	e8 e0 e4 ff ff       	call   800206 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d26:	83 c4 18             	add    $0x18,%esp
  801d29:	53                   	push   %ebx
  801d2a:	ff 75 10             	pushl  0x10(%ebp)
  801d2d:	e8 83 e4 ff ff       	call   8001b5 <vcprintf>
	cprintf("\n");
  801d32:	c7 04 24 50 20 80 00 	movl   $0x802050,(%esp)
  801d39:	e8 c8 e4 ff ff       	call   800206 <cprintf>
  801d3e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d41:	cc                   	int3   
  801d42:	eb fd                	jmp    801d41 <_panic+0x43>

00801d44 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801d4a:	68 bc 24 80 00       	push   $0x8024bc
  801d4f:	6a 1a                	push   $0x1a
  801d51:	68 d5 24 80 00       	push   $0x8024d5
  801d56:	e8 a3 ff ff ff       	call   801cfe <_panic>

00801d5b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801d61:	68 df 24 80 00       	push   $0x8024df
  801d66:	6a 2a                	push   $0x2a
  801d68:	68 d5 24 80 00       	push   $0x8024d5
  801d6d:	e8 8c ff ff ff       	call   801cfe <_panic>

00801d72 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d7d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d80:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d86:	8b 52 50             	mov    0x50(%edx),%edx
  801d89:	39 ca                	cmp    %ecx,%edx
  801d8b:	74 11                	je     801d9e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801d8d:	83 c0 01             	add    $0x1,%eax
  801d90:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d95:	75 e6                	jne    801d7d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d97:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9c:	eb 0b                	jmp    801da9 <ipc_find_env+0x37>
			return envs[i].env_id;
  801d9e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801da1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801da6:	8b 40 48             	mov    0x48(%eax),%eax
}
  801da9:	5d                   	pop    %ebp
  801daa:	c3                   	ret    

00801dab <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801db1:	89 d0                	mov    %edx,%eax
  801db3:	c1 e8 16             	shr    $0x16,%eax
  801db6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801dc2:	f6 c1 01             	test   $0x1,%cl
  801dc5:	74 1d                	je     801de4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801dc7:	c1 ea 0c             	shr    $0xc,%edx
  801dca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801dd1:	f6 c2 01             	test   $0x1,%dl
  801dd4:	74 0e                	je     801de4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801dd6:	c1 ea 0c             	shr    $0xc,%edx
  801dd9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801de0:	ef 
  801de1:	0f b7 c0             	movzwl %ax,%eax
}
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    
  801de6:	66 90                	xchg   %ax,%ax
  801de8:	66 90                	xchg   %ax,%ax
  801dea:	66 90                	xchg   %ax,%ax
  801dec:	66 90                	xchg   %ax,%ax
  801dee:	66 90                	xchg   %ax,%ax

00801df0 <__udivdi3>:
  801df0:	55                   	push   %ebp
  801df1:	57                   	push   %edi
  801df2:	56                   	push   %esi
  801df3:	53                   	push   %ebx
  801df4:	83 ec 1c             	sub    $0x1c,%esp
  801df7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801dfb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801dff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e07:	85 d2                	test   %edx,%edx
  801e09:	75 35                	jne    801e40 <__udivdi3+0x50>
  801e0b:	39 f3                	cmp    %esi,%ebx
  801e0d:	0f 87 bd 00 00 00    	ja     801ed0 <__udivdi3+0xe0>
  801e13:	85 db                	test   %ebx,%ebx
  801e15:	89 d9                	mov    %ebx,%ecx
  801e17:	75 0b                	jne    801e24 <__udivdi3+0x34>
  801e19:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1e:	31 d2                	xor    %edx,%edx
  801e20:	f7 f3                	div    %ebx
  801e22:	89 c1                	mov    %eax,%ecx
  801e24:	31 d2                	xor    %edx,%edx
  801e26:	89 f0                	mov    %esi,%eax
  801e28:	f7 f1                	div    %ecx
  801e2a:	89 c6                	mov    %eax,%esi
  801e2c:	89 e8                	mov    %ebp,%eax
  801e2e:	89 f7                	mov    %esi,%edi
  801e30:	f7 f1                	div    %ecx
  801e32:	89 fa                	mov    %edi,%edx
  801e34:	83 c4 1c             	add    $0x1c,%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    
  801e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e40:	39 f2                	cmp    %esi,%edx
  801e42:	77 7c                	ja     801ec0 <__udivdi3+0xd0>
  801e44:	0f bd fa             	bsr    %edx,%edi
  801e47:	83 f7 1f             	xor    $0x1f,%edi
  801e4a:	0f 84 98 00 00 00    	je     801ee8 <__udivdi3+0xf8>
  801e50:	89 f9                	mov    %edi,%ecx
  801e52:	b8 20 00 00 00       	mov    $0x20,%eax
  801e57:	29 f8                	sub    %edi,%eax
  801e59:	d3 e2                	shl    %cl,%edx
  801e5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5f:	89 c1                	mov    %eax,%ecx
  801e61:	89 da                	mov    %ebx,%edx
  801e63:	d3 ea                	shr    %cl,%edx
  801e65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e69:	09 d1                	or     %edx,%ecx
  801e6b:	89 f2                	mov    %esi,%edx
  801e6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e71:	89 f9                	mov    %edi,%ecx
  801e73:	d3 e3                	shl    %cl,%ebx
  801e75:	89 c1                	mov    %eax,%ecx
  801e77:	d3 ea                	shr    %cl,%edx
  801e79:	89 f9                	mov    %edi,%ecx
  801e7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e7f:	d3 e6                	shl    %cl,%esi
  801e81:	89 eb                	mov    %ebp,%ebx
  801e83:	89 c1                	mov    %eax,%ecx
  801e85:	d3 eb                	shr    %cl,%ebx
  801e87:	09 de                	or     %ebx,%esi
  801e89:	89 f0                	mov    %esi,%eax
  801e8b:	f7 74 24 08          	divl   0x8(%esp)
  801e8f:	89 d6                	mov    %edx,%esi
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	f7 64 24 0c          	mull   0xc(%esp)
  801e97:	39 d6                	cmp    %edx,%esi
  801e99:	72 0c                	jb     801ea7 <__udivdi3+0xb7>
  801e9b:	89 f9                	mov    %edi,%ecx
  801e9d:	d3 e5                	shl    %cl,%ebp
  801e9f:	39 c5                	cmp    %eax,%ebp
  801ea1:	73 5d                	jae    801f00 <__udivdi3+0x110>
  801ea3:	39 d6                	cmp    %edx,%esi
  801ea5:	75 59                	jne    801f00 <__udivdi3+0x110>
  801ea7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eaa:	31 ff                	xor    %edi,%edi
  801eac:	89 fa                	mov    %edi,%edx
  801eae:	83 c4 1c             	add    $0x1c,%esp
  801eb1:	5b                   	pop    %ebx
  801eb2:	5e                   	pop    %esi
  801eb3:	5f                   	pop    %edi
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    
  801eb6:	8d 76 00             	lea    0x0(%esi),%esi
  801eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801ec0:	31 ff                	xor    %edi,%edi
  801ec2:	31 c0                	xor    %eax,%eax
  801ec4:	89 fa                	mov    %edi,%edx
  801ec6:	83 c4 1c             	add    $0x1c,%esp
  801ec9:	5b                   	pop    %ebx
  801eca:	5e                   	pop    %esi
  801ecb:	5f                   	pop    %edi
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    
  801ece:	66 90                	xchg   %ax,%ax
  801ed0:	31 ff                	xor    %edi,%edi
  801ed2:	89 e8                	mov    %ebp,%eax
  801ed4:	89 f2                	mov    %esi,%edx
  801ed6:	f7 f3                	div    %ebx
  801ed8:	89 fa                	mov    %edi,%edx
  801eda:	83 c4 1c             	add    $0x1c,%esp
  801edd:	5b                   	pop    %ebx
  801ede:	5e                   	pop    %esi
  801edf:	5f                   	pop    %edi
  801ee0:	5d                   	pop    %ebp
  801ee1:	c3                   	ret    
  801ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ee8:	39 f2                	cmp    %esi,%edx
  801eea:	72 06                	jb     801ef2 <__udivdi3+0x102>
  801eec:	31 c0                	xor    %eax,%eax
  801eee:	39 eb                	cmp    %ebp,%ebx
  801ef0:	77 d2                	ja     801ec4 <__udivdi3+0xd4>
  801ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef7:	eb cb                	jmp    801ec4 <__udivdi3+0xd4>
  801ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f00:	89 d8                	mov    %ebx,%eax
  801f02:	31 ff                	xor    %edi,%edi
  801f04:	eb be                	jmp    801ec4 <__udivdi3+0xd4>
  801f06:	66 90                	xchg   %ax,%ax
  801f08:	66 90                	xchg   %ax,%ax
  801f0a:	66 90                	xchg   %ax,%ax
  801f0c:	66 90                	xchg   %ax,%ax
  801f0e:	66 90                	xchg   %ax,%ax

00801f10 <__umoddi3>:
  801f10:	55                   	push   %ebp
  801f11:	57                   	push   %edi
  801f12:	56                   	push   %esi
  801f13:	53                   	push   %ebx
  801f14:	83 ec 1c             	sub    $0x1c,%esp
  801f17:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801f1b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f1f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f27:	85 ed                	test   %ebp,%ebp
  801f29:	89 f0                	mov    %esi,%eax
  801f2b:	89 da                	mov    %ebx,%edx
  801f2d:	75 19                	jne    801f48 <__umoddi3+0x38>
  801f2f:	39 df                	cmp    %ebx,%edi
  801f31:	0f 86 b1 00 00 00    	jbe    801fe8 <__umoddi3+0xd8>
  801f37:	f7 f7                	div    %edi
  801f39:	89 d0                	mov    %edx,%eax
  801f3b:	31 d2                	xor    %edx,%edx
  801f3d:	83 c4 1c             	add    $0x1c,%esp
  801f40:	5b                   	pop    %ebx
  801f41:	5e                   	pop    %esi
  801f42:	5f                   	pop    %edi
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    
  801f45:	8d 76 00             	lea    0x0(%esi),%esi
  801f48:	39 dd                	cmp    %ebx,%ebp
  801f4a:	77 f1                	ja     801f3d <__umoddi3+0x2d>
  801f4c:	0f bd cd             	bsr    %ebp,%ecx
  801f4f:	83 f1 1f             	xor    $0x1f,%ecx
  801f52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f56:	0f 84 b4 00 00 00    	je     802010 <__umoddi3+0x100>
  801f5c:	b8 20 00 00 00       	mov    $0x20,%eax
  801f61:	89 c2                	mov    %eax,%edx
  801f63:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f67:	29 c2                	sub    %eax,%edx
  801f69:	89 c1                	mov    %eax,%ecx
  801f6b:	89 f8                	mov    %edi,%eax
  801f6d:	d3 e5                	shl    %cl,%ebp
  801f6f:	89 d1                	mov    %edx,%ecx
  801f71:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f75:	d3 e8                	shr    %cl,%eax
  801f77:	09 c5                	or     %eax,%ebp
  801f79:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f7d:	89 c1                	mov    %eax,%ecx
  801f7f:	d3 e7                	shl    %cl,%edi
  801f81:	89 d1                	mov    %edx,%ecx
  801f83:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f87:	89 df                	mov    %ebx,%edi
  801f89:	d3 ef                	shr    %cl,%edi
  801f8b:	89 c1                	mov    %eax,%ecx
  801f8d:	89 f0                	mov    %esi,%eax
  801f8f:	d3 e3                	shl    %cl,%ebx
  801f91:	89 d1                	mov    %edx,%ecx
  801f93:	89 fa                	mov    %edi,%edx
  801f95:	d3 e8                	shr    %cl,%eax
  801f97:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f9c:	09 d8                	or     %ebx,%eax
  801f9e:	f7 f5                	div    %ebp
  801fa0:	d3 e6                	shl    %cl,%esi
  801fa2:	89 d1                	mov    %edx,%ecx
  801fa4:	f7 64 24 08          	mull   0x8(%esp)
  801fa8:	39 d1                	cmp    %edx,%ecx
  801faa:	89 c3                	mov    %eax,%ebx
  801fac:	89 d7                	mov    %edx,%edi
  801fae:	72 06                	jb     801fb6 <__umoddi3+0xa6>
  801fb0:	75 0e                	jne    801fc0 <__umoddi3+0xb0>
  801fb2:	39 c6                	cmp    %eax,%esi
  801fb4:	73 0a                	jae    801fc0 <__umoddi3+0xb0>
  801fb6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801fba:	19 ea                	sbb    %ebp,%edx
  801fbc:	89 d7                	mov    %edx,%edi
  801fbe:	89 c3                	mov    %eax,%ebx
  801fc0:	89 ca                	mov    %ecx,%edx
  801fc2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801fc7:	29 de                	sub    %ebx,%esi
  801fc9:	19 fa                	sbb    %edi,%edx
  801fcb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801fcf:	89 d0                	mov    %edx,%eax
  801fd1:	d3 e0                	shl    %cl,%eax
  801fd3:	89 d9                	mov    %ebx,%ecx
  801fd5:	d3 ee                	shr    %cl,%esi
  801fd7:	d3 ea                	shr    %cl,%edx
  801fd9:	09 f0                	or     %esi,%eax
  801fdb:	83 c4 1c             	add    $0x1c,%esp
  801fde:	5b                   	pop    %ebx
  801fdf:	5e                   	pop    %esi
  801fe0:	5f                   	pop    %edi
  801fe1:	5d                   	pop    %ebp
  801fe2:	c3                   	ret    
  801fe3:	90                   	nop
  801fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fe8:	85 ff                	test   %edi,%edi
  801fea:	89 f9                	mov    %edi,%ecx
  801fec:	75 0b                	jne    801ff9 <__umoddi3+0xe9>
  801fee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff3:	31 d2                	xor    %edx,%edx
  801ff5:	f7 f7                	div    %edi
  801ff7:	89 c1                	mov    %eax,%ecx
  801ff9:	89 d8                	mov    %ebx,%eax
  801ffb:	31 d2                	xor    %edx,%edx
  801ffd:	f7 f1                	div    %ecx
  801fff:	89 f0                	mov    %esi,%eax
  802001:	f7 f1                	div    %ecx
  802003:	e9 31 ff ff ff       	jmp    801f39 <__umoddi3+0x29>
  802008:	90                   	nop
  802009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802010:	39 dd                	cmp    %ebx,%ebp
  802012:	72 08                	jb     80201c <__umoddi3+0x10c>
  802014:	39 f7                	cmp    %esi,%edi
  802016:	0f 87 21 ff ff ff    	ja     801f3d <__umoddi3+0x2d>
  80201c:	89 da                	mov    %ebx,%edx
  80201e:	89 f0                	mov    %esi,%eax
  802020:	29 f8                	sub    %edi,%eax
  802022:	19 ea                	sbb    %ebp,%edx
  802024:	e9 14 ff ff ff       	jmp    801f3d <__umoddi3+0x2d>
