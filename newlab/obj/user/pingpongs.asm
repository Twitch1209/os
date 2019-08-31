
obj/user/pingpongs.debug：     文件格式 elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 aa 0f 00 00       	call   800feb <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 ad 0f 00 00       	call   801005 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 04 40 80 00       	mov    0x804004,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 2c 0b 00 00       	call   800b9d <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 d0 20 80 00       	push   $0x8020d0
  800080:	e8 73 01 00 00       	call   8001f8 <cprintf>
		if (val == 10)
  800085:	a1 04 40 80 00       	mov    0x804004,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 04 40 80 00       	mov    %eax,0x804004
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a3:	e8 74 0f 00 00       	call   80101c <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 04 40 80 00 0a 	cmpl   $0xa,0x804004
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000c2:	e8 d6 0a 00 00       	call   800b9d <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 a0 20 80 00       	push   $0x8020a0
  8000d1:	e8 22 01 00 00       	call   8001f8 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 bf 0a 00 00       	call   800b9d <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 ba 20 80 00       	push   $0x8020ba
  8000e8:	e8 0b 01 00 00       	call   8001f8 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 21 0f 00 00       	call   80101c <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010e:	e8 8a 0a 00 00       	call   800b9d <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	85 db                	test   %ebx,%ebx
  800127:	7e 07                	jle    800130 <libmain+0x2d>
		binaryname = argv[0];
  800129:	8b 06                	mov    (%esi),%eax
  80012b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 0a 00 00 00       	call   800149 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80014f:	e8 ee 10 00 00       	call   801242 <close_all>
	sys_env_destroy(0);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	6a 00                	push   $0x0
  800159:	e8 fe 09 00 00       	call   800b5c <sys_env_destroy>
}
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	53                   	push   %ebx
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016d:	8b 13                	mov    (%ebx),%edx
  80016f:	8d 42 01             	lea    0x1(%edx),%eax
  800172:	89 03                	mov    %eax,(%ebx)
  800174:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800177:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800180:	74 09                	je     80018b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800182:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800189:	c9                   	leave  
  80018a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	68 ff 00 00 00       	push   $0xff
  800193:	8d 43 08             	lea    0x8(%ebx),%eax
  800196:	50                   	push   %eax
  800197:	e8 83 09 00 00       	call   800b1f <sys_cputs>
		b->idx = 0;
  80019c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	eb db                	jmp    800182 <putch+0x1f>

008001a7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b7:	00 00 00 
	b.cnt = 0;
  8001ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c4:	ff 75 0c             	pushl  0xc(%ebp)
  8001c7:	ff 75 08             	pushl  0x8(%ebp)
  8001ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	68 63 01 80 00       	push   $0x800163
  8001d6:	e8 1a 01 00 00       	call   8002f5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001db:	83 c4 08             	add    $0x8,%esp
  8001de:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 2f 09 00 00       	call   800b1f <sys_cputs>

	return b.cnt;
}
  8001f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f6:	c9                   	leave  
  8001f7:	c3                   	ret    

008001f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800201:	50                   	push   %eax
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	e8 9d ff ff ff       	call   8001a7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	89 c7                	mov    %eax,%edi
  800217:	89 d6                	mov    %edx,%esi
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800222:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800225:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800230:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800233:	39 d3                	cmp    %edx,%ebx
  800235:	72 05                	jb     80023c <printnum+0x30>
  800237:	39 45 10             	cmp    %eax,0x10(%ebp)
  80023a:	77 7a                	ja     8002b6 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	ff 75 18             	pushl  0x18(%ebp)
  800242:	8b 45 14             	mov    0x14(%ebp),%eax
  800245:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800248:	53                   	push   %ebx
  800249:	ff 75 10             	pushl  0x10(%ebp)
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800252:	ff 75 e0             	pushl  -0x20(%ebp)
  800255:	ff 75 dc             	pushl  -0x24(%ebp)
  800258:	ff 75 d8             	pushl  -0x28(%ebp)
  80025b:	e8 f0 1b 00 00       	call   801e50 <__udivdi3>
  800260:	83 c4 18             	add    $0x18,%esp
  800263:	52                   	push   %edx
  800264:	50                   	push   %eax
  800265:	89 f2                	mov    %esi,%edx
  800267:	89 f8                	mov    %edi,%eax
  800269:	e8 9e ff ff ff       	call   80020c <printnum>
  80026e:	83 c4 20             	add    $0x20,%esp
  800271:	eb 13                	jmp    800286 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	56                   	push   %esi
  800277:	ff 75 18             	pushl  0x18(%ebp)
  80027a:	ff d7                	call   *%edi
  80027c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80027f:	83 eb 01             	sub    $0x1,%ebx
  800282:	85 db                	test   %ebx,%ebx
  800284:	7f ed                	jg     800273 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	56                   	push   %esi
  80028a:	83 ec 04             	sub    $0x4,%esp
  80028d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800290:	ff 75 e0             	pushl  -0x20(%ebp)
  800293:	ff 75 dc             	pushl  -0x24(%ebp)
  800296:	ff 75 d8             	pushl  -0x28(%ebp)
  800299:	e8 d2 1c 00 00       	call   801f70 <__umoddi3>
  80029e:	83 c4 14             	add    $0x14,%esp
  8002a1:	0f be 80 00 21 80 00 	movsbl 0x802100(%eax),%eax
  8002a8:	50                   	push   %eax
  8002a9:	ff d7                	call   *%edi
}
  8002ab:	83 c4 10             	add    $0x10,%esp
  8002ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b1:	5b                   	pop    %ebx
  8002b2:	5e                   	pop    %esi
  8002b3:	5f                   	pop    %edi
  8002b4:	5d                   	pop    %ebp
  8002b5:	c3                   	ret    
  8002b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b9:	eb c4                	jmp    80027f <printnum+0x73>

008002bb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ca:	73 0a                	jae    8002d6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cf:	89 08                	mov    %ecx,(%eax)
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	88 02                	mov    %al,(%edx)
}
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    

