
obj/user/forktree.debug：     文件格式 elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 3b 0b 00 00       	call   800b7d <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 80 20 80 00       	push   $0x802080
  80004c:	e8 87 01 00 00       	call   8001d8 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 08 07 00 00       	call   80078b <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 91 20 80 00       	push   $0x802091
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 c5 06 00 00       	call   800771 <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 0f 0d 00 00       	call   800dc3 <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 60 00 00 00       	call   800129 <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 90 20 80 00       	push   $0x802090
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 8a 0a 00 00       	call   800b7d <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x2d>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800110:	83 ec 08             	sub    $0x8,%esp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	e8 b4 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80011a:	e8 0a 00 00 00       	call   800129 <exit>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012f:	e8 87 10 00 00       	call   8011bb <close_all>
	sys_env_destroy(0);
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	6a 00                	push   $0x0
  800139:	e8 fe 09 00 00       	call   800b3c <sys_env_destroy>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	53                   	push   %ebx
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014d:	8b 13                	mov    (%ebx),%edx
  80014f:	8d 42 01             	lea    0x1(%edx),%eax
  800152:	89 03                	mov    %eax,(%ebx)
  800154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800157:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800160:	74 09                	je     80016b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800162:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800169:	c9                   	leave  
  80016a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	68 ff 00 00 00       	push   $0xff
  800173:	8d 43 08             	lea    0x8(%ebx),%eax
  800176:	50                   	push   %eax
  800177:	e8 83 09 00 00       	call   800aff <sys_cputs>
		b->idx = 0;
  80017c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	eb db                	jmp    800162 <putch+0x1f>

00800187 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800190:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800197:	00 00 00 
	b.cnt = 0;
  80019a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	68 43 01 80 00       	push   $0x800143
  8001b6:	e8 1a 01 00 00       	call   8002d5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bb:	83 c4 08             	add    $0x8,%esp
  8001be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	e8 2f 09 00 00       	call   800aff <sys_cputs>

	return b.cnt;
}
  8001d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001de:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e1:	50                   	push   %eax
  8001e2:	ff 75 08             	pushl  0x8(%ebp)
  8001e5:	e8 9d ff ff ff       	call   800187 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 1c             	sub    $0x1c,%esp
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	89 d6                	mov    %edx,%esi
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800202:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800205:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800208:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800210:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800213:	39 d3                	cmp    %edx,%ebx
  800215:	72 05                	jb     80021c <printnum+0x30>
  800217:	39 45 10             	cmp    %eax,0x10(%ebp)
  80021a:	77 7a                	ja     800296 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	ff 75 18             	pushl  0x18(%ebp)
  800222:	8b 45 14             	mov    0x14(%ebp),%eax
  800225:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800228:	53                   	push   %ebx
  800229:	ff 75 10             	pushl  0x10(%ebp)
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800232:	ff 75 e0             	pushl  -0x20(%ebp)
  800235:	ff 75 dc             	pushl  -0x24(%ebp)
  800238:	ff 75 d8             	pushl  -0x28(%ebp)
  80023b:	e8 f0 1b 00 00       	call   801e30 <__udivdi3>
  800240:	83 c4 18             	add    $0x18,%esp
  800243:	52                   	push   %edx
  800244:	50                   	push   %eax
  800245:	89 f2                	mov    %esi,%edx
  800247:	89 f8                	mov    %edi,%eax
  800249:	e8 9e ff ff ff       	call   8001ec <printnum>
  80024e:	83 c4 20             	add    $0x20,%esp
  800251:	eb 13                	jmp    800266 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	56                   	push   %esi
  800257:	ff 75 18             	pushl  0x18(%ebp)
  80025a:	ff d7                	call   *%edi
  80025c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80025f:	83 eb 01             	sub    $0x1,%ebx
  800262:	85 db                	test   %ebx,%ebx
  800264:	7f ed                	jg     800253 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800266:	83 ec 08             	sub    $0x8,%esp
  800269:	56                   	push   %esi
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800270:	ff 75 e0             	pushl  -0x20(%ebp)
  800273:	ff 75 dc             	pushl  -0x24(%ebp)
  800276:	ff 75 d8             	pushl  -0x28(%ebp)
  800279:	e8 d2 1c 00 00       	call   801f50 <__umoddi3>
  80027e:	83 c4 14             	add    $0x14,%esp
  800281:	0f be 80 a0 20 80 00 	movsbl 0x8020a0(%eax),%eax
  800288:	50                   	push   %eax
  800289:	ff d7                	call   *%edi
}
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800291:	5b                   	pop    %ebx
  800292:	5e                   	pop    %esi
  800293:	5f                   	pop    %edi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    
  800296:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800299:	eb c4                	jmp    80025f <printnum+0x73>

0080029b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a5:	8b 10                	mov    (%eax),%edx
  8002a7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002aa:	73 0a                	jae    8002b6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002af:	89 08                	mov    %ecx,(%eax)
  8002b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b4:	88 02                	mov    %al,(%edx)
}
  8002b6:	5d                   	pop    %ebp
  8002b7:	c3                   	ret    

