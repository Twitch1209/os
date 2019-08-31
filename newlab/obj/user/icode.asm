
obj/user/icode.debug：     文件格式 elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 00 	movl   $0x802400,0x803000
  800045:	24 80 00 

	cprintf("icode startup\n");
  800048:	68 06 24 80 00       	push   $0x802406
  80004d:	e8 1d 02 00 00       	call   80026f <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 15 24 80 00 	movl   $0x802415,(%esp)
  800059:	e8 11 02 00 00       	call   80026f <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 28 24 80 00       	push   $0x802428
  800068:	e8 22 15 00 00       	call   80158f <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 18                	js     80008e <umain+0x5b>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 51 24 80 00       	push   $0x802451
  80007e:	e8 ec 01 00 00       	call   80026f <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	eb 1f                	jmp    8000ad <umain+0x7a>
		panic("icode: open /motd: %e", fd);
  80008e:	50                   	push   %eax
  80008f:	68 2e 24 80 00       	push   $0x80242e
  800094:	6a 0f                	push   $0xf
  800096:	68 44 24 80 00       	push   $0x802444
  80009b:	e8 f4 00 00 00       	call   800194 <_panic>
		sys_cputs(buf, n);
  8000a0:	83 ec 08             	sub    $0x8,%esp
  8000a3:	50                   	push   %eax
  8000a4:	53                   	push   %ebx
  8000a5:	e8 ec 0a 00 00       	call   800b96 <sys_cputs>
  8000aa:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	68 00 02 00 00       	push   $0x200
  8000b5:	53                   	push   %ebx
  8000b6:	56                   	push   %esi
  8000b7:	e8 6e 10 00 00       	call   80112a <read>
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	7f dd                	jg     8000a0 <umain+0x6d>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 64 24 80 00       	push   $0x802464
  8000cb:	e8 9f 01 00 00       	call   80026f <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 16 0f 00 00       	call   800fee <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 78 24 80 00 	movl   $0x802478,(%esp)
  8000df:	e8 8b 01 00 00       	call   80026f <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 8c 24 80 00       	push   $0x80248c
  8000f0:	68 95 24 80 00       	push   $0x802495
  8000f5:	68 9f 24 80 00       	push   $0x80249f
  8000fa:	68 9e 24 80 00       	push   $0x80249e
  8000ff:	e8 c9 1a 00 00       	call   801bcd <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 bb 24 80 00       	push   $0x8024bb
  800113:	e8 57 01 00 00       	call   80026f <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 a4 24 80 00       	push   $0x8024a4
  800128:	6a 1a                	push   $0x1a
  80012a:	68 44 24 80 00       	push   $0x802444
  80012f:	e8 60 00 00 00       	call   800194 <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013f:	e8 d0 0a 00 00       	call   800c14 <sys_getenvid>
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80014c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800151:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800156:	85 db                	test   %ebx,%ebx
  800158:	7e 07                	jle    800161 <libmain+0x2d>
		binaryname = argv[0];
  80015a:	8b 06                	mov    (%esi),%eax
  80015c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	e8 c8 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016b:	e8 0a 00 00 00       	call   80017a <exit>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800180:	e8 94 0e 00 00       	call   801019 <close_all>
	sys_env_destroy(0);
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	6a 00                	push   $0x0
  80018a:	e8 44 0a 00 00       	call   800bd3 <sys_env_destroy>
}
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800199:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80019c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001a2:	e8 6d 0a 00 00       	call   800c14 <sys_getenvid>
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 0c             	pushl  0xc(%ebp)
  8001ad:	ff 75 08             	pushl  0x8(%ebp)
  8001b0:	56                   	push   %esi
  8001b1:	50                   	push   %eax
  8001b2:	68 d8 24 80 00       	push   $0x8024d8
  8001b7:	e8 b3 00 00 00       	call   80026f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001bc:	83 c4 18             	add    $0x18,%esp
  8001bf:	53                   	push   %ebx
  8001c0:	ff 75 10             	pushl  0x10(%ebp)
  8001c3:	e8 56 00 00 00       	call   80021e <vcprintf>
	cprintf("\n");
  8001c8:	c7 04 24 b8 29 80 00 	movl   $0x8029b8,(%esp)
  8001cf:	e8 9b 00 00 00       	call   80026f <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d7:	cc                   	int3   
  8001d8:	eb fd                	jmp    8001d7 <_panic+0x43>

008001da <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	53                   	push   %ebx
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e4:	8b 13                	mov    (%ebx),%edx
  8001e6:	8d 42 01             	lea    0x1(%edx),%eax
  8001e9:	89 03                	mov    %eax,(%ebx)
  8001eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f7:	74 09                	je     800202 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800200:	c9                   	leave  
  800201:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	68 ff 00 00 00       	push   $0xff
  80020a:	8d 43 08             	lea    0x8(%ebx),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 83 09 00 00       	call   800b96 <sys_cputs>
		b->idx = 0;
  800213:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb db                	jmp    8001f9 <putch+0x1f>

0080021e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800227:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022e:	00 00 00 
	b.cnt = 0;
  800231:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800238:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800247:	50                   	push   %eax
  800248:	68 da 01 80 00       	push   $0x8001da
  80024d:	e8 1a 01 00 00       	call   80036c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800252:	83 c4 08             	add    $0x8,%esp
  800255:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80025b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800261:	50                   	push   %eax
  800262:	e8 2f 09 00 00       	call   800b96 <sys_cputs>

	return b.cnt;
}
  800267:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800275:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	e8 9d ff ff ff       	call   80021e <vcprintf>
	va_end(ap);

	return cnt;
}
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	57                   	push   %edi
  800287:	56                   	push   %esi
  800288:	53                   	push   %ebx
  800289:	83 ec 1c             	sub    $0x1c,%esp
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	89 d6                	mov    %edx,%esi
  800290:	8b 45 08             	mov    0x8(%ebp),%eax
  800293:	8b 55 0c             	mov    0xc(%ebp),%edx
  800296:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800299:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002aa:	39 d3                	cmp    %edx,%ebx
  8002ac:	72 05                	jb     8002b3 <printnum+0x30>
  8002ae:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b1:	77 7a                	ja     80032d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	ff 75 18             	pushl  0x18(%ebp)
  8002b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002bf:	53                   	push   %ebx
  8002c0:	ff 75 10             	pushl  0x10(%ebp)
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d2:	e8 e9 1e 00 00       	call   8021c0 <__udivdi3>
  8002d7:	83 c4 18             	add    $0x18,%esp
  8002da:	52                   	push   %edx
  8002db:	50                   	push   %eax
  8002dc:	89 f2                	mov    %esi,%edx
  8002de:	89 f8                	mov    %edi,%eax
  8002e0:	e8 9e ff ff ff       	call   800283 <printnum>
  8002e5:	83 c4 20             	add    $0x20,%esp
  8002e8:	eb 13                	jmp    8002fd <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	56                   	push   %esi
  8002ee:	ff 75 18             	pushl  0x18(%ebp)
  8002f1:	ff d7                	call   *%edi
  8002f3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002f6:	83 eb 01             	sub    $0x1,%ebx
  8002f9:	85 db                	test   %ebx,%ebx
  8002fb:	7f ed                	jg     8002ea <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	56                   	push   %esi
  800301:	83 ec 04             	sub    $0x4,%esp
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	ff 75 e0             	pushl  -0x20(%ebp)
  80030a:	ff 75 dc             	pushl  -0x24(%ebp)
  80030d:	ff 75 d8             	pushl  -0x28(%ebp)
  800310:	e8 cb 1f 00 00       	call   8022e0 <__umoddi3>
  800315:	83 c4 14             	add    $0x14,%esp
  800318:	0f be 80 fb 24 80 00 	movsbl 0x8024fb(%eax),%eax
  80031f:	50                   	push   %eax
  800320:	ff d7                	call   *%edi
}
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800328:	5b                   	pop    %ebx
  800329:	5e                   	pop    %esi
  80032a:	5f                   	pop    %edi
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    
  80032d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800330:	eb c4                	jmp    8002f6 <printnum+0x73>