008002d8 <printfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002de:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e1:	50                   	push   %eax
  8002e2:	ff 75 10             	pushl  0x10(%ebp)
  8002e5:	ff 75 0c             	pushl  0xc(%ebp)
  8002e8:	ff 75 08             	pushl  0x8(%ebp)
  8002eb:	e8 05 00 00 00       	call   8002f5 <vprintfmt>
}
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <vprintfmt>:
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 2c             	sub    $0x2c,%esp
  8002fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800301:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800304:	8b 7d 10             	mov    0x10(%ebp),%edi
  800307:	e9 8c 03 00 00       	jmp    800698 <vprintfmt+0x3a3>
		padc = ' ';
  80030c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800310:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800317:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80031e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800325:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8d 47 01             	lea    0x1(%edi),%eax
  80032d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800330:	0f b6 17             	movzbl (%edi),%edx
  800333:	8d 42 dd             	lea    -0x23(%edx),%eax
  800336:	3c 55                	cmp    $0x55,%al
  800338:	0f 87 dd 03 00 00    	ja     80071b <vprintfmt+0x426>
  80033e:	0f b6 c0             	movzbl %al,%eax
  800341:	ff 24 85 40 22 80 00 	jmp    *0x802240(,%eax,4)
  800348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80034b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80034f:	eb d9                	jmp    80032a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800351:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800354:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800358:	eb d0                	jmp    80032a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	0f b6 d2             	movzbl %dl,%edx
  80035d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800360:	b8 00 00 00 00       	mov    $0x0,%eax
  800365:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800368:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800372:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800375:	83 f9 09             	cmp    $0x9,%ecx
  800378:	77 55                	ja     8003cf <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80037a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80037d:	eb e9                	jmp    800368 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	8d 40 04             	lea    0x4(%eax),%eax
  80038d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800393:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800397:	79 91                	jns    80032a <vprintfmt+0x35>
				width = precision, precision = -1;
  800399:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003a6:	eb 82                	jmp    80032a <vprintfmt+0x35>
  8003a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b2:	0f 49 d0             	cmovns %eax,%edx
  8003b5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003bb:	e9 6a ff ff ff       	jmp    80032a <vprintfmt+0x35>
  8003c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003ca:	e9 5b ff ff ff       	jmp    80032a <vprintfmt+0x35>
  8003cf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003d5:	eb bc                	jmp    800393 <vprintfmt+0x9e>
			lflag++;
  8003d7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003dd:	e9 48 ff ff ff       	jmp    80032a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	8d 78 04             	lea    0x4(%eax),%edi
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	53                   	push   %ebx
  8003ec:	ff 30                	pushl  (%eax)
  8003ee:	ff d6                	call   *%esi
			break;
  8003f0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f6:	e9 9a 02 00 00       	jmp    800695 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8d 78 04             	lea    0x4(%eax),%edi
  800401:	8b 00                	mov    (%eax),%eax
  800403:	99                   	cltd   
  800404:	31 d0                	xor    %edx,%eax
  800406:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800408:	83 f8 0f             	cmp    $0xf,%eax
  80040b:	7f 23                	jg     800430 <vprintfmt+0x13b>
  80040d:	8b 14 85 a0 23 80 00 	mov    0x8023a0(,%eax,4),%edx
  800414:	85 d2                	test   %edx,%edx
  800416:	74 18                	je     800430 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800418:	52                   	push   %edx
  800419:	68 cd 25 80 00       	push   $0x8025cd
  80041e:	53                   	push   %ebx
  80041f:	56                   	push   %esi
  800420:	e8 b3 fe ff ff       	call   8002d8 <printfmt>
  800425:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800428:	89 7d 14             	mov    %edi,0x14(%ebp)
  80042b:	e9 65 02 00 00       	jmp    800695 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800430:	50                   	push   %eax
  800431:	68 18 21 80 00       	push   $0x802118
  800436:	53                   	push   %ebx
  800437:	56                   	push   %esi
  800438:	e8 9b fe ff ff       	call   8002d8 <printfmt>
  80043d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800440:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800443:	e9 4d 02 00 00       	jmp    800695 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	83 c0 04             	add    $0x4,%eax
  80044e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800456:	85 ff                	test   %edi,%edi
  800458:	b8 11 21 80 00       	mov    $0x802111,%eax
  80045d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800460:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800464:	0f 8e bd 00 00 00    	jle    800527 <vprintfmt+0x232>
  80046a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80046e:	75 0e                	jne    80047e <vprintfmt+0x189>
  800470:	89 75 08             	mov    %esi,0x8(%ebp)
  800473:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800476:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800479:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80047c:	eb 6d                	jmp    8004eb <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	ff 75 d0             	pushl  -0x30(%ebp)
  800484:	57                   	push   %edi
  800485:	e8 39 03 00 00       	call   8007c3 <strnlen>
  80048a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048d:	29 c1                	sub    %eax,%ecx
  80048f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800492:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800495:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800499:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80049f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	eb 0f                	jmp    8004b2 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004aa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ac:	83 ef 01             	sub    $0x1,%edi
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	85 ff                	test   %edi,%edi
  8004b4:	7f ed                	jg     8004a3 <vprintfmt+0x1ae>
  8004b6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004bc:	85 c9                	test   %ecx,%ecx
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	0f 49 c1             	cmovns %ecx,%eax
  8004c6:	29 c1                	sub    %eax,%ecx
  8004c8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ce:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004d1:	89 cb                	mov    %ecx,%ebx
  8004d3:	eb 16                	jmp    8004eb <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d9:	75 31                	jne    80050c <vprintfmt+0x217>
					putch(ch, putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	ff 75 0c             	pushl  0xc(%ebp)
  8004e1:	50                   	push   %eax
  8004e2:	ff 55 08             	call   *0x8(%ebp)
  8004e5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e8:	83 eb 01             	sub    $0x1,%ebx
  8004eb:	83 c7 01             	add    $0x1,%edi
  8004ee:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004f2:	0f be c2             	movsbl %dl,%eax
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	74 59                	je     800552 <vprintfmt+0x25d>
  8004f9:	85 f6                	test   %esi,%esi
  8004fb:	78 d8                	js     8004d5 <vprintfmt+0x1e0>
  8004fd:	83 ee 01             	sub    $0x1,%esi
  800500:	79 d3                	jns    8004d5 <vprintfmt+0x1e0>
  800502:	89 df                	mov    %ebx,%edi
  800504:	8b 75 08             	mov    0x8(%ebp),%esi
  800507:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050a:	eb 37                	jmp    800543 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80050c:	0f be d2             	movsbl %dl,%edx
  80050f:	83 ea 20             	sub    $0x20,%edx
  800512:	83 fa 5e             	cmp    $0x5e,%edx
  800515:	76 c4                	jbe    8004db <vprintfmt+0x1e6>
					putch('?', putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	ff 75 0c             	pushl  0xc(%ebp)
  80051d:	6a 3f                	push   $0x3f
  80051f:	ff 55 08             	call   *0x8(%ebp)
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	eb c1                	jmp    8004e8 <vprintfmt+0x1f3>
  800527:	89 75 08             	mov    %esi,0x8(%ebp)
  80052a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80052d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800530:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800533:	eb b6                	jmp    8004eb <vprintfmt+0x1f6>
				putch(' ', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 20                	push   $0x20
  80053b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053d:	83 ef 01             	sub    $0x1,%edi
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	85 ff                	test   %edi,%edi
  800545:	7f ee                	jg     800535 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	e9 43 01 00 00       	jmp    800695 <vprintfmt+0x3a0>
  800552:	89 df                	mov    %ebx,%edi
  800554:	8b 75 08             	mov    0x8(%ebp),%esi
  800557:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80055a:	eb e7                	jmp    800543 <vprintfmt+0x24e>
	if (lflag >= 2)
  80055c:	83 f9 01             	cmp    $0x1,%ecx
  80055f:	7e 3f                	jle    8005a0 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8b 50 04             	mov    0x4(%eax),%edx
  800567:	8b 00                	mov    (%eax),%eax
  800569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 40 08             	lea    0x8(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800578:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80057c:	79 5c                	jns    8005da <vprintfmt+0x2e5>
				putch('-', putdat);
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	53                   	push   %ebx
  800582:	6a 2d                	push   $0x2d
  800584:	ff d6                	call   *%esi
				num = -(long long) num;
  800586:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800589:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80058c:	f7 da                	neg    %edx
  80058e:	83 d1 00             	adc    $0x0,%ecx
  800591:	f7 d9                	neg    %ecx
  800593:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800596:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059b:	e9 db 00 00 00       	jmp    80067b <vprintfmt+0x386>
	else if (lflag)
  8005a0:	85 c9                	test   %ecx,%ecx
  8005a2:	75 1b                	jne    8005bf <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ac:	89 c1                	mov    %eax,%ecx
  8005ae:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bd:	eb b9                	jmp    800578 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c7:	89 c1                	mov    %eax,%ecx
  8005c9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005cc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d8:	eb 9e                	jmp    800578 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005dd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e5:	e9 91 00 00 00       	jmp    80067b <vprintfmt+0x386>
	if (lflag >= 2)
  8005ea:	83 f9 01             	cmp    $0x1,%ecx
  8005ed:	7e 15                	jle    800604 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	8b 48 04             	mov    0x4(%eax),%ecx
  8005f7:	8d 40 08             	lea    0x8(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800602:	eb 77                	jmp    80067b <vprintfmt+0x386>
	else if (lflag)
  800604:	85 c9                	test   %ecx,%ecx
  800606:	75 17                	jne    80061f <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061d:	eb 5c                	jmp    80067b <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 10                	mov    (%eax),%edx
  800624:	b9 00 00 00 00       	mov    $0x0,%ecx
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800634:	eb 45                	jmp    80067b <vprintfmt+0x386>
			putch('X', putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	53                   	push   %ebx
  80063a:	6a 58                	push   $0x58
  80063c:	ff d6                	call   *%esi
			putch('X', putdat);
  80063e:	83 c4 08             	add    $0x8,%esp
  800641:	53                   	push   %ebx
  800642:	6a 58                	push   $0x58
  800644:	ff d6                	call   *%esi
			putch('X', putdat);
  800646:	83 c4 08             	add    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 58                	push   $0x58
  80064c:	ff d6                	call   *%esi
			break;
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	eb 42                	jmp    800695 <vprintfmt+0x3a0>
			putch('0', putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	53                   	push   %ebx
  800657:	6a 30                	push   $0x30
  800659:	ff d6                	call   *%esi
			putch('x', putdat);
  80065b:	83 c4 08             	add    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 78                	push   $0x78
  800661:	ff d6                	call   *%esi
			num = (unsigned long long)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 10                	mov    (%eax),%edx
  800668:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80066d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800682:	57                   	push   %edi
  800683:	ff 75 e0             	pushl  -0x20(%ebp)
  800686:	50                   	push   %eax
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	89 da                	mov    %ebx,%edx
  80068b:	89 f0                	mov    %esi,%eax
  80068d:	e8 7a fb ff ff       	call   80020c <printnum>
			break;
  800692:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800695:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800698:	83 c7 01             	add    $0x1,%edi
  80069b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80069f:	83 f8 25             	cmp    $0x25,%eax
  8006a2:	0f 84 64 fc ff ff    	je     80030c <vprintfmt+0x17>
			if (ch == '\0')
  8006a8:	85 c0                	test   %eax,%eax
  8006aa:	0f 84 8b 00 00 00    	je     80073b <vprintfmt+0x446>
			putch(ch, putdat);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	50                   	push   %eax
  8006b5:	ff d6                	call   *%esi
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	eb dc                	jmp    800698 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8006bc:	83 f9 01             	cmp    $0x1,%ecx
  8006bf:	7e 15                	jle    8006d6 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 10                	mov    (%eax),%edx
  8006c6:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c9:	8d 40 08             	lea    0x8(%eax),%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cf:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d4:	eb a5                	jmp    80067b <vprintfmt+0x386>
	else if (lflag)
  8006d6:	85 c9                	test   %ecx,%ecx
  8006d8:	75 17                	jne    8006f1 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 10                	mov    (%eax),%edx
  8006df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ea:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ef:	eb 8a                	jmp    80067b <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 10                	mov    (%eax),%edx
  8006f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fb:	8d 40 04             	lea    0x4(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800701:	b8 10 00 00 00       	mov    $0x10,%eax
  800706:	e9 70 ff ff ff       	jmp    80067b <vprintfmt+0x386>
			putch(ch, putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	53                   	push   %ebx
  80070f:	6a 25                	push   $0x25
  800711:	ff d6                	call   *%esi
			break;
  800713:	83 c4 10             	add    $0x10,%esp
  800716:	e9 7a ff ff ff       	jmp    800695 <vprintfmt+0x3a0>
			putch('%', putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	53                   	push   %ebx
  80071f:	6a 25                	push   $0x25
  800721:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	89 f8                	mov    %edi,%eax
  800728:	eb 03                	jmp    80072d <vprintfmt+0x438>
  80072a:	83 e8 01             	sub    $0x1,%eax
  80072d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800731:	75 f7                	jne    80072a <vprintfmt+0x435>
  800733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800736:	e9 5a ff ff ff       	jmp    800695 <vprintfmt+0x3a0>
}
  80073b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073e:	5b                   	pop    %ebx
  80073f:	5e                   	pop    %esi
  800740:	5f                   	pop    %edi
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800752:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800756:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800760:	85 c0                	test   %eax,%eax
  800762:	74 26                	je     80078a <vsnprintf+0x47>
  800764:	85 d2                	test   %edx,%edx
  800766:	7e 22                	jle    80078a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800768:	ff 75 14             	pushl  0x14(%ebp)
  80076b:	ff 75 10             	pushl  0x10(%ebp)
  80076e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800771:	50                   	push   %eax
  800772:	68 bb 02 80 00       	push   $0x8002bb
  800777:	e8 79 fb ff ff       	call   8002f5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800785:	83 c4 10             	add    $0x10,%esp
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    
		return -E_INVAL;
  80078a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80078f:	eb f7                	jmp    800788 <vsnprintf+0x45>

00800791 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800797:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80079a:	50                   	push   %eax
  80079b:	ff 75 10             	pushl  0x10(%ebp)
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	ff 75 08             	pushl  0x8(%ebp)
  8007a4:	e8 9a ff ff ff       	call   800743 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b6:	eb 03                	jmp    8007bb <strlen+0x10>
		n++;
  8007b8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007bf:	75 f7                	jne    8007b8 <strlen+0xd>
	return n;
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d1:	eb 03                	jmp    8007d6 <strnlen+0x13>
		n++;
  8007d3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d6:	39 d0                	cmp    %edx,%eax
  8007d8:	74 06                	je     8007e0 <strnlen+0x1d>
  8007da:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007de:	75 f3                	jne    8007d3 <strnlen+0x10>
	return n;
}
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	53                   	push   %ebx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ec:	89 c2                	mov    %eax,%edx
  8007ee:	83 c1 01             	add    $0x1,%ecx
  8007f1:	83 c2 01             	add    $0x1,%edx
  8007f4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007f8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007fb:	84 db                	test   %bl,%bl
  8007fd:	75 ef                	jne    8007ee <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007ff:	5b                   	pop    %ebx
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800809:	53                   	push   %ebx
  80080a:	e8 9c ff ff ff       	call   8007ab <strlen>
  80080f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	01 d8                	add    %ebx,%eax
  800817:	50                   	push   %eax
  800818:	e8 c5 ff ff ff       	call   8007e2 <strcpy>
	return dst;
}
  80081d:	89 d8                	mov    %ebx,%eax
  80081f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800822:	c9                   	leave  
  800823:	c3                   	ret    

00800824 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	56                   	push   %esi
  800828:	53                   	push   %ebx
  800829:	8b 75 08             	mov    0x8(%ebp),%esi
  80082c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082f:	89 f3                	mov    %esi,%ebx
  800831:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800834:	89 f2                	mov    %esi,%edx
  800836:	eb 0f                	jmp    800847 <strncpy+0x23>
		*dst++ = *src;
  800838:	83 c2 01             	add    $0x1,%edx
  80083b:	0f b6 01             	movzbl (%ecx),%eax
  80083e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800841:	80 39 01             	cmpb   $0x1,(%ecx)
  800844:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800847:	39 da                	cmp    %ebx,%edx
  800849:	75 ed                	jne    800838 <strncpy+0x14>
	}
	return ret;
}
  80084b:	89 f0                	mov    %esi,%eax
  80084d:	5b                   	pop    %ebx
  80084e:	5e                   	pop    %esi
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	8b 75 08             	mov    0x8(%ebp),%esi
  800859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80085f:	89 f0                	mov    %esi,%eax
  800861:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800865:	85 c9                	test   %ecx,%ecx
  800867:	75 0b                	jne    800874 <strlcpy+0x23>
  800869:	eb 17                	jmp    800882 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80086b:	83 c2 01             	add    $0x1,%edx
  80086e:	83 c0 01             	add    $0x1,%eax
  800871:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800874:	39 d8                	cmp    %ebx,%eax
  800876:	74 07                	je     80087f <strlcpy+0x2e>
  800878:	0f b6 0a             	movzbl (%edx),%ecx
  80087b:	84 c9                	test   %cl,%cl
  80087d:	75 ec                	jne    80086b <strlcpy+0x1a>
		*dst = '\0';
  80087f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800882:	29 f0                	sub    %esi,%eax
}
  800884:	5b                   	pop    %ebx
  800885:	5e                   	pop    %esi
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800891:	eb 06                	jmp    800899 <strcmp+0x11>
		p++, q++;
  800893:	83 c1 01             	add    $0x1,%ecx
  800896:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800899:	0f b6 01             	movzbl (%ecx),%eax
  80089c:	84 c0                	test   %al,%al
  80089e:	74 04                	je     8008a4 <strcmp+0x1c>
  8008a0:	3a 02                	cmp    (%edx),%al
  8008a2:	74 ef                	je     800893 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a4:	0f b6 c0             	movzbl %al,%eax
  8008a7:	0f b6 12             	movzbl (%edx),%edx
  8008aa:	29 d0                	sub    %edx,%eax
}
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	53                   	push   %ebx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b8:	89 c3                	mov    %eax,%ebx
  8008ba:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008bd:	eb 06                	jmp    8008c5 <strncmp+0x17>
		n--, p++, q++;
  8008bf:	83 c0 01             	add    $0x1,%eax
  8008c2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008c5:	39 d8                	cmp    %ebx,%eax
  8008c7:	74 16                	je     8008df <strncmp+0x31>
  8008c9:	0f b6 08             	movzbl (%eax),%ecx
  8008cc:	84 c9                	test   %cl,%cl
  8008ce:	74 04                	je     8008d4 <strncmp+0x26>
  8008d0:	3a 0a                	cmp    (%edx),%cl
  8008d2:	74 eb                	je     8008bf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d4:	0f b6 00             	movzbl (%eax),%eax
  8008d7:	0f b6 12             	movzbl (%edx),%edx
  8008da:	29 d0                	sub    %edx,%eax
}
  8008dc:	5b                   	pop    %ebx
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    
		return 0;
  8008df:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e4:	eb f6                	jmp    8008dc <strncmp+0x2e>

008008e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f0:	0f b6 10             	movzbl (%eax),%edx
  8008f3:	84 d2                	test   %dl,%dl
  8008f5:	74 09                	je     800900 <strchr+0x1a>
		if (*s == c)
  8008f7:	38 ca                	cmp    %cl,%dl
  8008f9:	74 0a                	je     800905 <strchr+0x1f>
	for (; *s; s++)
  8008fb:	83 c0 01             	add    $0x1,%eax
  8008fe:	eb f0                	jmp    8008f0 <strchr+0xa>
			return (char *) s;
	return 0;
  800900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800911:	eb 03                	jmp    800916 <strfind+0xf>
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800919:	38 ca                	cmp    %cl,%dl
  80091b:	74 04                	je     800921 <strfind+0x1a>
  80091d:	84 d2                	test   %dl,%dl
  80091f:	75 f2                	jne    800913 <strfind+0xc>
			break;
	return (char *) s;
}
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	57                   	push   %edi
  800927:	56                   	push   %esi
  800928:	53                   	push   %ebx
  800929:	8b 7d 08             	mov    0x8(%ebp),%edi
  80092c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80092f:	85 c9                	test   %ecx,%ecx
  800931:	74 13                	je     800946 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800933:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800939:	75 05                	jne    800940 <memset+0x1d>
  80093b:	f6 c1 03             	test   $0x3,%cl
  80093e:	74 0d                	je     80094d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	fc                   	cld    
  800944:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800946:	89 f8                	mov    %edi,%eax
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5f                   	pop    %edi
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    
		c &= 0xFF;
  80094d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800951:	89 d3                	mov    %edx,%ebx
  800953:	c1 e3 08             	shl    $0x8,%ebx
  800956:	89 d0                	mov    %edx,%eax
  800958:	c1 e0 18             	shl    $0x18,%eax
  80095b:	89 d6                	mov    %edx,%esi
  80095d:	c1 e6 10             	shl    $0x10,%esi
  800960:	09 f0                	or     %esi,%eax
  800962:	09 c2                	or     %eax,%edx
  800964:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800966:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800969:	89 d0                	mov    %edx,%eax
  80096b:	fc                   	cld    
  80096c:	f3 ab                	rep stos %eax,%es:(%edi)
  80096e:	eb d6                	jmp    800946 <memset+0x23>

00800970 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	57                   	push   %edi
  800974:	56                   	push   %esi
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 75 0c             	mov    0xc(%ebp),%esi
  80097b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097e:	39 c6                	cmp    %eax,%esi
  800980:	73 35                	jae    8009b7 <memmove+0x47>
  800982:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800985:	39 c2                	cmp    %eax,%edx
  800987:	76 2e                	jbe    8009b7 <memmove+0x47>
		s += n;
		d += n;
  800989:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098c:	89 d6                	mov    %edx,%esi
  80098e:	09 fe                	or     %edi,%esi
  800990:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800996:	74 0c                	je     8009a4 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800998:	83 ef 01             	sub    $0x1,%edi
  80099b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80099e:	fd                   	std    
  80099f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a1:	fc                   	cld    
  8009a2:	eb 21                	jmp    8009c5 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a4:	f6 c1 03             	test   $0x3,%cl
  8009a7:	75 ef                	jne    800998 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a9:	83 ef 04             	sub    $0x4,%edi
  8009ac:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009af:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009b2:	fd                   	std    
  8009b3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b5:	eb ea                	jmp    8009a1 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b7:	89 f2                	mov    %esi,%edx
  8009b9:	09 c2                	or     %eax,%edx
  8009bb:	f6 c2 03             	test   $0x3,%dl
  8009be:	74 09                	je     8009c9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009c0:	89 c7                	mov    %eax,%edi
  8009c2:	fc                   	cld    
  8009c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c5:	5e                   	pop    %esi
  8009c6:	5f                   	pop    %edi
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c9:	f6 c1 03             	test   $0x3,%cl
  8009cc:	75 f2                	jne    8009c0 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ce:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d1:	89 c7                	mov    %eax,%edi
  8009d3:	fc                   	cld    
  8009d4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d6:	eb ed                	jmp    8009c5 <memmove+0x55>

008009d8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009db:	ff 75 10             	pushl  0x10(%ebp)
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	ff 75 08             	pushl  0x8(%ebp)
  8009e4:	e8 87 ff ff ff       	call   800970 <memmove>
}
  8009e9:	c9                   	leave  
  8009ea:	c3                   	ret    