008002b8 <printfmt>:
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002be:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c1:	50                   	push   %eax
  8002c2:	ff 75 10             	pushl  0x10(%ebp)
  8002c5:	ff 75 0c             	pushl  0xc(%ebp)
  8002c8:	ff 75 08             	pushl  0x8(%ebp)
  8002cb:	e8 05 00 00 00       	call   8002d5 <vprintfmt>
}
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <vprintfmt>:
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 2c             	sub    $0x2c,%esp
  8002de:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e7:	e9 8c 03 00 00       	jmp    800678 <vprintfmt+0x3a3>
		padc = ' ';
  8002ec:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002f0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002f7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800305:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8d 47 01             	lea    0x1(%edi),%eax
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800310:	0f b6 17             	movzbl (%edi),%edx
  800313:	8d 42 dd             	lea    -0x23(%edx),%eax
  800316:	3c 55                	cmp    $0x55,%al
  800318:	0f 87 dd 03 00 00    	ja     8006fb <vprintfmt+0x426>
  80031e:	0f b6 c0             	movzbl %al,%eax
  800321:	ff 24 85 e0 21 80 00 	jmp    *0x8021e0(,%eax,4)
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80032f:	eb d9                	jmp    80030a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800334:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800338:	eb d0                	jmp    80030a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	0f b6 d2             	movzbl %dl,%edx
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800348:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800352:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800355:	83 f9 09             	cmp    $0x9,%ecx
  800358:	77 55                	ja     8003af <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80035a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035d:	eb e9                	jmp    800348 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8d 40 04             	lea    0x4(%eax),%eax
  80036d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800373:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800377:	79 91                	jns    80030a <vprintfmt+0x35>
				width = precision, precision = -1;
  800379:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80037c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800386:	eb 82                	jmp    80030a <vprintfmt+0x35>
  800388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038b:	85 c0                	test   %eax,%eax
  80038d:	ba 00 00 00 00       	mov    $0x0,%edx
  800392:	0f 49 d0             	cmovns %eax,%edx
  800395:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039b:	e9 6a ff ff ff       	jmp    80030a <vprintfmt+0x35>
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003aa:	e9 5b ff ff ff       	jmp    80030a <vprintfmt+0x35>
  8003af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b5:	eb bc                	jmp    800373 <vprintfmt+0x9e>
			lflag++;
  8003b7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bd:	e9 48 ff ff ff       	jmp    80030a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	8d 78 04             	lea    0x4(%eax),%edi
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	53                   	push   %ebx
  8003cc:	ff 30                	pushl  (%eax)
  8003ce:	ff d6                	call   *%esi
			break;
  8003d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d6:	e9 9a 02 00 00       	jmp    800675 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8d 78 04             	lea    0x4(%eax),%edi
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	99                   	cltd   
  8003e4:	31 d0                	xor    %edx,%eax
  8003e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e8:	83 f8 0f             	cmp    $0xf,%eax
  8003eb:	7f 23                	jg     800410 <vprintfmt+0x13b>
  8003ed:	8b 14 85 40 23 80 00 	mov    0x802340(,%eax,4),%edx
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 18                	je     800410 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003f8:	52                   	push   %edx
  8003f9:	68 31 25 80 00       	push   $0x802531
  8003fe:	53                   	push   %ebx
  8003ff:	56                   	push   %esi
  800400:	e8 b3 fe ff ff       	call   8002b8 <printfmt>
  800405:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800408:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040b:	e9 65 02 00 00       	jmp    800675 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800410:	50                   	push   %eax
  800411:	68 b8 20 80 00       	push   $0x8020b8
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 9b fe ff ff       	call   8002b8 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800423:	e9 4d 02 00 00       	jmp    800675 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800428:	8b 45 14             	mov    0x14(%ebp),%eax
  80042b:	83 c0 04             	add    $0x4,%eax
  80042e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800436:	85 ff                	test   %edi,%edi
  800438:	b8 b1 20 80 00       	mov    $0x8020b1,%eax
  80043d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800440:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800444:	0f 8e bd 00 00 00    	jle    800507 <vprintfmt+0x232>
  80044a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80044e:	75 0e                	jne    80045e <vprintfmt+0x189>
  800450:	89 75 08             	mov    %esi,0x8(%ebp)
  800453:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800456:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800459:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80045c:	eb 6d                	jmp    8004cb <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	ff 75 d0             	pushl  -0x30(%ebp)
  800464:	57                   	push   %edi
  800465:	e8 39 03 00 00       	call   8007a3 <strnlen>
  80046a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046d:	29 c1                	sub    %eax,%ecx
  80046f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800472:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800475:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800479:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80047f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800481:	eb 0f                	jmp    800492 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	53                   	push   %ebx
  800487:	ff 75 e0             	pushl  -0x20(%ebp)
  80048a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	83 ef 01             	sub    $0x1,%edi
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	85 ff                	test   %edi,%edi
  800494:	7f ed                	jg     800483 <vprintfmt+0x1ae>
  800496:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800499:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80049c:	85 c9                	test   %ecx,%ecx
  80049e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a3:	0f 49 c1             	cmovns %ecx,%eax
  8004a6:	29 c1                	sub    %eax,%ecx
  8004a8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ab:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ae:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b1:	89 cb                	mov    %ecx,%ebx
  8004b3:	eb 16                	jmp    8004cb <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b9:	75 31                	jne    8004ec <vprintfmt+0x217>
					putch(ch, putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	50                   	push   %eax
  8004c2:	ff 55 08             	call   *0x8(%ebp)
  8004c5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c8:	83 eb 01             	sub    $0x1,%ebx
  8004cb:	83 c7 01             	add    $0x1,%edi
  8004ce:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004d2:	0f be c2             	movsbl %dl,%eax
  8004d5:	85 c0                	test   %eax,%eax
  8004d7:	74 59                	je     800532 <vprintfmt+0x25d>
  8004d9:	85 f6                	test   %esi,%esi
  8004db:	78 d8                	js     8004b5 <vprintfmt+0x1e0>
  8004dd:	83 ee 01             	sub    $0x1,%esi
  8004e0:	79 d3                	jns    8004b5 <vprintfmt+0x1e0>
  8004e2:	89 df                	mov    %ebx,%edi
  8004e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ea:	eb 37                	jmp    800523 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ec:	0f be d2             	movsbl %dl,%edx
  8004ef:	83 ea 20             	sub    $0x20,%edx
  8004f2:	83 fa 5e             	cmp    $0x5e,%edx
  8004f5:	76 c4                	jbe    8004bb <vprintfmt+0x1e6>
					putch('?', putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	ff 75 0c             	pushl  0xc(%ebp)
  8004fd:	6a 3f                	push   $0x3f
  8004ff:	ff 55 08             	call   *0x8(%ebp)
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	eb c1                	jmp    8004c8 <vprintfmt+0x1f3>
  800507:	89 75 08             	mov    %esi,0x8(%ebp)
  80050a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80050d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800510:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800513:	eb b6                	jmp    8004cb <vprintfmt+0x1f6>
				putch(' ', putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	6a 20                	push   $0x20
  80051b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80051d:	83 ef 01             	sub    $0x1,%edi
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	85 ff                	test   %edi,%edi
  800525:	7f ee                	jg     800515 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800527:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	e9 43 01 00 00       	jmp    800675 <vprintfmt+0x3a0>
  800532:	89 df                	mov    %ebx,%edi
  800534:	8b 75 08             	mov    0x8(%ebp),%esi
  800537:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053a:	eb e7                	jmp    800523 <vprintfmt+0x24e>
	if (lflag >= 2)
  80053c:	83 f9 01             	cmp    $0x1,%ecx
  80053f:	7e 3f                	jle    800580 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8b 50 04             	mov    0x4(%eax),%edx
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 40 08             	lea    0x8(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800558:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80055c:	79 5c                	jns    8005ba <vprintfmt+0x2e5>
				putch('-', putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	6a 2d                	push   $0x2d
  800564:	ff d6                	call   *%esi
				num = -(long long) num;
  800566:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800569:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80056c:	f7 da                	neg    %edx
  80056e:	83 d1 00             	adc    $0x0,%ecx
  800571:	f7 d9                	neg    %ecx
  800573:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800576:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057b:	e9 db 00 00 00       	jmp    80065b <vprintfmt+0x386>
	else if (lflag)
  800580:	85 c9                	test   %ecx,%ecx
  800582:	75 1b                	jne    80059f <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058c:	89 c1                	mov    %eax,%ecx
  80058e:	c1 f9 1f             	sar    $0x1f,%ecx
  800591:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 40 04             	lea    0x4(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
  80059d:	eb b9                	jmp    800558 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a7:	89 c1                	mov    %eax,%ecx
  8005a9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ac:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 40 04             	lea    0x4(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b8:	eb 9e                	jmp    800558 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005bd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c5:	e9 91 00 00 00       	jmp    80065b <vprintfmt+0x386>
	if (lflag >= 2)
  8005ca:	83 f9 01             	cmp    $0x1,%ecx
  8005cd:	7e 15                	jle    8005e4 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 10                	mov    (%eax),%edx
  8005d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d7:	8d 40 08             	lea    0x8(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e2:	eb 77                	jmp    80065b <vprintfmt+0x386>
	else if (lflag)
  8005e4:	85 c9                	test   %ecx,%ecx
  8005e6:	75 17                	jne    8005ff <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 10                	mov    (%eax),%edx
  8005ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f2:	8d 40 04             	lea    0x4(%eax),%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fd:	eb 5c                	jmp    80065b <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8b 10                	mov    (%eax),%edx
  800604:	b9 00 00 00 00       	mov    $0x0,%ecx
  800609:	8d 40 04             	lea    0x4(%eax),%eax
  80060c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800614:	eb 45                	jmp    80065b <vprintfmt+0x386>
			putch('X', putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	53                   	push   %ebx
  80061a:	6a 58                	push   $0x58
  80061c:	ff d6                	call   *%esi
			putch('X', putdat);
  80061e:	83 c4 08             	add    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	6a 58                	push   $0x58
  800624:	ff d6                	call   *%esi
			putch('X', putdat);
  800626:	83 c4 08             	add    $0x8,%esp
  800629:	53                   	push   %ebx
  80062a:	6a 58                	push   $0x58
  80062c:	ff d6                	call   *%esi
			break;
  80062e:	83 c4 10             	add    $0x10,%esp
  800631:	eb 42                	jmp    800675 <vprintfmt+0x3a0>
			putch('0', putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	53                   	push   %ebx
  800637:	6a 30                	push   $0x30
  800639:	ff d6                	call   *%esi
			putch('x', putdat);
  80063b:	83 c4 08             	add    $0x8,%esp
  80063e:	53                   	push   %ebx
  80063f:	6a 78                	push   $0x78
  800641:	ff d6                	call   *%esi
			num = (unsigned long long)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 10                	mov    (%eax),%edx
  800648:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800656:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80065b:	83 ec 0c             	sub    $0xc,%esp
  80065e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800662:	57                   	push   %edi
  800663:	ff 75 e0             	pushl  -0x20(%ebp)
  800666:	50                   	push   %eax
  800667:	51                   	push   %ecx
  800668:	52                   	push   %edx
  800669:	89 da                	mov    %ebx,%edx
  80066b:	89 f0                	mov    %esi,%eax
  80066d:	e8 7a fb ff ff       	call   8001ec <printnum>
			break;
  800672:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800675:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800678:	83 c7 01             	add    $0x1,%edi
  80067b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80067f:	83 f8 25             	cmp    $0x25,%eax
  800682:	0f 84 64 fc ff ff    	je     8002ec <vprintfmt+0x17>
			if (ch == '\0')
  800688:	85 c0                	test   %eax,%eax
  80068a:	0f 84 8b 00 00 00    	je     80071b <vprintfmt+0x446>
			putch(ch, putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	50                   	push   %eax
  800695:	ff d6                	call   *%esi
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	eb dc                	jmp    800678 <vprintfmt+0x3a3>
	if (lflag >= 2)
  80069c:	83 f9 01             	cmp    $0x1,%ecx
  80069f:	7e 15                	jle    8006b6 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 10                	mov    (%eax),%edx
  8006a6:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a9:	8d 40 08             	lea    0x8(%eax),%eax
  8006ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006af:	b8 10 00 00 00       	mov    $0x10,%eax
  8006b4:	eb a5                	jmp    80065b <vprintfmt+0x386>
	else if (lflag)
  8006b6:	85 c9                	test   %ecx,%ecx
  8006b8:	75 17                	jne    8006d1 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 10                	mov    (%eax),%edx
  8006bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ca:	b8 10 00 00 00       	mov    $0x10,%eax
  8006cf:	eb 8a                	jmp    80065b <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 10                	mov    (%eax),%edx
  8006d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e1:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e6:	e9 70 ff ff ff       	jmp    80065b <vprintfmt+0x386>
			putch(ch, putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 25                	push   $0x25
  8006f1:	ff d6                	call   *%esi
			break;
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	e9 7a ff ff ff       	jmp    800675 <vprintfmt+0x3a0>
			putch('%', putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	53                   	push   %ebx
  8006ff:	6a 25                	push   $0x25
  800701:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	89 f8                	mov    %edi,%eax
  800708:	eb 03                	jmp    80070d <vprintfmt+0x438>
  80070a:	83 e8 01             	sub    $0x1,%eax
  80070d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800711:	75 f7                	jne    80070a <vprintfmt+0x435>
  800713:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800716:	e9 5a ff ff ff       	jmp    800675 <vprintfmt+0x3a0>
}
  80071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071e:	5b                   	pop    %ebx
  80071f:	5e                   	pop    %esi
  800720:	5f                   	pop    %edi
  800721:	5d                   	pop    %ebp
  800722:	c3                   	ret    

00800723 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	83 ec 18             	sub    $0x18,%esp
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80072f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800732:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800736:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800739:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800740:	85 c0                	test   %eax,%eax
  800742:	74 26                	je     80076a <vsnprintf+0x47>
  800744:	85 d2                	test   %edx,%edx
  800746:	7e 22                	jle    80076a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800748:	ff 75 14             	pushl  0x14(%ebp)
  80074b:	ff 75 10             	pushl  0x10(%ebp)
  80074e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800751:	50                   	push   %eax
  800752:	68 9b 02 80 00       	push   $0x80029b
  800757:	e8 79 fb ff ff       	call   8002d5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80075c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80075f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800765:	83 c4 10             	add    $0x10,%esp
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    
		return -E_INVAL;
  80076a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80076f:	eb f7                	jmp    800768 <vsnprintf+0x45>

00800771 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
  800774:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800777:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80077a:	50                   	push   %eax
  80077b:	ff 75 10             	pushl  0x10(%ebp)
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	e8 9a ff ff ff       	call   800723 <vsnprintf>
	va_end(ap);

	return rc;
}
  800789:	c9                   	leave  
  80078a:	c3                   	ret    

0080078b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800791:	b8 00 00 00 00       	mov    $0x0,%eax
  800796:	eb 03                	jmp    80079b <strlen+0x10>
		n++;
  800798:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80079b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80079f:	75 f7                	jne    800798 <strlen+0xd>
	return n;
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b1:	eb 03                	jmp    8007b6 <strnlen+0x13>
		n++;
  8007b3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b6:	39 d0                	cmp    %edx,%eax
  8007b8:	74 06                	je     8007c0 <strnlen+0x1d>
  8007ba:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007be:	75 f3                	jne    8007b3 <strnlen+0x10>
	return n;
}
  8007c0:	5d                   	pop    %ebp
  8007c1:	c3                   	ret    

008007c2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	53                   	push   %ebx
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007cc:	89 c2                	mov    %eax,%edx
  8007ce:	83 c1 01             	add    $0x1,%ecx
  8007d1:	83 c2 01             	add    $0x1,%edx
  8007d4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007d8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007db:	84 db                	test   %bl,%bl
  8007dd:	75 ef                	jne    8007ce <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007df:	5b                   	pop    %ebx
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	53                   	push   %ebx
  8007e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e9:	53                   	push   %ebx
  8007ea:	e8 9c ff ff ff       	call   80078b <strlen>
  8007ef:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	50                   	push   %eax
  8007f8:	e8 c5 ff ff ff       	call   8007c2 <strcpy>
	return dst;
}
  8007fd:	89 d8                	mov    %ebx,%eax
  8007ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800802:	c9                   	leave  
  800803:	c3                   	ret    

00800804 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	56                   	push   %esi
  800808:	53                   	push   %ebx
  800809:	8b 75 08             	mov    0x8(%ebp),%esi
  80080c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080f:	89 f3                	mov    %esi,%ebx
  800811:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800814:	89 f2                	mov    %esi,%edx
  800816:	eb 0f                	jmp    800827 <strncpy+0x23>
		*dst++ = *src;
  800818:	83 c2 01             	add    $0x1,%edx
  80081b:	0f b6 01             	movzbl (%ecx),%eax
  80081e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800821:	80 39 01             	cmpb   $0x1,(%ecx)
  800824:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800827:	39 da                	cmp    %ebx,%edx
  800829:	75 ed                	jne    800818 <strncpy+0x14>
	}
	return ret;
}
  80082b:	89 f0                	mov    %esi,%eax
  80082d:	5b                   	pop    %ebx
  80082e:	5e                   	pop    %esi
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	56                   	push   %esi
  800835:	53                   	push   %ebx
  800836:	8b 75 08             	mov    0x8(%ebp),%esi
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80083f:	89 f0                	mov    %esi,%eax
  800841:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800845:	85 c9                	test   %ecx,%ecx
  800847:	75 0b                	jne    800854 <strlcpy+0x23>
  800849:	eb 17                	jmp    800862 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80084b:	83 c2 01             	add    $0x1,%edx
  80084e:	83 c0 01             	add    $0x1,%eax
  800851:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800854:	39 d8                	cmp    %ebx,%eax
  800856:	74 07                	je     80085f <strlcpy+0x2e>
  800858:	0f b6 0a             	movzbl (%edx),%ecx
  80085b:	84 c9                	test   %cl,%cl
  80085d:	75 ec                	jne    80084b <strlcpy+0x1a>
		*dst = '\0';
  80085f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800862:	29 f0                	sub    %esi,%eax
}
  800864:	5b                   	pop    %ebx
  800865:	5e                   	pop    %esi
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800871:	eb 06                	jmp    800879 <strcmp+0x11>
		p++, q++;
  800873:	83 c1 01             	add    $0x1,%ecx
  800876:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800879:	0f b6 01             	movzbl (%ecx),%eax
  80087c:	84 c0                	test   %al,%al
  80087e:	74 04                	je     800884 <strcmp+0x1c>
  800880:	3a 02                	cmp    (%edx),%al
  800882:	74 ef                	je     800873 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800884:	0f b6 c0             	movzbl %al,%eax
  800887:	0f b6 12             	movzbl (%edx),%edx
  80088a:	29 d0                	sub    %edx,%eax
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	53                   	push   %ebx
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 55 0c             	mov    0xc(%ebp),%edx
  800898:	89 c3                	mov    %eax,%ebx
  80089a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80089d:	eb 06                	jmp    8008a5 <strncmp+0x17>
		n--, p++, q++;
  80089f:	83 c0 01             	add    $0x1,%eax
  8008a2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008a5:	39 d8                	cmp    %ebx,%eax
  8008a7:	74 16                	je     8008bf <strncmp+0x31>
  8008a9:	0f b6 08             	movzbl (%eax),%ecx
  8008ac:	84 c9                	test   %cl,%cl
  8008ae:	74 04                	je     8008b4 <strncmp+0x26>
  8008b0:	3a 0a                	cmp    (%edx),%cl
  8008b2:	74 eb                	je     80089f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b4:	0f b6 00             	movzbl (%eax),%eax
  8008b7:	0f b6 12             	movzbl (%edx),%edx
  8008ba:	29 d0                	sub    %edx,%eax
}
  8008bc:	5b                   	pop    %ebx
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    
		return 0;
  8008bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c4:	eb f6                	jmp    8008bc <strncmp+0x2e>

008008c6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d0:	0f b6 10             	movzbl (%eax),%edx
  8008d3:	84 d2                	test   %dl,%dl
  8008d5:	74 09                	je     8008e0 <strchr+0x1a>
		if (*s == c)
  8008d7:	38 ca                	cmp    %cl,%dl
  8008d9:	74 0a                	je     8008e5 <strchr+0x1f>
	for (; *s; s++)
  8008db:	83 c0 01             	add    $0x1,%eax
  8008de:	eb f0                	jmp    8008d0 <strchr+0xa>
			return (char *) s;
	return 0;
  8008e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f1:	eb 03                	jmp    8008f6 <strfind+0xf>
  8008f3:	83 c0 01             	add    $0x1,%eax
  8008f6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008f9:	38 ca                	cmp    %cl,%dl
  8008fb:	74 04                	je     800901 <strfind+0x1a>
  8008fd:	84 d2                	test   %dl,%dl
  8008ff:	75 f2                	jne    8008f3 <strfind+0xc>
			break;
	return (char *) s;
}
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	57                   	push   %edi
  800907:	56                   	push   %esi
  800908:	53                   	push   %ebx
  800909:	8b 7d 08             	mov    0x8(%ebp),%edi
  80090c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80090f:	85 c9                	test   %ecx,%ecx
  800911:	74 13                	je     800926 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800913:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800919:	75 05                	jne    800920 <memset+0x1d>
  80091b:	f6 c1 03             	test   $0x3,%cl
  80091e:	74 0d                	je     80092d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800920:	8b 45 0c             	mov    0xc(%ebp),%eax
  800923:	fc                   	cld    
  800924:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800926:	89 f8                	mov    %edi,%eax
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5f                   	pop    %edi
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    
		c &= 0xFF;
  80092d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800931:	89 d3                	mov    %edx,%ebx
  800933:	c1 e3 08             	shl    $0x8,%ebx
  800936:	89 d0                	mov    %edx,%eax
  800938:	c1 e0 18             	shl    $0x18,%eax
  80093b:	89 d6                	mov    %edx,%esi
  80093d:	c1 e6 10             	shl    $0x10,%esi
  800940:	09 f0                	or     %esi,%eax
  800942:	09 c2                	or     %eax,%edx
  800944:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800946:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800949:	89 d0                	mov    %edx,%eax
  80094b:	fc                   	cld    
  80094c:	f3 ab                	rep stos %eax,%es:(%edi)
  80094e:	eb d6                	jmp    800926 <memset+0x23>

00800950 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	57                   	push   %edi
  800954:	56                   	push   %esi
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 75 0c             	mov    0xc(%ebp),%esi
  80095b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80095e:	39 c6                	cmp    %eax,%esi
  800960:	73 35                	jae    800997 <memmove+0x47>
  800962:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800965:	39 c2                	cmp    %eax,%edx
  800967:	76 2e                	jbe    800997 <memmove+0x47>
		s += n;
		d += n;
  800969:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096c:	89 d6                	mov    %edx,%esi
  80096e:	09 fe                	or     %edi,%esi
  800970:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800976:	74 0c                	je     800984 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800978:	83 ef 01             	sub    $0x1,%edi
  80097b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80097e:	fd                   	std    
  80097f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800981:	fc                   	cld    
  800982:	eb 21                	jmp    8009a5 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800984:	f6 c1 03             	test   $0x3,%cl
  800987:	75 ef                	jne    800978 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800989:	83 ef 04             	sub    $0x4,%edi
  80098c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80098f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800992:	fd                   	std    
  800993:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800995:	eb ea                	jmp    800981 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800997:	89 f2                	mov    %esi,%edx
  800999:	09 c2                	or     %eax,%edx
  80099b:	f6 c2 03             	test   $0x3,%dl
  80099e:	74 09                	je     8009a9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009a0:	89 c7                	mov    %eax,%edi
  8009a2:	fc                   	cld    
  8009a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009a5:	5e                   	pop    %esi
  8009a6:	5f                   	pop    %edi
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a9:	f6 c1 03             	test   $0x3,%cl
  8009ac:	75 f2                	jne    8009a0 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ae:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b1:	89 c7                	mov    %eax,%edi
  8009b3:	fc                   	cld    
  8009b4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b6:	eb ed                	jmp    8009a5 <memmove+0x55>

008009b8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009bb:	ff 75 10             	pushl  0x10(%ebp)
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	ff 75 08             	pushl  0x8(%ebp)
  8009c4:	e8 87 ff ff ff       	call   800950 <memmove>
}
  8009c9:	c9                   	leave  
  8009ca:	c3                   	ret    

008009cb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	56                   	push   %esi
  8009cf:	53                   	push   %ebx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d6:	89 c6                	mov    %eax,%esi
  8009d8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009db:	39 f0                	cmp    %esi,%eax
  8009dd:	74 1c                	je     8009fb <memcmp+0x30>
		if (*s1 != *s2)
  8009df:	0f b6 08             	movzbl (%eax),%ecx
  8009e2:	0f b6 1a             	movzbl (%edx),%ebx
  8009e5:	38 d9                	cmp    %bl,%cl
  8009e7:	75 08                	jne    8009f1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009e9:	83 c0 01             	add    $0x1,%eax
  8009ec:	83 c2 01             	add    $0x1,%edx
  8009ef:	eb ea                	jmp    8009db <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009f1:	0f b6 c1             	movzbl %cl,%eax
  8009f4:	0f b6 db             	movzbl %bl,%ebx
  8009f7:	29 d8                	sub    %ebx,%eax
  8009f9:	eb 05                	jmp    800a00 <memcmp+0x35>
	}

	return 0;
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a00:	5b                   	pop    %ebx
  800a01:	5e                   	pop    %esi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a0d:	89 c2                	mov    %eax,%edx
  800a0f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a12:	39 d0                	cmp    %edx,%eax
  800a14:	73 09                	jae    800a1f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a16:	38 08                	cmp    %cl,(%eax)
  800a18:	74 05                	je     800a1f <memfind+0x1b>
	for (; s < ends; s++)
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	eb f3                	jmp    800a12 <memfind+0xe>
			break;
	return (void *) s;
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	57                   	push   %edi
  800a25:	56                   	push   %esi
  800a26:	53                   	push   %ebx
  800a27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a2d:	eb 03                	jmp    800a32 <strtol+0x11>
		s++;
  800a2f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a32:	0f b6 01             	movzbl (%ecx),%eax
  800a35:	3c 20                	cmp    $0x20,%al
  800a37:	74 f6                	je     800a2f <strtol+0xe>
  800a39:	3c 09                	cmp    $0x9,%al
  800a3b:	74 f2                	je     800a2f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a3d:	3c 2b                	cmp    $0x2b,%al
  800a3f:	74 2e                	je     800a6f <strtol+0x4e>
	int neg = 0;
  800a41:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a46:	3c 2d                	cmp    $0x2d,%al
  800a48:	74 2f                	je     800a79 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a4a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a50:	75 05                	jne    800a57 <strtol+0x36>
  800a52:	80 39 30             	cmpb   $0x30,(%ecx)
  800a55:	74 2c                	je     800a83 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a57:	85 db                	test   %ebx,%ebx
  800a59:	75 0a                	jne    800a65 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a5b:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a60:	80 39 30             	cmpb   $0x30,(%ecx)
  800a63:	74 28                	je     800a8d <strtol+0x6c>
		base = 10;
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a6d:	eb 50                	jmp    800abf <strtol+0x9e>
		s++;
  800a6f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a72:	bf 00 00 00 00       	mov    $0x0,%edi
  800a77:	eb d1                	jmp    800a4a <strtol+0x29>
		s++, neg = 1;
  800a79:	83 c1 01             	add    $0x1,%ecx
  800a7c:	bf 01 00 00 00       	mov    $0x1,%edi
  800a81:	eb c7                	jmp    800a4a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a83:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a87:	74 0e                	je     800a97 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a89:	85 db                	test   %ebx,%ebx
  800a8b:	75 d8                	jne    800a65 <strtol+0x44>
		s++, base = 8;
  800a8d:	83 c1 01             	add    $0x1,%ecx
  800a90:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a95:	eb ce                	jmp    800a65 <strtol+0x44>
		s += 2, base = 16;
  800a97:	83 c1 02             	add    $0x2,%ecx
  800a9a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a9f:	eb c4                	jmp    800a65 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aa1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aa4:	89 f3                	mov    %esi,%ebx
  800aa6:	80 fb 19             	cmp    $0x19,%bl
  800aa9:	77 29                	ja     800ad4 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aab:	0f be d2             	movsbl %dl,%edx
  800aae:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ab1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ab4:	7d 30                	jge    800ae6 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ab6:	83 c1 01             	add    $0x1,%ecx
  800ab9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800abd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800abf:	0f b6 11             	movzbl (%ecx),%edx
  800ac2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ac5:	89 f3                	mov    %esi,%ebx
  800ac7:	80 fb 09             	cmp    $0x9,%bl
  800aca:	77 d5                	ja     800aa1 <strtol+0x80>
			dig = *s - '0';
  800acc:	0f be d2             	movsbl %dl,%edx
  800acf:	83 ea 30             	sub    $0x30,%edx
  800ad2:	eb dd                	jmp    800ab1 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ad4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ad7:	89 f3                	mov    %esi,%ebx
  800ad9:	80 fb 19             	cmp    $0x19,%bl
  800adc:	77 08                	ja     800ae6 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ade:	0f be d2             	movsbl %dl,%edx
  800ae1:	83 ea 37             	sub    $0x37,%edx
  800ae4:	eb cb                	jmp    800ab1 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ae6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aea:	74 05                	je     800af1 <strtol+0xd0>
		*endptr = (char *) s;
  800aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aef:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800af1:	89 c2                	mov    %eax,%edx
  800af3:	f7 da                	neg    %edx
  800af5:	85 ff                	test   %edi,%edi
  800af7:	0f 45 c2             	cmovne %edx,%eax
}
  800afa:	5b                   	pop    %ebx
  800afb:	5e                   	pop    %esi
  800afc:	5f                   	pop    %edi
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	57                   	push   %edi
  800b03:	56                   	push   %esi
  800b04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b05:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b10:	89 c3                	mov    %eax,%ebx
  800b12:	89 c7                	mov    %eax,%edi
  800b14:	89 c6                	mov    %eax,%esi
  800b16:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5f                   	pop    %edi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <sys_cgetc>:

int
sys_cgetc(void)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	57                   	push   %edi
  800b21:	56                   	push   %esi
  800b22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b23:	ba 00 00 00 00       	mov    $0x0,%edx
  800b28:	b8 01 00 00 00       	mov    $0x1,%eax
  800b2d:	89 d1                	mov    %edx,%ecx
  800b2f:	89 d3                	mov    %edx,%ebx
  800b31:	89 d7                	mov    %edx,%edi
  800b33:	89 d6                	mov    %edx,%esi
  800b35:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5f                   	pop    %edi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	57                   	push   %edi
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
  800b42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b45:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b52:	89 cb                	mov    %ecx,%ebx
  800b54:	89 cf                	mov    %ecx,%edi
  800b56:	89 ce                	mov    %ecx,%esi
  800b58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b5a:	85 c0                	test   %eax,%eax
  800b5c:	7f 08                	jg     800b66 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b66:	83 ec 0c             	sub    $0xc,%esp
  800b69:	50                   	push   %eax
  800b6a:	6a 03                	push   $0x3
  800b6c:	68 9f 23 80 00       	push   $0x80239f
  800b71:	6a 23                	push   $0x23
  800b73:	68 bc 23 80 00       	push   $0x8023bc
  800b78:	e8 23 11 00 00       	call   801ca0 <_panic>

00800b7d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	57                   	push   %edi
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
  800b88:	b8 02 00 00 00       	mov    $0x2,%eax
  800b8d:	89 d1                	mov    %edx,%ecx
  800b8f:	89 d3                	mov    %edx,%ebx
  800b91:	89 d7                	mov    %edx,%edi
  800b93:	89 d6                	mov    %edx,%esi
  800b95:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b97:	5b                   	pop    %ebx
  800b98:	5e                   	pop    %esi
  800b99:	5f                   	pop    %edi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <sys_yield>:

void
sys_yield(void)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	57                   	push   %edi
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bac:	89 d1                	mov    %edx,%ecx
  800bae:	89 d3                	mov    %edx,%ebx
  800bb0:	89 d7                	mov    %edx,%edi
  800bb2:	89 d6                	mov    %edx,%esi
  800bb4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5f                   	pop    %edi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
  800bc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc4:	be 00 00 00 00       	mov    $0x0,%esi
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcf:	b8 04 00 00 00       	mov    $0x4,%eax
  800bd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd7:	89 f7                	mov    %esi,%edi
  800bd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bdb:	85 c0                	test   %eax,%eax
  800bdd:	7f 08                	jg     800be7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	50                   	push   %eax
  800beb:	6a 04                	push   $0x4
  800bed:	68 9f 23 80 00       	push   $0x80239f
  800bf2:	6a 23                	push   $0x23
  800bf4:	68 bc 23 80 00       	push   $0x8023bc
  800bf9:	e8 a2 10 00 00       	call   801ca0 <_panic>

00800bfe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c15:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c18:	8b 75 18             	mov    0x18(%ebp),%esi
  800c1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	7f 08                	jg     800c29 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c29:	83 ec 0c             	sub    $0xc,%esp
  800c2c:	50                   	push   %eax
  800c2d:	6a 05                	push   $0x5
  800c2f:	68 9f 23 80 00       	push   $0x80239f
  800c34:	6a 23                	push   $0x23
  800c36:	68 bc 23 80 00       	push   $0x8023bc
  800c3b:	e8 60 10 00 00       	call   801ca0 <_panic>

00800c40 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
  800c46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c54:	b8 06 00 00 00       	mov    $0x6,%eax
  800c59:	89 df                	mov    %ebx,%edi
  800c5b:	89 de                	mov    %ebx,%esi
  800c5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5f:	85 c0                	test   %eax,%eax
  800c61:	7f 08                	jg     800c6b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6b:	83 ec 0c             	sub    $0xc,%esp
  800c6e:	50                   	push   %eax
  800c6f:	6a 06                	push   $0x6
  800c71:	68 9f 23 80 00       	push   $0x80239f
  800c76:	6a 23                	push   $0x23
  800c78:	68 bc 23 80 00       	push   $0x8023bc
  800c7d:	e8 1e 10 00 00       	call   801ca0 <_panic>

00800c82 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	b8 08 00 00 00       	mov    $0x8,%eax
  800c9b:	89 df                	mov    %ebx,%edi
  800c9d:	89 de                	mov    %ebx,%esi
  800c9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	7f 08                	jg     800cad <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	83 ec 0c             	sub    $0xc,%esp
  800cb0:	50                   	push   %eax
  800cb1:	6a 08                	push   $0x8
  800cb3:	68 9f 23 80 00       	push   $0x80239f
  800cb8:	6a 23                	push   $0x23
  800cba:	68 bc 23 80 00       	push   $0x8023bc
  800cbf:	e8 dc 0f 00 00       	call   801ca0 <_panic>

00800cc4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
  800cca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	b8 09 00 00 00       	mov    $0x9,%eax
  800cdd:	89 df                	mov    %ebx,%edi
  800cdf:	89 de                	mov    %ebx,%esi
  800ce1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7f 08                	jg     800cef <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	50                   	push   %eax
  800cf3:	6a 09                	push   $0x9
  800cf5:	68 9f 23 80 00       	push   $0x80239f
  800cfa:	6a 23                	push   $0x23
  800cfc:	68 bc 23 80 00       	push   $0x8023bc
  800d01:	e8 9a 0f 00 00       	call   801ca0 <_panic>

00800d06 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d1f:	89 df                	mov    %ebx,%edi
  800d21:	89 de                	mov    %ebx,%esi
  800d23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	7f 08                	jg     800d31 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	50                   	push   %eax
  800d35:	6a 0a                	push   $0xa
  800d37:	68 9f 23 80 00       	push   $0x80239f
  800d3c:	6a 23                	push   $0x23
  800d3e:	68 bc 23 80 00       	push   $0x8023bc
  800d43:	e8 58 0f 00 00       	call   801ca0 <_panic>

00800d48 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d54:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d59:	be 00 00 00 00       	mov    $0x0,%esi
  800d5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d61:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d64:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d81:	89 cb                	mov    %ecx,%ebx
  800d83:	89 cf                	mov    %ecx,%edi
  800d85:	89 ce                	mov    %ecx,%esi
  800d87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	7f 08                	jg     800d95 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d95:	83 ec 0c             	sub    $0xc,%esp
  800d98:	50                   	push   %eax
  800d99:	6a 0d                	push   $0xd
  800d9b:	68 9f 23 80 00       	push   $0x80239f
  800da0:	6a 23                	push   $0x23
  800da2:	68 bc 23 80 00       	push   $0x8023bc
  800da7:	e8 f4 0e 00 00       	call   801ca0 <_panic>

00800dac <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800db2:	68 ca 23 80 00       	push   $0x8023ca
  800db7:	6a 25                	push   $0x25
  800db9:	68 e2 23 80 00       	push   $0x8023e2
  800dbe:	e8 dd 0e 00 00       	call   801ca0 <_panic>

00800dc3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800dcc:	68 ac 0d 80 00       	push   $0x800dac
  800dd1:	e8 10 0f 00 00       	call   801ce6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800dd6:	b8 07 00 00 00       	mov    $0x7,%eax
  800ddb:	cd 30                	int    $0x30
  800ddd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800de0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800de3:	83 c4 10             	add    $0x10,%esp
  800de6:	85 c0                	test   %eax,%eax
  800de8:	78 27                	js     800e11 <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800dea:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800def:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df3:	75 65                	jne    800e5a <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800df5:	e8 83 fd ff ff       	call   800b7d <sys_getenvid>
  800dfa:	25 ff 03 00 00       	and    $0x3ff,%eax
  800dff:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800e02:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e07:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800e0c:	e9 11 01 00 00       	jmp    800f22 <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800e11:	50                   	push   %eax
  800e12:	68 ed 23 80 00       	push   $0x8023ed
  800e17:	6a 6f                	push   $0x6f
  800e19:	68 e2 23 80 00       	push   $0x8023e2
  800e1e:	e8 7d 0e 00 00       	call   801ca0 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800e23:	e8 55 fd ff ff       	call   800b7d <sys_getenvid>
  800e28:	83 ec 0c             	sub    $0xc,%esp
  800e2b:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800e31:	56                   	push   %esi
  800e32:	57                   	push   %edi
  800e33:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e36:	57                   	push   %edi
  800e37:	50                   	push   %eax
  800e38:	e8 c1 fd ff ff       	call   800bfe <sys_page_map>
  800e3d:	83 c4 20             	add    $0x20,%esp
  800e40:	85 c0                	test   %eax,%eax
  800e42:	0f 88 84 00 00 00    	js     800ecc <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800e48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800e4e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800e54:	0f 84 84 00 00 00    	je     800ede <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800e5a:	89 d8                	mov    %ebx,%eax
  800e5c:	c1 e8 16             	shr    $0x16,%eax
  800e5f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e66:	a8 01                	test   $0x1,%al
  800e68:	74 de                	je     800e48 <fork+0x85>
  800e6a:	89 d8                	mov    %ebx,%eax
  800e6c:	c1 e8 0c             	shr    $0xc,%eax
  800e6f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e76:	f6 c2 01             	test   $0x1,%dl
  800e79:	74 cd                	je     800e48 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800e7b:	89 c7                	mov    %eax,%edi
  800e7d:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800e80:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800e87:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800e8d:	75 94                	jne    800e23 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800e8f:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800e95:	0f 85 d1 00 00 00    	jne    800f6c <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800e9b:	a1 04 40 80 00       	mov    0x804004,%eax
  800ea0:	8b 40 48             	mov    0x48(%eax),%eax
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	6a 05                	push   $0x5
  800ea8:	57                   	push   %edi
  800ea9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eac:	57                   	push   %edi
  800ead:	50                   	push   %eax
  800eae:	e8 4b fd ff ff       	call   800bfe <sys_page_map>
  800eb3:	83 c4 20             	add    $0x20,%esp
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	79 8e                	jns    800e48 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800eba:	50                   	push   %eax
  800ebb:	68 44 24 80 00       	push   $0x802444
  800ec0:	6a 4a                	push   $0x4a
  800ec2:	68 e2 23 80 00       	push   $0x8023e2
  800ec7:	e8 d4 0d 00 00       	call   801ca0 <_panic>
                        panic("duppage: page mapping failed %e", r);
  800ecc:	50                   	push   %eax
  800ecd:	68 24 24 80 00       	push   $0x802424
  800ed2:	6a 41                	push   $0x41
  800ed4:	68 e2 23 80 00       	push   $0x8023e2
  800ed9:	e8 c2 0d 00 00       	call   801ca0 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800ede:	83 ec 04             	sub    $0x4,%esp
  800ee1:	6a 07                	push   $0x7
  800ee3:	68 00 f0 bf ee       	push   $0xeebff000
  800ee8:	ff 75 e0             	pushl  -0x20(%ebp)
  800eeb:	e8 cb fc ff ff       	call   800bbb <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  800ef0:	83 c4 10             	add    $0x10,%esp
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	78 36                	js     800f2d <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	68 5a 1d 80 00       	push   $0x801d5a
  800eff:	ff 75 e0             	pushl  -0x20(%ebp)
  800f02:	e8 ff fd ff ff       	call   800d06 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	78 34                	js     800f42 <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	6a 02                	push   $0x2
  800f13:	ff 75 e0             	pushl  -0x20(%ebp)
  800f16:	e8 67 fd ff ff       	call   800c82 <sys_env_set_status>
  800f1b:	83 c4 10             	add    $0x10,%esp
  800f1e:	85 c0                	test   %eax,%eax
  800f20:	78 35                	js     800f57 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  800f22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  800f2d:	50                   	push   %eax
  800f2e:	68 ed 23 80 00       	push   $0x8023ed
  800f33:	68 82 00 00 00       	push   $0x82
  800f38:	68 e2 23 80 00       	push   $0x8023e2
  800f3d:	e8 5e 0d 00 00       	call   801ca0 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f42:	50                   	push   %eax
  800f43:	68 68 24 80 00       	push   $0x802468
  800f48:	68 87 00 00 00       	push   $0x87
  800f4d:	68 e2 23 80 00       	push   $0x8023e2
  800f52:	e8 49 0d 00 00       	call   801ca0 <_panic>
        	panic("sys_env_set_status: %e", r);
  800f57:	50                   	push   %eax
  800f58:	68 f6 23 80 00       	push   $0x8023f6
  800f5d:	68 8b 00 00 00       	push   $0x8b
  800f62:	68 e2 23 80 00       	push   $0x8023e2
  800f67:	e8 34 0d 00 00       	call   801ca0 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800f6c:	a1 04 40 80 00       	mov    0x804004,%eax
  800f71:	8b 40 48             	mov    0x48(%eax),%eax
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	68 05 08 00 00       	push   $0x805
  800f7c:	57                   	push   %edi
  800f7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f80:	57                   	push   %edi
  800f81:	50                   	push   %eax
  800f82:	e8 77 fc ff ff       	call   800bfe <sys_page_map>
  800f87:	83 c4 20             	add    $0x20,%esp
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	0f 88 28 ff ff ff    	js     800eba <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  800f92:	a1 04 40 80 00       	mov    0x804004,%eax
  800f97:	8b 50 48             	mov    0x48(%eax),%edx
  800f9a:	8b 40 48             	mov    0x48(%eax),%eax
  800f9d:	83 ec 0c             	sub    $0xc,%esp
  800fa0:	68 05 08 00 00       	push   $0x805
  800fa5:	57                   	push   %edi
  800fa6:	52                   	push   %edx
  800fa7:	57                   	push   %edi
  800fa8:	50                   	push   %eax
  800fa9:	e8 50 fc ff ff       	call   800bfe <sys_page_map>
  800fae:	83 c4 20             	add    $0x20,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	0f 89 8f fe ff ff    	jns    800e48 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  800fb9:	50                   	push   %eax
  800fba:	68 44 24 80 00       	push   $0x802444
  800fbf:	6a 4f                	push   $0x4f
  800fc1:	68 e2 23 80 00       	push   $0x8023e2
  800fc6:	e8 d5 0c 00 00       	call   801ca0 <_panic>

00800fcb <sfork>:

// Challenge!
int
sfork(void)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800fd1:	68 0d 24 80 00       	push   $0x80240d
  800fd6:	68 94 00 00 00       	push   $0x94
  800fdb:	68 e2 23 80 00       	push   $0x8023e2
  800fe0:	e8 bb 0c 00 00       	call   801ca0 <_panic>

00800fe5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	05 00 00 00 30       	add    $0x30000000,%eax
  800ff0:	c1 e8 0c             	shr    $0xc,%eax
}
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801000:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801005:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801012:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801017:	89 c2                	mov    %eax,%edx
  801019:	c1 ea 16             	shr    $0x16,%edx
  80101c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801023:	f6 c2 01             	test   $0x1,%dl
  801026:	74 2a                	je     801052 <fd_alloc+0x46>
  801028:	89 c2                	mov    %eax,%edx
  80102a:	c1 ea 0c             	shr    $0xc,%edx
  80102d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801034:	f6 c2 01             	test   $0x1,%dl
  801037:	74 19                	je     801052 <fd_alloc+0x46>
  801039:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80103e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801043:	75 d2                	jne    801017 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801045:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80104b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801050:	eb 07                	jmp    801059 <fd_alloc+0x4d>
			*fd_store = fd;
  801052:	89 01                	mov    %eax,(%ecx)
			return 0;
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801061:	83 f8 1f             	cmp    $0x1f,%eax
  801064:	77 36                	ja     80109c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801066:	c1 e0 0c             	shl    $0xc,%eax
  801069:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80106e:	89 c2                	mov    %eax,%edx
  801070:	c1 ea 16             	shr    $0x16,%edx
  801073:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80107a:	f6 c2 01             	test   $0x1,%dl
  80107d:	74 24                	je     8010a3 <fd_lookup+0x48>
  80107f:	89 c2                	mov    %eax,%edx
  801081:	c1 ea 0c             	shr    $0xc,%edx
  801084:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80108b:	f6 c2 01             	test   $0x1,%dl
  80108e:	74 1a                	je     8010aa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801090:	8b 55 0c             	mov    0xc(%ebp),%edx
  801093:	89 02                	mov    %eax,(%edx)
	return 0;
  801095:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    
		return -E_INVAL;
  80109c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a1:	eb f7                	jmp    80109a <fd_lookup+0x3f>
		return -E_INVAL;
  8010a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a8:	eb f0                	jmp    80109a <fd_lookup+0x3f>
  8010aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010af:	eb e9                	jmp    80109a <fd_lookup+0x3f>