00800332 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800338:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033c:	8b 10                	mov    (%eax),%edx
  80033e:	3b 50 04             	cmp    0x4(%eax),%edx
  800341:	73 0a                	jae    80034d <sprintputch+0x1b>
		*b->buf++ = ch;
  800343:	8d 4a 01             	lea    0x1(%edx),%ecx
  800346:	89 08                	mov    %ecx,(%eax)
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	88 02                	mov    %al,(%edx)
}
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <printfmt>:
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800355:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800358:	50                   	push   %eax
  800359:	ff 75 10             	pushl  0x10(%ebp)
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	e8 05 00 00 00       	call   80036c <vprintfmt>
}
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <vprintfmt>:
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	57                   	push   %edi
  800370:	56                   	push   %esi
  800371:	53                   	push   %ebx
  800372:	83 ec 2c             	sub    $0x2c,%esp
  800375:	8b 75 08             	mov    0x8(%ebp),%esi
  800378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037e:	e9 8c 03 00 00       	jmp    80070f <vprintfmt+0x3a3>
		padc = ' ';
  800383:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800387:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80038e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800395:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80039c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8d 47 01             	lea    0x1(%edi),%eax
  8003a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a7:	0f b6 17             	movzbl (%edi),%edx
  8003aa:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ad:	3c 55                	cmp    $0x55,%al
  8003af:	0f 87 dd 03 00 00    	ja     800792 <vprintfmt+0x426>
  8003b5:	0f b6 c0             	movzbl %al,%eax
  8003b8:	ff 24 85 40 26 80 00 	jmp    *0x802640(,%eax,4)
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003c2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003c6:	eb d9                	jmp    8003a1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003cb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003cf:	eb d0                	jmp    8003a1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003d1:	0f b6 d2             	movzbl %dl,%edx
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003df:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003e2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003ec:	83 f9 09             	cmp    $0x9,%ecx
  8003ef:	77 55                	ja     800446 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003f1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f4:	eb e9                	jmp    8003df <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8d 40 04             	lea    0x4(%eax),%eax
  800404:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80040a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040e:	79 91                	jns    8003a1 <vprintfmt+0x35>
				width = precision, precision = -1;
  800410:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800413:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800416:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80041d:	eb 82                	jmp    8003a1 <vprintfmt+0x35>
  80041f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800422:	85 c0                	test   %eax,%eax
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	0f 49 d0             	cmovns %eax,%edx
  80042c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800432:	e9 6a ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
  800437:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80043a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800441:	e9 5b ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
  800446:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800449:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80044c:	eb bc                	jmp    80040a <vprintfmt+0x9e>
			lflag++;
  80044e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800454:	e9 48 ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800459:	8b 45 14             	mov    0x14(%ebp),%eax
  80045c:	8d 78 04             	lea    0x4(%eax),%edi
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	ff 30                	pushl  (%eax)
  800465:	ff d6                	call   *%esi
			break;
  800467:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80046a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80046d:	e9 9a 02 00 00       	jmp    80070c <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800472:	8b 45 14             	mov    0x14(%ebp),%eax
  800475:	8d 78 04             	lea    0x4(%eax),%edi
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	99                   	cltd   
  80047b:	31 d0                	xor    %edx,%eax
  80047d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047f:	83 f8 0f             	cmp    $0xf,%eax
  800482:	7f 23                	jg     8004a7 <vprintfmt+0x13b>
  800484:	8b 14 85 a0 27 80 00 	mov    0x8027a0(,%eax,4),%edx
  80048b:	85 d2                	test   %edx,%edx
  80048d:	74 18                	je     8004a7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80048f:	52                   	push   %edx
  800490:	68 d1 28 80 00       	push   $0x8028d1
  800495:	53                   	push   %ebx
  800496:	56                   	push   %esi
  800497:	e8 b3 fe ff ff       	call   80034f <printfmt>
  80049c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049f:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004a2:	e9 65 02 00 00       	jmp    80070c <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8004a7:	50                   	push   %eax
  8004a8:	68 13 25 80 00       	push   $0x802513
  8004ad:	53                   	push   %ebx
  8004ae:	56                   	push   %esi
  8004af:	e8 9b fe ff ff       	call   80034f <printfmt>
  8004b4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ba:	e9 4d 02 00 00       	jmp    80070c <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	83 c0 04             	add    $0x4,%eax
  8004c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004cd:	85 ff                	test   %edi,%edi
  8004cf:	b8 0c 25 80 00       	mov    $0x80250c,%eax
  8004d4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004db:	0f 8e bd 00 00 00    	jle    80059e <vprintfmt+0x232>
  8004e1:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004e5:	75 0e                	jne    8004f5 <vprintfmt+0x189>
  8004e7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ea:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ed:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f3:	eb 6d                	jmp    800562 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	ff 75 d0             	pushl  -0x30(%ebp)
  8004fb:	57                   	push   %edi
  8004fc:	e8 39 03 00 00       	call   80083a <strnlen>
  800501:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800504:	29 c1                	sub    %eax,%ecx
  800506:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800509:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80050c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800510:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800513:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800516:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	eb 0f                	jmp    800529 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	53                   	push   %ebx
  80051e:	ff 75 e0             	pushl  -0x20(%ebp)
  800521:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800523:	83 ef 01             	sub    $0x1,%edi
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	85 ff                	test   %edi,%edi
  80052b:	7f ed                	jg     80051a <vprintfmt+0x1ae>
  80052d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800530:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800533:	85 c9                	test   %ecx,%ecx
  800535:	b8 00 00 00 00       	mov    $0x0,%eax
  80053a:	0f 49 c1             	cmovns %ecx,%eax
  80053d:	29 c1                	sub    %eax,%ecx
  80053f:	89 75 08             	mov    %esi,0x8(%ebp)
  800542:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800545:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800548:	89 cb                	mov    %ecx,%ebx
  80054a:	eb 16                	jmp    800562 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80054c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800550:	75 31                	jne    800583 <vprintfmt+0x217>
					putch(ch, putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	ff 75 0c             	pushl  0xc(%ebp)
  800558:	50                   	push   %eax
  800559:	ff 55 08             	call   *0x8(%ebp)
  80055c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055f:	83 eb 01             	sub    $0x1,%ebx
  800562:	83 c7 01             	add    $0x1,%edi
  800565:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800569:	0f be c2             	movsbl %dl,%eax
  80056c:	85 c0                	test   %eax,%eax
  80056e:	74 59                	je     8005c9 <vprintfmt+0x25d>
  800570:	85 f6                	test   %esi,%esi
  800572:	78 d8                	js     80054c <vprintfmt+0x1e0>
  800574:	83 ee 01             	sub    $0x1,%esi
  800577:	79 d3                	jns    80054c <vprintfmt+0x1e0>
  800579:	89 df                	mov    %ebx,%edi
  80057b:	8b 75 08             	mov    0x8(%ebp),%esi
  80057e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800581:	eb 37                	jmp    8005ba <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800583:	0f be d2             	movsbl %dl,%edx
  800586:	83 ea 20             	sub    $0x20,%edx
  800589:	83 fa 5e             	cmp    $0x5e,%edx
  80058c:	76 c4                	jbe    800552 <vprintfmt+0x1e6>
					putch('?', putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 0c             	pushl  0xc(%ebp)
  800594:	6a 3f                	push   $0x3f
  800596:	ff 55 08             	call   *0x8(%ebp)
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb c1                	jmp    80055f <vprintfmt+0x1f3>
  80059e:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005aa:	eb b6                	jmp    800562 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	6a 20                	push   $0x20
  8005b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b4:	83 ef 01             	sub    $0x1,%edi
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7f ee                	jg     8005ac <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	e9 43 01 00 00       	jmp    80070c <vprintfmt+0x3a0>
  8005c9:	89 df                	mov    %ebx,%edi
  8005cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d1:	eb e7                	jmp    8005ba <vprintfmt+0x24e>
	if (lflag >= 2)
  8005d3:	83 f9 01             	cmp    $0x1,%ecx
  8005d6:	7e 3f                	jle    800617 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 50 04             	mov    0x4(%eax),%edx
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f3:	79 5c                	jns    800651 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	53                   	push   %ebx
  8005f9:	6a 2d                	push   $0x2d
  8005fb:	ff d6                	call   *%esi
				num = -(long long) num;
  8005fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800600:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800603:	f7 da                	neg    %edx
  800605:	83 d1 00             	adc    $0x0,%ecx
  800608:	f7 d9                	neg    %ecx
  80060a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800612:	e9 db 00 00 00       	jmp    8006f2 <vprintfmt+0x386>
	else if (lflag)
  800617:	85 c9                	test   %ecx,%ecx
  800619:	75 1b                	jne    800636 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 c1                	mov    %eax,%ecx
  800625:	c1 f9 1f             	sar    $0x1f,%ecx
  800628:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	eb b9                	jmp    8005ef <vprintfmt+0x283>
		return va_arg(*ap, long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063e:	89 c1                	mov    %eax,%ecx
  800640:	c1 f9 1f             	sar    $0x1f,%ecx
  800643:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb 9e                	jmp    8005ef <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800651:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800654:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800657:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065c:	e9 91 00 00 00       	jmp    8006f2 <vprintfmt+0x386>
	if (lflag >= 2)
  800661:	83 f9 01             	cmp    $0x1,%ecx
  800664:	7e 15                	jle    80067b <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 10                	mov    (%eax),%edx
  80066b:	8b 48 04             	mov    0x4(%eax),%ecx
  80066e:	8d 40 08             	lea    0x8(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800674:	b8 0a 00 00 00       	mov    $0xa,%eax
  800679:	eb 77                	jmp    8006f2 <vprintfmt+0x386>
	else if (lflag)
  80067b:	85 c9                	test   %ecx,%ecx
  80067d:	75 17                	jne    800696 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	b9 00 00 00 00       	mov    $0x0,%ecx
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800694:	eb 5c                	jmp    8006f2 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8b 10                	mov    (%eax),%edx
  80069b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a0:	8d 40 04             	lea    0x4(%eax),%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ab:	eb 45                	jmp    8006f2 <vprintfmt+0x386>
			putch('X', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 58                	push   $0x58
  8006b3:	ff d6                	call   *%esi
			putch('X', putdat);
  8006b5:	83 c4 08             	add    $0x8,%esp
  8006b8:	53                   	push   %ebx
  8006b9:	6a 58                	push   $0x58
  8006bb:	ff d6                	call   *%esi
			putch('X', putdat);
  8006bd:	83 c4 08             	add    $0x8,%esp
  8006c0:	53                   	push   %ebx
  8006c1:	6a 58                	push   $0x58
  8006c3:	ff d6                	call   *%esi
			break;
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	eb 42                	jmp    80070c <vprintfmt+0x3a0>
			putch('0', putdat);
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	53                   	push   %ebx
  8006ce:	6a 30                	push   $0x30
  8006d0:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d2:	83 c4 08             	add    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 78                	push   $0x78
  8006d8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 10                	mov    (%eax),%edx
  8006df:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006e4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ed:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006f9:	57                   	push   %edi
  8006fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fd:	50                   	push   %eax
  8006fe:	51                   	push   %ecx
  8006ff:	52                   	push   %edx
  800700:	89 da                	mov    %ebx,%edx
  800702:	89 f0                	mov    %esi,%eax
  800704:	e8 7a fb ff ff       	call   800283 <printnum>
			break;
  800709:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80070c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070f:	83 c7 01             	add    $0x1,%edi
  800712:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800716:	83 f8 25             	cmp    $0x25,%eax
  800719:	0f 84 64 fc ff ff    	je     800383 <vprintfmt+0x17>
			if (ch == '\0')
  80071f:	85 c0                	test   %eax,%eax
  800721:	0f 84 8b 00 00 00    	je     8007b2 <vprintfmt+0x446>
			putch(ch, putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	53                   	push   %ebx
  80072b:	50                   	push   %eax
  80072c:	ff d6                	call   *%esi
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	eb dc                	jmp    80070f <vprintfmt+0x3a3>
	if (lflag >= 2)
  800733:	83 f9 01             	cmp    $0x1,%ecx
  800736:	7e 15                	jle    80074d <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8b 10                	mov    (%eax),%edx
  80073d:	8b 48 04             	mov    0x4(%eax),%ecx
  800740:	8d 40 08             	lea    0x8(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800746:	b8 10 00 00 00       	mov    $0x10,%eax
  80074b:	eb a5                	jmp    8006f2 <vprintfmt+0x386>
	else if (lflag)
  80074d:	85 c9                	test   %ecx,%ecx
  80074f:	75 17                	jne    800768 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 10                	mov    (%eax),%edx
  800756:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075b:	8d 40 04             	lea    0x4(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800761:	b8 10 00 00 00       	mov    $0x10,%eax
  800766:	eb 8a                	jmp    8006f2 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 10                	mov    (%eax),%edx
  80076d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800772:	8d 40 04             	lea    0x4(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800778:	b8 10 00 00 00       	mov    $0x10,%eax
  80077d:	e9 70 ff ff ff       	jmp    8006f2 <vprintfmt+0x386>
			putch(ch, putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	53                   	push   %ebx
  800786:	6a 25                	push   $0x25
  800788:	ff d6                	call   *%esi
			break;
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	e9 7a ff ff ff       	jmp    80070c <vprintfmt+0x3a0>
			putch('%', putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	53                   	push   %ebx
  800796:	6a 25                	push   $0x25
  800798:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 f8                	mov    %edi,%eax
  80079f:	eb 03                	jmp    8007a4 <vprintfmt+0x438>
  8007a1:	83 e8 01             	sub    $0x1,%eax
  8007a4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a8:	75 f7                	jne    8007a1 <vprintfmt+0x435>
  8007aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ad:	e9 5a ff ff ff       	jmp    80070c <vprintfmt+0x3a0>
}
  8007b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b5:	5b                   	pop    %ebx
  8007b6:	5e                   	pop    %esi
  8007b7:	5f                   	pop    %edi
  8007b8:	5d                   	pop    %ebp
  8007b9:	c3                   	ret    

008007ba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 18             	sub    $0x18,%esp
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007cd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d7:	85 c0                	test   %eax,%eax
  8007d9:	74 26                	je     800801 <vsnprintf+0x47>
  8007db:	85 d2                	test   %edx,%edx
  8007dd:	7e 22                	jle    800801 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007df:	ff 75 14             	pushl  0x14(%ebp)
  8007e2:	ff 75 10             	pushl  0x10(%ebp)
  8007e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e8:	50                   	push   %eax
  8007e9:	68 32 03 80 00       	push   $0x800332
  8007ee:	e8 79 fb ff ff       	call   80036c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007fc:	83 c4 10             	add    $0x10,%esp
}
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    
		return -E_INVAL;
  800801:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800806:	eb f7                	jmp    8007ff <vsnprintf+0x45>

00800808 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80080e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800811:	50                   	push   %eax
  800812:	ff 75 10             	pushl  0x10(%ebp)
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	e8 9a ff ff ff       	call   8007ba <vsnprintf>
	va_end(ap);

	return rc;
}
  800820:	c9                   	leave  
  800821:	c3                   	ret    

00800822 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800828:	b8 00 00 00 00       	mov    $0x0,%eax
  80082d:	eb 03                	jmp    800832 <strlen+0x10>
		n++;
  80082f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800832:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800836:	75 f7                	jne    80082f <strlen+0xd>
	return n;
}
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
  800848:	eb 03                	jmp    80084d <strnlen+0x13>
		n++;
  80084a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80084d:	39 d0                	cmp    %edx,%eax
  80084f:	74 06                	je     800857 <strnlen+0x1d>
  800851:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800855:	75 f3                	jne    80084a <strnlen+0x10>
	return n;
}
  800857:	5d                   	pop    %ebp
  800858:	c3                   	ret    

00800859 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800863:	89 c2                	mov    %eax,%edx
  800865:	83 c1 01             	add    $0x1,%ecx
  800868:	83 c2 01             	add    $0x1,%edx
  80086b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80086f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800872:	84 db                	test   %bl,%bl
  800874:	75 ef                	jne    800865 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800876:	5b                   	pop    %ebx
  800877:	5d                   	pop    %ebp
  800878:	c3                   	ret    

00800879 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	53                   	push   %ebx
  80087d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800880:	53                   	push   %ebx
  800881:	e8 9c ff ff ff       	call   800822 <strlen>
  800886:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	01 d8                	add    %ebx,%eax
  80088e:	50                   	push   %eax
  80088f:	e8 c5 ff ff ff       	call   800859 <strcpy>
	return dst;
}
  800894:	89 d8                	mov    %ebx,%eax
  800896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800899:	c9                   	leave  
  80089a:	c3                   	ret    

0080089b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	56                   	push   %esi
  80089f:	53                   	push   %ebx
  8008a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a6:	89 f3                	mov    %esi,%ebx
  8008a8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ab:	89 f2                	mov    %esi,%edx
  8008ad:	eb 0f                	jmp    8008be <strncpy+0x23>
		*dst++ = *src;
  8008af:	83 c2 01             	add    $0x1,%edx
  8008b2:	0f b6 01             	movzbl (%ecx),%eax
  8008b5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b8:	80 39 01             	cmpb   $0x1,(%ecx)
  8008bb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008be:	39 da                	cmp    %ebx,%edx
  8008c0:	75 ed                	jne    8008af <strncpy+0x14>
	}
	return ret;
}
  8008c2:	89 f0                	mov    %esi,%eax
  8008c4:	5b                   	pop    %ebx
  8008c5:	5e                   	pop    %esi
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	56                   	push   %esi
  8008cc:	53                   	push   %ebx
  8008cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008d6:	89 f0                	mov    %esi,%eax
  8008d8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008dc:	85 c9                	test   %ecx,%ecx
  8008de:	75 0b                	jne    8008eb <strlcpy+0x23>
  8008e0:	eb 17                	jmp    8008f9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008e2:	83 c2 01             	add    $0x1,%edx
  8008e5:	83 c0 01             	add    $0x1,%eax
  8008e8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008eb:	39 d8                	cmp    %ebx,%eax
  8008ed:	74 07                	je     8008f6 <strlcpy+0x2e>
  8008ef:	0f b6 0a             	movzbl (%edx),%ecx
  8008f2:	84 c9                	test   %cl,%cl
  8008f4:	75 ec                	jne    8008e2 <strlcpy+0x1a>
		*dst = '\0';
  8008f6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f9:	29 f0                	sub    %esi,%eax
}
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800905:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800908:	eb 06                	jmp    800910 <strcmp+0x11>
		p++, q++;
  80090a:	83 c1 01             	add    $0x1,%ecx
  80090d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800910:	0f b6 01             	movzbl (%ecx),%eax
  800913:	84 c0                	test   %al,%al
  800915:	74 04                	je     80091b <strcmp+0x1c>
  800917:	3a 02                	cmp    (%edx),%al
  800919:	74 ef                	je     80090a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091b:	0f b6 c0             	movzbl %al,%eax
  80091e:	0f b6 12             	movzbl (%edx),%edx
  800921:	29 d0                	sub    %edx,%eax
}
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	53                   	push   %ebx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092f:	89 c3                	mov    %eax,%ebx
  800931:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800934:	eb 06                	jmp    80093c <strncmp+0x17>
		n--, p++, q++;
  800936:	83 c0 01             	add    $0x1,%eax
  800939:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80093c:	39 d8                	cmp    %ebx,%eax
  80093e:	74 16                	je     800956 <strncmp+0x31>
  800940:	0f b6 08             	movzbl (%eax),%ecx
  800943:	84 c9                	test   %cl,%cl
  800945:	74 04                	je     80094b <strncmp+0x26>
  800947:	3a 0a                	cmp    (%edx),%cl
  800949:	74 eb                	je     800936 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80094b:	0f b6 00             	movzbl (%eax),%eax
  80094e:	0f b6 12             	movzbl (%edx),%edx
  800951:	29 d0                	sub    %edx,%eax
}
  800953:	5b                   	pop    %ebx
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    
		return 0;
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	eb f6                	jmp    800953 <strncmp+0x2e>

0080095d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800967:	0f b6 10             	movzbl (%eax),%edx
  80096a:	84 d2                	test   %dl,%dl
  80096c:	74 09                	je     800977 <strchr+0x1a>
		if (*s == c)
  80096e:	38 ca                	cmp    %cl,%dl
  800970:	74 0a                	je     80097c <strchr+0x1f>
	for (; *s; s++)
  800972:	83 c0 01             	add    $0x1,%eax
  800975:	eb f0                	jmp    800967 <strchr+0xa>
			return (char *) s;
	return 0;
  800977:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800988:	eb 03                	jmp    80098d <strfind+0xf>
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800990:	38 ca                	cmp    %cl,%dl
  800992:	74 04                	je     800998 <strfind+0x1a>
  800994:	84 d2                	test   %dl,%dl
  800996:	75 f2                	jne    80098a <strfind+0xc>
			break;
	return (char *) s;
}
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	57                   	push   %edi
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a6:	85 c9                	test   %ecx,%ecx
  8009a8:	74 13                	je     8009bd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009aa:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009b0:	75 05                	jne    8009b7 <memset+0x1d>
  8009b2:	f6 c1 03             	test   $0x3,%cl
  8009b5:	74 0d                	je     8009c4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009bd:	89 f8                	mov    %edi,%eax
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    
		c &= 0xFF;
  8009c4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c8:	89 d3                	mov    %edx,%ebx
  8009ca:	c1 e3 08             	shl    $0x8,%ebx
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	c1 e0 18             	shl    $0x18,%eax
  8009d2:	89 d6                	mov    %edx,%esi
  8009d4:	c1 e6 10             	shl    $0x10,%esi
  8009d7:	09 f0                	or     %esi,%eax
  8009d9:	09 c2                	or     %eax,%edx
  8009db:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009dd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e0:	89 d0                	mov    %edx,%eax
  8009e2:	fc                   	cld    
  8009e3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e5:	eb d6                	jmp    8009bd <memset+0x23>