008009eb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	56                   	push   %esi
  8009ef:	53                   	push   %ebx
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f6:	89 c6                	mov    %eax,%esi
  8009f8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fb:	39 f0                	cmp    %esi,%eax
  8009fd:	74 1c                	je     800a1b <memcmp+0x30>
		if (*s1 != *s2)
  8009ff:	0f b6 08             	movzbl (%eax),%ecx
  800a02:	0f b6 1a             	movzbl (%edx),%ebx
  800a05:	38 d9                	cmp    %bl,%cl
  800a07:	75 08                	jne    800a11 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	83 c2 01             	add    $0x1,%edx
  800a0f:	eb ea                	jmp    8009fb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a11:	0f b6 c1             	movzbl %cl,%eax
  800a14:	0f b6 db             	movzbl %bl,%ebx
  800a17:	29 d8                	sub    %ebx,%eax
  800a19:	eb 05                	jmp    800a20 <memcmp+0x35>
	}

	return 0;
  800a1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a20:	5b                   	pop    %ebx
  800a21:	5e                   	pop    %esi
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2d:	89 c2                	mov    %eax,%edx
  800a2f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a32:	39 d0                	cmp    %edx,%eax
  800a34:	73 09                	jae    800a3f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a36:	38 08                	cmp    %cl,(%eax)
  800a38:	74 05                	je     800a3f <memfind+0x1b>
	for (; s < ends; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	eb f3                	jmp    800a32 <memfind+0xe>
			break;
	return (void *) s;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	57                   	push   %edi
  800a45:	56                   	push   %esi
  800a46:	53                   	push   %ebx
  800a47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4d:	eb 03                	jmp    800a52 <strtol+0x11>
		s++;
  800a4f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a52:	0f b6 01             	movzbl (%ecx),%eax
  800a55:	3c 20                	cmp    $0x20,%al
  800a57:	74 f6                	je     800a4f <strtol+0xe>
  800a59:	3c 09                	cmp    $0x9,%al
  800a5b:	74 f2                	je     800a4f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a5d:	3c 2b                	cmp    $0x2b,%al
  800a5f:	74 2e                	je     800a8f <strtol+0x4e>
	int neg = 0;
  800a61:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a66:	3c 2d                	cmp    $0x2d,%al
  800a68:	74 2f                	je     800a99 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a70:	75 05                	jne    800a77 <strtol+0x36>
  800a72:	80 39 30             	cmpb   $0x30,(%ecx)
  800a75:	74 2c                	je     800aa3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a77:	85 db                	test   %ebx,%ebx
  800a79:	75 0a                	jne    800a85 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a7b:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a80:	80 39 30             	cmpb   $0x30,(%ecx)
  800a83:	74 28                	je     800aad <strtol+0x6c>
		base = 10;
  800a85:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a8d:	eb 50                	jmp    800adf <strtol+0x9e>
		s++;
  800a8f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a92:	bf 00 00 00 00       	mov    $0x0,%edi
  800a97:	eb d1                	jmp    800a6a <strtol+0x29>
		s++, neg = 1;
  800a99:	83 c1 01             	add    $0x1,%ecx
  800a9c:	bf 01 00 00 00       	mov    $0x1,%edi
  800aa1:	eb c7                	jmp    800a6a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aa7:	74 0e                	je     800ab7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa9:	85 db                	test   %ebx,%ebx
  800aab:	75 d8                	jne    800a85 <strtol+0x44>
		s++, base = 8;
  800aad:	83 c1 01             	add    $0x1,%ecx
  800ab0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ab5:	eb ce                	jmp    800a85 <strtol+0x44>
		s += 2, base = 16;
  800ab7:	83 c1 02             	add    $0x2,%ecx
  800aba:	bb 10 00 00 00       	mov    $0x10,%ebx
  800abf:	eb c4                	jmp    800a85 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ac1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ac4:	89 f3                	mov    %esi,%ebx
  800ac6:	80 fb 19             	cmp    $0x19,%bl
  800ac9:	77 29                	ja     800af4 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800acb:	0f be d2             	movsbl %dl,%edx
  800ace:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ad1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ad4:	7d 30                	jge    800b06 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ad6:	83 c1 01             	add    $0x1,%ecx
  800ad9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800add:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800adf:	0f b6 11             	movzbl (%ecx),%edx
  800ae2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ae5:	89 f3                	mov    %esi,%ebx
  800ae7:	80 fb 09             	cmp    $0x9,%bl
  800aea:	77 d5                	ja     800ac1 <strtol+0x80>
			dig = *s - '0';
  800aec:	0f be d2             	movsbl %dl,%edx
  800aef:	83 ea 30             	sub    $0x30,%edx
  800af2:	eb dd                	jmp    800ad1 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800af4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800af7:	89 f3                	mov    %esi,%ebx
  800af9:	80 fb 19             	cmp    $0x19,%bl
  800afc:	77 08                	ja     800b06 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800afe:	0f be d2             	movsbl %dl,%edx
  800b01:	83 ea 37             	sub    $0x37,%edx
  800b04:	eb cb                	jmp    800ad1 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0a:	74 05                	je     800b11 <strtol+0xd0>
		*endptr = (char *) s;
  800b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	f7 da                	neg    %edx
  800b15:	85 ff                	test   %edi,%edi
  800b17:	0f 45 c2             	cmovne %edx,%eax
}
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5f                   	pop    %edi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	57                   	push   %edi
  800b23:	56                   	push   %esi
  800b24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b25:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b30:	89 c3                	mov    %eax,%ebx
  800b32:	89 c7                	mov    %eax,%edi
  800b34:	89 c6                	mov    %eax,%esi
  800b36:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <sys_cgetc>:

int
sys_cgetc(void)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	57                   	push   %edi
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
  800b48:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4d:	89 d1                	mov    %edx,%ecx
  800b4f:	89 d3                	mov    %edx,%ebx
  800b51:	89 d7                	mov    %edx,%edi
  800b53:	89 d6                	mov    %edx,%esi
  800b55:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	57                   	push   %edi
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b72:	89 cb                	mov    %ecx,%ebx
  800b74:	89 cf                	mov    %ecx,%edi
  800b76:	89 ce                	mov    %ecx,%esi
  800b78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b7a:	85 c0                	test   %eax,%eax
  800b7c:	7f 08                	jg     800b86 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b81:	5b                   	pop    %ebx
  800b82:	5e                   	pop    %esi
  800b83:	5f                   	pop    %edi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	50                   	push   %eax
  800b8a:	6a 03                	push   $0x3
  800b8c:	68 ff 23 80 00       	push   $0x8023ff
  800b91:	6a 23                	push   $0x23
  800b93:	68 1c 24 80 00       	push   $0x80241c
  800b98:	e8 8a 11 00 00       	call   801d27 <_panic>

00800b9d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	57                   	push   %edi
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba8:	b8 02 00 00 00       	mov    $0x2,%eax
  800bad:	89 d1                	mov    %edx,%ecx
  800baf:	89 d3                	mov    %edx,%ebx
  800bb1:	89 d7                	mov    %edx,%edi
  800bb3:	89 d6                	mov    %edx,%esi
  800bb5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <sys_yield>:

void
sys_yield(void)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bcc:	89 d1                	mov    %edx,%ecx
  800bce:	89 d3                	mov    %edx,%ebx
  800bd0:	89 d7                	mov    %edx,%edi
  800bd2:	89 d6                	mov    %edx,%esi
  800bd4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	57                   	push   %edi
  800bdf:	56                   	push   %esi
  800be0:	53                   	push   %ebx
  800be1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be4:	be 00 00 00 00       	mov    $0x0,%esi
  800be9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bef:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf7:	89 f7                	mov    %esi,%edi
  800bf9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfb:	85 c0                	test   %eax,%eax
  800bfd:	7f 08                	jg     800c07 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c07:	83 ec 0c             	sub    $0xc,%esp
  800c0a:	50                   	push   %eax
  800c0b:	6a 04                	push   $0x4
  800c0d:	68 ff 23 80 00       	push   $0x8023ff
  800c12:	6a 23                	push   $0x23
  800c14:	68 1c 24 80 00       	push   $0x80241c
  800c19:	e8 09 11 00 00       	call   801d27 <_panic>

00800c1e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c38:	8b 75 18             	mov    0x18(%ebp),%esi
  800c3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	7f 08                	jg     800c49 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c49:	83 ec 0c             	sub    $0xc,%esp
  800c4c:	50                   	push   %eax
  800c4d:	6a 05                	push   $0x5
  800c4f:	68 ff 23 80 00       	push   $0x8023ff
  800c54:	6a 23                	push   $0x23
  800c56:	68 1c 24 80 00       	push   $0x80241c
  800c5b:	e8 c7 10 00 00       	call   801d27 <_panic>

00800c60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	b8 06 00 00 00       	mov    $0x6,%eax
  800c79:	89 df                	mov    %ebx,%edi
  800c7b:	89 de                	mov    %ebx,%esi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 06                	push   $0x6
  800c91:	68 ff 23 80 00       	push   $0x8023ff
  800c96:	6a 23                	push   $0x23
  800c98:	68 1c 24 80 00       	push   $0x80241c
  800c9d:	e8 85 10 00 00       	call   801d27 <_panic>

00800ca2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb6:	b8 08 00 00 00       	mov    $0x8,%eax
  800cbb:	89 df                	mov    %ebx,%edi
  800cbd:	89 de                	mov    %ebx,%esi
  800cbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7f 08                	jg     800ccd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccd:	83 ec 0c             	sub    $0xc,%esp
  800cd0:	50                   	push   %eax
  800cd1:	6a 08                	push   $0x8
  800cd3:	68 ff 23 80 00       	push   $0x8023ff
  800cd8:	6a 23                	push   $0x23
  800cda:	68 1c 24 80 00       	push   $0x80241c
  800cdf:	e8 43 10 00 00       	call   801d27 <_panic>

00800ce4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	b8 09 00 00 00       	mov    $0x9,%eax
  800cfd:	89 df                	mov    %ebx,%edi
  800cff:	89 de                	mov    %ebx,%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 09                	push   $0x9
  800d15:	68 ff 23 80 00       	push   $0x8023ff
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 1c 24 80 00       	push   $0x80241c
  800d21:	e8 01 10 00 00       	call   801d27 <_panic>

00800d26 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d3f:	89 df                	mov    %ebx,%edi
  800d41:	89 de                	mov    %ebx,%esi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 0a                	push   $0xa
  800d57:	68 ff 23 80 00       	push   $0x8023ff
  800d5c:	6a 23                	push   $0x23
  800d5e:	68 1c 24 80 00       	push   $0x80241c
  800d63:	e8 bf 0f 00 00       	call   801d27 <_panic>