008010b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 08             	sub    $0x8,%esp
  8010b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ba:	ba 08 25 80 00       	mov    $0x802508,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8010bf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010c4:	39 08                	cmp    %ecx,(%eax)
  8010c6:	74 33                	je     8010fb <dev_lookup+0x4a>
  8010c8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010cb:	8b 02                	mov    (%edx),%eax
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	75 f3                	jne    8010c4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8010d6:	8b 40 48             	mov    0x48(%eax),%eax
  8010d9:	83 ec 04             	sub    $0x4,%esp
  8010dc:	51                   	push   %ecx
  8010dd:	50                   	push   %eax
  8010de:	68 8c 24 80 00       	push   $0x80248c
  8010e3:	e8 f0 f0 ff ff       	call   8001d8 <cprintf>
	*dev = 0;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010f1:	83 c4 10             	add    $0x10,%esp
  8010f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    
			*dev = devtab[i];
  8010fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	eb f2                	jmp    8010f9 <dev_lookup+0x48>

00801107 <fd_close>:
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
  80110d:	83 ec 1c             	sub    $0x1c,%esp
  801110:	8b 75 08             	mov    0x8(%ebp),%esi
  801113:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801116:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801119:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801120:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801123:	50                   	push   %eax
  801124:	e8 32 ff ff ff       	call   80105b <fd_lookup>
  801129:	89 c3                	mov    %eax,%ebx
  80112b:	83 c4 08             	add    $0x8,%esp
  80112e:	85 c0                	test   %eax,%eax
  801130:	78 05                	js     801137 <fd_close+0x30>
	    || fd != fd2)
  801132:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801135:	74 16                	je     80114d <fd_close+0x46>
		return (must_exist ? r : 0);
  801137:	89 f8                	mov    %edi,%eax
  801139:	84 c0                	test   %al,%al
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
  801140:	0f 44 d8             	cmove  %eax,%ebx
}
  801143:	89 d8                	mov    %ebx,%eax
  801145:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801148:	5b                   	pop    %ebx
  801149:	5e                   	pop    %esi
  80114a:	5f                   	pop    %edi
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801153:	50                   	push   %eax
  801154:	ff 36                	pushl  (%esi)
  801156:	e8 56 ff ff ff       	call   8010b1 <dev_lookup>
  80115b:	89 c3                	mov    %eax,%ebx
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	78 15                	js     801179 <fd_close+0x72>
		if (dev->dev_close)
  801164:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801167:	8b 40 10             	mov    0x10(%eax),%eax
  80116a:	85 c0                	test   %eax,%eax
  80116c:	74 1b                	je     801189 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	56                   	push   %esi
  801172:	ff d0                	call   *%eax
  801174:	89 c3                	mov    %eax,%ebx
  801176:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	56                   	push   %esi
  80117d:	6a 00                	push   $0x0
  80117f:	e8 bc fa ff ff       	call   800c40 <sys_page_unmap>
	return r;
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	eb ba                	jmp    801143 <fd_close+0x3c>
			r = 0;
  801189:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118e:	eb e9                	jmp    801179 <fd_close+0x72>