008009e7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	57                   	push   %edi
  8009eb:	56                   	push   %esi
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f5:	39 c6                	cmp    %eax,%esi
  8009f7:	73 35                	jae    800a2e <memmove+0x47>
  8009f9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009fc:	39 c2                	cmp    %eax,%edx
  8009fe:	76 2e                	jbe    800a2e <memmove+0x47>
		s += n;
		d += n;
  800a00:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a03:	89 d6                	mov    %edx,%esi
  800a05:	09 fe                	or     %edi,%esi
  800a07:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0d:	74 0c                	je     800a1b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a0f:	83 ef 01             	sub    $0x1,%edi
  800a12:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a15:	fd                   	std    
  800a16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a18:	fc                   	cld    
  800a19:	eb 21                	jmp    800a3c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1b:	f6 c1 03             	test   $0x3,%cl
  800a1e:	75 ef                	jne    800a0f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a20:	83 ef 04             	sub    $0x4,%edi
  800a23:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a29:	fd                   	std    
  800a2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a2c:	eb ea                	jmp    800a18 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2e:	89 f2                	mov    %esi,%edx
  800a30:	09 c2                	or     %eax,%edx
  800a32:	f6 c2 03             	test   $0x3,%dl
  800a35:	74 09                	je     800a40 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a37:	89 c7                	mov    %eax,%edi
  800a39:	fc                   	cld    
  800a3a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a3c:	5e                   	pop    %esi
  800a3d:	5f                   	pop    %edi
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a40:	f6 c1 03             	test   $0x3,%cl
  800a43:	75 f2                	jne    800a37 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a45:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a48:	89 c7                	mov    %eax,%edi
  800a4a:	fc                   	cld    
  800a4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4d:	eb ed                	jmp    800a3c <memmove+0x55>

00800a4f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a52:	ff 75 10             	pushl  0x10(%ebp)
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	ff 75 08             	pushl  0x8(%ebp)
  800a5b:	e8 87 ff ff ff       	call   8009e7 <memmove>
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	56                   	push   %esi
  800a66:	53                   	push   %ebx
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6d:	89 c6                	mov    %eax,%esi
  800a6f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a72:	39 f0                	cmp    %esi,%eax
  800a74:	74 1c                	je     800a92 <memcmp+0x30>
		if (*s1 != *s2)
  800a76:	0f b6 08             	movzbl (%eax),%ecx
  800a79:	0f b6 1a             	movzbl (%edx),%ebx
  800a7c:	38 d9                	cmp    %bl,%cl
  800a7e:	75 08                	jne    800a88 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a80:	83 c0 01             	add    $0x1,%eax
  800a83:	83 c2 01             	add    $0x1,%edx
  800a86:	eb ea                	jmp    800a72 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a88:	0f b6 c1             	movzbl %cl,%eax
  800a8b:	0f b6 db             	movzbl %bl,%ebx
  800a8e:	29 d8                	sub    %ebx,%eax
  800a90:	eb 05                	jmp    800a97 <memcmp+0x35>
	}

	return 0;
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa4:	89 c2                	mov    %eax,%edx
  800aa6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa9:	39 d0                	cmp    %edx,%eax
  800aab:	73 09                	jae    800ab6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aad:	38 08                	cmp    %cl,(%eax)
  800aaf:	74 05                	je     800ab6 <memfind+0x1b>
	for (; s < ends; s++)
  800ab1:	83 c0 01             	add    $0x1,%eax
  800ab4:	eb f3                	jmp    800aa9 <memfind+0xe>
			break;
	return (void *) s;
}
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	57                   	push   %edi
  800abc:	56                   	push   %esi
  800abd:	53                   	push   %ebx
  800abe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac4:	eb 03                	jmp    800ac9 <strtol+0x11>
		s++;
  800ac6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ac9:	0f b6 01             	movzbl (%ecx),%eax
  800acc:	3c 20                	cmp    $0x20,%al
  800ace:	74 f6                	je     800ac6 <strtol+0xe>
  800ad0:	3c 09                	cmp    $0x9,%al
  800ad2:	74 f2                	je     800ac6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ad4:	3c 2b                	cmp    $0x2b,%al
  800ad6:	74 2e                	je     800b06 <strtol+0x4e>
	int neg = 0;
  800ad8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800add:	3c 2d                	cmp    $0x2d,%al
  800adf:	74 2f                	je     800b10 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae7:	75 05                	jne    800aee <strtol+0x36>
  800ae9:	80 39 30             	cmpb   $0x30,(%ecx)
  800aec:	74 2c                	je     800b1a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aee:	85 db                	test   %ebx,%ebx
  800af0:	75 0a                	jne    800afc <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800af7:	80 39 30             	cmpb   $0x30,(%ecx)
  800afa:	74 28                	je     800b24 <strtol+0x6c>
		base = 10;
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b04:	eb 50                	jmp    800b56 <strtol+0x9e>
		s++;
  800b06:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b09:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0e:	eb d1                	jmp    800ae1 <strtol+0x29>
		s++, neg = 1;
  800b10:	83 c1 01             	add    $0x1,%ecx
  800b13:	bf 01 00 00 00       	mov    $0x1,%edi
  800b18:	eb c7                	jmp    800ae1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b1e:	74 0e                	je     800b2e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b20:	85 db                	test   %ebx,%ebx
  800b22:	75 d8                	jne    800afc <strtol+0x44>
		s++, base = 8;
  800b24:	83 c1 01             	add    $0x1,%ecx
  800b27:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b2c:	eb ce                	jmp    800afc <strtol+0x44>
		s += 2, base = 16;
  800b2e:	83 c1 02             	add    $0x2,%ecx
  800b31:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b36:	eb c4                	jmp    800afc <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b38:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b3b:	89 f3                	mov    %esi,%ebx
  800b3d:	80 fb 19             	cmp    $0x19,%bl
  800b40:	77 29                	ja     800b6b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b42:	0f be d2             	movsbl %dl,%edx
  800b45:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b48:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b4b:	7d 30                	jge    800b7d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b4d:	83 c1 01             	add    $0x1,%ecx
  800b50:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b54:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b56:	0f b6 11             	movzbl (%ecx),%edx
  800b59:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b5c:	89 f3                	mov    %esi,%ebx
  800b5e:	80 fb 09             	cmp    $0x9,%bl
  800b61:	77 d5                	ja     800b38 <strtol+0x80>
			dig = *s - '0';
  800b63:	0f be d2             	movsbl %dl,%edx
  800b66:	83 ea 30             	sub    $0x30,%edx
  800b69:	eb dd                	jmp    800b48 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b6b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b6e:	89 f3                	mov    %esi,%ebx
  800b70:	80 fb 19             	cmp    $0x19,%bl
  800b73:	77 08                	ja     800b7d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b75:	0f be d2             	movsbl %dl,%edx
  800b78:	83 ea 37             	sub    $0x37,%edx
  800b7b:	eb cb                	jmp    800b48 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b81:	74 05                	je     800b88 <strtol+0xd0>
		*endptr = (char *) s;
  800b83:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b86:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b88:	89 c2                	mov    %eax,%edx
  800b8a:	f7 da                	neg    %edx
  800b8c:	85 ff                	test   %edi,%edi
  800b8e:	0f 45 c2             	cmovne %edx,%eax
}
  800b91:	5b                   	pop    %ebx
  800b92:	5e                   	pop    %esi
  800b93:	5f                   	pop    %edi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba7:	89 c3                	mov    %eax,%ebx
  800ba9:	89 c7                	mov    %eax,%edi
  800bab:	89 c6                	mov    %eax,%esi
  800bad:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc4:	89 d1                	mov    %edx,%ecx
  800bc6:	89 d3                	mov    %edx,%ebx
  800bc8:	89 d7                	mov    %edx,%edi
  800bca:	89 d6                	mov    %edx,%esi
  800bcc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	b8 03 00 00 00       	mov    $0x3,%eax
  800be9:	89 cb                	mov    %ecx,%ebx
  800beb:	89 cf                	mov    %ecx,%edi
  800bed:	89 ce                	mov    %ecx,%esi
  800bef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf1:	85 c0                	test   %eax,%eax
  800bf3:	7f 08                	jg     800bfd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf8:	5b                   	pop    %ebx
  800bf9:	5e                   	pop    %esi
  800bfa:	5f                   	pop    %edi
  800bfb:	5d                   	pop    %ebp
  800bfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfd:	83 ec 0c             	sub    $0xc,%esp
  800c00:	50                   	push   %eax
  800c01:	6a 03                	push   $0x3
  800c03:	68 ff 27 80 00       	push   $0x8027ff
  800c08:	6a 23                	push   $0x23
  800c0a:	68 1c 28 80 00       	push   $0x80281c
  800c0f:	e8 80 f5 ff ff       	call   800194 <_panic>

00800c14 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	b8 02 00 00 00       	mov    $0x2,%eax
  800c24:	89 d1                	mov    %edx,%ecx
  800c26:	89 d3                	mov    %edx,%ebx
  800c28:	89 d7                	mov    %edx,%edi
  800c2a:	89 d6                	mov    %edx,%esi
  800c2c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <sys_yield>:

void
sys_yield(void)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c39:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c43:	89 d1                	mov    %edx,%ecx
  800c45:	89 d3                	mov    %edx,%ebx
  800c47:	89 d7                	mov    %edx,%edi
  800c49:	89 d6                	mov    %edx,%esi
  800c4b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5b:	be 00 00 00 00       	mov    $0x0,%esi
  800c60:	8b 55 08             	mov    0x8(%ebp),%edx
  800c63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c66:	b8 04 00 00 00       	mov    $0x4,%eax
  800c6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6e:	89 f7                	mov    %esi,%edi
  800c70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	7f 08                	jg     800c7e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	50                   	push   %eax
  800c82:	6a 04                	push   $0x4
  800c84:	68 ff 27 80 00       	push   $0x8027ff
  800c89:	6a 23                	push   $0x23
  800c8b:	68 1c 28 80 00       	push   $0x80281c
  800c90:	e8 ff f4 ff ff       	call   800194 <_panic>

00800c95 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca4:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cac:	8b 7d 14             	mov    0x14(%ebp),%edi
  800caf:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb4:	85 c0                	test   %eax,%eax
  800cb6:	7f 08                	jg     800cc0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc0:	83 ec 0c             	sub    $0xc,%esp
  800cc3:	50                   	push   %eax
  800cc4:	6a 05                	push   $0x5
  800cc6:	68 ff 27 80 00       	push   $0x8027ff
  800ccb:	6a 23                	push   $0x23
  800ccd:	68 1c 28 80 00       	push   $0x80281c
  800cd2:	e8 bd f4 ff ff       	call   800194 <_panic>

00800cd7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 06 00 00 00       	mov    $0x6,%eax
  800cf0:	89 df                	mov    %ebx,%edi
  800cf2:	89 de                	mov    %ebx,%esi
  800cf4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7f 08                	jg     800d02 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d02:	83 ec 0c             	sub    $0xc,%esp
  800d05:	50                   	push   %eax
  800d06:	6a 06                	push   $0x6
  800d08:	68 ff 27 80 00       	push   $0x8027ff
  800d0d:	6a 23                	push   $0x23
  800d0f:	68 1c 28 80 00       	push   $0x80281c
  800d14:	e8 7b f4 ff ff       	call   800194 <_panic>

00800d19 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
  800d1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d32:	89 df                	mov    %ebx,%edi
  800d34:	89 de                	mov    %ebx,%esi
  800d36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	7f 08                	jg     800d44 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	50                   	push   %eax
  800d48:	6a 08                	push   $0x8
  800d4a:	68 ff 27 80 00       	push   $0x8027ff
  800d4f:	6a 23                	push   $0x23
  800d51:	68 1c 28 80 00       	push   $0x80281c
  800d56:	e8 39 f4 ff ff       	call   800194 <_panic>

00800d5b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	57                   	push   %edi
  800d5f:	56                   	push   %esi
  800d60:	53                   	push   %ebx
  800d61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6f:	b8 09 00 00 00       	mov    $0x9,%eax
  800d74:	89 df                	mov    %ebx,%edi
  800d76:	89 de                	mov    %ebx,%esi
  800d78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7f 08                	jg     800d86 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	6a 09                	push   $0x9
  800d8c:	68 ff 27 80 00       	push   $0x8027ff
  800d91:	6a 23                	push   $0x23
  800d93:	68 1c 28 80 00       	push   $0x80281c
  800d98:	e8 f7 f3 ff ff       	call   800194 <_panic>

00800d9d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	89 de                	mov    %ebx,%esi
  800dba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	7f 08                	jg     800dc8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc8:	83 ec 0c             	sub    $0xc,%esp
  800dcb:	50                   	push   %eax
  800dcc:	6a 0a                	push   $0xa
  800dce:	68 ff 27 80 00       	push   $0x8027ff
  800dd3:	6a 23                	push   $0x23
  800dd5:	68 1c 28 80 00       	push   $0x80281c
  800dda:	e8 b5 f3 ff ff       	call   800194 <_panic>

00800ddf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de5:	8b 55 08             	mov    0x8(%ebp),%edx
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df0:	be 00 00 00 00       	mov    $0x0,%esi
  800df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dfb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e18:	89 cb                	mov    %ecx,%ebx
  800e1a:	89 cf                	mov    %ecx,%edi
  800e1c:	89 ce                	mov    %ecx,%esi
  800e1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e20:	85 c0                	test   %eax,%eax
  800e22:	7f 08                	jg     800e2c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2c:	83 ec 0c             	sub    $0xc,%esp
  800e2f:	50                   	push   %eax
  800e30:	6a 0d                	push   $0xd
  800e32:	68 ff 27 80 00       	push   $0x8027ff
  800e37:	6a 23                	push   $0x23
  800e39:	68 1c 28 80 00       	push   $0x80281c
  800e3e:	e8 51 f3 ff ff       	call   800194 <_panic>