00800d68 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d74:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d79:	be 00 00 00 00       	mov    $0x0,%esi
  800d7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d84:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d94:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800da1:	89 cb                	mov    %ecx,%ebx
  800da3:	89 cf                	mov    %ecx,%edi
  800da5:	89 ce                	mov    %ecx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	50                   	push   %eax
  800db9:	6a 0d                	push   $0xd
  800dbb:	68 ff 23 80 00       	push   $0x8023ff
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 1c 24 80 00       	push   $0x80241c
  800dc7:	e8 5b 0f 00 00       	call   801d27 <_panic>

00800dcc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800dd2:	68 2a 24 80 00       	push   $0x80242a
  800dd7:	6a 25                	push   $0x25
  800dd9:	68 42 24 80 00       	push   $0x802442
  800dde:	e8 44 0f 00 00       	call   801d27 <_panic>

00800de3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800dec:	68 cc 0d 80 00       	push   $0x800dcc
  800df1:	e8 77 0f 00 00       	call   801d6d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800df6:	b8 07 00 00 00       	mov    $0x7,%eax
  800dfb:	cd 30                	int    $0x30
  800dfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800e03:	83 c4 10             	add    $0x10,%esp
  800e06:	85 c0                	test   %eax,%eax
  800e08:	78 27                	js     800e31 <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800e0a:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800e0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e13:	75 65                	jne    800e7a <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800e15:	e8 83 fd ff ff       	call   800b9d <sys_getenvid>
  800e1a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800e1f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800e22:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e27:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800e2c:	e9 11 01 00 00       	jmp    800f42 <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800e31:	50                   	push   %eax
  800e32:	68 4d 24 80 00       	push   $0x80244d
  800e37:	6a 6f                	push   $0x6f
  800e39:	68 42 24 80 00       	push   $0x802442
  800e3e:	e8 e4 0e 00 00       	call   801d27 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800e43:	e8 55 fd ff ff       	call   800b9d <sys_getenvid>
  800e48:	83 ec 0c             	sub    $0xc,%esp
  800e4b:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800e51:	56                   	push   %esi
  800e52:	57                   	push   %edi
  800e53:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e56:	57                   	push   %edi
  800e57:	50                   	push   %eax
  800e58:	e8 c1 fd ff ff       	call   800c1e <sys_page_map>
  800e5d:	83 c4 20             	add    $0x20,%esp
  800e60:	85 c0                	test   %eax,%eax
  800e62:	0f 88 84 00 00 00    	js     800eec <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800e68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800e6e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800e74:	0f 84 84 00 00 00    	je     800efe <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800e7a:	89 d8                	mov    %ebx,%eax
  800e7c:	c1 e8 16             	shr    $0x16,%eax
  800e7f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e86:	a8 01                	test   $0x1,%al
  800e88:	74 de                	je     800e68 <fork+0x85>
  800e8a:	89 d8                	mov    %ebx,%eax
  800e8c:	c1 e8 0c             	shr    $0xc,%eax
  800e8f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e96:	f6 c2 01             	test   $0x1,%dl
  800e99:	74 cd                	je     800e68 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800e9b:	89 c7                	mov    %eax,%edi
  800e9d:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800ea0:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800ea7:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800ead:	75 94                	jne    800e43 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800eaf:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800eb5:	0f 85 d1 00 00 00    	jne    800f8c <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800ebb:	a1 08 40 80 00       	mov    0x804008,%eax
  800ec0:	8b 40 48             	mov    0x48(%eax),%eax
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	6a 05                	push   $0x5
  800ec8:	57                   	push   %edi
  800ec9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ecc:	57                   	push   %edi
  800ecd:	50                   	push   %eax
  800ece:	e8 4b fd ff ff       	call   800c1e <sys_page_map>
  800ed3:	83 c4 20             	add    $0x20,%esp
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	79 8e                	jns    800e68 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800eda:	50                   	push   %eax
  800edb:	68 a4 24 80 00       	push   $0x8024a4
  800ee0:	6a 4a                	push   $0x4a
  800ee2:	68 42 24 80 00       	push   $0x802442
  800ee7:	e8 3b 0e 00 00       	call   801d27 <_panic>
                        panic("duppage: page mapping failed %e", r);
  800eec:	50                   	push   %eax
  800eed:	68 84 24 80 00       	push   $0x802484
  800ef2:	6a 41                	push   $0x41
  800ef4:	68 42 24 80 00       	push   $0x802442
  800ef9:	e8 29 0e 00 00       	call   801d27 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800efe:	83 ec 04             	sub    $0x4,%esp
  800f01:	6a 07                	push   $0x7
  800f03:	68 00 f0 bf ee       	push   $0xeebff000
  800f08:	ff 75 e0             	pushl  -0x20(%ebp)
  800f0b:	e8 cb fc ff ff       	call   800bdb <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  800f10:	83 c4 10             	add    $0x10,%esp
  800f13:	85 c0                	test   %eax,%eax
  800f15:	78 36                	js     800f4d <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800f17:	83 ec 08             	sub    $0x8,%esp
  800f1a:	68 e1 1d 80 00       	push   $0x801de1
  800f1f:	ff 75 e0             	pushl  -0x20(%ebp)
  800f22:	e8 ff fd ff ff       	call   800d26 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f27:	83 c4 10             	add    $0x10,%esp
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	78 34                	js     800f62 <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	6a 02                	push   $0x2
  800f33:	ff 75 e0             	pushl  -0x20(%ebp)
  800f36:	e8 67 fd ff ff       	call   800ca2 <sys_env_set_status>
  800f3b:	83 c4 10             	add    $0x10,%esp
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	78 35                	js     800f77 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  800f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	5f                   	pop    %edi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  800f4d:	50                   	push   %eax
  800f4e:	68 4d 24 80 00       	push   $0x80244d
  800f53:	68 82 00 00 00       	push   $0x82
  800f58:	68 42 24 80 00       	push   $0x802442
  800f5d:	e8 c5 0d 00 00       	call   801d27 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f62:	50                   	push   %eax
  800f63:	68 c8 24 80 00       	push   $0x8024c8
  800f68:	68 87 00 00 00       	push   $0x87
  800f6d:	68 42 24 80 00       	push   $0x802442
  800f72:	e8 b0 0d 00 00       	call   801d27 <_panic>
        	panic("sys_env_set_status: %e", r);
  800f77:	50                   	push   %eax
  800f78:	68 56 24 80 00       	push   $0x802456
  800f7d:	68 8b 00 00 00       	push   $0x8b
  800f82:	68 42 24 80 00       	push   $0x802442
  800f87:	e8 9b 0d 00 00       	call   801d27 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800f8c:	a1 08 40 80 00       	mov    0x804008,%eax
  800f91:	8b 40 48             	mov    0x48(%eax),%eax
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	68 05 08 00 00       	push   $0x805
  800f9c:	57                   	push   %edi
  800f9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fa0:	57                   	push   %edi
  800fa1:	50                   	push   %eax
  800fa2:	e8 77 fc ff ff       	call   800c1e <sys_page_map>
  800fa7:	83 c4 20             	add    $0x20,%esp
  800faa:	85 c0                	test   %eax,%eax
  800fac:	0f 88 28 ff ff ff    	js     800eda <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  800fb2:	a1 08 40 80 00       	mov    0x804008,%eax
  800fb7:	8b 50 48             	mov    0x48(%eax),%edx
  800fba:	8b 40 48             	mov    0x48(%eax),%eax
  800fbd:	83 ec 0c             	sub    $0xc,%esp
  800fc0:	68 05 08 00 00       	push   $0x805
  800fc5:	57                   	push   %edi
  800fc6:	52                   	push   %edx
  800fc7:	57                   	push   %edi
  800fc8:	50                   	push   %eax
  800fc9:	e8 50 fc ff ff       	call   800c1e <sys_page_map>
  800fce:	83 c4 20             	add    $0x20,%esp
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	0f 89 8f fe ff ff    	jns    800e68 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  800fd9:	50                   	push   %eax
  800fda:	68 a4 24 80 00       	push   $0x8024a4
  800fdf:	6a 4f                	push   $0x4f
  800fe1:	68 42 24 80 00       	push   $0x802442
  800fe6:	e8 3c 0d 00 00       	call   801d27 <_panic>

00800feb <sfork>:

// Challenge!
int
sfork(void)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800ff1:	68 6d 24 80 00       	push   $0x80246d
  800ff6:	68 94 00 00 00       	push   $0x94
  800ffb:	68 42 24 80 00       	push   $0x802442
  801000:	e8 22 0d 00 00       	call   801d27 <_panic>

00801005 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80100b:	68 ec 24 80 00       	push   $0x8024ec
  801010:	6a 1a                	push   $0x1a
  801012:	68 05 25 80 00       	push   $0x802505
  801017:	e8 0b 0d 00 00       	call   801d27 <_panic>

0080101c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801022:	68 0f 25 80 00       	push   $0x80250f
  801027:	6a 2a                	push   $0x2a
  801029:	68 05 25 80 00       	push   $0x802505
  80102e:	e8 f4 0c 00 00       	call   801d27 <_panic>

00801033 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80103e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801041:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801047:	8b 52 50             	mov    0x50(%edx),%edx
  80104a:	39 ca                	cmp    %ecx,%edx
  80104c:	74 11                	je     80105f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80104e:	83 c0 01             	add    $0x1,%eax
  801051:	3d 00 04 00 00       	cmp    $0x400,%eax
  801056:	75 e6                	jne    80103e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
  80105d:	eb 0b                	jmp    80106a <ipc_find_env+0x37>
			return envs[i].env_id;
  80105f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801067:	8b 40 48             	mov    0x48(%eax),%eax
}
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	05 00 00 00 30       	add    $0x30000000,%eax
  801077:	c1 e8 0c             	shr    $0xc,%eax
}
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80108c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    

00801093 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801099:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80109e:	89 c2                	mov    %eax,%edx
  8010a0:	c1 ea 16             	shr    $0x16,%edx
  8010a3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010aa:	f6 c2 01             	test   $0x1,%dl
  8010ad:	74 2a                	je     8010d9 <fd_alloc+0x46>
  8010af:	89 c2                	mov    %eax,%edx
  8010b1:	c1 ea 0c             	shr    $0xc,%edx
  8010b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010bb:	f6 c2 01             	test   $0x1,%dl
  8010be:	74 19                	je     8010d9 <fd_alloc+0x46>
  8010c0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010c5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010ca:	75 d2                	jne    80109e <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010cc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010d2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010d7:	eb 07                	jmp    8010e0 <fd_alloc+0x4d>
			*fd_store = fd;
  8010d9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    

008010e2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010e8:	83 f8 1f             	cmp    $0x1f,%eax
  8010eb:	77 36                	ja     801123 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010ed:	c1 e0 0c             	shl    $0xc,%eax
  8010f0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010f5:	89 c2                	mov    %eax,%edx
  8010f7:	c1 ea 16             	shr    $0x16,%edx
  8010fa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801101:	f6 c2 01             	test   $0x1,%dl
  801104:	74 24                	je     80112a <fd_lookup+0x48>
  801106:	89 c2                	mov    %eax,%edx
  801108:	c1 ea 0c             	shr    $0xc,%edx
  80110b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801112:	f6 c2 01             	test   $0x1,%dl
  801115:	74 1a                	je     801131 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801117:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111a:	89 02                	mov    %eax,(%edx)
	return 0;
  80111c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801121:	5d                   	pop    %ebp
  801122:	c3                   	ret    
		return -E_INVAL;
  801123:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801128:	eb f7                	jmp    801121 <fd_lookup+0x3f>
		return -E_INVAL;
  80112a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112f:	eb f0                	jmp    801121 <fd_lookup+0x3f>
  801131:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801136:	eb e9                	jmp    801121 <fd_lookup+0x3f>

00801138 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801141:	ba a4 25 80 00       	mov    $0x8025a4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801146:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80114b:	39 08                	cmp    %ecx,(%eax)
  80114d:	74 33                	je     801182 <dev_lookup+0x4a>
  80114f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801152:	8b 02                	mov    (%edx),%eax
  801154:	85 c0                	test   %eax,%eax
  801156:	75 f3                	jne    80114b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801158:	a1 08 40 80 00       	mov    0x804008,%eax
  80115d:	8b 40 48             	mov    0x48(%eax),%eax
  801160:	83 ec 04             	sub    $0x4,%esp
  801163:	51                   	push   %ecx
  801164:	50                   	push   %eax
  801165:	68 28 25 80 00       	push   $0x802528
  80116a:	e8 89 f0 ff ff       	call   8001f8 <cprintf>
	*dev = 0;
  80116f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801172:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    
			*dev = devtab[i];
  801182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801185:	89 01                	mov    %eax,(%ecx)
			return 0;
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
  80118c:	eb f2                	jmp    801180 <dev_lookup+0x48>