00801190 <close>:

int
close(int fdnum)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801196:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801199:	50                   	push   %eax
  80119a:	ff 75 08             	pushl  0x8(%ebp)
  80119d:	e8 b9 fe ff ff       	call   80105b <fd_lookup>
  8011a2:	83 c4 08             	add    $0x8,%esp
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	78 10                	js     8011b9 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	6a 01                	push   $0x1
  8011ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b1:	e8 51 ff ff ff       	call   801107 <fd_close>
  8011b6:	83 c4 10             	add    $0x10,%esp
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <close_all>:

void
close_all(void)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011c2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	53                   	push   %ebx
  8011cb:	e8 c0 ff ff ff       	call   801190 <close>
	for (i = 0; i < MAXFD; i++)
  8011d0:	83 c3 01             	add    $0x1,%ebx
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	83 fb 20             	cmp    $0x20,%ebx
  8011d9:	75 ec                	jne    8011c7 <close_all+0xc>
}
  8011db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	57                   	push   %edi
  8011e4:	56                   	push   %esi
  8011e5:	53                   	push   %ebx
  8011e6:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011ec:	50                   	push   %eax
  8011ed:	ff 75 08             	pushl  0x8(%ebp)
  8011f0:	e8 66 fe ff ff       	call   80105b <fd_lookup>
  8011f5:	89 c3                	mov    %eax,%ebx
  8011f7:	83 c4 08             	add    $0x8,%esp
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	0f 88 81 00 00 00    	js     801283 <dup+0xa3>
		return r;
	close(newfdnum);
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	e8 83 ff ff ff       	call   801190 <close>

	newfd = INDEX2FD(newfdnum);
  80120d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801210:	c1 e6 0c             	shl    $0xc,%esi
  801213:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801219:	83 c4 04             	add    $0x4,%esp
  80121c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80121f:	e8 d1 fd ff ff       	call   800ff5 <fd2data>
  801224:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801226:	89 34 24             	mov    %esi,(%esp)
  801229:	e8 c7 fd ff ff       	call   800ff5 <fd2data>
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801233:	89 d8                	mov    %ebx,%eax
  801235:	c1 e8 16             	shr    $0x16,%eax
  801238:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80123f:	a8 01                	test   $0x1,%al
  801241:	74 11                	je     801254 <dup+0x74>
  801243:	89 d8                	mov    %ebx,%eax
  801245:	c1 e8 0c             	shr    $0xc,%eax
  801248:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80124f:	f6 c2 01             	test   $0x1,%dl
  801252:	75 39                	jne    80128d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801254:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801257:	89 d0                	mov    %edx,%eax
  801259:	c1 e8 0c             	shr    $0xc,%eax
  80125c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801263:	83 ec 0c             	sub    $0xc,%esp
  801266:	25 07 0e 00 00       	and    $0xe07,%eax
  80126b:	50                   	push   %eax
  80126c:	56                   	push   %esi
  80126d:	6a 00                	push   $0x0
  80126f:	52                   	push   %edx
  801270:	6a 00                	push   $0x0
  801272:	e8 87 f9 ff ff       	call   800bfe <sys_page_map>
  801277:	89 c3                	mov    %eax,%ebx
  801279:	83 c4 20             	add    $0x20,%esp
  80127c:	85 c0                	test   %eax,%eax
  80127e:	78 31                	js     8012b1 <dup+0xd1>
		goto err;

	return newfdnum;
  801280:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801283:	89 d8                	mov    %ebx,%eax
  801285:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5f                   	pop    %edi
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80128d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801294:	83 ec 0c             	sub    $0xc,%esp
  801297:	25 07 0e 00 00       	and    $0xe07,%eax
  80129c:	50                   	push   %eax
  80129d:	57                   	push   %edi
  80129e:	6a 00                	push   $0x0
  8012a0:	53                   	push   %ebx
  8012a1:	6a 00                	push   $0x0
  8012a3:	e8 56 f9 ff ff       	call   800bfe <sys_page_map>
  8012a8:	89 c3                	mov    %eax,%ebx
  8012aa:	83 c4 20             	add    $0x20,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	79 a3                	jns    801254 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012b1:	83 ec 08             	sub    $0x8,%esp
  8012b4:	56                   	push   %esi
  8012b5:	6a 00                	push   $0x0
  8012b7:	e8 84 f9 ff ff       	call   800c40 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012bc:	83 c4 08             	add    $0x8,%esp
  8012bf:	57                   	push   %edi
  8012c0:	6a 00                	push   $0x0
  8012c2:	e8 79 f9 ff ff       	call   800c40 <sys_page_unmap>
	return r;
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	eb b7                	jmp    801283 <dup+0xa3>