00800e43 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	05 00 00 00 30       	add    $0x30000000,%eax
  800e4e:	c1 e8 0c             	shr    $0xc,%eax
}
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e63:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e70:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e75:	89 c2                	mov    %eax,%edx
  800e77:	c1 ea 16             	shr    $0x16,%edx
  800e7a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e81:	f6 c2 01             	test   $0x1,%dl
  800e84:	74 2a                	je     800eb0 <fd_alloc+0x46>
  800e86:	89 c2                	mov    %eax,%edx
  800e88:	c1 ea 0c             	shr    $0xc,%edx
  800e8b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e92:	f6 c2 01             	test   $0x1,%dl
  800e95:	74 19                	je     800eb0 <fd_alloc+0x46>
  800e97:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e9c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ea1:	75 d2                	jne    800e75 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ea3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ea9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eae:	eb 07                	jmp    800eb7 <fd_alloc+0x4d>
			*fd_store = fd;
  800eb0:	89 01                	mov    %eax,(%ecx)
			return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ebf:	83 f8 1f             	cmp    $0x1f,%eax
  800ec2:	77 36                	ja     800efa <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ec4:	c1 e0 0c             	shl    $0xc,%eax
  800ec7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ecc:	89 c2                	mov    %eax,%edx
  800ece:	c1 ea 16             	shr    $0x16,%edx
  800ed1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed8:	f6 c2 01             	test   $0x1,%dl
  800edb:	74 24                	je     800f01 <fd_lookup+0x48>
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	c1 ea 0c             	shr    $0xc,%edx
  800ee2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee9:	f6 c2 01             	test   $0x1,%dl
  800eec:	74 1a                	je     800f08 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef1:	89 02                	mov    %eax,(%edx)
	return 0;
  800ef3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    
		return -E_INVAL;
  800efa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eff:	eb f7                	jmp    800ef8 <fd_lookup+0x3f>
		return -E_INVAL;
  800f01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f06:	eb f0                	jmp    800ef8 <fd_lookup+0x3f>
  800f08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f0d:	eb e9                	jmp    800ef8 <fd_lookup+0x3f>

00800f0f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f18:	ba a8 28 80 00       	mov    $0x8028a8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f1d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f22:	39 08                	cmp    %ecx,(%eax)
  800f24:	74 33                	je     800f59 <dev_lookup+0x4a>
  800f26:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f29:	8b 02                	mov    (%edx),%eax
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	75 f3                	jne    800f22 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f2f:	a1 04 40 80 00       	mov    0x804004,%eax
  800f34:	8b 40 48             	mov    0x48(%eax),%eax
  800f37:	83 ec 04             	sub    $0x4,%esp
  800f3a:	51                   	push   %ecx
  800f3b:	50                   	push   %eax
  800f3c:	68 2c 28 80 00       	push   $0x80282c
  800f41:	e8 29 f3 ff ff       	call   80026f <cprintf>
	*dev = 0;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f4f:	83 c4 10             	add    $0x10,%esp
  800f52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f57:	c9                   	leave  
  800f58:	c3                   	ret    
			*dev = devtab[i];
  800f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5c:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f63:	eb f2                	jmp    800f57 <dev_lookup+0x48>

00800f65 <fd_close>:
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
  800f6b:	83 ec 1c             	sub    $0x1c,%esp
  800f6e:	8b 75 08             	mov    0x8(%ebp),%esi
  800f71:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f77:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f78:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f7e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f81:	50                   	push   %eax
  800f82:	e8 32 ff ff ff       	call   800eb9 <fd_lookup>
  800f87:	89 c3                	mov    %eax,%ebx
  800f89:	83 c4 08             	add    $0x8,%esp
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	78 05                	js     800f95 <fd_close+0x30>
	    || fd != fd2)
  800f90:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f93:	74 16                	je     800fab <fd_close+0x46>
		return (must_exist ? r : 0);
  800f95:	89 f8                	mov    %edi,%eax
  800f97:	84 c0                	test   %al,%al
  800f99:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9e:	0f 44 d8             	cmove  %eax,%ebx
}
  800fa1:	89 d8                	mov    %ebx,%eax
  800fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5f                   	pop    %edi
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fb1:	50                   	push   %eax
  800fb2:	ff 36                	pushl  (%esi)
  800fb4:	e8 56 ff ff ff       	call   800f0f <dev_lookup>
  800fb9:	89 c3                	mov    %eax,%ebx
  800fbb:	83 c4 10             	add    $0x10,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	78 15                	js     800fd7 <fd_close+0x72>
		if (dev->dev_close)
  800fc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc5:	8b 40 10             	mov    0x10(%eax),%eax
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	74 1b                	je     800fe7 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	56                   	push   %esi
  800fd0:	ff d0                	call   *%eax
  800fd2:	89 c3                	mov    %eax,%ebx
  800fd4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	56                   	push   %esi
  800fdb:	6a 00                	push   $0x0
  800fdd:	e8 f5 fc ff ff       	call   800cd7 <sys_page_unmap>
	return r;
  800fe2:	83 c4 10             	add    $0x10,%esp
  800fe5:	eb ba                	jmp    800fa1 <fd_close+0x3c>
			r = 0;
  800fe7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fec:	eb e9                	jmp    800fd7 <fd_close+0x72>

00800fee <close>:

int
close(int fdnum)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ff4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff7:	50                   	push   %eax
  800ff8:	ff 75 08             	pushl  0x8(%ebp)
  800ffb:	e8 b9 fe ff ff       	call   800eb9 <fd_lookup>
  801000:	83 c4 08             	add    $0x8,%esp
  801003:	85 c0                	test   %eax,%eax
  801005:	78 10                	js     801017 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	6a 01                	push   $0x1
  80100c:	ff 75 f4             	pushl  -0xc(%ebp)
  80100f:	e8 51 ff ff ff       	call   800f65 <fd_close>
  801014:	83 c4 10             	add    $0x10,%esp
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <close_all>:

void
close_all(void)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	53                   	push   %ebx
  80101d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801020:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801025:	83 ec 0c             	sub    $0xc,%esp
  801028:	53                   	push   %ebx
  801029:	e8 c0 ff ff ff       	call   800fee <close>
	for (i = 0; i < MAXFD; i++)
  80102e:	83 c3 01             	add    $0x1,%ebx
  801031:	83 c4 10             	add    $0x10,%esp
  801034:	83 fb 20             	cmp    $0x20,%ebx
  801037:	75 ec                	jne    801025 <close_all+0xc>
}
  801039:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801047:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	ff 75 08             	pushl  0x8(%ebp)
  80104e:	e8 66 fe ff ff       	call   800eb9 <fd_lookup>
  801053:	89 c3                	mov    %eax,%ebx
  801055:	83 c4 08             	add    $0x8,%esp
  801058:	85 c0                	test   %eax,%eax
  80105a:	0f 88 81 00 00 00    	js     8010e1 <dup+0xa3>
		return r;
	close(newfdnum);
  801060:	83 ec 0c             	sub    $0xc,%esp
  801063:	ff 75 0c             	pushl  0xc(%ebp)
  801066:	e8 83 ff ff ff       	call   800fee <close>

	newfd = INDEX2FD(newfdnum);
  80106b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80106e:	c1 e6 0c             	shl    $0xc,%esi
  801071:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801077:	83 c4 04             	add    $0x4,%esp
  80107a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80107d:	e8 d1 fd ff ff       	call   800e53 <fd2data>
  801082:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801084:	89 34 24             	mov    %esi,(%esp)
  801087:	e8 c7 fd ff ff       	call   800e53 <fd2data>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801091:	89 d8                	mov    %ebx,%eax
  801093:	c1 e8 16             	shr    $0x16,%eax
  801096:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80109d:	a8 01                	test   $0x1,%al
  80109f:	74 11                	je     8010b2 <dup+0x74>
  8010a1:	89 d8                	mov    %ebx,%eax
  8010a3:	c1 e8 0c             	shr    $0xc,%eax
  8010a6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010ad:	f6 c2 01             	test   $0x1,%dl
  8010b0:	75 39                	jne    8010eb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010b5:	89 d0                	mov    %edx,%eax
  8010b7:	c1 e8 0c             	shr    $0xc,%eax
  8010ba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010c1:	83 ec 0c             	sub    $0xc,%esp
  8010c4:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c9:	50                   	push   %eax
  8010ca:	56                   	push   %esi
  8010cb:	6a 00                	push   $0x0
  8010cd:	52                   	push   %edx
  8010ce:	6a 00                	push   $0x0
  8010d0:	e8 c0 fb ff ff       	call   800c95 <sys_page_map>
  8010d5:	89 c3                	mov    %eax,%ebx
  8010d7:	83 c4 20             	add    $0x20,%esp
  8010da:	85 c0                	test   %eax,%eax
  8010dc:	78 31                	js     80110f <dup+0xd1>
		goto err;

	return newfdnum;
  8010de:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010e1:	89 d8                	mov    %ebx,%eax
  8010e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e6:	5b                   	pop    %ebx
  8010e7:	5e                   	pop    %esi
  8010e8:	5f                   	pop    %edi
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8010fa:	50                   	push   %eax
  8010fb:	57                   	push   %edi
  8010fc:	6a 00                	push   $0x0
  8010fe:	53                   	push   %ebx
  8010ff:	6a 00                	push   $0x0
  801101:	e8 8f fb ff ff       	call   800c95 <sys_page_map>
  801106:	89 c3                	mov    %eax,%ebx
  801108:	83 c4 20             	add    $0x20,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	79 a3                	jns    8010b2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80110f:	83 ec 08             	sub    $0x8,%esp
  801112:	56                   	push   %esi
  801113:	6a 00                	push   $0x0
  801115:	e8 bd fb ff ff       	call   800cd7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80111a:	83 c4 08             	add    $0x8,%esp
  80111d:	57                   	push   %edi
  80111e:	6a 00                	push   $0x0
  801120:	e8 b2 fb ff ff       	call   800cd7 <sys_page_unmap>
	return r;
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	eb b7                	jmp    8010e1 <dup+0xa3>

0080112a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	53                   	push   %ebx
  80112e:	83 ec 14             	sub    $0x14,%esp
  801131:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801134:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801137:	50                   	push   %eax
  801138:	53                   	push   %ebx
  801139:	e8 7b fd ff ff       	call   800eb9 <fd_lookup>
  80113e:	83 c4 08             	add    $0x8,%esp
  801141:	85 c0                	test   %eax,%eax
  801143:	78 3f                	js     801184 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80114b:	50                   	push   %eax
  80114c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114f:	ff 30                	pushl  (%eax)
  801151:	e8 b9 fd ff ff       	call   800f0f <dev_lookup>
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	85 c0                	test   %eax,%eax
  80115b:	78 27                	js     801184 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80115d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801160:	8b 42 08             	mov    0x8(%edx),%eax
  801163:	83 e0 03             	and    $0x3,%eax
  801166:	83 f8 01             	cmp    $0x1,%eax
  801169:	74 1e                	je     801189 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80116b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116e:	8b 40 08             	mov    0x8(%eax),%eax
  801171:	85 c0                	test   %eax,%eax
  801173:	74 35                	je     8011aa <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801175:	83 ec 04             	sub    $0x4,%esp
  801178:	ff 75 10             	pushl  0x10(%ebp)
  80117b:	ff 75 0c             	pushl  0xc(%ebp)
  80117e:	52                   	push   %edx
  80117f:	ff d0                	call   *%eax
  801181:	83 c4 10             	add    $0x10,%esp
}
  801184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801187:	c9                   	leave  
  801188:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801189:	a1 04 40 80 00       	mov    0x804004,%eax
  80118e:	8b 40 48             	mov    0x48(%eax),%eax
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	53                   	push   %ebx
  801195:	50                   	push   %eax
  801196:	68 6d 28 80 00       	push   $0x80286d
  80119b:	e8 cf f0 ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a8:	eb da                	jmp    801184 <read+0x5a>
		return -E_NOT_SUPP;
  8011aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011af:	eb d3                	jmp    801184 <read+0x5a>

008011b1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
  8011b7:	83 ec 0c             	sub    $0xc,%esp
  8011ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011bd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c5:	39 f3                	cmp    %esi,%ebx
  8011c7:	73 25                	jae    8011ee <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011c9:	83 ec 04             	sub    $0x4,%esp
  8011cc:	89 f0                	mov    %esi,%eax
  8011ce:	29 d8                	sub    %ebx,%eax
  8011d0:	50                   	push   %eax
  8011d1:	89 d8                	mov    %ebx,%eax
  8011d3:	03 45 0c             	add    0xc(%ebp),%eax
  8011d6:	50                   	push   %eax
  8011d7:	57                   	push   %edi
  8011d8:	e8 4d ff ff ff       	call   80112a <read>
		if (m < 0)
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	78 08                	js     8011ec <readn+0x3b>
			return m;
		if (m == 0)
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	74 06                	je     8011ee <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011e8:	01 c3                	add    %eax,%ebx
  8011ea:	eb d9                	jmp    8011c5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011ec:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011ee:	89 d8                	mov    %ebx,%eax
  8011f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f3:	5b                   	pop    %ebx
  8011f4:	5e                   	pop    %esi
  8011f5:	5f                   	pop    %edi
  8011f6:	5d                   	pop    %ebp
  8011f7:	c3                   	ret    

008011f8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 14             	sub    $0x14,%esp
  8011ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801202:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801205:	50                   	push   %eax
  801206:	53                   	push   %ebx
  801207:	e8 ad fc ff ff       	call   800eb9 <fd_lookup>
  80120c:	83 c4 08             	add    $0x8,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	78 3a                	js     80124d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801219:	50                   	push   %eax
  80121a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121d:	ff 30                	pushl  (%eax)
  80121f:	e8 eb fc ff ff       	call   800f0f <dev_lookup>
  801224:	83 c4 10             	add    $0x10,%esp
  801227:	85 c0                	test   %eax,%eax
  801229:	78 22                	js     80124d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80122b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801232:	74 1e                	je     801252 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801237:	8b 52 0c             	mov    0xc(%edx),%edx
  80123a:	85 d2                	test   %edx,%edx
  80123c:	74 35                	je     801273 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80123e:	83 ec 04             	sub    $0x4,%esp
  801241:	ff 75 10             	pushl  0x10(%ebp)
  801244:	ff 75 0c             	pushl  0xc(%ebp)
  801247:	50                   	push   %eax
  801248:	ff d2                	call   *%edx
  80124a:	83 c4 10             	add    $0x10,%esp
}
  80124d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801250:	c9                   	leave  
  801251:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801252:	a1 04 40 80 00       	mov    0x804004,%eax
  801257:	8b 40 48             	mov    0x48(%eax),%eax
  80125a:	83 ec 04             	sub    $0x4,%esp
  80125d:	53                   	push   %ebx
  80125e:	50                   	push   %eax
  80125f:	68 89 28 80 00       	push   $0x802889
  801264:	e8 06 f0 ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801271:	eb da                	jmp    80124d <write+0x55>
		return -E_NOT_SUPP;
  801273:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801278:	eb d3                	jmp    80124d <write+0x55>