0080118e <fd_close>:
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	83 ec 1c             	sub    $0x1c,%esp
  801197:	8b 75 08             	mov    0x8(%ebp),%esi
  80119a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80119d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011a0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011a7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011aa:	50                   	push   %eax
  8011ab:	e8 32 ff ff ff       	call   8010e2 <fd_lookup>
  8011b0:	89 c3                	mov    %eax,%ebx
  8011b2:	83 c4 08             	add    $0x8,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	78 05                	js     8011be <fd_close+0x30>
	    || fd != fd2)
  8011b9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011bc:	74 16                	je     8011d4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011be:	89 f8                	mov    %edi,%eax
  8011c0:	84 c0                	test   %al,%al
  8011c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c7:	0f 44 d8             	cmove  %eax,%ebx
}
  8011ca:	89 d8                	mov    %ebx,%eax
  8011cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cf:	5b                   	pop    %ebx
  8011d0:	5e                   	pop    %esi
  8011d1:	5f                   	pop    %edi
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011d4:	83 ec 08             	sub    $0x8,%esp
  8011d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	ff 36                	pushl  (%esi)
  8011dd:	e8 56 ff ff ff       	call   801138 <dev_lookup>
  8011e2:	89 c3                	mov    %eax,%ebx
  8011e4:	83 c4 10             	add    $0x10,%esp
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	78 15                	js     801200 <fd_close+0x72>
		if (dev->dev_close)
  8011eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ee:	8b 40 10             	mov    0x10(%eax),%eax
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	74 1b                	je     801210 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	56                   	push   %esi
  8011f9:	ff d0                	call   *%eax
  8011fb:	89 c3                	mov    %eax,%ebx
  8011fd:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801200:	83 ec 08             	sub    $0x8,%esp
  801203:	56                   	push   %esi
  801204:	6a 00                	push   $0x0
  801206:	e8 55 fa ff ff       	call   800c60 <sys_page_unmap>
	return r;
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	eb ba                	jmp    8011ca <fd_close+0x3c>
			r = 0;
  801210:	bb 00 00 00 00       	mov    $0x0,%ebx
  801215:	eb e9                	jmp    801200 <fd_close+0x72>

00801217 <close>:

int
close(int fdnum)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80121d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801220:	50                   	push   %eax
  801221:	ff 75 08             	pushl  0x8(%ebp)
  801224:	e8 b9 fe ff ff       	call   8010e2 <fd_lookup>
  801229:	83 c4 08             	add    $0x8,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	78 10                	js     801240 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801230:	83 ec 08             	sub    $0x8,%esp
  801233:	6a 01                	push   $0x1
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	e8 51 ff ff ff       	call   80118e <fd_close>
  80123d:	83 c4 10             	add    $0x10,%esp
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <close_all>:

void
close_all(void)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	53                   	push   %ebx
  801246:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801249:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	53                   	push   %ebx
  801252:	e8 c0 ff ff ff       	call   801217 <close>
	for (i = 0; i < MAXFD; i++)
  801257:	83 c3 01             	add    $0x1,%ebx
  80125a:	83 c4 10             	add    $0x10,%esp
  80125d:	83 fb 20             	cmp    $0x20,%ebx
  801260:	75 ec                	jne    80124e <close_all+0xc>
}
  801262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
  80126d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801270:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801273:	50                   	push   %eax
  801274:	ff 75 08             	pushl  0x8(%ebp)
  801277:	e8 66 fe ff ff       	call   8010e2 <fd_lookup>
  80127c:	89 c3                	mov    %eax,%ebx
  80127e:	83 c4 08             	add    $0x8,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	0f 88 81 00 00 00    	js     80130a <dup+0xa3>
		return r;
	close(newfdnum);
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	ff 75 0c             	pushl  0xc(%ebp)
  80128f:	e8 83 ff ff ff       	call   801217 <close>

	newfd = INDEX2FD(newfdnum);
  801294:	8b 75 0c             	mov    0xc(%ebp),%esi
  801297:	c1 e6 0c             	shl    $0xc,%esi
  80129a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012a0:	83 c4 04             	add    $0x4,%esp
  8012a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012a6:	e8 d1 fd ff ff       	call   80107c <fd2data>
  8012ab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012ad:	89 34 24             	mov    %esi,(%esp)
  8012b0:	e8 c7 fd ff ff       	call   80107c <fd2data>
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ba:	89 d8                	mov    %ebx,%eax
  8012bc:	c1 e8 16             	shr    $0x16,%eax
  8012bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c6:	a8 01                	test   $0x1,%al
  8012c8:	74 11                	je     8012db <dup+0x74>
  8012ca:	89 d8                	mov    %ebx,%eax
  8012cc:	c1 e8 0c             	shr    $0xc,%eax
  8012cf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012d6:	f6 c2 01             	test   $0x1,%dl
  8012d9:	75 39                	jne    801314 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012de:	89 d0                	mov    %edx,%eax
  8012e0:	c1 e8 0c             	shr    $0xc,%eax
  8012e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ea:	83 ec 0c             	sub    $0xc,%esp
  8012ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f2:	50                   	push   %eax
  8012f3:	56                   	push   %esi
  8012f4:	6a 00                	push   $0x0
  8012f6:	52                   	push   %edx
  8012f7:	6a 00                	push   $0x0
  8012f9:	e8 20 f9 ff ff       	call   800c1e <sys_page_map>
  8012fe:	89 c3                	mov    %eax,%ebx
  801300:	83 c4 20             	add    $0x20,%esp
  801303:	85 c0                	test   %eax,%eax
  801305:	78 31                	js     801338 <dup+0xd1>
		goto err;

	return newfdnum;
  801307:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80130a:	89 d8                	mov    %ebx,%eax
  80130c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130f:	5b                   	pop    %ebx
  801310:	5e                   	pop    %esi
  801311:	5f                   	pop    %edi
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801314:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80131b:	83 ec 0c             	sub    $0xc,%esp
  80131e:	25 07 0e 00 00       	and    $0xe07,%eax
  801323:	50                   	push   %eax
  801324:	57                   	push   %edi
  801325:	6a 00                	push   $0x0
  801327:	53                   	push   %ebx
  801328:	6a 00                	push   $0x0
  80132a:	e8 ef f8 ff ff       	call   800c1e <sys_page_map>
  80132f:	89 c3                	mov    %eax,%ebx
  801331:	83 c4 20             	add    $0x20,%esp
  801334:	85 c0                	test   %eax,%eax
  801336:	79 a3                	jns    8012db <dup+0x74>
	sys_page_unmap(0, newfd);
  801338:	83 ec 08             	sub    $0x8,%esp
  80133b:	56                   	push   %esi
  80133c:	6a 00                	push   $0x0
  80133e:	e8 1d f9 ff ff       	call   800c60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801343:	83 c4 08             	add    $0x8,%esp
  801346:	57                   	push   %edi
  801347:	6a 00                	push   $0x0
  801349:	e8 12 f9 ff ff       	call   800c60 <sys_page_unmap>
	return r;
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	eb b7                	jmp    80130a <dup+0xa3>

00801353 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	53                   	push   %ebx
  801357:	83 ec 14             	sub    $0x14,%esp
  80135a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80135d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801360:	50                   	push   %eax
  801361:	53                   	push   %ebx
  801362:	e8 7b fd ff ff       	call   8010e2 <fd_lookup>
  801367:	83 c4 08             	add    $0x8,%esp
  80136a:	85 c0                	test   %eax,%eax
  80136c:	78 3f                	js     8013ad <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801378:	ff 30                	pushl  (%eax)
  80137a:	e8 b9 fd ff ff       	call   801138 <dev_lookup>
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	78 27                	js     8013ad <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801386:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801389:	8b 42 08             	mov    0x8(%edx),%eax
  80138c:	83 e0 03             	and    $0x3,%eax
  80138f:	83 f8 01             	cmp    $0x1,%eax
  801392:	74 1e                	je     8013b2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	8b 40 08             	mov    0x8(%eax),%eax
  80139a:	85 c0                	test   %eax,%eax
  80139c:	74 35                	je     8013d3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80139e:	83 ec 04             	sub    $0x4,%esp
  8013a1:	ff 75 10             	pushl  0x10(%ebp)
  8013a4:	ff 75 0c             	pushl  0xc(%ebp)
  8013a7:	52                   	push   %edx
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
}
  8013ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8013b7:	8b 40 48             	mov    0x48(%eax),%eax
  8013ba:	83 ec 04             	sub    $0x4,%esp
  8013bd:	53                   	push   %ebx
  8013be:	50                   	push   %eax
  8013bf:	68 69 25 80 00       	push   $0x802569
  8013c4:	e8 2f ee ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d1:	eb da                	jmp    8013ad <read+0x5a>
		return -E_NOT_SUPP;
  8013d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d8:	eb d3                	jmp    8013ad <read+0x5a>

008013da <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	57                   	push   %edi
  8013de:	56                   	push   %esi
  8013df:	53                   	push   %ebx
  8013e0:	83 ec 0c             	sub    $0xc,%esp
  8013e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ee:	39 f3                	cmp    %esi,%ebx
  8013f0:	73 25                	jae    801417 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	89 f0                	mov    %esi,%eax
  8013f7:	29 d8                	sub    %ebx,%eax
  8013f9:	50                   	push   %eax
  8013fa:	89 d8                	mov    %ebx,%eax
  8013fc:	03 45 0c             	add    0xc(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	57                   	push   %edi
  801401:	e8 4d ff ff ff       	call   801353 <read>
		if (m < 0)
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 08                	js     801415 <readn+0x3b>
			return m;
		if (m == 0)
  80140d:	85 c0                	test   %eax,%eax
  80140f:	74 06                	je     801417 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801411:	01 c3                	add    %eax,%ebx
  801413:	eb d9                	jmp    8013ee <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801415:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801417:	89 d8                	mov    %ebx,%eax
  801419:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141c:	5b                   	pop    %ebx
  80141d:	5e                   	pop    %esi
  80141e:	5f                   	pop    %edi
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    

00801421 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	53                   	push   %ebx
  801425:	83 ec 14             	sub    $0x14,%esp
  801428:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142e:	50                   	push   %eax
  80142f:	53                   	push   %ebx
  801430:	e8 ad fc ff ff       	call   8010e2 <fd_lookup>
  801435:	83 c4 08             	add    $0x8,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	78 3a                	js     801476 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143c:	83 ec 08             	sub    $0x8,%esp
  80143f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801446:	ff 30                	pushl  (%eax)
  801448:	e8 eb fc ff ff       	call   801138 <dev_lookup>
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	78 22                	js     801476 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801457:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145b:	74 1e                	je     80147b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80145d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801460:	8b 52 0c             	mov    0xc(%edx),%edx
  801463:	85 d2                	test   %edx,%edx
  801465:	74 35                	je     80149c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	ff 75 10             	pushl  0x10(%ebp)
  80146d:	ff 75 0c             	pushl  0xc(%ebp)
  801470:	50                   	push   %eax
  801471:	ff d2                	call   *%edx
  801473:	83 c4 10             	add    $0x10,%esp
}
  801476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801479:	c9                   	leave  
  80147a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80147b:	a1 08 40 80 00       	mov    0x804008,%eax
  801480:	8b 40 48             	mov    0x48(%eax),%eax
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	53                   	push   %ebx
  801487:	50                   	push   %eax
  801488:	68 85 25 80 00       	push   $0x802585
  80148d:	e8 66 ed ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149a:	eb da                	jmp    801476 <write+0x55>
		return -E_NOT_SUPP;
  80149c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a1:	eb d3                	jmp    801476 <write+0x55>

008014a3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a9:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014ac:	50                   	push   %eax
  8014ad:	ff 75 08             	pushl  0x8(%ebp)
  8014b0:	e8 2d fc ff ff       	call   8010e2 <fd_lookup>
  8014b5:	83 c4 08             	add    $0x8,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 0e                	js     8014ca <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 14             	sub    $0x14,%esp
  8014d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d9:	50                   	push   %eax
  8014da:	53                   	push   %ebx
  8014db:	e8 02 fc ff ff       	call   8010e2 <fd_lookup>
  8014e0:	83 c4 08             	add    $0x8,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	78 37                	js     80151e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e7:	83 ec 08             	sub    $0x8,%esp
  8014ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ed:	50                   	push   %eax
  8014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f1:	ff 30                	pushl  (%eax)
  8014f3:	e8 40 fc ff ff       	call   801138 <dev_lookup>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 1f                	js     80151e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801502:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801506:	74 1b                	je     801523 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150b:	8b 52 18             	mov    0x18(%edx),%edx
  80150e:	85 d2                	test   %edx,%edx
  801510:	74 32                	je     801544 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801512:	83 ec 08             	sub    $0x8,%esp
  801515:	ff 75 0c             	pushl  0xc(%ebp)
  801518:	50                   	push   %eax
  801519:	ff d2                	call   *%edx
  80151b:	83 c4 10             	add    $0x10,%esp
}
  80151e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801521:	c9                   	leave  
  801522:	c3                   	ret    
			thisenv->env_id, fdnum);
  801523:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801528:	8b 40 48             	mov    0x48(%eax),%eax
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	53                   	push   %ebx
  80152f:	50                   	push   %eax
  801530:	68 48 25 80 00       	push   $0x802548
  801535:	e8 be ec ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801542:	eb da                	jmp    80151e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801544:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801549:	eb d3                	jmp    80151e <ftruncate+0x52>

0080154b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	53                   	push   %ebx
  80154f:	83 ec 14             	sub    $0x14,%esp
  801552:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801555:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801558:	50                   	push   %eax
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 81 fb ff ff       	call   8010e2 <fd_lookup>
  801561:	83 c4 08             	add    $0x8,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 4b                	js     8015b3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801568:	83 ec 08             	sub    $0x8,%esp
  80156b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156e:	50                   	push   %eax
  80156f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801572:	ff 30                	pushl  (%eax)
  801574:	e8 bf fb ff ff       	call   801138 <dev_lookup>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 33                	js     8015b3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801583:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801587:	74 2f                	je     8015b8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801589:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80158c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801593:	00 00 00 
	stat->st_isdir = 0;
  801596:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80159d:	00 00 00 
	stat->st_dev = dev;
  8015a0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	53                   	push   %ebx
  8015aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8015ad:	ff 50 14             	call   *0x14(%eax)
  8015b0:	83 c4 10             	add    $0x10,%esp
}
  8015b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    
		return -E_NOT_SUPP;
  8015b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015bd:	eb f4                	jmp    8015b3 <fstat+0x68>