008012cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	53                   	push   %ebx
  8012d0:	83 ec 14             	sub    $0x14,%esp
  8012d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d9:	50                   	push   %eax
  8012da:	53                   	push   %ebx
  8012db:	e8 7b fd ff ff       	call   80105b <fd_lookup>
  8012e0:	83 c4 08             	add    $0x8,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	78 3f                	js     801326 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e7:	83 ec 08             	sub    $0x8,%esp
  8012ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ed:	50                   	push   %eax
  8012ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f1:	ff 30                	pushl  (%eax)
  8012f3:	e8 b9 fd ff ff       	call   8010b1 <dev_lookup>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 27                	js     801326 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801302:	8b 42 08             	mov    0x8(%edx),%eax
  801305:	83 e0 03             	and    $0x3,%eax
  801308:	83 f8 01             	cmp    $0x1,%eax
  80130b:	74 1e                	je     80132b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	8b 40 08             	mov    0x8(%eax),%eax
  801313:	85 c0                	test   %eax,%eax
  801315:	74 35                	je     80134c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801317:	83 ec 04             	sub    $0x4,%esp
  80131a:	ff 75 10             	pushl  0x10(%ebp)
  80131d:	ff 75 0c             	pushl  0xc(%ebp)
  801320:	52                   	push   %edx
  801321:	ff d0                	call   *%eax
  801323:	83 c4 10             	add    $0x10,%esp
}
  801326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801329:	c9                   	leave  
  80132a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80132b:	a1 04 40 80 00       	mov    0x804004,%eax
  801330:	8b 40 48             	mov    0x48(%eax),%eax
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	53                   	push   %ebx
  801337:	50                   	push   %eax
  801338:	68 cd 24 80 00       	push   $0x8024cd
  80133d:	e8 96 ee ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134a:	eb da                	jmp    801326 <read+0x5a>
		return -E_NOT_SUPP;
  80134c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801351:	eb d3                	jmp    801326 <read+0x5a>

00801353 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	57                   	push   %edi
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
  801359:	83 ec 0c             	sub    $0xc,%esp
  80135c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80135f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801362:	bb 00 00 00 00       	mov    $0x0,%ebx
  801367:	39 f3                	cmp    %esi,%ebx
  801369:	73 25                	jae    801390 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80136b:	83 ec 04             	sub    $0x4,%esp
  80136e:	89 f0                	mov    %esi,%eax
  801370:	29 d8                	sub    %ebx,%eax
  801372:	50                   	push   %eax
  801373:	89 d8                	mov    %ebx,%eax
  801375:	03 45 0c             	add    0xc(%ebp),%eax
  801378:	50                   	push   %eax
  801379:	57                   	push   %edi
  80137a:	e8 4d ff ff ff       	call   8012cc <read>
		if (m < 0)
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	78 08                	js     80138e <readn+0x3b>
			return m;
		if (m == 0)
  801386:	85 c0                	test   %eax,%eax
  801388:	74 06                	je     801390 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80138a:	01 c3                	add    %eax,%ebx
  80138c:	eb d9                	jmp    801367 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80138e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801390:	89 d8                	mov    %ebx,%eax
  801392:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801395:	5b                   	pop    %ebx
  801396:	5e                   	pop    %esi
  801397:	5f                   	pop    %edi
  801398:	5d                   	pop    %ebp
  801399:	c3                   	ret    

0080139a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	53                   	push   %ebx
  80139e:	83 ec 14             	sub    $0x14,%esp
  8013a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a7:	50                   	push   %eax
  8013a8:	53                   	push   %ebx
  8013a9:	e8 ad fc ff ff       	call   80105b <fd_lookup>
  8013ae:	83 c4 08             	add    $0x8,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 3a                	js     8013ef <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b5:	83 ec 08             	sub    $0x8,%esp
  8013b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013bb:	50                   	push   %eax
  8013bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bf:	ff 30                	pushl  (%eax)
  8013c1:	e8 eb fc ff ff       	call   8010b1 <dev_lookup>
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 22                	js     8013ef <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d4:	74 1e                	je     8013f4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d9:	8b 52 0c             	mov    0xc(%edx),%edx
  8013dc:	85 d2                	test   %edx,%edx
  8013de:	74 35                	je     801415 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013e0:	83 ec 04             	sub    $0x4,%esp
  8013e3:	ff 75 10             	pushl  0x10(%ebp)
  8013e6:	ff 75 0c             	pushl  0xc(%ebp)
  8013e9:	50                   	push   %eax
  8013ea:	ff d2                	call   *%edx
  8013ec:	83 c4 10             	add    $0x10,%esp
}
  8013ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f4:	a1 04 40 80 00       	mov    0x804004,%eax
  8013f9:	8b 40 48             	mov    0x48(%eax),%eax
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	53                   	push   %ebx
  801400:	50                   	push   %eax
  801401:	68 e9 24 80 00       	push   $0x8024e9
  801406:	e8 cd ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801413:	eb da                	jmp    8013ef <write+0x55>
		return -E_NOT_SUPP;
  801415:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141a:	eb d3                	jmp    8013ef <write+0x55>

0080141c <seek>:

int
seek(int fdnum, off_t offset)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801422:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	ff 75 08             	pushl  0x8(%ebp)
  801429:	e8 2d fc ff ff       	call   80105b <fd_lookup>
  80142e:	83 c4 08             	add    $0x8,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 0e                	js     801443 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80143e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	53                   	push   %ebx
  801449:	83 ec 14             	sub    $0x14,%esp
  80144c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80144f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801452:	50                   	push   %eax
  801453:	53                   	push   %ebx
  801454:	e8 02 fc ff ff       	call   80105b <fd_lookup>
  801459:	83 c4 08             	add    $0x8,%esp
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 37                	js     801497 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146a:	ff 30                	pushl  (%eax)
  80146c:	e8 40 fc ff ff       	call   8010b1 <dev_lookup>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 1f                	js     801497 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80147f:	74 1b                	je     80149c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801484:	8b 52 18             	mov    0x18(%edx),%edx
  801487:	85 d2                	test   %edx,%edx
  801489:	74 32                	je     8014bd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80148b:	83 ec 08             	sub    $0x8,%esp
  80148e:	ff 75 0c             	pushl  0xc(%ebp)
  801491:	50                   	push   %eax
  801492:	ff d2                	call   *%edx
  801494:	83 c4 10             	add    $0x10,%esp
}
  801497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80149c:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014a1:	8b 40 48             	mov    0x48(%eax),%eax
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	53                   	push   %ebx
  8014a8:	50                   	push   %eax
  8014a9:	68 ac 24 80 00       	push   $0x8024ac
  8014ae:	e8 25 ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  8014b3:	83 c4 10             	add    $0x10,%esp
  8014b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bb:	eb da                	jmp    801497 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c2:	eb d3                	jmp    801497 <ftruncate+0x52>

008014c4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	53                   	push   %ebx
  8014c8:	83 ec 14             	sub    $0x14,%esp
  8014cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d1:	50                   	push   %eax
  8014d2:	ff 75 08             	pushl  0x8(%ebp)
  8014d5:	e8 81 fb ff ff       	call   80105b <fd_lookup>
  8014da:	83 c4 08             	add    $0x8,%esp
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	78 4b                	js     80152c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e1:	83 ec 08             	sub    $0x8,%esp
  8014e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e7:	50                   	push   %eax
  8014e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014eb:	ff 30                	pushl  (%eax)
  8014ed:	e8 bf fb ff ff       	call   8010b1 <dev_lookup>
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 33                	js     80152c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801500:	74 2f                	je     801531 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801502:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801505:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80150c:	00 00 00 
	stat->st_isdir = 0;
  80150f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801516:	00 00 00 
	stat->st_dev = dev;
  801519:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	53                   	push   %ebx
  801523:	ff 75 f0             	pushl  -0x10(%ebp)
  801526:	ff 50 14             	call   *0x14(%eax)
  801529:	83 c4 10             	add    $0x10,%esp
}
  80152c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152f:	c9                   	leave  
  801530:	c3                   	ret    
		return -E_NOT_SUPP;
  801531:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801536:	eb f4                	jmp    80152c <fstat+0x68>