0080127a <seek>:

int
seek(int fdnum, off_t offset)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801280:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801283:	50                   	push   %eax
  801284:	ff 75 08             	pushl  0x8(%ebp)
  801287:	e8 2d fc ff ff       	call   800eb9 <fd_lookup>
  80128c:	83 c4 08             	add    $0x8,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	78 0e                	js     8012a1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801293:	8b 55 0c             	mov    0xc(%ebp),%edx
  801296:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801299:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80129c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 14             	sub    $0x14,%esp
  8012aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b0:	50                   	push   %eax
  8012b1:	53                   	push   %ebx
  8012b2:	e8 02 fc ff ff       	call   800eb9 <fd_lookup>
  8012b7:	83 c4 08             	add    $0x8,%esp
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	78 37                	js     8012f5 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012be:	83 ec 08             	sub    $0x8,%esp
  8012c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c4:	50                   	push   %eax
  8012c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c8:	ff 30                	pushl  (%eax)
  8012ca:	e8 40 fc ff ff       	call   800f0f <dev_lookup>
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 1f                	js     8012f5 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012dd:	74 1b                	je     8012fa <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e2:	8b 52 18             	mov    0x18(%edx),%edx
  8012e5:	85 d2                	test   %edx,%edx
  8012e7:	74 32                	je     80131b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	50                   	push   %eax
  8012f0:	ff d2                	call   *%edx
  8012f2:	83 c4 10             	add    $0x10,%esp
}
  8012f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012fa:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012ff:	8b 40 48             	mov    0x48(%eax),%eax
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	53                   	push   %ebx
  801306:	50                   	push   %eax
  801307:	68 4c 28 80 00       	push   $0x80284c
  80130c:	e8 5e ef ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801319:	eb da                	jmp    8012f5 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80131b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801320:	eb d3                	jmp    8012f5 <ftruncate+0x52>

00801322 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	53                   	push   %ebx
  801326:	83 ec 14             	sub    $0x14,%esp
  801329:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80132c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132f:	50                   	push   %eax
  801330:	ff 75 08             	pushl  0x8(%ebp)
  801333:	e8 81 fb ff ff       	call   800eb9 <fd_lookup>
  801338:	83 c4 08             	add    $0x8,%esp
  80133b:	85 c0                	test   %eax,%eax
  80133d:	78 4b                	js     80138a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801345:	50                   	push   %eax
  801346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801349:	ff 30                	pushl  (%eax)
  80134b:	e8 bf fb ff ff       	call   800f0f <dev_lookup>
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	85 c0                	test   %eax,%eax
  801355:	78 33                	js     80138a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80135e:	74 2f                	je     80138f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801360:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801363:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80136a:	00 00 00 
	stat->st_isdir = 0;
  80136d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801374:	00 00 00 
	stat->st_dev = dev;
  801377:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80137d:	83 ec 08             	sub    $0x8,%esp
  801380:	53                   	push   %ebx
  801381:	ff 75 f0             	pushl  -0x10(%ebp)
  801384:	ff 50 14             	call   *0x14(%eax)
  801387:	83 c4 10             	add    $0x10,%esp
}
  80138a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    
		return -E_NOT_SUPP;
  80138f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801394:	eb f4                	jmp    80138a <fstat+0x68>

00801396 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	56                   	push   %esi
  80139a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80139b:	83 ec 08             	sub    $0x8,%esp
  80139e:	6a 00                	push   $0x0
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 e7 01 00 00       	call   80158f <open>
  8013a8:	89 c3                	mov    %eax,%ebx
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 1b                	js     8013cc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013b1:	83 ec 08             	sub    $0x8,%esp
  8013b4:	ff 75 0c             	pushl  0xc(%ebp)
  8013b7:	50                   	push   %eax
  8013b8:	e8 65 ff ff ff       	call   801322 <fstat>
  8013bd:	89 c6                	mov    %eax,%esi
	close(fd);
  8013bf:	89 1c 24             	mov    %ebx,(%esp)
  8013c2:	e8 27 fc ff ff       	call   800fee <close>
	return r;
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 f3                	mov    %esi,%ebx
}
  8013cc:	89 d8                	mov    %ebx,%eax
  8013ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d1:	5b                   	pop    %ebx
  8013d2:	5e                   	pop    %esi
  8013d3:	5d                   	pop    %ebp
  8013d4:	c3                   	ret    

008013d5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	56                   	push   %esi
  8013d9:	53                   	push   %ebx
  8013da:	89 c6                	mov    %eax,%esi
  8013dc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013de:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013e5:	74 27                	je     80140e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013e7:	6a 07                	push   $0x7
  8013e9:	68 00 50 80 00       	push   $0x805000
  8013ee:	56                   	push   %esi
  8013ef:	ff 35 00 40 80 00    	pushl  0x804000
  8013f5:	e8 31 0d 00 00       	call   80212b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013fa:	83 c4 0c             	add    $0xc,%esp
  8013fd:	6a 00                	push   $0x0
  8013ff:	53                   	push   %ebx
  801400:	6a 00                	push   $0x0
  801402:	e8 0d 0d 00 00       	call   802114 <ipc_recv>
}
  801407:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80140a:	5b                   	pop    %ebx
  80140b:	5e                   	pop    %esi
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	6a 01                	push   $0x1
  801413:	e8 2a 0d 00 00       	call   802142 <ipc_find_env>
  801418:	a3 00 40 80 00       	mov    %eax,0x804000
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	eb c5                	jmp    8013e7 <fsipc+0x12>

00801422 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8b 40 0c             	mov    0xc(%eax),%eax
  80142e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80143b:	ba 00 00 00 00       	mov    $0x0,%edx
  801440:	b8 02 00 00 00       	mov    $0x2,%eax
  801445:	e8 8b ff ff ff       	call   8013d5 <fsipc>
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <devfile_flush>:
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8b 40 0c             	mov    0xc(%eax),%eax
  801458:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80145d:	ba 00 00 00 00       	mov    $0x0,%edx
  801462:	b8 06 00 00 00       	mov    $0x6,%eax
  801467:	e8 69 ff ff ff       	call   8013d5 <fsipc>
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <devfile_stat>:
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	53                   	push   %ebx
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8b 40 0c             	mov    0xc(%eax),%eax
  80147e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801483:	ba 00 00 00 00       	mov    $0x0,%edx
  801488:	b8 05 00 00 00       	mov    $0x5,%eax
  80148d:	e8 43 ff ff ff       	call   8013d5 <fsipc>
  801492:	85 c0                	test   %eax,%eax
  801494:	78 2c                	js     8014c2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	68 00 50 80 00       	push   $0x805000
  80149e:	53                   	push   %ebx
  80149f:	e8 b5 f3 ff ff       	call   800859 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014a4:	a1 80 50 80 00       	mov    0x805080,%eax
  8014a9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014af:	a1 84 50 80 00       	mov    0x805084,%eax
  8014b4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <devfile_write>:
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 0c             	sub    $0xc,%esp
  8014cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d0:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014d5:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014da:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e0:	8b 52 0c             	mov    0xc(%edx),%edx
  8014e3:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8014e9:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8014ee:	50                   	push   %eax
  8014ef:	ff 75 0c             	pushl  0xc(%ebp)
  8014f2:	68 08 50 80 00       	push   $0x805008
  8014f7:	e8 eb f4 ff ff       	call   8009e7 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801501:	b8 04 00 00 00       	mov    $0x4,%eax
  801506:	e8 ca fe ff ff       	call   8013d5 <fsipc>
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <devfile_read>:
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	56                   	push   %esi
  801511:	53                   	push   %ebx
  801512:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8b 40 0c             	mov    0xc(%eax),%eax
  80151b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801520:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801526:	ba 00 00 00 00       	mov    $0x0,%edx
  80152b:	b8 03 00 00 00       	mov    $0x3,%eax
  801530:	e8 a0 fe ff ff       	call   8013d5 <fsipc>
  801535:	89 c3                	mov    %eax,%ebx
  801537:	85 c0                	test   %eax,%eax
  801539:	78 1f                	js     80155a <devfile_read+0x4d>
	assert(r <= n);
  80153b:	39 f0                	cmp    %esi,%eax
  80153d:	77 24                	ja     801563 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80153f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801544:	7f 33                	jg     801579 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801546:	83 ec 04             	sub    $0x4,%esp
  801549:	50                   	push   %eax
  80154a:	68 00 50 80 00       	push   $0x805000
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	e8 90 f4 ff ff       	call   8009e7 <memmove>
	return r;
  801557:	83 c4 10             	add    $0x10,%esp
}
  80155a:	89 d8                	mov    %ebx,%eax
  80155c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    
	assert(r <= n);
  801563:	68 b8 28 80 00       	push   $0x8028b8
  801568:	68 bf 28 80 00       	push   $0x8028bf
  80156d:	6a 7c                	push   $0x7c
  80156f:	68 d4 28 80 00       	push   $0x8028d4
  801574:	e8 1b ec ff ff       	call   800194 <_panic>
	assert(r <= PGSIZE);
  801579:	68 df 28 80 00       	push   $0x8028df
  80157e:	68 bf 28 80 00       	push   $0x8028bf
  801583:	6a 7d                	push   $0x7d
  801585:	68 d4 28 80 00       	push   $0x8028d4
  80158a:	e8 05 ec ff ff       	call   800194 <_panic>

0080158f <open>:
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	56                   	push   %esi
  801593:	53                   	push   %ebx
  801594:	83 ec 1c             	sub    $0x1c,%esp
  801597:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80159a:	56                   	push   %esi
  80159b:	e8 82 f2 ff ff       	call   800822 <strlen>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015a8:	7f 6c                	jg     801616 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015aa:	83 ec 0c             	sub    $0xc,%esp
  8015ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	e8 b4 f8 ff ff       	call   800e6a <fd_alloc>
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 3c                	js     8015fb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015bf:	83 ec 08             	sub    $0x8,%esp
  8015c2:	56                   	push   %esi
  8015c3:	68 00 50 80 00       	push   $0x805000
  8015c8:	e8 8c f2 ff ff       	call   800859 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8015dd:	e8 f3 fd ff ff       	call   8013d5 <fsipc>
  8015e2:	89 c3                	mov    %eax,%ebx
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 19                	js     801604 <open+0x75>
	return fd2num(fd);
  8015eb:	83 ec 0c             	sub    $0xc,%esp
  8015ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f1:	e8 4d f8 ff ff       	call   800e43 <fd2num>
  8015f6:	89 c3                	mov    %eax,%ebx
  8015f8:	83 c4 10             	add    $0x10,%esp
}
  8015fb:	89 d8                	mov    %ebx,%eax
  8015fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801600:	5b                   	pop    %ebx
  801601:	5e                   	pop    %esi
  801602:	5d                   	pop    %ebp
  801603:	c3                   	ret    
		fd_close(fd, 0);
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	6a 00                	push   $0x0
  801609:	ff 75 f4             	pushl  -0xc(%ebp)
  80160c:	e8 54 f9 ff ff       	call   800f65 <fd_close>
		return r;
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	eb e5                	jmp    8015fb <open+0x6c>
		return -E_BAD_PATH;
  801616:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80161b:	eb de                	jmp    8015fb <open+0x6c>