008015bf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	56                   	push   %esi
  8015c3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	6a 00                	push   $0x0
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	e8 e7 01 00 00       	call   8017b8 <open>
  8015d1:	89 c3                	mov    %eax,%ebx
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 1b                	js     8015f5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	50                   	push   %eax
  8015e1:	e8 65 ff ff ff       	call   80154b <fstat>
  8015e6:	89 c6                	mov    %eax,%esi
	close(fd);
  8015e8:	89 1c 24             	mov    %ebx,(%esp)
  8015eb:	e8 27 fc ff ff       	call   801217 <close>
	return r;
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	89 f3                	mov    %esi,%ebx
}
  8015f5:	89 d8                	mov    %ebx,%eax
  8015f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5d                   	pop    %ebp
  8015fd:	c3                   	ret    

008015fe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	56                   	push   %esi
  801602:	53                   	push   %ebx
  801603:	89 c6                	mov    %eax,%esi
  801605:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801607:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80160e:	74 27                	je     801637 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801610:	6a 07                	push   $0x7
  801612:	68 00 50 80 00       	push   $0x805000
  801617:	56                   	push   %esi
  801618:	ff 35 00 40 80 00    	pushl  0x804000
  80161e:	e8 f9 f9 ff ff       	call   80101c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801623:	83 c4 0c             	add    $0xc,%esp
  801626:	6a 00                	push   $0x0
  801628:	53                   	push   %ebx
  801629:	6a 00                	push   $0x0
  80162b:	e8 d5 f9 ff ff       	call   801005 <ipc_recv>
}
  801630:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801633:	5b                   	pop    %ebx
  801634:	5e                   	pop    %esi
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	6a 01                	push   $0x1
  80163c:	e8 f2 f9 ff ff       	call   801033 <ipc_find_env>
  801641:	a3 00 40 80 00       	mov    %eax,0x804000
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	eb c5                	jmp    801610 <fsipc+0x12>

0080164b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	8b 40 0c             	mov    0xc(%eax),%eax
  801657:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80165c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	b8 02 00 00 00       	mov    $0x2,%eax
  80166e:	e8 8b ff ff ff       	call   8015fe <fsipc>
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <devfile_flush>:
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8b 40 0c             	mov    0xc(%eax),%eax
  801681:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801686:	ba 00 00 00 00       	mov    $0x0,%edx
  80168b:	b8 06 00 00 00       	mov    $0x6,%eax
  801690:	e8 69 ff ff ff       	call   8015fe <fsipc>
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <devfile_stat>:
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	53                   	push   %ebx
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b1:	b8 05 00 00 00       	mov    $0x5,%eax
  8016b6:	e8 43 ff ff ff       	call   8015fe <fsipc>
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	78 2c                	js     8016eb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	68 00 50 80 00       	push   $0x805000
  8016c7:	53                   	push   %ebx
  8016c8:	e8 15 f1 ff ff       	call   8007e2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016cd:	a1 80 50 80 00       	mov    0x805080,%eax
  8016d2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016d8:	a1 84 50 80 00       	mov    0x805084,%eax
  8016dd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <devfile_write>:
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 0c             	sub    $0xc,%esp
  8016f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016fe:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801703:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801706:	8b 55 08             	mov    0x8(%ebp),%edx
  801709:	8b 52 0c             	mov    0xc(%edx),%edx
  80170c:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801712:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801717:	50                   	push   %eax
  801718:	ff 75 0c             	pushl  0xc(%ebp)
  80171b:	68 08 50 80 00       	push   $0x805008
  801720:	e8 4b f2 ff ff       	call   800970 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801725:	ba 00 00 00 00       	mov    $0x0,%edx
  80172a:	b8 04 00 00 00       	mov    $0x4,%eax
  80172f:	e8 ca fe ff ff       	call   8015fe <fsipc>
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <devfile_read>:
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8b 40 0c             	mov    0xc(%eax),%eax
  801744:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801749:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80174f:	ba 00 00 00 00       	mov    $0x0,%edx
  801754:	b8 03 00 00 00       	mov    $0x3,%eax
  801759:	e8 a0 fe ff ff       	call   8015fe <fsipc>
  80175e:	89 c3                	mov    %eax,%ebx
  801760:	85 c0                	test   %eax,%eax
  801762:	78 1f                	js     801783 <devfile_read+0x4d>
	assert(r <= n);
  801764:	39 f0                	cmp    %esi,%eax
  801766:	77 24                	ja     80178c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801768:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80176d:	7f 33                	jg     8017a2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	50                   	push   %eax
  801773:	68 00 50 80 00       	push   $0x805000
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	e8 f0 f1 ff ff       	call   800970 <memmove>
	return r;
  801780:	83 c4 10             	add    $0x10,%esp
}
  801783:	89 d8                	mov    %ebx,%eax
  801785:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    
	assert(r <= n);
  80178c:	68 b4 25 80 00       	push   $0x8025b4
  801791:	68 bb 25 80 00       	push   $0x8025bb
  801796:	6a 7c                	push   $0x7c
  801798:	68 d0 25 80 00       	push   $0x8025d0
  80179d:	e8 85 05 00 00       	call   801d27 <_panic>
	assert(r <= PGSIZE);
  8017a2:	68 db 25 80 00       	push   $0x8025db
  8017a7:	68 bb 25 80 00       	push   $0x8025bb
  8017ac:	6a 7d                	push   $0x7d
  8017ae:	68 d0 25 80 00       	push   $0x8025d0
  8017b3:	e8 6f 05 00 00       	call   801d27 <_panic>

008017b8 <open>:
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
  8017bd:	83 ec 1c             	sub    $0x1c,%esp
  8017c0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c3:	56                   	push   %esi
  8017c4:	e8 e2 ef ff ff       	call   8007ab <strlen>
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d1:	7f 6c                	jg     80183f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d3:	83 ec 0c             	sub    $0xc,%esp
  8017d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d9:	50                   	push   %eax
  8017da:	e8 b4 f8 ff ff       	call   801093 <fd_alloc>
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 3c                	js     801824 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017e8:	83 ec 08             	sub    $0x8,%esp
  8017eb:	56                   	push   %esi
  8017ec:	68 00 50 80 00       	push   $0x805000
  8017f1:	e8 ec ef ff ff       	call   8007e2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801801:	b8 01 00 00 00       	mov    $0x1,%eax
  801806:	e8 f3 fd ff ff       	call   8015fe <fsipc>
  80180b:	89 c3                	mov    %eax,%ebx
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	85 c0                	test   %eax,%eax
  801812:	78 19                	js     80182d <open+0x75>
	return fd2num(fd);
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	ff 75 f4             	pushl  -0xc(%ebp)
  80181a:	e8 4d f8 ff ff       	call   80106c <fd2num>
  80181f:	89 c3                	mov    %eax,%ebx
  801821:	83 c4 10             	add    $0x10,%esp
}
  801824:	89 d8                	mov    %ebx,%eax
  801826:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801829:	5b                   	pop    %ebx
  80182a:	5e                   	pop    %esi
  80182b:	5d                   	pop    %ebp
  80182c:	c3                   	ret    
		fd_close(fd, 0);
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	6a 00                	push   $0x0
  801832:	ff 75 f4             	pushl  -0xc(%ebp)
  801835:	e8 54 f9 ff ff       	call   80118e <fd_close>
		return r;
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	eb e5                	jmp    801824 <open+0x6c>
		return -E_BAD_PATH;
  80183f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801844:	eb de                	jmp    801824 <open+0x6c>

00801846 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80184c:	ba 00 00 00 00       	mov    $0x0,%edx
  801851:	b8 08 00 00 00       	mov    $0x8,%eax
  801856:	e8 a3 fd ff ff       	call   8015fe <fsipc>
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	56                   	push   %esi
  801861:	53                   	push   %ebx
  801862:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801865:	83 ec 0c             	sub    $0xc,%esp
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	e8 0c f8 ff ff       	call   80107c <fd2data>
  801870:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801872:	83 c4 08             	add    $0x8,%esp
  801875:	68 e7 25 80 00       	push   $0x8025e7
  80187a:	53                   	push   %ebx
  80187b:	e8 62 ef ff ff       	call   8007e2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801880:	8b 46 04             	mov    0x4(%esi),%eax
  801883:	2b 06                	sub    (%esi),%eax
  801885:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80188b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801892:	00 00 00 
	stat->st_dev = &devpipe;
  801895:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80189c:	30 80 00 
	return 0;
}
  80189f:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a7:	5b                   	pop    %ebx
  8018a8:	5e                   	pop    %esi
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    

008018ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	53                   	push   %ebx
  8018af:	83 ec 0c             	sub    $0xc,%esp
  8018b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018b5:	53                   	push   %ebx
  8018b6:	6a 00                	push   $0x0
  8018b8:	e8 a3 f3 ff ff       	call   800c60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018bd:	89 1c 24             	mov    %ebx,(%esp)
  8018c0:	e8 b7 f7 ff ff       	call   80107c <fd2data>
  8018c5:	83 c4 08             	add    $0x8,%esp
  8018c8:	50                   	push   %eax
  8018c9:	6a 00                	push   $0x0
  8018cb:	e8 90 f3 ff ff       	call   800c60 <sys_page_unmap>
}
  8018d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <_pipeisclosed>:
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	57                   	push   %edi
  8018d9:	56                   	push   %esi
  8018da:	53                   	push   %ebx
  8018db:	83 ec 1c             	sub    $0x1c,%esp
  8018de:	89 c7                	mov    %eax,%edi
  8018e0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8018e2:	a1 08 40 80 00       	mov    0x804008,%eax
  8018e7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018ea:	83 ec 0c             	sub    $0xc,%esp
  8018ed:	57                   	push   %edi
  8018ee:	e8 15 05 00 00       	call   801e08 <pageref>
  8018f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018f6:	89 34 24             	mov    %esi,(%esp)
  8018f9:	e8 0a 05 00 00       	call   801e08 <pageref>
		nn = thisenv->env_runs;
  8018fe:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801904:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	39 cb                	cmp    %ecx,%ebx
  80190c:	74 1b                	je     801929 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80190e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801911:	75 cf                	jne    8018e2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801913:	8b 42 58             	mov    0x58(%edx),%eax
  801916:	6a 01                	push   $0x1
  801918:	50                   	push   %eax
  801919:	53                   	push   %ebx
  80191a:	68 ee 25 80 00       	push   $0x8025ee
  80191f:	e8 d4 e8 ff ff       	call   8001f8 <cprintf>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	eb b9                	jmp    8018e2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801929:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80192c:	0f 94 c0             	sete   %al
  80192f:	0f b6 c0             	movzbl %al,%eax
}
  801932:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5f                   	pop    %edi
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    

0080193a <devpipe_write>:
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	57                   	push   %edi
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	83 ec 28             	sub    $0x28,%esp
  801943:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801946:	56                   	push   %esi
  801947:	e8 30 f7 ff ff       	call   80107c <fd2data>
  80194c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	bf 00 00 00 00       	mov    $0x0,%edi
  801956:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801959:	74 4f                	je     8019aa <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80195b:	8b 43 04             	mov    0x4(%ebx),%eax
  80195e:	8b 0b                	mov    (%ebx),%ecx
  801960:	8d 51 20             	lea    0x20(%ecx),%edx
  801963:	39 d0                	cmp    %edx,%eax
  801965:	72 14                	jb     80197b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801967:	89 da                	mov    %ebx,%edx
  801969:	89 f0                	mov    %esi,%eax
  80196b:	e8 65 ff ff ff       	call   8018d5 <_pipeisclosed>
  801970:	85 c0                	test   %eax,%eax
  801972:	75 3a                	jne    8019ae <devpipe_write+0x74>
			sys_yield();
  801974:	e8 43 f2 ff ff       	call   800bbc <sys_yield>
  801979:	eb e0                	jmp    80195b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80197b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80197e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801982:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801985:	89 c2                	mov    %eax,%edx
  801987:	c1 fa 1f             	sar    $0x1f,%edx
  80198a:	89 d1                	mov    %edx,%ecx
  80198c:	c1 e9 1b             	shr    $0x1b,%ecx
  80198f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801992:	83 e2 1f             	and    $0x1f,%edx
  801995:	29 ca                	sub    %ecx,%edx
  801997:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80199b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80199f:	83 c0 01             	add    $0x1,%eax
  8019a2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019a5:	83 c7 01             	add    $0x1,%edi
  8019a8:	eb ac                	jmp    801956 <devpipe_write+0x1c>
	return i;
  8019aa:	89 f8                	mov    %edi,%eax
  8019ac:	eb 05                	jmp    8019b3 <devpipe_write+0x79>
				return 0;
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b6:	5b                   	pop    %ebx
  8019b7:	5e                   	pop    %esi
  8019b8:	5f                   	pop    %edi
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    