00801538 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	6a 00                	push   $0x0
  801542:	ff 75 08             	pushl  0x8(%ebp)
  801545:	e8 e7 01 00 00       	call   801731 <open>
  80154a:	89 c3                	mov    %eax,%ebx
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 1b                	js     80156e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	50                   	push   %eax
  80155a:	e8 65 ff ff ff       	call   8014c4 <fstat>
  80155f:	89 c6                	mov    %eax,%esi
	close(fd);
  801561:	89 1c 24             	mov    %ebx,(%esp)
  801564:	e8 27 fc ff ff       	call   801190 <close>
	return r;
  801569:	83 c4 10             	add    $0x10,%esp
  80156c:	89 f3                	mov    %esi,%ebx
}
  80156e:	89 d8                	mov    %ebx,%eax
  801570:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	56                   	push   %esi
  80157b:	53                   	push   %ebx
  80157c:	89 c6                	mov    %eax,%esi
  80157e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801580:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801587:	74 27                	je     8015b0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801589:	6a 07                	push   $0x7
  80158b:	68 00 50 80 00       	push   $0x805000
  801590:	56                   	push   %esi
  801591:	ff 35 00 40 80 00    	pushl  0x804000
  801597:	e8 fc 07 00 00       	call   801d98 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80159c:	83 c4 0c             	add    $0xc,%esp
  80159f:	6a 00                	push   $0x0
  8015a1:	53                   	push   %ebx
  8015a2:	6a 00                	push   $0x0
  8015a4:	e8 d8 07 00 00       	call   801d81 <ipc_recv>
}
  8015a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ac:	5b                   	pop    %ebx
  8015ad:	5e                   	pop    %esi
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	6a 01                	push   $0x1
  8015b5:	e8 f5 07 00 00       	call   801daf <ipc_find_env>
  8015ba:	a3 00 40 80 00       	mov    %eax,0x804000
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	eb c5                	jmp    801589 <fsipc+0x12>

008015c4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e2:	b8 02 00 00 00       	mov    $0x2,%eax
  8015e7:	e8 8b ff ff ff       	call   801577 <fsipc>
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <devfile_flush>:
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fa:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801604:	b8 06 00 00 00       	mov    $0x6,%eax
  801609:	e8 69 ff ff ff       	call   801577 <fsipc>
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <devfile_stat>:
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	53                   	push   %ebx
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8b 40 0c             	mov    0xc(%eax),%eax
  801620:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	b8 05 00 00 00       	mov    $0x5,%eax
  80162f:	e8 43 ff ff ff       	call   801577 <fsipc>
  801634:	85 c0                	test   %eax,%eax
  801636:	78 2c                	js     801664 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801638:	83 ec 08             	sub    $0x8,%esp
  80163b:	68 00 50 80 00       	push   $0x805000
  801640:	53                   	push   %ebx
  801641:	e8 7c f1 ff ff       	call   8007c2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801646:	a1 80 50 80 00       	mov    0x805080,%eax
  80164b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801651:	a1 84 50 80 00       	mov    0x805084,%eax
  801656:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <devfile_write>:
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 0c             	sub    $0xc,%esp
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801677:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80167c:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80167f:	8b 55 08             	mov    0x8(%ebp),%edx
  801682:	8b 52 0c             	mov    0xc(%edx),%edx
  801685:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  80168b:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801690:	50                   	push   %eax
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	68 08 50 80 00       	push   $0x805008
  801699:	e8 b2 f2 ff ff       	call   800950 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80169e:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a8:	e8 ca fe ff ff       	call   801577 <fsipc>
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <devfile_read>:
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016c2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cd:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d2:	e8 a0 fe ff ff       	call   801577 <fsipc>
  8016d7:	89 c3                	mov    %eax,%ebx
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	78 1f                	js     8016fc <devfile_read+0x4d>
	assert(r <= n);
  8016dd:	39 f0                	cmp    %esi,%eax
  8016df:	77 24                	ja     801705 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e6:	7f 33                	jg     80171b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	50                   	push   %eax
  8016ec:	68 00 50 80 00       	push   $0x805000
  8016f1:	ff 75 0c             	pushl  0xc(%ebp)
  8016f4:	e8 57 f2 ff ff       	call   800950 <memmove>
	return r;
  8016f9:	83 c4 10             	add    $0x10,%esp
}
  8016fc:	89 d8                	mov    %ebx,%eax
  8016fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    
	assert(r <= n);
  801705:	68 18 25 80 00       	push   $0x802518
  80170a:	68 1f 25 80 00       	push   $0x80251f
  80170f:	6a 7c                	push   $0x7c
  801711:	68 34 25 80 00       	push   $0x802534
  801716:	e8 85 05 00 00       	call   801ca0 <_panic>
	assert(r <= PGSIZE);
  80171b:	68 3f 25 80 00       	push   $0x80253f
  801720:	68 1f 25 80 00       	push   $0x80251f
  801725:	6a 7d                	push   $0x7d
  801727:	68 34 25 80 00       	push   $0x802534
  80172c:	e8 6f 05 00 00       	call   801ca0 <_panic>

00801731 <open>:
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	56                   	push   %esi
  801735:	53                   	push   %ebx
  801736:	83 ec 1c             	sub    $0x1c,%esp
  801739:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80173c:	56                   	push   %esi
  80173d:	e8 49 f0 ff ff       	call   80078b <strlen>
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80174a:	7f 6c                	jg     8017b8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801752:	50                   	push   %eax
  801753:	e8 b4 f8 ff ff       	call   80100c <fd_alloc>
  801758:	89 c3                	mov    %eax,%ebx
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 3c                	js     80179d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	56                   	push   %esi
  801765:	68 00 50 80 00       	push   $0x805000
  80176a:	e8 53 f0 ff ff       	call   8007c2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80176f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801772:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801777:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177a:	b8 01 00 00 00       	mov    $0x1,%eax
  80177f:	e8 f3 fd ff ff       	call   801577 <fsipc>
  801784:	89 c3                	mov    %eax,%ebx
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	85 c0                	test   %eax,%eax
  80178b:	78 19                	js     8017a6 <open+0x75>
	return fd2num(fd);
  80178d:	83 ec 0c             	sub    $0xc,%esp
  801790:	ff 75 f4             	pushl  -0xc(%ebp)
  801793:	e8 4d f8 ff ff       	call   800fe5 <fd2num>
  801798:	89 c3                	mov    %eax,%ebx
  80179a:	83 c4 10             	add    $0x10,%esp
}
  80179d:	89 d8                	mov    %ebx,%eax
  80179f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a2:	5b                   	pop    %ebx
  8017a3:	5e                   	pop    %esi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    
		fd_close(fd, 0);
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	6a 00                	push   $0x0
  8017ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ae:	e8 54 f9 ff ff       	call   801107 <fd_close>
		return r;
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	eb e5                	jmp    80179d <open+0x6c>
		return -E_BAD_PATH;
  8017b8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017bd:	eb de                	jmp    80179d <open+0x6c>

008017bf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8017cf:	e8 a3 fd ff ff       	call   801577 <fsipc>
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017de:	83 ec 0c             	sub    $0xc,%esp
  8017e1:	ff 75 08             	pushl  0x8(%ebp)
  8017e4:	e8 0c f8 ff ff       	call   800ff5 <fd2data>
  8017e9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017eb:	83 c4 08             	add    $0x8,%esp
  8017ee:	68 4b 25 80 00       	push   $0x80254b
  8017f3:	53                   	push   %ebx
  8017f4:	e8 c9 ef ff ff       	call   8007c2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017f9:	8b 46 04             	mov    0x4(%esi),%eax
  8017fc:	2b 06                	sub    (%esi),%eax
  8017fe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801804:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80180b:	00 00 00 
	stat->st_dev = &devpipe;
  80180e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801815:	30 80 00 
	return 0;
}
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
  80181d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801820:	5b                   	pop    %ebx
  801821:	5e                   	pop    %esi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    

00801824 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	53                   	push   %ebx
  801828:	83 ec 0c             	sub    $0xc,%esp
  80182b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80182e:	53                   	push   %ebx
  80182f:	6a 00                	push   $0x0
  801831:	e8 0a f4 ff ff       	call   800c40 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801836:	89 1c 24             	mov    %ebx,(%esp)
  801839:	e8 b7 f7 ff ff       	call   800ff5 <fd2data>
  80183e:	83 c4 08             	add    $0x8,%esp
  801841:	50                   	push   %eax
  801842:	6a 00                	push   $0x0
  801844:	e8 f7 f3 ff ff       	call   800c40 <sys_page_unmap>
}
  801849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <_pipeisclosed>:
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	57                   	push   %edi
  801852:	56                   	push   %esi
  801853:	53                   	push   %ebx
  801854:	83 ec 1c             	sub    $0x1c,%esp
  801857:	89 c7                	mov    %eax,%edi
  801859:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80185b:	a1 04 40 80 00       	mov    0x804004,%eax
  801860:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	57                   	push   %edi
  801867:	e8 7c 05 00 00       	call   801de8 <pageref>
  80186c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80186f:	89 34 24             	mov    %esi,(%esp)
  801872:	e8 71 05 00 00       	call   801de8 <pageref>
		nn = thisenv->env_runs;
  801877:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80187d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	39 cb                	cmp    %ecx,%ebx
  801885:	74 1b                	je     8018a2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801887:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80188a:	75 cf                	jne    80185b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80188c:	8b 42 58             	mov    0x58(%edx),%eax
  80188f:	6a 01                	push   $0x1
  801891:	50                   	push   %eax
  801892:	53                   	push   %ebx
  801893:	68 52 25 80 00       	push   $0x802552
  801898:	e8 3b e9 ff ff       	call   8001d8 <cprintf>
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	eb b9                	jmp    80185b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018a2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018a5:	0f 94 c0             	sete   %al
  8018a8:	0f b6 c0             	movzbl %al,%eax
}
  8018ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ae:	5b                   	pop    %ebx
  8018af:	5e                   	pop    %esi
  8018b0:	5f                   	pop    %edi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <devpipe_write>:
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	57                   	push   %edi
  8018b7:	56                   	push   %esi
  8018b8:	53                   	push   %ebx
  8018b9:	83 ec 28             	sub    $0x28,%esp
  8018bc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018bf:	56                   	push   %esi
  8018c0:	e8 30 f7 ff ff       	call   800ff5 <fd2data>
  8018c5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8018cf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018d2:	74 4f                	je     801923 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018d4:	8b 43 04             	mov    0x4(%ebx),%eax
  8018d7:	8b 0b                	mov    (%ebx),%ecx
  8018d9:	8d 51 20             	lea    0x20(%ecx),%edx
  8018dc:	39 d0                	cmp    %edx,%eax
  8018de:	72 14                	jb     8018f4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8018e0:	89 da                	mov    %ebx,%edx
  8018e2:	89 f0                	mov    %esi,%eax
  8018e4:	e8 65 ff ff ff       	call   80184e <_pipeisclosed>
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	75 3a                	jne    801927 <devpipe_write+0x74>
			sys_yield();
  8018ed:	e8 aa f2 ff ff       	call   800b9c <sys_yield>
  8018f2:	eb e0                	jmp    8018d4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018fb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018fe:	89 c2                	mov    %eax,%edx
  801900:	c1 fa 1f             	sar    $0x1f,%edx
  801903:	89 d1                	mov    %edx,%ecx
  801905:	c1 e9 1b             	shr    $0x1b,%ecx
  801908:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80190b:	83 e2 1f             	and    $0x1f,%edx
  80190e:	29 ca                	sub    %ecx,%edx
  801910:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801914:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801918:	83 c0 01             	add    $0x1,%eax
  80191b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80191e:	83 c7 01             	add    $0x1,%edi
  801921:	eb ac                	jmp    8018cf <devpipe_write+0x1c>
	return i;
  801923:	89 f8                	mov    %edi,%eax
  801925:	eb 05                	jmp    80192c <devpipe_write+0x79>
				return 0;
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5f                   	pop    %edi
  801932:	5d                   	pop    %ebp
  801933:	c3                   	ret    

00801934 <devpipe_read>:
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	57                   	push   %edi
  801938:	56                   	push   %esi
  801939:	53                   	push   %ebx
  80193a:	83 ec 18             	sub    $0x18,%esp
  80193d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801940:	57                   	push   %edi
  801941:	e8 af f6 ff ff       	call   800ff5 <fd2data>
  801946:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	be 00 00 00 00       	mov    $0x0,%esi
  801950:	3b 75 10             	cmp    0x10(%ebp),%esi
  801953:	74 47                	je     80199c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801955:	8b 03                	mov    (%ebx),%eax
  801957:	3b 43 04             	cmp    0x4(%ebx),%eax
  80195a:	75 22                	jne    80197e <devpipe_read+0x4a>
			if (i > 0)
  80195c:	85 f6                	test   %esi,%esi
  80195e:	75 14                	jne    801974 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801960:	89 da                	mov    %ebx,%edx
  801962:	89 f8                	mov    %edi,%eax
  801964:	e8 e5 fe ff ff       	call   80184e <_pipeisclosed>
  801969:	85 c0                	test   %eax,%eax
  80196b:	75 33                	jne    8019a0 <devpipe_read+0x6c>
			sys_yield();
  80196d:	e8 2a f2 ff ff       	call   800b9c <sys_yield>
  801972:	eb e1                	jmp    801955 <devpipe_read+0x21>
				return i;
  801974:	89 f0                	mov    %esi,%eax
}
  801976:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801979:	5b                   	pop    %ebx
  80197a:	5e                   	pop    %esi
  80197b:	5f                   	pop    %edi
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80197e:	99                   	cltd   
  80197f:	c1 ea 1b             	shr    $0x1b,%edx
  801982:	01 d0                	add    %edx,%eax
  801984:	83 e0 1f             	and    $0x1f,%eax
  801987:	29 d0                	sub    %edx,%eax
  801989:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80198e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801991:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801994:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801997:	83 c6 01             	add    $0x1,%esi
  80199a:	eb b4                	jmp    801950 <devpipe_read+0x1c>
	return i;
  80199c:	89 f0                	mov    %esi,%eax
  80199e:	eb d6                	jmp    801976 <devpipe_read+0x42>
				return 0;
  8019a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a5:	eb cf                	jmp    801976 <devpipe_read+0x42>