0080161d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801623:	ba 00 00 00 00       	mov    $0x0,%edx
  801628:	b8 08 00 00 00       	mov    $0x8,%eax
  80162d:	e8 a3 fd ff ff       	call   8013d5 <fsipc>
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	57                   	push   %edi
  801638:	56                   	push   %esi
  801639:	53                   	push   %ebx
  80163a:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801640:	6a 00                	push   $0x0
  801642:	ff 75 08             	pushl  0x8(%ebp)
  801645:	e8 45 ff ff ff       	call   80158f <open>
  80164a:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	85 c0                	test   %eax,%eax
  801655:	0f 88 40 03 00 00    	js     80199b <spawn+0x367>
  80165b:	89 c7                	mov    %eax,%edi
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	68 00 02 00 00       	push   $0x200
  801665:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	57                   	push   %edi
  80166d:	e8 3f fb ff ff       	call   8011b1 <readn>
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	3d 00 02 00 00       	cmp    $0x200,%eax
  80167a:	75 5d                	jne    8016d9 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  80167c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801683:	45 4c 46 
  801686:	75 51                	jne    8016d9 <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801688:	b8 07 00 00 00       	mov    $0x7,%eax
  80168d:	cd 30                	int    $0x30
  80168f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801695:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80169b:	85 c0                	test   %eax,%eax
  80169d:	0f 88 81 04 00 00    	js     801b24 <spawn+0x4f0>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8016a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016a8:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8016ab:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8016b1:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8016b7:	b9 11 00 00 00       	mov    $0x11,%ecx
  8016bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8016be:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8016c4:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8016ca:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8016cf:	be 00 00 00 00       	mov    $0x0,%esi
  8016d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016d7:	eb 4b                	jmp    801724 <spawn+0xf0>
		close(fd);
  8016d9:	83 ec 0c             	sub    $0xc,%esp
  8016dc:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8016e2:	e8 07 f9 ff ff       	call   800fee <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8016e7:	83 c4 0c             	add    $0xc,%esp
  8016ea:	68 7f 45 4c 46       	push   $0x464c457f
  8016ef:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8016f5:	68 eb 28 80 00       	push   $0x8028eb
  8016fa:	e8 70 eb ff ff       	call   80026f <cprintf>
		return -E_NOT_EXEC;
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801709:	ff ff ff 
  80170c:	e9 8a 02 00 00       	jmp    80199b <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801711:	83 ec 0c             	sub    $0xc,%esp
  801714:	50                   	push   %eax
  801715:	e8 08 f1 ff ff       	call   800822 <strlen>
  80171a:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80171e:	83 c3 01             	add    $0x1,%ebx
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80172b:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80172e:	85 c0                	test   %eax,%eax
  801730:	75 df                	jne    801711 <spawn+0xdd>
  801732:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801738:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80173e:	bf 00 10 40 00       	mov    $0x401000,%edi
  801743:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801745:	89 fa                	mov    %edi,%edx
  801747:	83 e2 fc             	and    $0xfffffffc,%edx
  80174a:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801751:	29 c2                	sub    %eax,%edx
  801753:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801759:	8d 42 f8             	lea    -0x8(%edx),%eax
  80175c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801761:	0f 86 ce 03 00 00    	jbe    801b35 <spawn+0x501>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	6a 07                	push   $0x7
  80176c:	68 00 00 40 00       	push   $0x400000
  801771:	6a 00                	push   $0x0
  801773:	e8 da f4 ff ff       	call   800c52 <sys_page_alloc>
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	85 c0                	test   %eax,%eax
  80177d:	0f 88 b7 03 00 00    	js     801b3a <spawn+0x506>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801783:	be 00 00 00 00       	mov    $0x0,%esi
  801788:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  80178e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801791:	eb 30                	jmp    8017c3 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801793:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801799:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  80179f:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8017a2:	83 ec 08             	sub    $0x8,%esp
  8017a5:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8017a8:	57                   	push   %edi
  8017a9:	e8 ab f0 ff ff       	call   800859 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8017ae:	83 c4 04             	add    $0x4,%esp
  8017b1:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8017b4:	e8 69 f0 ff ff       	call   800822 <strlen>
  8017b9:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8017bd:	83 c6 01             	add    $0x1,%esi
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  8017c9:	7f c8                	jg     801793 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  8017cb:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8017d1:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8017d7:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8017de:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8017e4:	0f 85 8c 00 00 00    	jne    801876 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8017ea:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  8017f0:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8017f6:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  8017f9:	89 f8                	mov    %edi,%eax
  8017fb:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801801:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801804:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801809:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	6a 07                	push   $0x7
  801814:	68 00 d0 bf ee       	push   $0xeebfd000
  801819:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80181f:	68 00 00 40 00       	push   $0x400000
  801824:	6a 00                	push   $0x0
  801826:	e8 6a f4 ff ff       	call   800c95 <sys_page_map>
  80182b:	89 c3                	mov    %eax,%ebx
  80182d:	83 c4 20             	add    $0x20,%esp
  801830:	85 c0                	test   %eax,%eax
  801832:	0f 88 78 03 00 00    	js     801bb0 <spawn+0x57c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	68 00 00 40 00       	push   $0x400000
  801840:	6a 00                	push   $0x0
  801842:	e8 90 f4 ff ff       	call   800cd7 <sys_page_unmap>
  801847:	89 c3                	mov    %eax,%ebx
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	85 c0                	test   %eax,%eax
  80184e:	0f 88 5c 03 00 00    	js     801bb0 <spawn+0x57c>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801854:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80185a:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801861:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801867:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  80186e:	00 00 00 
  801871:	e9 56 01 00 00       	jmp    8019cc <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801876:	68 78 29 80 00       	push   $0x802978
  80187b:	68 bf 28 80 00       	push   $0x8028bf
  801880:	68 f2 00 00 00       	push   $0xf2
  801885:	68 05 29 80 00       	push   $0x802905
  80188a:	e8 05 e9 ff ff       	call   800194 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	6a 07                	push   $0x7
  801894:	68 00 00 40 00       	push   $0x400000
  801899:	6a 00                	push   $0x0
  80189b:	e8 b2 f3 ff ff       	call   800c52 <sys_page_alloc>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	0f 88 9a 02 00 00    	js     801b45 <spawn+0x511>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8018b4:	01 f0                	add    %esi,%eax
  8018b6:	50                   	push   %eax
  8018b7:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8018bd:	e8 b8 f9 ff ff       	call   80127a <seek>
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	0f 88 7f 02 00 00    	js     801b4c <spawn+0x518>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8018d6:	29 f0                	sub    %esi,%eax
  8018d8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018dd:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8018e2:	0f 47 c1             	cmova  %ecx,%eax
  8018e5:	50                   	push   %eax
  8018e6:	68 00 00 40 00       	push   $0x400000
  8018eb:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8018f1:	e8 bb f8 ff ff       	call   8011b1 <readn>
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	0f 88 52 02 00 00    	js     801b53 <spawn+0x51f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	57                   	push   %edi
  801905:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  80190b:	56                   	push   %esi
  80190c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801912:	68 00 00 40 00       	push   $0x400000
  801917:	6a 00                	push   $0x0
  801919:	e8 77 f3 ff ff       	call   800c95 <sys_page_map>
  80191e:	83 c4 20             	add    $0x20,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	0f 88 80 00 00 00    	js     8019a9 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801929:	83 ec 08             	sub    $0x8,%esp
  80192c:	68 00 00 40 00       	push   $0x400000
  801931:	6a 00                	push   $0x0
  801933:	e8 9f f3 ff ff       	call   800cd7 <sys_page_unmap>
  801938:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80193b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801941:	89 de                	mov    %ebx,%esi
  801943:	39 9d 88 fd ff ff    	cmp    %ebx,-0x278(%ebp)
  801949:	76 73                	jbe    8019be <spawn+0x38a>
		if (i >= filesz) {
  80194b:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801951:	0f 87 38 ff ff ff    	ja     80188f <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	57                   	push   %edi
  80195b:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  801961:	56                   	push   %esi
  801962:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801968:	e8 e5 f2 ff ff       	call   800c52 <sys_page_alloc>
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	79 c7                	jns    80193b <spawn+0x307>
  801974:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801976:	83 ec 0c             	sub    $0xc,%esp
  801979:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80197f:	e8 4f f2 ff ff       	call   800bd3 <sys_env_destroy>
	close(fd);
  801984:	83 c4 04             	add    $0x4,%esp
  801987:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80198d:	e8 5c f6 ff ff       	call   800fee <close>
	return r;
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  80199b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8019a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019a4:	5b                   	pop    %ebx
  8019a5:	5e                   	pop    %esi
  8019a6:	5f                   	pop    %edi
  8019a7:	5d                   	pop    %ebp
  8019a8:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  8019a9:	50                   	push   %eax
  8019aa:	68 11 29 80 00       	push   $0x802911
  8019af:	68 25 01 00 00       	push   $0x125
  8019b4:	68 05 29 80 00       	push   $0x802905
  8019b9:	e8 d6 e7 ff ff       	call   800194 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019be:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8019c5:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  8019cc:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8019d3:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  8019d9:	7e 71                	jle    801a4c <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  8019db:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  8019e1:	83 39 01             	cmpl   $0x1,(%ecx)
  8019e4:	75 d8                	jne    8019be <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8019e6:	8b 41 18             	mov    0x18(%ecx),%eax
  8019e9:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8019ec:	83 f8 01             	cmp    $0x1,%eax
  8019ef:	19 ff                	sbb    %edi,%edi
  8019f1:	83 e7 fe             	and    $0xfffffffe,%edi
  8019f4:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8019f7:	8b 71 04             	mov    0x4(%ecx),%esi
  8019fa:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801a00:	8b 59 10             	mov    0x10(%ecx),%ebx
  801a03:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801a09:	8b 41 14             	mov    0x14(%ecx),%eax
  801a0c:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801a12:	8b 51 08             	mov    0x8(%ecx),%edx
  801a15:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	if ((i = PGOFF(va))) {
  801a1b:	89 d0                	mov    %edx,%eax
  801a1d:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a22:	74 1e                	je     801a42 <spawn+0x40e>
		va -= i;
  801a24:	29 c2                	sub    %eax,%edx
  801a26:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		memsz += i;
  801a2c:	01 85 88 fd ff ff    	add    %eax,-0x278(%ebp)
		filesz += i;
  801a32:	01 c3                	add    %eax,%ebx
  801a34:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801a3a:	29 c6                	sub    %eax,%esi
  801a3c:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801a42:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a47:	e9 f5 fe ff ff       	jmp    801941 <spawn+0x30d>
	close(fd);
  801a4c:	83 ec 0c             	sub    $0xc,%esp
  801a4f:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801a55:	e8 94 f5 ff ff       	call   800fee <close>
  801a5a:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i, j, pn, r;

        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  801a5d:	bf 02 00 00 00       	mov    $0x2,%edi
  801a62:	eb 7c                	jmp    801ae0 <spawn+0x4ac>
  801a64:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                if (uvpd[i] & PTE_P) {
                        for (j = 0; j < NPTENTRIES; j++) {
  801a6a:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801a70:	74 63                	je     801ad5 <spawn+0x4a1>
                                pn = PGNUM(PGADDR(i, j, 0));
  801a72:	89 da                	mov    %ebx,%edx
  801a74:	09 f2                	or     %esi,%edx
  801a76:	89 d0                	mov    %edx,%eax
  801a78:	c1 e8 0c             	shr    $0xc,%eax
                                if (pn == PGNUM(UXSTACKTOP - PGSIZE))
  801a7b:	3d ff eb 0e 00       	cmp    $0xeebff,%eax
  801a80:	74 53                	je     801ad5 <spawn+0x4a1>
                                        break;
                                if ((uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  801a82:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  801a89:	f6 c1 01             	test   $0x1,%cl
  801a8c:	74 d6                	je     801a64 <spawn+0x430>
  801a8e:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  801a95:	f6 c5 04             	test   $0x4,%ch
  801a98:	74 ca                	je     801a64 <spawn+0x430>
                                        if ((r = sys_page_map(0, (void *)PGADDR(i, j, 0), child, (void *)PGADDR(i, j, 0), uvpt[pn] & PTE_SYSCALL)) < 0)
  801a9a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aa1:	83 ec 0c             	sub    $0xc,%esp
  801aa4:	25 07 0e 00 00       	and    $0xe07,%eax
  801aa9:	50                   	push   %eax
  801aaa:	52                   	push   %edx
  801aab:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ab1:	52                   	push   %edx
  801ab2:	6a 00                	push   $0x0
  801ab4:	e8 dc f1 ff ff       	call   800c95 <sys_page_map>
  801ab9:	83 c4 20             	add    $0x20,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	79 a4                	jns    801a64 <spawn+0x430>
		panic("copy_shared_pages: %e", r);
  801ac0:	50                   	push   %eax
  801ac1:	68 5f 29 80 00       	push   $0x80295f
  801ac6:	68 82 00 00 00       	push   $0x82
  801acb:	68 05 29 80 00       	push   $0x802905
  801ad0:	e8 bf e6 ff ff       	call   800194 <_panic>
        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  801ad5:	83 c7 01             	add    $0x1,%edi
  801ad8:	81 ff bb 03 00 00    	cmp    $0x3bb,%edi
  801ade:	74 7a                	je     801b5a <spawn+0x526>
                if (uvpd[i] & PTE_P) {
  801ae0:	8b 04 bd 00 d0 7b ef 	mov    -0x10843000(,%edi,4),%eax
  801ae7:	a8 01                	test   $0x1,%al
  801ae9:	74 ea                	je     801ad5 <spawn+0x4a1>
  801aeb:	89 fe                	mov    %edi,%esi
  801aed:	c1 e6 16             	shl    $0x16,%esi
  801af0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801af5:	e9 78 ff ff ff       	jmp    801a72 <spawn+0x43e>
		panic("sys_env_set_trapframe: %e", r);
  801afa:	50                   	push   %eax
  801afb:	68 2e 29 80 00       	push   $0x80292e
  801b00:	68 86 00 00 00       	push   $0x86
  801b05:	68 05 29 80 00       	push   $0x802905
  801b0a:	e8 85 e6 ff ff       	call   800194 <_panic>
		panic("sys_env_set_status: %e", r);
  801b0f:	50                   	push   %eax
  801b10:	68 48 29 80 00       	push   $0x802948
  801b15:	68 89 00 00 00       	push   $0x89
  801b1a:	68 05 29 80 00       	push   $0x802905
  801b1f:	e8 70 e6 ff ff       	call   800194 <_panic>
		return r;
  801b24:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b2a:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b30:	e9 66 fe ff ff       	jmp    80199b <spawn+0x367>
		return -E_NO_MEM;
  801b35:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801b3a:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b40:	e9 56 fe ff ff       	jmp    80199b <spawn+0x367>
  801b45:	89 c7                	mov    %eax,%edi
  801b47:	e9 2a fe ff ff       	jmp    801976 <spawn+0x342>
  801b4c:	89 c7                	mov    %eax,%edi
  801b4e:	e9 23 fe ff ff       	jmp    801976 <spawn+0x342>
  801b53:	89 c7                	mov    %eax,%edi
  801b55:	e9 1c fe ff ff       	jmp    801976 <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801b5a:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801b61:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801b64:	83 ec 08             	sub    $0x8,%esp
  801b67:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801b6d:	50                   	push   %eax
  801b6e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b74:	e8 e2 f1 ff ff       	call   800d5b <sys_env_set_trapframe>
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	0f 88 76 ff ff ff    	js     801afa <spawn+0x4c6>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801b84:	83 ec 08             	sub    $0x8,%esp
  801b87:	6a 02                	push   $0x2
  801b89:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b8f:	e8 85 f1 ff ff       	call   800d19 <sys_env_set_status>
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	85 c0                	test   %eax,%eax
  801b99:	0f 88 70 ff ff ff    	js     801b0f <spawn+0x4db>
	return child;
  801b9f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ba5:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801bab:	e9 eb fd ff ff       	jmp    80199b <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  801bb0:	83 ec 08             	sub    $0x8,%esp
  801bb3:	68 00 00 40 00       	push   $0x400000
  801bb8:	6a 00                	push   $0x0
  801bba:	e8 18 f1 ff ff       	call   800cd7 <sys_page_unmap>
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801bc8:	e9 ce fd ff ff       	jmp    80199b <spawn+0x367>

00801bcd <spawnl>:
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	57                   	push   %edi
  801bd1:	56                   	push   %esi
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801bd6:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801bde:	eb 05                	jmp    801be5 <spawnl+0x18>
		argc++;
  801be0:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801be3:	89 ca                	mov    %ecx,%edx
  801be5:	8d 4a 04             	lea    0x4(%edx),%ecx
  801be8:	83 3a 00             	cmpl   $0x0,(%edx)
  801beb:	75 f3                	jne    801be0 <spawnl+0x13>
	const char *argv[argc+2];
  801bed:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801bf4:	83 e2 f0             	and    $0xfffffff0,%edx
  801bf7:	29 d4                	sub    %edx,%esp
  801bf9:	8d 54 24 03          	lea    0x3(%esp),%edx
  801bfd:	c1 ea 02             	shr    $0x2,%edx
  801c00:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801c07:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c0c:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801c13:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801c1a:	00 
	va_start(vl, arg0);
  801c1b:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801c1e:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
  801c25:	eb 0b                	jmp    801c32 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801c27:	83 c0 01             	add    $0x1,%eax
  801c2a:	8b 39                	mov    (%ecx),%edi
  801c2c:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801c2f:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801c32:	39 d0                	cmp    %edx,%eax
  801c34:	75 f1                	jne    801c27 <spawnl+0x5a>
	return spawn(prog, argv);
  801c36:	83 ec 08             	sub    $0x8,%esp
  801c39:	56                   	push   %esi
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	e8 f2 f9 ff ff       	call   801634 <spawn>
}
  801c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c45:	5b                   	pop    %ebx
  801c46:	5e                   	pop    %esi
  801c47:	5f                   	pop    %edi
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	56                   	push   %esi
  801c4e:	53                   	push   %ebx
  801c4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c52:	83 ec 0c             	sub    $0xc,%esp
  801c55:	ff 75 08             	pushl  0x8(%ebp)
  801c58:	e8 f6 f1 ff ff       	call   800e53 <fd2data>
  801c5d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	68 a0 29 80 00       	push   $0x8029a0
  801c67:	53                   	push   %ebx
  801c68:	e8 ec eb ff ff       	call   800859 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c6d:	8b 46 04             	mov    0x4(%esi),%eax
  801c70:	2b 06                	sub    (%esi),%eax
  801c72:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c78:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c7f:	00 00 00 
	stat->st_dev = &devpipe;
  801c82:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c89:	30 80 00 
	return 0;
}
  801c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    

00801c98 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 0c             	sub    $0xc,%esp
  801c9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ca2:	53                   	push   %ebx
  801ca3:	6a 00                	push   $0x0
  801ca5:	e8 2d f0 ff ff       	call   800cd7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801caa:	89 1c 24             	mov    %ebx,(%esp)
  801cad:	e8 a1 f1 ff ff       	call   800e53 <fd2data>
  801cb2:	83 c4 08             	add    $0x8,%esp
  801cb5:	50                   	push   %eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	e8 1a f0 ff ff       	call   800cd7 <sys_page_unmap>
}
  801cbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <_pipeisclosed>:
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
  801ccb:	89 c7                	mov    %eax,%edi
  801ccd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ccf:	a1 04 40 80 00       	mov    0x804004,%eax
  801cd4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	57                   	push   %edi
  801cdb:	e8 9b 04 00 00       	call   80217b <pageref>
  801ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ce3:	89 34 24             	mov    %esi,(%esp)
  801ce6:	e8 90 04 00 00       	call   80217b <pageref>
		nn = thisenv->env_runs;
  801ceb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cf1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	39 cb                	cmp    %ecx,%ebx
  801cf9:	74 1b                	je     801d16 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cfb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cfe:	75 cf                	jne    801ccf <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d00:	8b 42 58             	mov    0x58(%edx),%eax
  801d03:	6a 01                	push   $0x1
  801d05:	50                   	push   %eax
  801d06:	53                   	push   %ebx
  801d07:	68 a7 29 80 00       	push   $0x8029a7
  801d0c:	e8 5e e5 ff ff       	call   80026f <cprintf>
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	eb b9                	jmp    801ccf <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d16:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d19:	0f 94 c0             	sete   %al
  801d1c:	0f b6 c0             	movzbl %al,%eax
}
  801d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d22:	5b                   	pop    %ebx
  801d23:	5e                   	pop    %esi
  801d24:	5f                   	pop    %edi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    

00801d27 <devpipe_write>:
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	57                   	push   %edi
  801d2b:	56                   	push   %esi
  801d2c:	53                   	push   %ebx
  801d2d:	83 ec 28             	sub    $0x28,%esp
  801d30:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d33:	56                   	push   %esi
  801d34:	e8 1a f1 ff ff       	call   800e53 <fd2data>
  801d39:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d43:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d46:	74 4f                	je     801d97 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d48:	8b 43 04             	mov    0x4(%ebx),%eax
  801d4b:	8b 0b                	mov    (%ebx),%ecx
  801d4d:	8d 51 20             	lea    0x20(%ecx),%edx
  801d50:	39 d0                	cmp    %edx,%eax
  801d52:	72 14                	jb     801d68 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d54:	89 da                	mov    %ebx,%edx
  801d56:	89 f0                	mov    %esi,%eax
  801d58:	e8 65 ff ff ff       	call   801cc2 <_pipeisclosed>
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	75 3a                	jne    801d9b <devpipe_write+0x74>
			sys_yield();
  801d61:	e8 cd ee ff ff       	call   800c33 <sys_yield>
  801d66:	eb e0                	jmp    801d48 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d6b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d6f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d72:	89 c2                	mov    %eax,%edx
  801d74:	c1 fa 1f             	sar    $0x1f,%edx
  801d77:	89 d1                	mov    %edx,%ecx
  801d79:	c1 e9 1b             	shr    $0x1b,%ecx
  801d7c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d7f:	83 e2 1f             	and    $0x1f,%edx
  801d82:	29 ca                	sub    %ecx,%edx
  801d84:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d88:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d8c:	83 c0 01             	add    $0x1,%eax
  801d8f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d92:	83 c7 01             	add    $0x1,%edi
  801d95:	eb ac                	jmp    801d43 <devpipe_write+0x1c>
	return i;
  801d97:	89 f8                	mov    %edi,%eax
  801d99:	eb 05                	jmp    801da0 <devpipe_write+0x79>
				return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    

00801da8 <devpipe_read>:
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	57                   	push   %edi
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
  801dae:	83 ec 18             	sub    $0x18,%esp
  801db1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801db4:	57                   	push   %edi
  801db5:	e8 99 f0 ff ff       	call   800e53 <fd2data>
  801dba:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	be 00 00 00 00       	mov    $0x0,%esi
  801dc4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc7:	74 47                	je     801e10 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801dc9:	8b 03                	mov    (%ebx),%eax
  801dcb:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dce:	75 22                	jne    801df2 <devpipe_read+0x4a>
			if (i > 0)
  801dd0:	85 f6                	test   %esi,%esi
  801dd2:	75 14                	jne    801de8 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801dd4:	89 da                	mov    %ebx,%edx
  801dd6:	89 f8                	mov    %edi,%eax
  801dd8:	e8 e5 fe ff ff       	call   801cc2 <_pipeisclosed>
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	75 33                	jne    801e14 <devpipe_read+0x6c>
			sys_yield();
  801de1:	e8 4d ee ff ff       	call   800c33 <sys_yield>
  801de6:	eb e1                	jmp    801dc9 <devpipe_read+0x21>
				return i;
  801de8:	89 f0                	mov    %esi,%eax
}
  801dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5f                   	pop    %edi
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801df2:	99                   	cltd   
  801df3:	c1 ea 1b             	shr    $0x1b,%edx
  801df6:	01 d0                	add    %edx,%eax
  801df8:	83 e0 1f             	and    $0x1f,%eax
  801dfb:	29 d0                	sub    %edx,%eax
  801dfd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e05:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e08:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e0b:	83 c6 01             	add    $0x1,%esi
  801e0e:	eb b4                	jmp    801dc4 <devpipe_read+0x1c>
	return i;
  801e10:	89 f0                	mov    %esi,%eax
  801e12:	eb d6                	jmp    801dea <devpipe_read+0x42>
				return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
  801e19:	eb cf                	jmp    801dea <devpipe_read+0x42>

00801e1b <pipe>:
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e26:	50                   	push   %eax
  801e27:	e8 3e f0 ff ff       	call   800e6a <fd_alloc>
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 5b                	js     801e90 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	68 07 04 00 00       	push   $0x407
  801e3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e40:	6a 00                	push   $0x0
  801e42:	e8 0b ee ff ff       	call   800c52 <sys_page_alloc>
  801e47:	89 c3                	mov    %eax,%ebx
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	78 40                	js     801e90 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e56:	50                   	push   %eax
  801e57:	e8 0e f0 ff ff       	call   800e6a <fd_alloc>
  801e5c:	89 c3                	mov    %eax,%ebx
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	85 c0                	test   %eax,%eax
  801e63:	78 1b                	js     801e80 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	68 07 04 00 00       	push   $0x407
  801e6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e70:	6a 00                	push   $0x0
  801e72:	e8 db ed ff ff       	call   800c52 <sys_page_alloc>
  801e77:	89 c3                	mov    %eax,%ebx
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	79 19                	jns    801e99 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801e80:	83 ec 08             	sub    $0x8,%esp
  801e83:	ff 75 f4             	pushl  -0xc(%ebp)
  801e86:	6a 00                	push   $0x0
  801e88:	e8 4a ee ff ff       	call   800cd7 <sys_page_unmap>
  801e8d:	83 c4 10             	add    $0x10,%esp
}
  801e90:	89 d8                	mov    %ebx,%eax
  801e92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    
	va = fd2data(fd0);
  801e99:	83 ec 0c             	sub    $0xc,%esp
  801e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9f:	e8 af ef ff ff       	call   800e53 <fd2data>
  801ea4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea6:	83 c4 0c             	add    $0xc,%esp
  801ea9:	68 07 04 00 00       	push   $0x407
  801eae:	50                   	push   %eax
  801eaf:	6a 00                	push   $0x0
  801eb1:	e8 9c ed ff ff       	call   800c52 <sys_page_alloc>
  801eb6:	89 c3                	mov    %eax,%ebx
  801eb8:	83 c4 10             	add    $0x10,%esp
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	0f 88 8c 00 00 00    	js     801f4f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec9:	e8 85 ef ff ff       	call   800e53 <fd2data>
  801ece:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ed5:	50                   	push   %eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	56                   	push   %esi
  801ed9:	6a 00                	push   $0x0
  801edb:	e8 b5 ed ff ff       	call   800c95 <sys_page_map>
  801ee0:	89 c3                	mov    %eax,%ebx
  801ee2:	83 c4 20             	add    $0x20,%esp
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	78 58                	js     801f41 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ef2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f01:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801f07:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f13:	83 ec 0c             	sub    $0xc,%esp
  801f16:	ff 75 f4             	pushl  -0xc(%ebp)
  801f19:	e8 25 ef ff ff       	call   800e43 <fd2num>
  801f1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f21:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f23:	83 c4 04             	add    $0x4,%esp
  801f26:	ff 75 f0             	pushl  -0x10(%ebp)
  801f29:	e8 15 ef ff ff       	call   800e43 <fd2num>
  801f2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f31:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f3c:	e9 4f ff ff ff       	jmp    801e90 <pipe+0x75>
	sys_page_unmap(0, va);
  801f41:	83 ec 08             	sub    $0x8,%esp
  801f44:	56                   	push   %esi
  801f45:	6a 00                	push   $0x0
  801f47:	e8 8b ed ff ff       	call   800cd7 <sys_page_unmap>
  801f4c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f4f:	83 ec 08             	sub    $0x8,%esp
  801f52:	ff 75 f0             	pushl  -0x10(%ebp)
  801f55:	6a 00                	push   $0x0
  801f57:	e8 7b ed ff ff       	call   800cd7 <sys_page_unmap>
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	e9 1c ff ff ff       	jmp    801e80 <pipe+0x65>

00801f64 <pipeisclosed>:
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	e8 43 ef ff ff       	call   800eb9 <fd_lookup>
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	78 18                	js     801f95 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	e8 cb ee ff ff       	call   800e53 <fd2data>
	return _pipeisclosed(fd, p);
  801f88:	89 c2                	mov    %eax,%edx
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	e8 30 fd ff ff       	call   801cc2 <_pipeisclosed>
  801f92:	83 c4 10             	add    $0x10,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9f:	5d                   	pop    %ebp
  801fa0:	c3                   	ret    

00801fa1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fa7:	68 bf 29 80 00       	push   $0x8029bf
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	e8 a5 e8 ff ff       	call   800859 <strcpy>
	return 0;
}
  801fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <devcons_write>:
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	57                   	push   %edi
  801fbf:	56                   	push   %esi
  801fc0:	53                   	push   %ebx
  801fc1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fc7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fcc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fd2:	eb 2f                	jmp    802003 <devcons_write+0x48>
		m = n - tot;
  801fd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fd7:	29 f3                	sub    %esi,%ebx
  801fd9:	83 fb 7f             	cmp    $0x7f,%ebx
  801fdc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fe1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fe4:	83 ec 04             	sub    $0x4,%esp
  801fe7:	53                   	push   %ebx
  801fe8:	89 f0                	mov    %esi,%eax
  801fea:	03 45 0c             	add    0xc(%ebp),%eax
  801fed:	50                   	push   %eax
  801fee:	57                   	push   %edi
  801fef:	e8 f3 e9 ff ff       	call   8009e7 <memmove>
		sys_cputs(buf, m);
  801ff4:	83 c4 08             	add    $0x8,%esp
  801ff7:	53                   	push   %ebx
  801ff8:	57                   	push   %edi
  801ff9:	e8 98 eb ff ff       	call   800b96 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ffe:	01 de                	add    %ebx,%esi
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	3b 75 10             	cmp    0x10(%ebp),%esi
  802006:	72 cc                	jb     801fd4 <devcons_write+0x19>
}
  802008:	89 f0                	mov    %esi,%eax
  80200a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200d:	5b                   	pop    %ebx
  80200e:	5e                   	pop    %esi
  80200f:	5f                   	pop    %edi
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    