008019bb <devpipe_read>:
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	57                   	push   %edi
  8019bf:	56                   	push   %esi
  8019c0:	53                   	push   %ebx
  8019c1:	83 ec 18             	sub    $0x18,%esp
  8019c4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8019c7:	57                   	push   %edi
  8019c8:	e8 af f6 ff ff       	call   80107c <fd2data>
  8019cd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	be 00 00 00 00       	mov    $0x0,%esi
  8019d7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019da:	74 47                	je     801a23 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8019dc:	8b 03                	mov    (%ebx),%eax
  8019de:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019e1:	75 22                	jne    801a05 <devpipe_read+0x4a>
			if (i > 0)
  8019e3:	85 f6                	test   %esi,%esi
  8019e5:	75 14                	jne    8019fb <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8019e7:	89 da                	mov    %ebx,%edx
  8019e9:	89 f8                	mov    %edi,%eax
  8019eb:	e8 e5 fe ff ff       	call   8018d5 <_pipeisclosed>
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	75 33                	jne    801a27 <devpipe_read+0x6c>
			sys_yield();
  8019f4:	e8 c3 f1 ff ff       	call   800bbc <sys_yield>
  8019f9:	eb e1                	jmp    8019dc <devpipe_read+0x21>
				return i;
  8019fb:	89 f0                	mov    %esi,%eax
}
  8019fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a00:	5b                   	pop    %ebx
  801a01:	5e                   	pop    %esi
  801a02:	5f                   	pop    %edi
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a05:	99                   	cltd   
  801a06:	c1 ea 1b             	shr    $0x1b,%edx
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	83 e0 1f             	and    $0x1f,%eax
  801a0e:	29 d0                	sub    %edx,%eax
  801a10:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a18:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a1b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a1e:	83 c6 01             	add    $0x1,%esi
  801a21:	eb b4                	jmp    8019d7 <devpipe_read+0x1c>
	return i;
  801a23:	89 f0                	mov    %esi,%eax
  801a25:	eb d6                	jmp    8019fd <devpipe_read+0x42>
				return 0;
  801a27:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2c:	eb cf                	jmp    8019fd <devpipe_read+0x42>

00801a2e <pipe>:
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	56                   	push   %esi
  801a32:	53                   	push   %ebx
  801a33:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a39:	50                   	push   %eax
  801a3a:	e8 54 f6 ff ff       	call   801093 <fd_alloc>
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 5b                	js     801aa3 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	68 07 04 00 00       	push   $0x407
  801a50:	ff 75 f4             	pushl  -0xc(%ebp)
  801a53:	6a 00                	push   $0x0
  801a55:	e8 81 f1 ff ff       	call   800bdb <sys_page_alloc>
  801a5a:	89 c3                	mov    %eax,%ebx
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	78 40                	js     801aa3 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801a63:	83 ec 0c             	sub    $0xc,%esp
  801a66:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a69:	50                   	push   %eax
  801a6a:	e8 24 f6 ff ff       	call   801093 <fd_alloc>
  801a6f:	89 c3                	mov    %eax,%ebx
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	85 c0                	test   %eax,%eax
  801a76:	78 1b                	js     801a93 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a78:	83 ec 04             	sub    $0x4,%esp
  801a7b:	68 07 04 00 00       	push   $0x407
  801a80:	ff 75 f0             	pushl  -0x10(%ebp)
  801a83:	6a 00                	push   $0x0
  801a85:	e8 51 f1 ff ff       	call   800bdb <sys_page_alloc>
  801a8a:	89 c3                	mov    %eax,%ebx
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	79 19                	jns    801aac <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801a93:	83 ec 08             	sub    $0x8,%esp
  801a96:	ff 75 f4             	pushl  -0xc(%ebp)
  801a99:	6a 00                	push   $0x0
  801a9b:	e8 c0 f1 ff ff       	call   800c60 <sys_page_unmap>
  801aa0:	83 c4 10             	add    $0x10,%esp
}
  801aa3:	89 d8                	mov    %ebx,%eax
  801aa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa8:	5b                   	pop    %ebx
  801aa9:	5e                   	pop    %esi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    
	va = fd2data(fd0);
  801aac:	83 ec 0c             	sub    $0xc,%esp
  801aaf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab2:	e8 c5 f5 ff ff       	call   80107c <fd2data>
  801ab7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ab9:	83 c4 0c             	add    $0xc,%esp
  801abc:	68 07 04 00 00       	push   $0x407
  801ac1:	50                   	push   %eax
  801ac2:	6a 00                	push   $0x0
  801ac4:	e8 12 f1 ff ff       	call   800bdb <sys_page_alloc>
  801ac9:	89 c3                	mov    %eax,%ebx
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	0f 88 8c 00 00 00    	js     801b62 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ad6:	83 ec 0c             	sub    $0xc,%esp
  801ad9:	ff 75 f0             	pushl  -0x10(%ebp)
  801adc:	e8 9b f5 ff ff       	call   80107c <fd2data>
  801ae1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ae8:	50                   	push   %eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	56                   	push   %esi
  801aec:	6a 00                	push   $0x0
  801aee:	e8 2b f1 ff ff       	call   800c1e <sys_page_map>
  801af3:	89 c3                	mov    %eax,%ebx
  801af5:	83 c4 20             	add    $0x20,%esp
  801af8:	85 c0                	test   %eax,%eax
  801afa:	78 58                	js     801b54 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aff:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b05:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b14:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b1a:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b26:	83 ec 0c             	sub    $0xc,%esp
  801b29:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2c:	e8 3b f5 ff ff       	call   80106c <fd2num>
  801b31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b34:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b36:	83 c4 04             	add    $0x4,%esp
  801b39:	ff 75 f0             	pushl  -0x10(%ebp)
  801b3c:	e8 2b f5 ff ff       	call   80106c <fd2num>
  801b41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b44:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b4f:	e9 4f ff ff ff       	jmp    801aa3 <pipe+0x75>
	sys_page_unmap(0, va);
  801b54:	83 ec 08             	sub    $0x8,%esp
  801b57:	56                   	push   %esi
  801b58:	6a 00                	push   $0x0
  801b5a:	e8 01 f1 ff ff       	call   800c60 <sys_page_unmap>
  801b5f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b62:	83 ec 08             	sub    $0x8,%esp
  801b65:	ff 75 f0             	pushl  -0x10(%ebp)
  801b68:	6a 00                	push   $0x0
  801b6a:	e8 f1 f0 ff ff       	call   800c60 <sys_page_unmap>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	e9 1c ff ff ff       	jmp    801a93 <pipe+0x65>

00801b77 <pipeisclosed>:
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b80:	50                   	push   %eax
  801b81:	ff 75 08             	pushl  0x8(%ebp)
  801b84:	e8 59 f5 ff ff       	call   8010e2 <fd_lookup>
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 18                	js     801ba8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b90:	83 ec 0c             	sub    $0xc,%esp
  801b93:	ff 75 f4             	pushl  -0xc(%ebp)
  801b96:	e8 e1 f4 ff ff       	call   80107c <fd2data>
	return _pipeisclosed(fd, p);
  801b9b:	89 c2                	mov    %eax,%edx
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	e8 30 fd ff ff       	call   8018d5 <_pipeisclosed>
  801ba5:	83 c4 10             	add    $0x10,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801bad:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    

00801bb4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801bba:	68 06 26 80 00       	push   $0x802606
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	e8 1b ec ff ff       	call   8007e2 <strcpy>
	return 0;
}
  801bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <devcons_write>:
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801bda:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801bdf:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801be5:	eb 2f                	jmp    801c16 <devcons_write+0x48>
		m = n - tot;
  801be7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bea:	29 f3                	sub    %esi,%ebx
  801bec:	83 fb 7f             	cmp    $0x7f,%ebx
  801bef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801bf4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	53                   	push   %ebx
  801bfb:	89 f0                	mov    %esi,%eax
  801bfd:	03 45 0c             	add    0xc(%ebp),%eax
  801c00:	50                   	push   %eax
  801c01:	57                   	push   %edi
  801c02:	e8 69 ed ff ff       	call   800970 <memmove>
		sys_cputs(buf, m);
  801c07:	83 c4 08             	add    $0x8,%esp
  801c0a:	53                   	push   %ebx
  801c0b:	57                   	push   %edi
  801c0c:	e8 0e ef ff ff       	call   800b1f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c11:	01 de                	add    %ebx,%esi
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c19:	72 cc                	jb     801be7 <devcons_write+0x19>
}
  801c1b:	89 f0                	mov    %esi,%eax
  801c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5f                   	pop    %edi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    

00801c25 <devcons_read>:
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 08             	sub    $0x8,%esp
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c34:	75 07                	jne    801c3d <devcons_read+0x18>
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    
		sys_yield();
  801c38:	e8 7f ef ff ff       	call   800bbc <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801c3d:	e8 fb ee ff ff       	call   800b3d <sys_cgetc>
  801c42:	85 c0                	test   %eax,%eax
  801c44:	74 f2                	je     801c38 <devcons_read+0x13>
	if (c < 0)
  801c46:	85 c0                	test   %eax,%eax
  801c48:	78 ec                	js     801c36 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801c4a:	83 f8 04             	cmp    $0x4,%eax
  801c4d:	74 0c                	je     801c5b <devcons_read+0x36>
	*(char*)vbuf = c;
  801c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c52:	88 02                	mov    %al,(%edx)
	return 1;
  801c54:	b8 01 00 00 00       	mov    $0x1,%eax
  801c59:	eb db                	jmp    801c36 <devcons_read+0x11>
		return 0;
  801c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c60:	eb d4                	jmp    801c36 <devcons_read+0x11>

00801c62 <cputchar>:
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c6e:	6a 01                	push   $0x1
  801c70:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c73:	50                   	push   %eax
  801c74:	e8 a6 ee ff ff       	call   800b1f <sys_cputs>
}
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <getchar>:
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c84:	6a 01                	push   $0x1
  801c86:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c89:	50                   	push   %eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	e8 c2 f6 ff ff       	call   801353 <read>
	if (r < 0)
  801c91:	83 c4 10             	add    $0x10,%esp
  801c94:	85 c0                	test   %eax,%eax
  801c96:	78 08                	js     801ca0 <getchar+0x22>
	if (r < 1)
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	7e 06                	jle    801ca2 <getchar+0x24>
	return c;
  801c9c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    
		return -E_EOF;
  801ca2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ca7:	eb f7                	jmp    801ca0 <getchar+0x22>

00801ca9 <iscons>:
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801caf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb2:	50                   	push   %eax
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	e8 27 f4 ff ff       	call   8010e2 <fd_lookup>
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	78 11                	js     801cd3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ccb:	39 10                	cmp    %edx,(%eax)
  801ccd:	0f 94 c0             	sete   %al
  801cd0:	0f b6 c0             	movzbl %al,%eax
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <opencons>:
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cde:	50                   	push   %eax
  801cdf:	e8 af f3 ff ff       	call   801093 <fd_alloc>
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 3a                	js     801d25 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ceb:	83 ec 04             	sub    $0x4,%esp
  801cee:	68 07 04 00 00       	push   $0x407
  801cf3:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf6:	6a 00                	push   $0x0
  801cf8:	e8 de ee ff ff       	call   800bdb <sys_page_alloc>
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	85 c0                	test   %eax,%eax
  801d02:	78 21                	js     801d25 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d07:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d0d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d12:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d19:	83 ec 0c             	sub    $0xc,%esp
  801d1c:	50                   	push   %eax
  801d1d:	e8 4a f3 ff ff       	call   80106c <fd2num>
  801d22:	83 c4 10             	add    $0x10,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801d2c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d2f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801d35:	e8 63 ee ff ff       	call   800b9d <sys_getenvid>
  801d3a:	83 ec 0c             	sub    $0xc,%esp
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	56                   	push   %esi
  801d44:	50                   	push   %eax
  801d45:	68 14 26 80 00       	push   $0x802614
  801d4a:	e8 a9 e4 ff ff       	call   8001f8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d4f:	83 c4 18             	add    $0x18,%esp
  801d52:	53                   	push   %ebx
  801d53:	ff 75 10             	pushl  0x10(%ebp)
  801d56:	e8 4c e4 ff ff       	call   8001a7 <vcprintf>
	cprintf("\n");
  801d5b:	c7 04 24 ff 25 80 00 	movl   $0x8025ff,(%esp)
  801d62:	e8 91 e4 ff ff       	call   8001f8 <cprintf>
  801d67:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d6a:	cc                   	int3   
  801d6b:	eb fd                	jmp    801d6a <_panic+0x43>

00801d6d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	53                   	push   %ebx
  801d71:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801d74:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801d7b:	74 0d                	je     801d8a <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801d85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801d8a:	e8 0e ee ff ff       	call   800b9d <sys_getenvid>
  801d8f:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	6a 07                	push   $0x7
  801d96:	68 00 f0 bf ee       	push   $0xeebff000
  801d9b:	50                   	push   %eax
  801d9c:	e8 3a ee ff ff       	call   800bdb <sys_page_alloc>
        	if (r < 0) {
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	78 27                	js     801dcf <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801da8:	83 ec 08             	sub    $0x8,%esp
  801dab:	68 e1 1d 80 00       	push   $0x801de1
  801db0:	53                   	push   %ebx
  801db1:	e8 70 ef ff ff       	call   800d26 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	79 c0                	jns    801d7d <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801dbd:	50                   	push   %eax
  801dbe:	68 38 26 80 00       	push   $0x802638
  801dc3:	6a 28                	push   $0x28
  801dc5:	68 4c 26 80 00       	push   $0x80264c
  801dca:	e8 58 ff ff ff       	call   801d27 <_panic>
            		panic("pgfault_handler: %e", r);
  801dcf:	50                   	push   %eax
  801dd0:	68 38 26 80 00       	push   $0x802638
  801dd5:	6a 24                	push   $0x24
  801dd7:	68 4c 26 80 00       	push   $0x80264c
  801ddc:	e8 46 ff ff ff       	call   801d27 <_panic>

00801de1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801de1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801de2:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801de7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801de9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801dec:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801df0:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801df3:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801df7:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801dfb:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801dfe:	83 c4 08             	add    $0x8,%esp
	popal
  801e01:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801e02:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801e05:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801e06:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801e07:	c3                   	ret    

00801e08 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	c1 e8 16             	shr    $0x16,%eax
  801e13:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801e1f:	f6 c1 01             	test   $0x1,%cl
  801e22:	74 1d                	je     801e41 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801e24:	c1 ea 0c             	shr    $0xc,%edx
  801e27:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e2e:	f6 c2 01             	test   $0x1,%dl
  801e31:	74 0e                	je     801e41 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e33:	c1 ea 0c             	shr    $0xc,%edx
  801e36:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e3d:	ef 
  801e3e:	0f b7 c0             	movzwl %ax,%eax
}
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    
  801e43:	66 90                	xchg   %ax,%ax
  801e45:	66 90                	xchg   %ax,%ax
  801e47:	66 90                	xchg   %ax,%ax
  801e49:	66 90                	xchg   %ax,%ax
  801e4b:	66 90                	xchg   %ax,%ax
  801e4d:	66 90                	xchg   %ax,%ax
  801e4f:	90                   	nop