008019a7 <pipe>:
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	56                   	push   %esi
  8019ab:	53                   	push   %ebx
  8019ac:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b2:	50                   	push   %eax
  8019b3:	e8 54 f6 ff ff       	call   80100c <fd_alloc>
  8019b8:	89 c3                	mov    %eax,%ebx
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	78 5b                	js     801a1c <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	68 07 04 00 00       	push   $0x407
  8019c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cc:	6a 00                	push   $0x0
  8019ce:	e8 e8 f1 ff ff       	call   800bbb <sys_page_alloc>
  8019d3:	89 c3                	mov    %eax,%ebx
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 40                	js     801a1c <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e2:	50                   	push   %eax
  8019e3:	e8 24 f6 ff ff       	call   80100c <fd_alloc>
  8019e8:	89 c3                	mov    %eax,%ebx
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 1b                	js     801a0c <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	68 07 04 00 00       	push   $0x407
  8019f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019fc:	6a 00                	push   $0x0
  8019fe:	e8 b8 f1 ff ff       	call   800bbb <sys_page_alloc>
  801a03:	89 c3                	mov    %eax,%ebx
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	79 19                	jns    801a25 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801a0c:	83 ec 08             	sub    $0x8,%esp
  801a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a12:	6a 00                	push   $0x0
  801a14:	e8 27 f2 ff ff       	call   800c40 <sys_page_unmap>
  801a19:	83 c4 10             	add    $0x10,%esp
}
  801a1c:	89 d8                	mov    %ebx,%eax
  801a1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a21:	5b                   	pop    %ebx
  801a22:	5e                   	pop    %esi
  801a23:	5d                   	pop    %ebp
  801a24:	c3                   	ret    
	va = fd2data(fd0);
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2b:	e8 c5 f5 ff ff       	call   800ff5 <fd2data>
  801a30:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a32:	83 c4 0c             	add    $0xc,%esp
  801a35:	68 07 04 00 00       	push   $0x407
  801a3a:	50                   	push   %eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	e8 79 f1 ff ff       	call   800bbb <sys_page_alloc>
  801a42:	89 c3                	mov    %eax,%ebx
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	85 c0                	test   %eax,%eax
  801a49:	0f 88 8c 00 00 00    	js     801adb <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 f0             	pushl  -0x10(%ebp)
  801a55:	e8 9b f5 ff ff       	call   800ff5 <fd2data>
  801a5a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a61:	50                   	push   %eax
  801a62:	6a 00                	push   $0x0
  801a64:	56                   	push   %esi
  801a65:	6a 00                	push   $0x0
  801a67:	e8 92 f1 ff ff       	call   800bfe <sys_page_map>
  801a6c:	89 c3                	mov    %eax,%ebx
  801a6e:	83 c4 20             	add    $0x20,%esp
  801a71:	85 c0                	test   %eax,%eax
  801a73:	78 58                	js     801acd <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a78:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a7e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a93:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a98:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa5:	e8 3b f5 ff ff       	call   800fe5 <fd2num>
  801aaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aad:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801aaf:	83 c4 04             	add    $0x4,%esp
  801ab2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab5:	e8 2b f5 ff ff       	call   800fe5 <fd2num>
  801aba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ac8:	e9 4f ff ff ff       	jmp    801a1c <pipe+0x75>
	sys_page_unmap(0, va);
  801acd:	83 ec 08             	sub    $0x8,%esp
  801ad0:	56                   	push   %esi
  801ad1:	6a 00                	push   $0x0
  801ad3:	e8 68 f1 ff ff       	call   800c40 <sys_page_unmap>
  801ad8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae1:	6a 00                	push   $0x0
  801ae3:	e8 58 f1 ff ff       	call   800c40 <sys_page_unmap>
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	e9 1c ff ff ff       	jmp    801a0c <pipe+0x65>

00801af0 <pipeisclosed>:
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af9:	50                   	push   %eax
  801afa:	ff 75 08             	pushl  0x8(%ebp)
  801afd:	e8 59 f5 ff ff       	call   80105b <fd_lookup>
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 18                	js     801b21 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b09:	83 ec 0c             	sub    $0xc,%esp
  801b0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b0f:	e8 e1 f4 ff ff       	call   800ff5 <fd2data>
	return _pipeisclosed(fd, p);
  801b14:	89 c2                	mov    %eax,%edx
  801b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b19:	e8 30 fd ff ff       	call   80184e <_pipeisclosed>
  801b1e:	83 c4 10             	add    $0x10,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b26:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2b:	5d                   	pop    %ebp
  801b2c:	c3                   	ret    

00801b2d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b33:	68 6a 25 80 00       	push   $0x80256a
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	e8 82 ec ff ff       	call   8007c2 <strcpy>
	return 0;
}
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <devcons_write>:
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	57                   	push   %edi
  801b4b:	56                   	push   %esi
  801b4c:	53                   	push   %ebx
  801b4d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b53:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b58:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b5e:	eb 2f                	jmp    801b8f <devcons_write+0x48>
		m = n - tot;
  801b60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b63:	29 f3                	sub    %esi,%ebx
  801b65:	83 fb 7f             	cmp    $0x7f,%ebx
  801b68:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b6d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	53                   	push   %ebx
  801b74:	89 f0                	mov    %esi,%eax
  801b76:	03 45 0c             	add    0xc(%ebp),%eax
  801b79:	50                   	push   %eax
  801b7a:	57                   	push   %edi
  801b7b:	e8 d0 ed ff ff       	call   800950 <memmove>
		sys_cputs(buf, m);
  801b80:	83 c4 08             	add    $0x8,%esp
  801b83:	53                   	push   %ebx
  801b84:	57                   	push   %edi
  801b85:	e8 75 ef ff ff       	call   800aff <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b8a:	01 de                	add    %ebx,%esi
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b92:	72 cc                	jb     801b60 <devcons_write+0x19>
}
  801b94:	89 f0                	mov    %esi,%eax
  801b96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5f                   	pop    %edi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    

00801b9e <devcons_read>:
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 08             	sub    $0x8,%esp
  801ba4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ba9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bad:	75 07                	jne    801bb6 <devcons_read+0x18>
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    
		sys_yield();
  801bb1:	e8 e6 ef ff ff       	call   800b9c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801bb6:	e8 62 ef ff ff       	call   800b1d <sys_cgetc>
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	74 f2                	je     801bb1 <devcons_read+0x13>
	if (c < 0)
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	78 ec                	js     801baf <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801bc3:	83 f8 04             	cmp    $0x4,%eax
  801bc6:	74 0c                	je     801bd4 <devcons_read+0x36>
	*(char*)vbuf = c;
  801bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcb:	88 02                	mov    %al,(%edx)
	return 1;
  801bcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd2:	eb db                	jmp    801baf <devcons_read+0x11>
		return 0;
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd9:	eb d4                	jmp    801baf <devcons_read+0x11>

00801bdb <cputchar>:
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801be7:	6a 01                	push   $0x1
  801be9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bec:	50                   	push   %eax
  801bed:	e8 0d ef ff ff       	call   800aff <sys_cputs>
}
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <getchar>:
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801bfd:	6a 01                	push   $0x1
  801bff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c02:	50                   	push   %eax
  801c03:	6a 00                	push   $0x0
  801c05:	e8 c2 f6 ff ff       	call   8012cc <read>
	if (r < 0)
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	78 08                	js     801c19 <getchar+0x22>
	if (r < 1)
  801c11:	85 c0                	test   %eax,%eax
  801c13:	7e 06                	jle    801c1b <getchar+0x24>
	return c;
  801c15:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    
		return -E_EOF;
  801c1b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c20:	eb f7                	jmp    801c19 <getchar+0x22>

00801c22 <iscons>:
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2b:	50                   	push   %eax
  801c2c:	ff 75 08             	pushl  0x8(%ebp)
  801c2f:	e8 27 f4 ff ff       	call   80105b <fd_lookup>
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	85 c0                	test   %eax,%eax
  801c39:	78 11                	js     801c4c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c44:	39 10                	cmp    %edx,(%eax)
  801c46:	0f 94 c0             	sete   %al
  801c49:	0f b6 c0             	movzbl %al,%eax
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <opencons>:
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c57:	50                   	push   %eax
  801c58:	e8 af f3 ff ff       	call   80100c <fd_alloc>
  801c5d:	83 c4 10             	add    $0x10,%esp
  801c60:	85 c0                	test   %eax,%eax
  801c62:	78 3a                	js     801c9e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	68 07 04 00 00       	push   $0x407
  801c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6f:	6a 00                	push   $0x0
  801c71:	e8 45 ef ff ff       	call   800bbb <sys_page_alloc>
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	78 21                	js     801c9e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c80:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c86:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c92:	83 ec 0c             	sub    $0xc,%esp
  801c95:	50                   	push   %eax
  801c96:	e8 4a f3 ff ff       	call   800fe5 <fd2num>
  801c9b:	83 c4 10             	add    $0x10,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ca5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ca8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801cae:	e8 ca ee ff ff       	call   800b7d <sys_getenvid>
  801cb3:	83 ec 0c             	sub    $0xc,%esp
  801cb6:	ff 75 0c             	pushl  0xc(%ebp)
  801cb9:	ff 75 08             	pushl  0x8(%ebp)
  801cbc:	56                   	push   %esi
  801cbd:	50                   	push   %eax
  801cbe:	68 78 25 80 00       	push   $0x802578
  801cc3:	e8 10 e5 ff ff       	call   8001d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801cc8:	83 c4 18             	add    $0x18,%esp
  801ccb:	53                   	push   %ebx
  801ccc:	ff 75 10             	pushl  0x10(%ebp)
  801ccf:	e8 b3 e4 ff ff       	call   800187 <vcprintf>
	cprintf("\n");
  801cd4:	c7 04 24 8f 20 80 00 	movl   $0x80208f,(%esp)
  801cdb:	e8 f8 e4 ff ff       	call   8001d8 <cprintf>
  801ce0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ce3:	cc                   	int3   
  801ce4:	eb fd                	jmp    801ce3 <_panic+0x43>

00801ce6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	53                   	push   %ebx
  801cea:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ced:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801cf4:	74 0d                	je     801d03 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801cfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801d03:	e8 75 ee ff ff       	call   800b7d <sys_getenvid>
  801d08:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	6a 07                	push   $0x7
  801d0f:	68 00 f0 bf ee       	push   $0xeebff000
  801d14:	50                   	push   %eax
  801d15:	e8 a1 ee ff ff       	call   800bbb <sys_page_alloc>
        	if (r < 0) {
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	78 27                	js     801d48 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801d21:	83 ec 08             	sub    $0x8,%esp
  801d24:	68 5a 1d 80 00       	push   $0x801d5a
  801d29:	53                   	push   %ebx
  801d2a:	e8 d7 ef ff ff       	call   800d06 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	85 c0                	test   %eax,%eax
  801d34:	79 c0                	jns    801cf6 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801d36:	50                   	push   %eax
  801d37:	68 9c 25 80 00       	push   $0x80259c
  801d3c:	6a 28                	push   $0x28
  801d3e:	68 b0 25 80 00       	push   $0x8025b0
  801d43:	e8 58 ff ff ff       	call   801ca0 <_panic>
            		panic("pgfault_handler: %e", r);
  801d48:	50                   	push   %eax
  801d49:	68 9c 25 80 00       	push   $0x80259c
  801d4e:	6a 24                	push   $0x24
  801d50:	68 b0 25 80 00       	push   $0x8025b0
  801d55:	e8 46 ff ff ff       	call   801ca0 <_panic>

00801d5a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801d5a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801d5b:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801d60:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801d62:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801d65:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801d69:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801d6c:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801d70:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801d74:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801d77:	83 c4 08             	add    $0x8,%esp
	popal
  801d7a:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801d7b:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801d7e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801d7f:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801d80:	c3                   	ret    

00801d81 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801d87:	68 be 25 80 00       	push   $0x8025be
  801d8c:	6a 1a                	push   $0x1a
  801d8e:	68 d7 25 80 00       	push   $0x8025d7
  801d93:	e8 08 ff ff ff       	call   801ca0 <_panic>

00801d98 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801d9e:	68 e1 25 80 00       	push   $0x8025e1
  801da3:	6a 2a                	push   $0x2a
  801da5:	68 d7 25 80 00       	push   $0x8025d7
  801daa:	e8 f1 fe ff ff       	call   801ca0 <_panic>

00801daf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801dba:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801dbd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801dc3:	8b 52 50             	mov    0x50(%edx),%edx
  801dc6:	39 ca                	cmp    %ecx,%edx
  801dc8:	74 11                	je     801ddb <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801dca:	83 c0 01             	add    $0x1,%eax
  801dcd:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dd2:	75 e6                	jne    801dba <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd9:	eb 0b                	jmp    801de6 <ipc_find_env+0x37>
			return envs[i].env_id;
  801ddb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801dde:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801de3:	8b 40 48             	mov    0x48(%eax),%eax
}
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    