00802012 <devcons_read>:
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 08             	sub    $0x8,%esp
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80201d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802021:	75 07                	jne    80202a <devcons_read+0x18>
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    
		sys_yield();
  802025:	e8 09 ec ff ff       	call   800c33 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80202a:	e8 85 eb ff ff       	call   800bb4 <sys_cgetc>
  80202f:	85 c0                	test   %eax,%eax
  802031:	74 f2                	je     802025 <devcons_read+0x13>
	if (c < 0)
  802033:	85 c0                	test   %eax,%eax
  802035:	78 ec                	js     802023 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802037:	83 f8 04             	cmp    $0x4,%eax
  80203a:	74 0c                	je     802048 <devcons_read+0x36>
	*(char*)vbuf = c;
  80203c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203f:	88 02                	mov    %al,(%edx)
	return 1;
  802041:	b8 01 00 00 00       	mov    $0x1,%eax
  802046:	eb db                	jmp    802023 <devcons_read+0x11>
		return 0;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	eb d4                	jmp    802023 <devcons_read+0x11>

0080204f <cputchar>:
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80205b:	6a 01                	push   $0x1
  80205d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802060:	50                   	push   %eax
  802061:	e8 30 eb ff ff       	call   800b96 <sys_cputs>
}
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <getchar>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802071:	6a 01                	push   $0x1
  802073:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802076:	50                   	push   %eax
  802077:	6a 00                	push   $0x0
  802079:	e8 ac f0 ff ff       	call   80112a <read>
	if (r < 0)
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	85 c0                	test   %eax,%eax
  802083:	78 08                	js     80208d <getchar+0x22>
	if (r < 1)
  802085:	85 c0                	test   %eax,%eax
  802087:	7e 06                	jle    80208f <getchar+0x24>
	return c;
  802089:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    
		return -E_EOF;
  80208f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802094:	eb f7                	jmp    80208d <getchar+0x22>