00801e50 <__udivdi3>:
  801e50:	55                   	push   %ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	53                   	push   %ebx
  801e54:	83 ec 1c             	sub    $0x1c,%esp
  801e57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e67:	85 d2                	test   %edx,%edx
  801e69:	75 35                	jne    801ea0 <__udivdi3+0x50>
  801e6b:	39 f3                	cmp    %esi,%ebx
  801e6d:	0f 87 bd 00 00 00    	ja     801f30 <__udivdi3+0xe0>
  801e73:	85 db                	test   %ebx,%ebx
  801e75:	89 d9                	mov    %ebx,%ecx
  801e77:	75 0b                	jne    801e84 <__udivdi3+0x34>
  801e79:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7e:	31 d2                	xor    %edx,%edx
  801e80:	f7 f3                	div    %ebx
  801e82:	89 c1                	mov    %eax,%ecx
  801e84:	31 d2                	xor    %edx,%edx
  801e86:	89 f0                	mov    %esi,%eax
  801e88:	f7 f1                	div    %ecx
  801e8a:	89 c6                	mov    %eax,%esi
  801e8c:	89 e8                	mov    %ebp,%eax
  801e8e:	89 f7                	mov    %esi,%edi
  801e90:	f7 f1                	div    %ecx
  801e92:	89 fa                	mov    %edi,%edx
  801e94:	83 c4 1c             	add    $0x1c,%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5f                   	pop    %edi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    
  801e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ea0:	39 f2                	cmp    %esi,%edx
  801ea2:	77 7c                	ja     801f20 <__udivdi3+0xd0>
  801ea4:	0f bd fa             	bsr    %edx,%edi
  801ea7:	83 f7 1f             	xor    $0x1f,%edi
  801eaa:	0f 84 98 00 00 00    	je     801f48 <__udivdi3+0xf8>
  801eb0:	89 f9                	mov    %edi,%ecx
  801eb2:	b8 20 00 00 00       	mov    $0x20,%eax
  801eb7:	29 f8                	sub    %edi,%eax
  801eb9:	d3 e2                	shl    %cl,%edx
  801ebb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ebf:	89 c1                	mov    %eax,%ecx
  801ec1:	89 da                	mov    %ebx,%edx
  801ec3:	d3 ea                	shr    %cl,%edx
  801ec5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ec9:	09 d1                	or     %edx,%ecx
  801ecb:	89 f2                	mov    %esi,%edx
  801ecd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ed1:	89 f9                	mov    %edi,%ecx
  801ed3:	d3 e3                	shl    %cl,%ebx
  801ed5:	89 c1                	mov    %eax,%ecx
  801ed7:	d3 ea                	shr    %cl,%edx
  801ed9:	89 f9                	mov    %edi,%ecx
  801edb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801edf:	d3 e6                	shl    %cl,%esi
  801ee1:	89 eb                	mov    %ebp,%ebx
  801ee3:	89 c1                	mov    %eax,%ecx
  801ee5:	d3 eb                	shr    %cl,%ebx
  801ee7:	09 de                	or     %ebx,%esi
  801ee9:	89 f0                	mov    %esi,%eax
  801eeb:	f7 74 24 08          	divl   0x8(%esp)
  801eef:	89 d6                	mov    %edx,%esi
  801ef1:	89 c3                	mov    %eax,%ebx
  801ef3:	f7 64 24 0c          	mull   0xc(%esp)
  801ef7:	39 d6                	cmp    %edx,%esi
  801ef9:	72 0c                	jb     801f07 <__udivdi3+0xb7>
  801efb:	89 f9                	mov    %edi,%ecx
  801efd:	d3 e5                	shl    %cl,%ebp
  801eff:	39 c5                	cmp    %eax,%ebp
  801f01:	73 5d                	jae    801f60 <__udivdi3+0x110>
  801f03:	39 d6                	cmp    %edx,%esi
  801f05:	75 59                	jne    801f60 <__udivdi3+0x110>
  801f07:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f0a:	31 ff                	xor    %edi,%edi
  801f0c:	89 fa                	mov    %edi,%edx
  801f0e:	83 c4 1c             	add    $0x1c,%esp
  801f11:	5b                   	pop    %ebx
  801f12:	5e                   	pop    %esi
  801f13:	5f                   	pop    %edi
  801f14:	5d                   	pop    %ebp
  801f15:	c3                   	ret    
  801f16:	8d 76 00             	lea    0x0(%esi),%esi
  801f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801f20:	31 ff                	xor    %edi,%edi
  801f22:	31 c0                	xor    %eax,%eax
  801f24:	89 fa                	mov    %edi,%edx
  801f26:	83 c4 1c             	add    $0x1c,%esp
  801f29:	5b                   	pop    %ebx
  801f2a:	5e                   	pop    %esi
  801f2b:	5f                   	pop    %edi
  801f2c:	5d                   	pop    %ebp
  801f2d:	c3                   	ret    
  801f2e:	66 90                	xchg   %ax,%ax
  801f30:	31 ff                	xor    %edi,%edi
  801f32:	89 e8                	mov    %ebp,%eax
  801f34:	89 f2                	mov    %esi,%edx
  801f36:	f7 f3                	div    %ebx
  801f38:	89 fa                	mov    %edi,%edx
  801f3a:	83 c4 1c             	add    $0x1c,%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5e                   	pop    %esi
  801f3f:	5f                   	pop    %edi
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    
  801f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f48:	39 f2                	cmp    %esi,%edx
  801f4a:	72 06                	jb     801f52 <__udivdi3+0x102>
  801f4c:	31 c0                	xor    %eax,%eax
  801f4e:	39 eb                	cmp    %ebp,%ebx
  801f50:	77 d2                	ja     801f24 <__udivdi3+0xd4>
  801f52:	b8 01 00 00 00       	mov    $0x1,%eax
  801f57:	eb cb                	jmp    801f24 <__udivdi3+0xd4>
  801f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f60:	89 d8                	mov    %ebx,%eax
  801f62:	31 ff                	xor    %edi,%edi
  801f64:	eb be                	jmp    801f24 <__udivdi3+0xd4>
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	66 90                	xchg   %ax,%ax
  801f6a:	66 90                	xchg   %ax,%ax
  801f6c:	66 90                	xchg   %ax,%ax
  801f6e:	66 90                	xchg   %ax,%ax

00801f70 <__umoddi3>:
  801f70:	55                   	push   %ebp
  801f71:	57                   	push   %edi
  801f72:	56                   	push   %esi
  801f73:	53                   	push   %ebx
  801f74:	83 ec 1c             	sub    $0x1c,%esp
  801f77:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801f7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f87:	85 ed                	test   %ebp,%ebp
  801f89:	89 f0                	mov    %esi,%eax
  801f8b:	89 da                	mov    %ebx,%edx
  801f8d:	75 19                	jne    801fa8 <__umoddi3+0x38>
  801f8f:	39 df                	cmp    %ebx,%edi
  801f91:	0f 86 b1 00 00 00    	jbe    802048 <__umoddi3+0xd8>
  801f97:	f7 f7                	div    %edi
  801f99:	89 d0                	mov    %edx,%eax
  801f9b:	31 d2                	xor    %edx,%edx
  801f9d:	83 c4 1c             	add    $0x1c,%esp
  801fa0:	5b                   	pop    %ebx
  801fa1:	5e                   	pop    %esi
  801fa2:	5f                   	pop    %edi
  801fa3:	5d                   	pop    %ebp
  801fa4:	c3                   	ret    
  801fa5:	8d 76 00             	lea    0x0(%esi),%esi
  801fa8:	39 dd                	cmp    %ebx,%ebp
  801faa:	77 f1                	ja     801f9d <__umoddi3+0x2d>
  801fac:	0f bd cd             	bsr    %ebp,%ecx
  801faf:	83 f1 1f             	xor    $0x1f,%ecx
  801fb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fb6:	0f 84 b4 00 00 00    	je     802070 <__umoddi3+0x100>
  801fbc:	b8 20 00 00 00       	mov    $0x20,%eax
  801fc1:	89 c2                	mov    %eax,%edx
  801fc3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fc7:	29 c2                	sub    %eax,%edx
  801fc9:	89 c1                	mov    %eax,%ecx
  801fcb:	89 f8                	mov    %edi,%eax
  801fcd:	d3 e5                	shl    %cl,%ebp
  801fcf:	89 d1                	mov    %edx,%ecx
  801fd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fd5:	d3 e8                	shr    %cl,%eax
  801fd7:	09 c5                	or     %eax,%ebp
  801fd9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fdd:	89 c1                	mov    %eax,%ecx
  801fdf:	d3 e7                	shl    %cl,%edi
  801fe1:	89 d1                	mov    %edx,%ecx
  801fe3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801fe7:	89 df                	mov    %ebx,%edi
  801fe9:	d3 ef                	shr    %cl,%edi
  801feb:	89 c1                	mov    %eax,%ecx
  801fed:	89 f0                	mov    %esi,%eax
  801fef:	d3 e3                	shl    %cl,%ebx
  801ff1:	89 d1                	mov    %edx,%ecx
  801ff3:	89 fa                	mov    %edi,%edx
  801ff5:	d3 e8                	shr    %cl,%eax
  801ff7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ffc:	09 d8                	or     %ebx,%eax
  801ffe:	f7 f5                	div    %ebp
  802000:	d3 e6                	shl    %cl,%esi
  802002:	89 d1                	mov    %edx,%ecx
  802004:	f7 64 24 08          	mull   0x8(%esp)
  802008:	39 d1                	cmp    %edx,%ecx
  80200a:	89 c3                	mov    %eax,%ebx
  80200c:	89 d7                	mov    %edx,%edi
  80200e:	72 06                	jb     802016 <__umoddi3+0xa6>
  802010:	75 0e                	jne    802020 <__umoddi3+0xb0>
  802012:	39 c6                	cmp    %eax,%esi
  802014:	73 0a                	jae    802020 <__umoddi3+0xb0>
  802016:	2b 44 24 08          	sub    0x8(%esp),%eax
  80201a:	19 ea                	sbb    %ebp,%edx
  80201c:	89 d7                	mov    %edx,%edi
  80201e:	89 c3                	mov    %eax,%ebx
  802020:	89 ca                	mov    %ecx,%edx
  802022:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802027:	29 de                	sub    %ebx,%esi
  802029:	19 fa                	sbb    %edi,%edx
  80202b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80202f:	89 d0                	mov    %edx,%eax
  802031:	d3 e0                	shl    %cl,%eax
  802033:	89 d9                	mov    %ebx,%ecx
  802035:	d3 ee                	shr    %cl,%esi
  802037:	d3 ea                	shr    %cl,%edx
  802039:	09 f0                	or     %esi,%eax
  80203b:	83 c4 1c             	add    $0x1c,%esp
  80203e:	5b                   	pop    %ebx
  80203f:	5e                   	pop    %esi
  802040:	5f                   	pop    %edi
  802041:	5d                   	pop    %ebp
  802042:	c3                   	ret    
  802043:	90                   	nop
  802044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802048:	85 ff                	test   %edi,%edi
  80204a:	89 f9                	mov    %edi,%ecx
  80204c:	75 0b                	jne    802059 <__umoddi3+0xe9>
  80204e:	b8 01 00 00 00       	mov    $0x1,%eax
  802053:	31 d2                	xor    %edx,%edx
  802055:	f7 f7                	div    %edi
  802057:	89 c1                	mov    %eax,%ecx
  802059:	89 d8                	mov    %ebx,%eax
  80205b:	31 d2                	xor    %edx,%edx
  80205d:	f7 f1                	div    %ecx
  80205f:	89 f0                	mov    %esi,%eax
  802061:	f7 f1                	div    %ecx
  802063:	e9 31 ff ff ff       	jmp    801f99 <__umoddi3+0x29>
  802068:	90                   	nop
  802069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802070:	39 dd                	cmp    %ebx,%ebp
  802072:	72 08                	jb     80207c <__umoddi3+0x10c>
  802074:	39 f7                	cmp    %esi,%edi
  802076:	0f 87 21 ff ff ff    	ja     801f9d <__umoddi3+0x2d>
  80207c:	89 da                	mov    %ebx,%edx
  80207e:	89 f0                	mov    %esi,%eax
  802080:	29 f8                	sub    %edi,%eax
  802082:	19 ea                	sbb    %ebp,%edx
  802084:	e9 14 ff ff ff       	jmp    801f9d <__umoddi3+0x2d>