00801de8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dee:	89 d0                	mov    %edx,%eax
  801df0:	c1 e8 16             	shr    $0x16,%eax
  801df3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801dff:	f6 c1 01             	test   $0x1,%cl
  801e02:	74 1d                	je     801e21 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801e04:	c1 ea 0c             	shr    $0xc,%edx
  801e07:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e0e:	f6 c2 01             	test   $0x1,%dl
  801e11:	74 0e                	je     801e21 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e13:	c1 ea 0c             	shr    $0xc,%edx
  801e16:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e1d:	ef 
  801e1e:	0f b7 c0             	movzwl %ax,%eax
}
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    
  801e23:	66 90                	xchg   %ax,%ax
  801e25:	66 90                	xchg   %ax,%ax
  801e27:	66 90                	xchg   %ax,%ax
  801e29:	66 90                	xchg   %ax,%ax
  801e2b:	66 90                	xchg   %ax,%ax
  801e2d:	66 90                	xchg   %ax,%ax
  801e2f:	90                   	nop

00801e30 <__udivdi3>:
  801e30:	55                   	push   %ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 1c             	sub    $0x1c,%esp
  801e37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e3b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e43:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e47:	85 d2                	test   %edx,%edx
  801e49:	75 35                	jne    801e80 <__udivdi3+0x50>
  801e4b:	39 f3                	cmp    %esi,%ebx
  801e4d:	0f 87 bd 00 00 00    	ja     801f10 <__udivdi3+0xe0>
  801e53:	85 db                	test   %ebx,%ebx
  801e55:	89 d9                	mov    %ebx,%ecx
  801e57:	75 0b                	jne    801e64 <__udivdi3+0x34>
  801e59:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5e:	31 d2                	xor    %edx,%edx
  801e60:	f7 f3                	div    %ebx
  801e62:	89 c1                	mov    %eax,%ecx
  801e64:	31 d2                	xor    %edx,%edx
  801e66:	89 f0                	mov    %esi,%eax
  801e68:	f7 f1                	div    %ecx
  801e6a:	89 c6                	mov    %eax,%esi
  801e6c:	89 e8                	mov    %ebp,%eax
  801e6e:	89 f7                	mov    %esi,%edi
  801e70:	f7 f1                	div    %ecx
  801e72:	89 fa                	mov    %edi,%edx
  801e74:	83 c4 1c             	add    $0x1c,%esp
  801e77:	5b                   	pop    %ebx
  801e78:	5e                   	pop    %esi
  801e79:	5f                   	pop    %edi
  801e7a:	5d                   	pop    %ebp
  801e7b:	c3                   	ret    
  801e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e80:	39 f2                	cmp    %esi,%edx
  801e82:	77 7c                	ja     801f00 <__udivdi3+0xd0>
  801e84:	0f bd fa             	bsr    %edx,%edi
  801e87:	83 f7 1f             	xor    $0x1f,%edi
  801e8a:	0f 84 98 00 00 00    	je     801f28 <__udivdi3+0xf8>
  801e90:	89 f9                	mov    %edi,%ecx
  801e92:	b8 20 00 00 00       	mov    $0x20,%eax
  801e97:	29 f8                	sub    %edi,%eax
  801e99:	d3 e2                	shl    %cl,%edx
  801e9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e9f:	89 c1                	mov    %eax,%ecx
  801ea1:	89 da                	mov    %ebx,%edx
  801ea3:	d3 ea                	shr    %cl,%edx
  801ea5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ea9:	09 d1                	or     %edx,%ecx
  801eab:	89 f2                	mov    %esi,%edx
  801ead:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eb1:	89 f9                	mov    %edi,%ecx
  801eb3:	d3 e3                	shl    %cl,%ebx
  801eb5:	89 c1                	mov    %eax,%ecx
  801eb7:	d3 ea                	shr    %cl,%edx
  801eb9:	89 f9                	mov    %edi,%ecx
  801ebb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ebf:	d3 e6                	shl    %cl,%esi
  801ec1:	89 eb                	mov    %ebp,%ebx
  801ec3:	89 c1                	mov    %eax,%ecx
  801ec5:	d3 eb                	shr    %cl,%ebx
  801ec7:	09 de                	or     %ebx,%esi
  801ec9:	89 f0                	mov    %esi,%eax
  801ecb:	f7 74 24 08          	divl   0x8(%esp)
  801ecf:	89 d6                	mov    %edx,%esi
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	f7 64 24 0c          	mull   0xc(%esp)
  801ed7:	39 d6                	cmp    %edx,%esi
  801ed9:	72 0c                	jb     801ee7 <__udivdi3+0xb7>
  801edb:	89 f9                	mov    %edi,%ecx
  801edd:	d3 e5                	shl    %cl,%ebp
  801edf:	39 c5                	cmp    %eax,%ebp
  801ee1:	73 5d                	jae    801f40 <__udivdi3+0x110>
  801ee3:	39 d6                	cmp    %edx,%esi
  801ee5:	75 59                	jne    801f40 <__udivdi3+0x110>
  801ee7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eea:	31 ff                	xor    %edi,%edi
  801eec:	89 fa                	mov    %edi,%edx
  801eee:	83 c4 1c             	add    $0x1c,%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5f                   	pop    %edi
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    
  801ef6:	8d 76 00             	lea    0x0(%esi),%esi
  801ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801f00:	31 ff                	xor    %edi,%edi
  801f02:	31 c0                	xor    %eax,%eax
  801f04:	89 fa                	mov    %edi,%edx
  801f06:	83 c4 1c             	add    $0x1c,%esp
  801f09:	5b                   	pop    %ebx
  801f0a:	5e                   	pop    %esi
  801f0b:	5f                   	pop    %edi
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    
  801f0e:	66 90                	xchg   %ax,%ax
  801f10:	31 ff                	xor    %edi,%edi
  801f12:	89 e8                	mov    %ebp,%eax
  801f14:	89 f2                	mov    %esi,%edx
  801f16:	f7 f3                	div    %ebx
  801f18:	89 fa                	mov    %edi,%edx
  801f1a:	83 c4 1c             	add    $0x1c,%esp
  801f1d:	5b                   	pop    %ebx
  801f1e:	5e                   	pop    %esi
  801f1f:	5f                   	pop    %edi
  801f20:	5d                   	pop    %ebp
  801f21:	c3                   	ret    
  801f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f28:	39 f2                	cmp    %esi,%edx
  801f2a:	72 06                	jb     801f32 <__udivdi3+0x102>
  801f2c:	31 c0                	xor    %eax,%eax
  801f2e:	39 eb                	cmp    %ebp,%ebx
  801f30:	77 d2                	ja     801f04 <__udivdi3+0xd4>
  801f32:	b8 01 00 00 00       	mov    $0x1,%eax
  801f37:	eb cb                	jmp    801f04 <__udivdi3+0xd4>
  801f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f40:	89 d8                	mov    %ebx,%eax
  801f42:	31 ff                	xor    %edi,%edi
  801f44:	eb be                	jmp    801f04 <__udivdi3+0xd4>
  801f46:	66 90                	xchg   %ax,%ax
  801f48:	66 90                	xchg   %ax,%ax
  801f4a:	66 90                	xchg   %ax,%ax
  801f4c:	66 90                	xchg   %ax,%ax
  801f4e:	66 90                	xchg   %ax,%ax

00801f50 <__umoddi3>:
  801f50:	55                   	push   %ebp
  801f51:	57                   	push   %edi
  801f52:	56                   	push   %esi
  801f53:	53                   	push   %ebx
  801f54:	83 ec 1c             	sub    $0x1c,%esp
  801f57:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801f5b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f5f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f67:	85 ed                	test   %ebp,%ebp
  801f69:	89 f0                	mov    %esi,%eax
  801f6b:	89 da                	mov    %ebx,%edx
  801f6d:	75 19                	jne    801f88 <__umoddi3+0x38>
  801f6f:	39 df                	cmp    %ebx,%edi
  801f71:	0f 86 b1 00 00 00    	jbe    802028 <__umoddi3+0xd8>
  801f77:	f7 f7                	div    %edi
  801f79:	89 d0                	mov    %edx,%eax
  801f7b:	31 d2                	xor    %edx,%edx
  801f7d:	83 c4 1c             	add    $0x1c,%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    
  801f85:	8d 76 00             	lea    0x0(%esi),%esi
  801f88:	39 dd                	cmp    %ebx,%ebp
  801f8a:	77 f1                	ja     801f7d <__umoddi3+0x2d>
  801f8c:	0f bd cd             	bsr    %ebp,%ecx
  801f8f:	83 f1 1f             	xor    $0x1f,%ecx
  801f92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f96:	0f 84 b4 00 00 00    	je     802050 <__umoddi3+0x100>
  801f9c:	b8 20 00 00 00       	mov    $0x20,%eax
  801fa1:	89 c2                	mov    %eax,%edx
  801fa3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fa7:	29 c2                	sub    %eax,%edx
  801fa9:	89 c1                	mov    %eax,%ecx
  801fab:	89 f8                	mov    %edi,%eax
  801fad:	d3 e5                	shl    %cl,%ebp
  801faf:	89 d1                	mov    %edx,%ecx
  801fb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fb5:	d3 e8                	shr    %cl,%eax
  801fb7:	09 c5                	or     %eax,%ebp
  801fb9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fbd:	89 c1                	mov    %eax,%ecx
  801fbf:	d3 e7                	shl    %cl,%edi
  801fc1:	89 d1                	mov    %edx,%ecx
  801fc3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801fc7:	89 df                	mov    %ebx,%edi
  801fc9:	d3 ef                	shr    %cl,%edi
  801fcb:	89 c1                	mov    %eax,%ecx
  801fcd:	89 f0                	mov    %esi,%eax
  801fcf:	d3 e3                	shl    %cl,%ebx
  801fd1:	89 d1                	mov    %edx,%ecx
  801fd3:	89 fa                	mov    %edi,%edx
  801fd5:	d3 e8                	shr    %cl,%eax
  801fd7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fdc:	09 d8                	or     %ebx,%eax
  801fde:	f7 f5                	div    %ebp
  801fe0:	d3 e6                	shl    %cl,%esi
  801fe2:	89 d1                	mov    %edx,%ecx
  801fe4:	f7 64 24 08          	mull   0x8(%esp)
  801fe8:	39 d1                	cmp    %edx,%ecx
  801fea:	89 c3                	mov    %eax,%ebx
  801fec:	89 d7                	mov    %edx,%edi
  801fee:	72 06                	jb     801ff6 <__umoddi3+0xa6>
  801ff0:	75 0e                	jne    802000 <__umoddi3+0xb0>
  801ff2:	39 c6                	cmp    %eax,%esi
  801ff4:	73 0a                	jae    802000 <__umoddi3+0xb0>
  801ff6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801ffa:	19 ea                	sbb    %ebp,%edx
  801ffc:	89 d7                	mov    %edx,%edi
  801ffe:	89 c3                	mov    %eax,%ebx
  802000:	89 ca                	mov    %ecx,%edx
  802002:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802007:	29 de                	sub    %ebx,%esi
  802009:	19 fa                	sbb    %edi,%edx
  80200b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80200f:	89 d0                	mov    %edx,%eax
  802011:	d3 e0                	shl    %cl,%eax
  802013:	89 d9                	mov    %ebx,%ecx
  802015:	d3 ee                	shr    %cl,%esi
  802017:	d3 ea                	shr    %cl,%edx
  802019:	09 f0                	or     %esi,%eax
  80201b:	83 c4 1c             	add    $0x1c,%esp
  80201e:	5b                   	pop    %ebx
  80201f:	5e                   	pop    %esi
  802020:	5f                   	pop    %edi
  802021:	5d                   	pop    %ebp
  802022:	c3                   	ret    
  802023:	90                   	nop
  802024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802028:	85 ff                	test   %edi,%edi
  80202a:	89 f9                	mov    %edi,%ecx
  80202c:	75 0b                	jne    802039 <__umoddi3+0xe9>
  80202e:	b8 01 00 00 00       	mov    $0x1,%eax
  802033:	31 d2                	xor    %edx,%edx
  802035:	f7 f7                	div    %edi
  802037:	89 c1                	mov    %eax,%ecx
  802039:	89 d8                	mov    %ebx,%eax
  80203b:	31 d2                	xor    %edx,%edx
  80203d:	f7 f1                	div    %ecx
  80203f:	89 f0                	mov    %esi,%eax
  802041:	f7 f1                	div    %ecx
  802043:	e9 31 ff ff ff       	jmp    801f79 <__umoddi3+0x29>
  802048:	90                   	nop
  802049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802050:	39 dd                	cmp    %ebx,%ebp
  802052:	72 08                	jb     80205c <__umoddi3+0x10c>
  802054:	39 f7                	cmp    %esi,%edi
  802056:	0f 87 21 ff ff ff    	ja     801f7d <__umoddi3+0x2d>
  80205c:	89 da                	mov    %ebx,%edx
  80205e:	89 f0                	mov    %esi,%eax
  802060:	29 f8                	sub    %edi,%eax
  802062:	19 ea                	sbb    %ebp,%edx
  802064:	e9 14 ff ff ff       	jmp    801f7d <__umoddi3+0x2d>