00802096 <iscons>:
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	50                   	push   %eax
  8020a0:	ff 75 08             	pushl  0x8(%ebp)
  8020a3:	e8 11 ee ff ff       	call   800eb9 <fd_lookup>
  8020a8:	83 c4 10             	add    $0x10,%esp
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	78 11                	js     8020c0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020b8:	39 10                	cmp    %edx,(%eax)
  8020ba:	0f 94 c0             	sete   %al
  8020bd:	0f b6 c0             	movzbl %al,%eax
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <opencons>:
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cb:	50                   	push   %eax
  8020cc:	e8 99 ed ff ff       	call   800e6a <fd_alloc>
  8020d1:	83 c4 10             	add    $0x10,%esp
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	78 3a                	js     802112 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	68 07 04 00 00       	push   $0x407
  8020e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e3:	6a 00                	push   $0x0
  8020e5:	e8 68 eb ff ff       	call   800c52 <sys_page_alloc>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 21                	js     802112 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	50                   	push   %eax
  80210a:	e8 34 ed ff ff       	call   800e43 <fd2num>
  80210f:	83 c4 10             	add    $0x10,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80211a:	68 cb 29 80 00       	push   $0x8029cb
  80211f:	6a 1a                	push   $0x1a
  802121:	68 e4 29 80 00       	push   $0x8029e4
  802126:	e8 69 e0 ff ff       	call   800194 <_panic>

0080212b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  802131:	68 ee 29 80 00       	push   $0x8029ee
  802136:	6a 2a                	push   $0x2a
  802138:	68 e4 29 80 00       	push   $0x8029e4
  80213d:	e8 52 e0 ff ff       	call   800194 <_panic>

00802142 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80214d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802150:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802156:	8b 52 50             	mov    0x50(%edx),%edx
  802159:	39 ca                	cmp    %ecx,%edx
  80215b:	74 11                	je     80216e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80215d:	83 c0 01             	add    $0x1,%eax
  802160:	3d 00 04 00 00       	cmp    $0x400,%eax
  802165:	75 e6                	jne    80214d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802167:	b8 00 00 00 00       	mov    $0x0,%eax
  80216c:	eb 0b                	jmp    802179 <ipc_find_env+0x37>
			return envs[i].env_id;
  80216e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802171:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802176:	8b 40 48             	mov    0x48(%eax),%eax
}
  802179:	5d                   	pop    %ebp
  80217a:	c3                   	ret    

0080217b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802181:	89 d0                	mov    %edx,%eax
  802183:	c1 e8 16             	shr    $0x16,%eax
  802186:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80218d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802192:	f6 c1 01             	test   $0x1,%cl
  802195:	74 1d                	je     8021b4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802197:	c1 ea 0c             	shr    $0xc,%edx
  80219a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021a1:	f6 c2 01             	test   $0x1,%dl
  8021a4:	74 0e                	je     8021b4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021a6:	c1 ea 0c             	shr    $0xc,%edx
  8021a9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021b0:	ef 
  8021b1:	0f b7 c0             	movzwl %ax,%eax
}
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    
  8021b6:	66 90                	xchg   %ax,%ax
  8021b8:	66 90                	xchg   %ax,%ax
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__udivdi3>:
  8021c0:	55                   	push   %ebp
  8021c1:	57                   	push   %edi
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 1c             	sub    $0x1c,%esp
  8021c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021d7:	85 d2                	test   %edx,%edx
  8021d9:	75 35                	jne    802210 <__udivdi3+0x50>
  8021db:	39 f3                	cmp    %esi,%ebx
  8021dd:	0f 87 bd 00 00 00    	ja     8022a0 <__udivdi3+0xe0>
  8021e3:	85 db                	test   %ebx,%ebx
  8021e5:	89 d9                	mov    %ebx,%ecx
  8021e7:	75 0b                	jne    8021f4 <__udivdi3+0x34>
  8021e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ee:	31 d2                	xor    %edx,%edx
  8021f0:	f7 f3                	div    %ebx
  8021f2:	89 c1                	mov    %eax,%ecx
  8021f4:	31 d2                	xor    %edx,%edx
  8021f6:	89 f0                	mov    %esi,%eax
  8021f8:	f7 f1                	div    %ecx
  8021fa:	89 c6                	mov    %eax,%esi
  8021fc:	89 e8                	mov    %ebp,%eax
  8021fe:	89 f7                	mov    %esi,%edi
  802200:	f7 f1                	div    %ecx
  802202:	89 fa                	mov    %edi,%edx
  802204:	83 c4 1c             	add    $0x1c,%esp
  802207:	5b                   	pop    %ebx
  802208:	5e                   	pop    %esi
  802209:	5f                   	pop    %edi
  80220a:	5d                   	pop    %ebp
  80220b:	c3                   	ret    
  80220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802210:	39 f2                	cmp    %esi,%edx
  802212:	77 7c                	ja     802290 <__udivdi3+0xd0>
  802214:	0f bd fa             	bsr    %edx,%edi
  802217:	83 f7 1f             	xor    $0x1f,%edi
  80221a:	0f 84 98 00 00 00    	je     8022b8 <__udivdi3+0xf8>
  802220:	89 f9                	mov    %edi,%ecx
  802222:	b8 20 00 00 00       	mov    $0x20,%eax
  802227:	29 f8                	sub    %edi,%eax
  802229:	d3 e2                	shl    %cl,%edx
  80222b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80222f:	89 c1                	mov    %eax,%ecx
  802231:	89 da                	mov    %ebx,%edx
  802233:	d3 ea                	shr    %cl,%edx
  802235:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802239:	09 d1                	or     %edx,%ecx
  80223b:	89 f2                	mov    %esi,%edx
  80223d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802241:	89 f9                	mov    %edi,%ecx
  802243:	d3 e3                	shl    %cl,%ebx
  802245:	89 c1                	mov    %eax,%ecx
  802247:	d3 ea                	shr    %cl,%edx
  802249:	89 f9                	mov    %edi,%ecx
  80224b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80224f:	d3 e6                	shl    %cl,%esi
  802251:	89 eb                	mov    %ebp,%ebx
  802253:	89 c1                	mov    %eax,%ecx
  802255:	d3 eb                	shr    %cl,%ebx
  802257:	09 de                	or     %ebx,%esi
  802259:	89 f0                	mov    %esi,%eax
  80225b:	f7 74 24 08          	divl   0x8(%esp)
  80225f:	89 d6                	mov    %edx,%esi
  802261:	89 c3                	mov    %eax,%ebx
  802263:	f7 64 24 0c          	mull   0xc(%esp)
  802267:	39 d6                	cmp    %edx,%esi
  802269:	72 0c                	jb     802277 <__udivdi3+0xb7>
  80226b:	89 f9                	mov    %edi,%ecx
  80226d:	d3 e5                	shl    %cl,%ebp
  80226f:	39 c5                	cmp    %eax,%ebp
  802271:	73 5d                	jae    8022d0 <__udivdi3+0x110>
  802273:	39 d6                	cmp    %edx,%esi
  802275:	75 59                	jne    8022d0 <__udivdi3+0x110>
  802277:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80227a:	31 ff                	xor    %edi,%edi
  80227c:	89 fa                	mov    %edi,%edx
  80227e:	83 c4 1c             	add    $0x1c,%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5f                   	pop    %edi
  802284:	5d                   	pop    %ebp
  802285:	c3                   	ret    
  802286:	8d 76 00             	lea    0x0(%esi),%esi
  802289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802290:	31 ff                	xor    %edi,%edi
  802292:	31 c0                	xor    %eax,%eax
  802294:	89 fa                	mov    %edi,%edx
  802296:	83 c4 1c             	add    $0x1c,%esp
  802299:	5b                   	pop    %ebx
  80229a:	5e                   	pop    %esi
  80229b:	5f                   	pop    %edi
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    
  80229e:	66 90                	xchg   %ax,%ax
  8022a0:	31 ff                	xor    %edi,%edi
  8022a2:	89 e8                	mov    %ebp,%eax
  8022a4:	89 f2                	mov    %esi,%edx
  8022a6:	f7 f3                	div    %ebx
  8022a8:	89 fa                	mov    %edi,%edx
  8022aa:	83 c4 1c             	add    $0x1c,%esp
  8022ad:	5b                   	pop    %ebx
  8022ae:	5e                   	pop    %esi
  8022af:	5f                   	pop    %edi
  8022b0:	5d                   	pop    %ebp
  8022b1:	c3                   	ret    
  8022b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022b8:	39 f2                	cmp    %esi,%edx
  8022ba:	72 06                	jb     8022c2 <__udivdi3+0x102>
  8022bc:	31 c0                	xor    %eax,%eax
  8022be:	39 eb                	cmp    %ebp,%ebx
  8022c0:	77 d2                	ja     802294 <__udivdi3+0xd4>
  8022c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c7:	eb cb                	jmp    802294 <__udivdi3+0xd4>
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	89 d8                	mov    %ebx,%eax
  8022d2:	31 ff                	xor    %edi,%edi
  8022d4:	eb be                	jmp    802294 <__udivdi3+0xd4>
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	66 90                	xchg   %ax,%ax
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <__umoddi3>:
  8022e0:	55                   	push   %ebp
  8022e1:	57                   	push   %edi
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 1c             	sub    $0x1c,%esp
  8022e7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8022eb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022f7:	85 ed                	test   %ebp,%ebp
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	89 da                	mov    %ebx,%edx
  8022fd:	75 19                	jne    802318 <__umoddi3+0x38>
  8022ff:	39 df                	cmp    %ebx,%edi
  802301:	0f 86 b1 00 00 00    	jbe    8023b8 <__umoddi3+0xd8>
  802307:	f7 f7                	div    %edi
  802309:	89 d0                	mov    %edx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	83 c4 1c             	add    $0x1c,%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5f                   	pop    %edi
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    
  802315:	8d 76 00             	lea    0x0(%esi),%esi
  802318:	39 dd                	cmp    %ebx,%ebp
  80231a:	77 f1                	ja     80230d <__umoddi3+0x2d>
  80231c:	0f bd cd             	bsr    %ebp,%ecx
  80231f:	83 f1 1f             	xor    $0x1f,%ecx
  802322:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802326:	0f 84 b4 00 00 00    	je     8023e0 <__umoddi3+0x100>
  80232c:	b8 20 00 00 00       	mov    $0x20,%eax
  802331:	89 c2                	mov    %eax,%edx
  802333:	8b 44 24 04          	mov    0x4(%esp),%eax
  802337:	29 c2                	sub    %eax,%edx
  802339:	89 c1                	mov    %eax,%ecx
  80233b:	89 f8                	mov    %edi,%eax
  80233d:	d3 e5                	shl    %cl,%ebp
  80233f:	89 d1                	mov    %edx,%ecx
  802341:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802345:	d3 e8                	shr    %cl,%eax
  802347:	09 c5                	or     %eax,%ebp
  802349:	8b 44 24 04          	mov    0x4(%esp),%eax
  80234d:	89 c1                	mov    %eax,%ecx
  80234f:	d3 e7                	shl    %cl,%edi
  802351:	89 d1                	mov    %edx,%ecx
  802353:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802357:	89 df                	mov    %ebx,%edi
  802359:	d3 ef                	shr    %cl,%edi
  80235b:	89 c1                	mov    %eax,%ecx
  80235d:	89 f0                	mov    %esi,%eax
  80235f:	d3 e3                	shl    %cl,%ebx
  802361:	89 d1                	mov    %edx,%ecx
  802363:	89 fa                	mov    %edi,%edx
  802365:	d3 e8                	shr    %cl,%eax
  802367:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80236c:	09 d8                	or     %ebx,%eax
  80236e:	f7 f5                	div    %ebp
  802370:	d3 e6                	shl    %cl,%esi
  802372:	89 d1                	mov    %edx,%ecx
  802374:	f7 64 24 08          	mull   0x8(%esp)
  802378:	39 d1                	cmp    %edx,%ecx
  80237a:	89 c3                	mov    %eax,%ebx
  80237c:	89 d7                	mov    %edx,%edi
  80237e:	72 06                	jb     802386 <__umoddi3+0xa6>
  802380:	75 0e                	jne    802390 <__umoddi3+0xb0>
  802382:	39 c6                	cmp    %eax,%esi
  802384:	73 0a                	jae    802390 <__umoddi3+0xb0>
  802386:	2b 44 24 08          	sub    0x8(%esp),%eax
  80238a:	19 ea                	sbb    %ebp,%edx
  80238c:	89 d7                	mov    %edx,%edi
  80238e:	89 c3                	mov    %eax,%ebx
  802390:	89 ca                	mov    %ecx,%edx
  802392:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802397:	29 de                	sub    %ebx,%esi
  802399:	19 fa                	sbb    %edi,%edx
  80239b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80239f:	89 d0                	mov    %edx,%eax
  8023a1:	d3 e0                	shl    %cl,%eax
  8023a3:	89 d9                	mov    %ebx,%ecx
  8023a5:	d3 ee                	shr    %cl,%esi
  8023a7:	d3 ea                	shr    %cl,%edx
  8023a9:	09 f0                	or     %esi,%eax
  8023ab:	83 c4 1c             	add    $0x1c,%esp
  8023ae:	5b                   	pop    %ebx
  8023af:	5e                   	pop    %esi
  8023b0:	5f                   	pop    %edi
  8023b1:	5d                   	pop    %ebp
  8023b2:	c3                   	ret    
  8023b3:	90                   	nop
  8023b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	85 ff                	test   %edi,%edi
  8023ba:	89 f9                	mov    %edi,%ecx
  8023bc:	75 0b                	jne    8023c9 <__umoddi3+0xe9>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f7                	div    %edi
  8023c7:	89 c1                	mov    %eax,%ecx
  8023c9:	89 d8                	mov    %ebx,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	f7 f1                	div    %ecx
  8023cf:	89 f0                	mov    %esi,%eax
  8023d1:	f7 f1                	div    %ecx
  8023d3:	e9 31 ff ff ff       	jmp    802309 <__umoddi3+0x29>
  8023d8:	90                   	nop
  8023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e0:	39 dd                	cmp    %ebx,%ebp
  8023e2:	72 08                	jb     8023ec <__umoddi3+0x10c>
  8023e4:	39 f7                	cmp    %esi,%edi
  8023e6:	0f 87 21 ff ff ff    	ja     80230d <__umoddi3+0x2d>
  8023ec:	89 da                	mov    %ebx,%edx
  8023ee:	89 f0                	mov    %esi,%eax
  8023f0:	29 f8                	sub    %edi,%eax
  8023f2:	19 ea                	sbb    %ebp,%edx
  8023f4:	e9 14 ff ff ff       	jmp    80230d <__umoddi3+0x2d>
