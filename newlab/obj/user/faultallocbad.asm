
obj/user/faultallocbad.debug：     文件格式 elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 00 1e 80 00       	push   $0x801e00
  800045:	e8 a6 01 00 00       	call   8001f0 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 75 0b 00 00       	call   800bd3 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 4c 1e 80 00       	push   $0x801e4c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 16 07 00 00       	call   800789 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 20 1e 80 00       	push   $0x801e20
  800085:	6a 0f                	push   $0xf
  800087:	68 0a 1e 80 00       	push   $0x801e0a
  80008c:	e8 84 00 00 00       	call   800115 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 23 0d 00 00       	call   800dc4 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 67 0a 00 00       	call   800b17 <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 d0 0a 00 00       	call   800b95 <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 a5 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800101:	e8 2f 0f 00 00       	call   801035 <close_all>
	sys_env_destroy(0);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	6a 00                	push   $0x0
  80010b:	e8 44 0a 00 00       	call   800b54 <sys_env_destroy>
}
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80011a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80011d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800123:	e8 6d 0a 00 00       	call   800b95 <sys_getenvid>
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 0c             	pushl  0xc(%ebp)
  80012e:	ff 75 08             	pushl  0x8(%ebp)
  800131:	56                   	push   %esi
  800132:	50                   	push   %eax
  800133:	68 78 1e 80 00       	push   $0x801e78
  800138:	e8 b3 00 00 00       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80013d:	83 c4 18             	add    $0x18,%esp
  800140:	53                   	push   %ebx
  800141:	ff 75 10             	pushl  0x10(%ebp)
  800144:	e8 56 00 00 00       	call   80019f <vcprintf>
	cprintf("\n");
  800149:	c7 04 24 c7 22 80 00 	movl   $0x8022c7,(%esp)
  800150:	e8 9b 00 00 00       	call   8001f0 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800158:	cc                   	int3   
  800159:	eb fd                	jmp    800158 <_panic+0x43>

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 83 09 00 00       	call   800b17 <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x1f>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001af:	00 00 00 
	b.cnt = 0;
  8001b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	68 5b 01 80 00       	push   $0x80015b
  8001ce:	e8 1a 01 00 00       	call   8002ed <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	83 c4 08             	add    $0x8,%esp
  8001d6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 2f 09 00 00       	call   800b17 <sys_cputs>

	return b.cnt;
}
  8001e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 9d ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80021d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800228:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80022b:	39 d3                	cmp    %edx,%ebx
  80022d:	72 05                	jb     800234 <printnum+0x30>
  80022f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800232:	77 7a                	ja     8002ae <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 18             	pushl  0x18(%ebp)
  80023a:	8b 45 14             	mov    0x14(%ebp),%eax
  80023d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800240:	53                   	push   %ebx
  800241:	ff 75 10             	pushl  0x10(%ebp)
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024a:	ff 75 e0             	pushl  -0x20(%ebp)
  80024d:	ff 75 dc             	pushl  -0x24(%ebp)
  800250:	ff 75 d8             	pushl  -0x28(%ebp)
  800253:	e8 68 19 00 00       	call   801bc0 <__udivdi3>
  800258:	83 c4 18             	add    $0x18,%esp
  80025b:	52                   	push   %edx
  80025c:	50                   	push   %eax
  80025d:	89 f2                	mov    %esi,%edx
  80025f:	89 f8                	mov    %edi,%eax
  800261:	e8 9e ff ff ff       	call   800204 <printnum>
  800266:	83 c4 20             	add    $0x20,%esp
  800269:	eb 13                	jmp    80027e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	56                   	push   %esi
  80026f:	ff 75 18             	pushl  0x18(%ebp)
  800272:	ff d7                	call   *%edi
  800274:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	85 db                	test   %ebx,%ebx
  80027c:	7f ed                	jg     80026b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	56                   	push   %esi
  800282:	83 ec 04             	sub    $0x4,%esp
  800285:	ff 75 e4             	pushl  -0x1c(%ebp)
  800288:	ff 75 e0             	pushl  -0x20(%ebp)
  80028b:	ff 75 dc             	pushl  -0x24(%ebp)
  80028e:	ff 75 d8             	pushl  -0x28(%ebp)
  800291:	e8 4a 1a 00 00       	call   801ce0 <__umoddi3>
  800296:	83 c4 14             	add    $0x14,%esp
  800299:	0f be 80 9b 1e 80 00 	movsbl 0x801e9b(%eax),%eax
  8002a0:	50                   	push   %eax
  8002a1:	ff d7                	call   *%edi
}
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    
  8002ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b1:	eb c4                	jmp    800277 <printnum+0x73>

008002b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bd:	8b 10                	mov    (%eax),%edx
  8002bf:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c2:	73 0a                	jae    8002ce <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c7:	89 08                	mov    %ecx,(%eax)
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	88 02                	mov    %al,(%edx)
}
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <printfmt>:
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d9:	50                   	push   %eax
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 05 00 00 00       	call   8002ed <vprintfmt>
}
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <vprintfmt>:
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 2c             	sub    $0x2c,%esp
  8002f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002fc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ff:	e9 8c 03 00 00       	jmp    800690 <vprintfmt+0x3a3>
		padc = ' ';
  800304:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800308:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80030f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800316:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80031d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8d 47 01             	lea    0x1(%edi),%eax
  800325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800328:	0f b6 17             	movzbl (%edi),%edx
  80032b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032e:	3c 55                	cmp    $0x55,%al
  800330:	0f 87 dd 03 00 00    	ja     800713 <vprintfmt+0x426>
  800336:	0f b6 c0             	movzbl %al,%eax
  800339:	ff 24 85 e0 1f 80 00 	jmp    *0x801fe0(,%eax,4)
  800340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800343:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800347:	eb d9                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80034c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800350:	eb d0                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800352:	0f b6 d2             	movzbl %dl,%edx
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800360:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800363:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800367:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80036d:	83 f9 09             	cmp    $0x9,%ecx
  800370:	77 55                	ja     8003c7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800372:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800375:	eb e9                	jmp    800360 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8d 40 04             	lea    0x4(%eax),%eax
  800385:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038f:	79 91                	jns    800322 <vprintfmt+0x35>
				width = precision, precision = -1;
  800391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800394:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800397:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80039e:	eb 82                	jmp    800322 <vprintfmt+0x35>
  8003a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a3:	85 c0                	test   %eax,%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	0f 49 d0             	cmovns %eax,%edx
  8003ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b3:	e9 6a ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003bb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003c2:	e9 5b ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003c7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003cd:	eb bc                	jmp    80038b <vprintfmt+0x9e>
			lflag++;
  8003cf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d5:	e9 48 ff ff ff       	jmp    800322 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	53                   	push   %ebx
  8003e4:	ff 30                	pushl  (%eax)
  8003e6:	ff d6                	call   *%esi
			break;
  8003e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003eb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ee:	e9 9a 02 00 00       	jmp    80068d <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 78 04             	lea    0x4(%eax),%edi
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	99                   	cltd   
  8003fc:	31 d0                	xor    %edx,%eax
  8003fe:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800400:	83 f8 0f             	cmp    $0xf,%eax
  800403:	7f 23                	jg     800428 <vprintfmt+0x13b>
  800405:	8b 14 85 40 21 80 00 	mov    0x802140(,%eax,4),%edx
  80040c:	85 d2                	test   %edx,%edx
  80040e:	74 18                	je     800428 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800410:	52                   	push   %edx
  800411:	68 95 22 80 00       	push   $0x802295
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 b3 fe ff ff       	call   8002d0 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
  800423:	e9 65 02 00 00       	jmp    80068d <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800428:	50                   	push   %eax
  800429:	68 b3 1e 80 00       	push   $0x801eb3
  80042e:	53                   	push   %ebx
  80042f:	56                   	push   %esi
  800430:	e8 9b fe ff ff       	call   8002d0 <printfmt>
  800435:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800438:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043b:	e9 4d 02 00 00       	jmp    80068d <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	83 c0 04             	add    $0x4,%eax
  800446:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80044e:	85 ff                	test   %edi,%edi
  800450:	b8 ac 1e 80 00       	mov    $0x801eac,%eax
  800455:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800458:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045c:	0f 8e bd 00 00 00    	jle    80051f <vprintfmt+0x232>
  800462:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800466:	75 0e                	jne    800476 <vprintfmt+0x189>
  800468:	89 75 08             	mov    %esi,0x8(%ebp)
  80046b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800471:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800474:	eb 6d                	jmp    8004e3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 d0             	pushl  -0x30(%ebp)
  80047c:	57                   	push   %edi
  80047d:	e8 39 03 00 00       	call   8007bb <strnlen>
  800482:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800485:	29 c1                	sub    %eax,%ecx
  800487:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80048a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80048d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800497:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800499:	eb 0f                	jmp    8004aa <vprintfmt+0x1bd>
					putch(padc, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	53                   	push   %ebx
  80049f:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a4:	83 ef 01             	sub    $0x1,%edi
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	85 ff                	test   %edi,%edi
  8004ac:	7f ed                	jg     80049b <vprintfmt+0x1ae>
  8004ae:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bb:	0f 49 c1             	cmovns %ecx,%eax
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c9:	89 cb                	mov    %ecx,%ebx
  8004cb:	eb 16                	jmp    8004e3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d1:	75 31                	jne    800504 <vprintfmt+0x217>
					putch(ch, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	50                   	push   %eax
  8004da:	ff 55 08             	call   *0x8(%ebp)
  8004dd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e0:	83 eb 01             	sub    $0x1,%ebx
  8004e3:	83 c7 01             	add    $0x1,%edi
  8004e6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ea:	0f be c2             	movsbl %dl,%eax
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	74 59                	je     80054a <vprintfmt+0x25d>
  8004f1:	85 f6                	test   %esi,%esi
  8004f3:	78 d8                	js     8004cd <vprintfmt+0x1e0>
  8004f5:	83 ee 01             	sub    $0x1,%esi
  8004f8:	79 d3                	jns    8004cd <vprintfmt+0x1e0>
  8004fa:	89 df                	mov    %ebx,%edi
  8004fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800502:	eb 37                	jmp    80053b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800504:	0f be d2             	movsbl %dl,%edx
  800507:	83 ea 20             	sub    $0x20,%edx
  80050a:	83 fa 5e             	cmp    $0x5e,%edx
  80050d:	76 c4                	jbe    8004d3 <vprintfmt+0x1e6>
					putch('?', putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	6a 3f                	push   $0x3f
  800517:	ff 55 08             	call   *0x8(%ebp)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	eb c1                	jmp    8004e0 <vprintfmt+0x1f3>
  80051f:	89 75 08             	mov    %esi,0x8(%ebp)
  800522:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800525:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800528:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052b:	eb b6                	jmp    8004e3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 20                	push   $0x20
  800533:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800535:	83 ef 01             	sub    $0x1,%edi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	85 ff                	test   %edi,%edi
  80053d:	7f ee                	jg     80052d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	e9 43 01 00 00       	jmp    80068d <vprintfmt+0x3a0>
  80054a:	89 df                	mov    %ebx,%edi
  80054c:	8b 75 08             	mov    0x8(%ebp),%esi
  80054f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800552:	eb e7                	jmp    80053b <vprintfmt+0x24e>
	if (lflag >= 2)
  800554:	83 f9 01             	cmp    $0x1,%ecx
  800557:	7e 3f                	jle    800598 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 50 04             	mov    0x4(%eax),%edx
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 08             	lea    0x8(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800570:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800574:	79 5c                	jns    8005d2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	53                   	push   %ebx
  80057a:	6a 2d                	push   $0x2d
  80057c:	ff d6                	call   *%esi
				num = -(long long) num;
  80057e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800581:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800584:	f7 da                	neg    %edx
  800586:	83 d1 00             	adc    $0x0,%ecx
  800589:	f7 d9                	neg    %ecx
  80058b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800593:	e9 db 00 00 00       	jmp    800673 <vprintfmt+0x386>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	75 1b                	jne    8005b7 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 c1                	mov    %eax,%ecx
  8005a6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8d 40 04             	lea    0x4(%eax),%eax
  8005b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b5:	eb b9                	jmp    800570 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 c1                	mov    %eax,%ecx
  8005c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	eb 9e                	jmp    800570 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dd:	e9 91 00 00 00       	jmp    800673 <vprintfmt+0x386>
	if (lflag >= 2)
  8005e2:	83 f9 01             	cmp    $0x1,%ecx
  8005e5:	7e 15                	jle    8005fc <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 10                	mov    (%eax),%edx
  8005ec:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ef:	8d 40 08             	lea    0x8(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	eb 77                	jmp    800673 <vprintfmt+0x386>
	else if (lflag)
  8005fc:	85 c9                	test   %ecx,%ecx
  8005fe:	75 17                	jne    800617 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 10                	mov    (%eax),%edx
  800605:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060a:	8d 40 04             	lea    0x4(%eax),%eax
  80060d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800610:	b8 0a 00 00 00       	mov    $0xa,%eax
  800615:	eb 5c                	jmp    800673 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 10                	mov    (%eax),%edx
  80061c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800627:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062c:	eb 45                	jmp    800673 <vprintfmt+0x386>
			putch('X', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	53                   	push   %ebx
  800632:	6a 58                	push   $0x58
  800634:	ff d6                	call   *%esi
			putch('X', putdat);
  800636:	83 c4 08             	add    $0x8,%esp
  800639:	53                   	push   %ebx
  80063a:	6a 58                	push   $0x58
  80063c:	ff d6                	call   *%esi
			putch('X', putdat);
  80063e:	83 c4 08             	add    $0x8,%esp
  800641:	53                   	push   %ebx
  800642:	6a 58                	push   $0x58
  800644:	ff d6                	call   *%esi
			break;
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	eb 42                	jmp    80068d <vprintfmt+0x3a0>
			putch('0', putdat);
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	53                   	push   %ebx
  80064f:	6a 30                	push   $0x30
  800651:	ff d6                	call   *%esi
			putch('x', putdat);
  800653:	83 c4 08             	add    $0x8,%esp
  800656:	53                   	push   %ebx
  800657:	6a 78                	push   $0x78
  800659:	ff d6                	call   *%esi
			num = (unsigned long long)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 10                	mov    (%eax),%edx
  800660:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800665:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800673:	83 ec 0c             	sub    $0xc,%esp
  800676:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80067a:	57                   	push   %edi
  80067b:	ff 75 e0             	pushl  -0x20(%ebp)
  80067e:	50                   	push   %eax
  80067f:	51                   	push   %ecx
  800680:	52                   	push   %edx
  800681:	89 da                	mov    %ebx,%edx
  800683:	89 f0                	mov    %esi,%eax
  800685:	e8 7a fb ff ff       	call   800204 <printnum>
			break;
  80068a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80068d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800690:	83 c7 01             	add    $0x1,%edi
  800693:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800697:	83 f8 25             	cmp    $0x25,%eax
  80069a:	0f 84 64 fc ff ff    	je     800304 <vprintfmt+0x17>
			if (ch == '\0')
  8006a0:	85 c0                	test   %eax,%eax
  8006a2:	0f 84 8b 00 00 00    	je     800733 <vprintfmt+0x446>
			putch(ch, putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	53                   	push   %ebx
  8006ac:	50                   	push   %eax
  8006ad:	ff d6                	call   *%esi
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	eb dc                	jmp    800690 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8006b4:	83 f9 01             	cmp    $0x1,%ecx
  8006b7:	7e 15                	jle    8006ce <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 10                	mov    (%eax),%edx
  8006be:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c1:	8d 40 08             	lea    0x8(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8006cc:	eb a5                	jmp    800673 <vprintfmt+0x386>
	else if (lflag)
  8006ce:	85 c9                	test   %ecx,%ecx
  8006d0:	75 17                	jne    8006e9 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 10                	mov    (%eax),%edx
  8006d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e7:	eb 8a                	jmp    800673 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8b 10                	mov    (%eax),%edx
  8006ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f3:	8d 40 04             	lea    0x4(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fe:	e9 70 ff ff ff       	jmp    800673 <vprintfmt+0x386>
			putch(ch, putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	6a 25                	push   $0x25
  800709:	ff d6                	call   *%esi
			break;
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	e9 7a ff ff ff       	jmp    80068d <vprintfmt+0x3a0>
			putch('%', putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	53                   	push   %ebx
  800717:	6a 25                	push   $0x25
  800719:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	89 f8                	mov    %edi,%eax
  800720:	eb 03                	jmp    800725 <vprintfmt+0x438>
  800722:	83 e8 01             	sub    $0x1,%eax
  800725:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800729:	75 f7                	jne    800722 <vprintfmt+0x435>
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	e9 5a ff ff ff       	jmp    80068d <vprintfmt+0x3a0>
}
  800733:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800736:	5b                   	pop    %ebx
  800737:	5e                   	pop    %esi
  800738:	5f                   	pop    %edi
  800739:	5d                   	pop    %ebp
  80073a:	c3                   	ret    

0080073b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	83 ec 18             	sub    $0x18,%esp
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800747:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80074a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80074e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800751:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800758:	85 c0                	test   %eax,%eax
  80075a:	74 26                	je     800782 <vsnprintf+0x47>
  80075c:	85 d2                	test   %edx,%edx
  80075e:	7e 22                	jle    800782 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800760:	ff 75 14             	pushl  0x14(%ebp)
  800763:	ff 75 10             	pushl  0x10(%ebp)
  800766:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800769:	50                   	push   %eax
  80076a:	68 b3 02 80 00       	push   $0x8002b3
  80076f:	e8 79 fb ff ff       	call   8002ed <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800777:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80077a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	c9                   	leave  
  800781:	c3                   	ret    
		return -E_INVAL;
  800782:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800787:	eb f7                	jmp    800780 <vsnprintf+0x45>

00800789 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80078f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800792:	50                   	push   %eax
  800793:	ff 75 10             	pushl  0x10(%ebp)
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	ff 75 08             	pushl  0x8(%ebp)
  80079c:	e8 9a ff ff ff       	call   80073b <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a1:	c9                   	leave  
  8007a2:	c3                   	ret    

008007a3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ae:	eb 03                	jmp    8007b3 <strlen+0x10>
		n++;
  8007b0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b7:	75 f7                	jne    8007b0 <strlen+0xd>
	return n;
}
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c9:	eb 03                	jmp    8007ce <strnlen+0x13>
		n++;
  8007cb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ce:	39 d0                	cmp    %edx,%eax
  8007d0:	74 06                	je     8007d8 <strnlen+0x1d>
  8007d2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007d6:	75 f3                	jne    8007cb <strnlen+0x10>
	return n;
}
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e4:	89 c2                	mov    %eax,%edx
  8007e6:	83 c1 01             	add    $0x1,%ecx
  8007e9:	83 c2 01             	add    $0x1,%edx
  8007ec:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007f0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007f3:	84 db                	test   %bl,%bl
  8007f5:	75 ef                	jne    8007e6 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007f7:	5b                   	pop    %ebx
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800801:	53                   	push   %ebx
  800802:	e8 9c ff ff ff       	call   8007a3 <strlen>
  800807:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	50                   	push   %eax
  800810:	e8 c5 ff ff ff       	call   8007da <strcpy>
	return dst;
}
  800815:	89 d8                	mov    %ebx,%eax
  800817:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    

0080081c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	56                   	push   %esi
  800820:	53                   	push   %ebx
  800821:	8b 75 08             	mov    0x8(%ebp),%esi
  800824:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800827:	89 f3                	mov    %esi,%ebx
  800829:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80082c:	89 f2                	mov    %esi,%edx
  80082e:	eb 0f                	jmp    80083f <strncpy+0x23>
		*dst++ = *src;
  800830:	83 c2 01             	add    $0x1,%edx
  800833:	0f b6 01             	movzbl (%ecx),%eax
  800836:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800839:	80 39 01             	cmpb   $0x1,(%ecx)
  80083c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80083f:	39 da                	cmp    %ebx,%edx
  800841:	75 ed                	jne    800830 <strncpy+0x14>
	}
	return ret;
}
  800843:	89 f0                	mov    %esi,%eax
  800845:	5b                   	pop    %ebx
  800846:	5e                   	pop    %esi
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	56                   	push   %esi
  80084d:	53                   	push   %ebx
  80084e:	8b 75 08             	mov    0x8(%ebp),%esi
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
  800854:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800857:	89 f0                	mov    %esi,%eax
  800859:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80085d:	85 c9                	test   %ecx,%ecx
  80085f:	75 0b                	jne    80086c <strlcpy+0x23>
  800861:	eb 17                	jmp    80087a <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800863:	83 c2 01             	add    $0x1,%edx
  800866:	83 c0 01             	add    $0x1,%eax
  800869:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80086c:	39 d8                	cmp    %ebx,%eax
  80086e:	74 07                	je     800877 <strlcpy+0x2e>
  800870:	0f b6 0a             	movzbl (%edx),%ecx
  800873:	84 c9                	test   %cl,%cl
  800875:	75 ec                	jne    800863 <strlcpy+0x1a>
		*dst = '\0';
  800877:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80087a:	29 f0                	sub    %esi,%eax
}
  80087c:	5b                   	pop    %ebx
  80087d:	5e                   	pop    %esi
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800886:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800889:	eb 06                	jmp    800891 <strcmp+0x11>
		p++, q++;
  80088b:	83 c1 01             	add    $0x1,%ecx
  80088e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800891:	0f b6 01             	movzbl (%ecx),%eax
  800894:	84 c0                	test   %al,%al
  800896:	74 04                	je     80089c <strcmp+0x1c>
  800898:	3a 02                	cmp    (%edx),%al
  80089a:	74 ef                	je     80088b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80089c:	0f b6 c0             	movzbl %al,%eax
  80089f:	0f b6 12             	movzbl (%edx),%edx
  8008a2:	29 d0                	sub    %edx,%eax
}
  8008a4:	5d                   	pop    %ebp
  8008a5:	c3                   	ret    

008008a6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	53                   	push   %ebx
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b0:	89 c3                	mov    %eax,%ebx
  8008b2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b5:	eb 06                	jmp    8008bd <strncmp+0x17>
		n--, p++, q++;
  8008b7:	83 c0 01             	add    $0x1,%eax
  8008ba:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008bd:	39 d8                	cmp    %ebx,%eax
  8008bf:	74 16                	je     8008d7 <strncmp+0x31>
  8008c1:	0f b6 08             	movzbl (%eax),%ecx
  8008c4:	84 c9                	test   %cl,%cl
  8008c6:	74 04                	je     8008cc <strncmp+0x26>
  8008c8:	3a 0a                	cmp    (%edx),%cl
  8008ca:	74 eb                	je     8008b7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008cc:	0f b6 00             	movzbl (%eax),%eax
  8008cf:	0f b6 12             	movzbl (%edx),%edx
  8008d2:	29 d0                	sub    %edx,%eax
}
  8008d4:	5b                   	pop    %ebx
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    
		return 0;
  8008d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dc:	eb f6                	jmp    8008d4 <strncmp+0x2e>

008008de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e8:	0f b6 10             	movzbl (%eax),%edx
  8008eb:	84 d2                	test   %dl,%dl
  8008ed:	74 09                	je     8008f8 <strchr+0x1a>
		if (*s == c)
  8008ef:	38 ca                	cmp    %cl,%dl
  8008f1:	74 0a                	je     8008fd <strchr+0x1f>
	for (; *s; s++)
  8008f3:	83 c0 01             	add    $0x1,%eax
  8008f6:	eb f0                	jmp    8008e8 <strchr+0xa>
			return (char *) s;
	return 0;
  8008f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800909:	eb 03                	jmp    80090e <strfind+0xf>
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800911:	38 ca                	cmp    %cl,%dl
  800913:	74 04                	je     800919 <strfind+0x1a>
  800915:	84 d2                	test   %dl,%dl
  800917:	75 f2                	jne    80090b <strfind+0xc>
			break;
	return (char *) s;
}
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	57                   	push   %edi
  80091f:	56                   	push   %esi
  800920:	53                   	push   %ebx
  800921:	8b 7d 08             	mov    0x8(%ebp),%edi
  800924:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800927:	85 c9                	test   %ecx,%ecx
  800929:	74 13                	je     80093e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80092b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800931:	75 05                	jne    800938 <memset+0x1d>
  800933:	f6 c1 03             	test   $0x3,%cl
  800936:	74 0d                	je     800945 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	fc                   	cld    
  80093c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80093e:	89 f8                	mov    %edi,%eax
  800940:	5b                   	pop    %ebx
  800941:	5e                   	pop    %esi
  800942:	5f                   	pop    %edi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    
		c &= 0xFF;
  800945:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800949:	89 d3                	mov    %edx,%ebx
  80094b:	c1 e3 08             	shl    $0x8,%ebx
  80094e:	89 d0                	mov    %edx,%eax
  800950:	c1 e0 18             	shl    $0x18,%eax
  800953:	89 d6                	mov    %edx,%esi
  800955:	c1 e6 10             	shl    $0x10,%esi
  800958:	09 f0                	or     %esi,%eax
  80095a:	09 c2                	or     %eax,%edx
  80095c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80095e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800961:	89 d0                	mov    %edx,%eax
  800963:	fc                   	cld    
  800964:	f3 ab                	rep stos %eax,%es:(%edi)
  800966:	eb d6                	jmp    80093e <memset+0x23>

00800968 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	57                   	push   %edi
  80096c:	56                   	push   %esi
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 75 0c             	mov    0xc(%ebp),%esi
  800973:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800976:	39 c6                	cmp    %eax,%esi
  800978:	73 35                	jae    8009af <memmove+0x47>
  80097a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80097d:	39 c2                	cmp    %eax,%edx
  80097f:	76 2e                	jbe    8009af <memmove+0x47>
		s += n;
		d += n;
  800981:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800984:	89 d6                	mov    %edx,%esi
  800986:	09 fe                	or     %edi,%esi
  800988:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098e:	74 0c                	je     80099c <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800990:	83 ef 01             	sub    $0x1,%edi
  800993:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800996:	fd                   	std    
  800997:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800999:	fc                   	cld    
  80099a:	eb 21                	jmp    8009bd <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099c:	f6 c1 03             	test   $0x3,%cl
  80099f:	75 ef                	jne    800990 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a1:	83 ef 04             	sub    $0x4,%edi
  8009a4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009aa:	fd                   	std    
  8009ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ad:	eb ea                	jmp    800999 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009af:	89 f2                	mov    %esi,%edx
  8009b1:	09 c2                	or     %eax,%edx
  8009b3:	f6 c2 03             	test   $0x3,%dl
  8009b6:	74 09                	je     8009c1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009b8:	89 c7                	mov    %eax,%edi
  8009ba:	fc                   	cld    
  8009bb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009bd:	5e                   	pop    %esi
  8009be:	5f                   	pop    %edi
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c1:	f6 c1 03             	test   $0x3,%cl
  8009c4:	75 f2                	jne    8009b8 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c9:	89 c7                	mov    %eax,%edi
  8009cb:	fc                   	cld    
  8009cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ce:	eb ed                	jmp    8009bd <memmove+0x55>

008009d0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009d3:	ff 75 10             	pushl  0x10(%ebp)
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 87 ff ff ff       	call   800968 <memmove>
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	56                   	push   %esi
  8009e7:	53                   	push   %ebx
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ee:	89 c6                	mov    %eax,%esi
  8009f0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f3:	39 f0                	cmp    %esi,%eax
  8009f5:	74 1c                	je     800a13 <memcmp+0x30>
		if (*s1 != *s2)
  8009f7:	0f b6 08             	movzbl (%eax),%ecx
  8009fa:	0f b6 1a             	movzbl (%edx),%ebx
  8009fd:	38 d9                	cmp    %bl,%cl
  8009ff:	75 08                	jne    800a09 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	83 c2 01             	add    $0x1,%edx
  800a07:	eb ea                	jmp    8009f3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a09:	0f b6 c1             	movzbl %cl,%eax
  800a0c:	0f b6 db             	movzbl %bl,%ebx
  800a0f:	29 d8                	sub    %ebx,%eax
  800a11:	eb 05                	jmp    800a18 <memcmp+0x35>
	}

	return 0;
  800a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a18:	5b                   	pop    %ebx
  800a19:	5e                   	pop    %esi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a25:	89 c2                	mov    %eax,%edx
  800a27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a2a:	39 d0                	cmp    %edx,%eax
  800a2c:	73 09                	jae    800a37 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a2e:	38 08                	cmp    %cl,(%eax)
  800a30:	74 05                	je     800a37 <memfind+0x1b>
	for (; s < ends; s++)
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	eb f3                	jmp    800a2a <memfind+0xe>
			break;
	return (void *) s;
}
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	57                   	push   %edi
  800a3d:	56                   	push   %esi
  800a3e:	53                   	push   %ebx
  800a3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a45:	eb 03                	jmp    800a4a <strtol+0x11>
		s++;
  800a47:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a4a:	0f b6 01             	movzbl (%ecx),%eax
  800a4d:	3c 20                	cmp    $0x20,%al
  800a4f:	74 f6                	je     800a47 <strtol+0xe>
  800a51:	3c 09                	cmp    $0x9,%al
  800a53:	74 f2                	je     800a47 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a55:	3c 2b                	cmp    $0x2b,%al
  800a57:	74 2e                	je     800a87 <strtol+0x4e>
	int neg = 0;
  800a59:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a5e:	3c 2d                	cmp    $0x2d,%al
  800a60:	74 2f                	je     800a91 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a62:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a68:	75 05                	jne    800a6f <strtol+0x36>
  800a6a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6d:	74 2c                	je     800a9b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a6f:	85 db                	test   %ebx,%ebx
  800a71:	75 0a                	jne    800a7d <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a73:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a78:	80 39 30             	cmpb   $0x30,(%ecx)
  800a7b:	74 28                	je     800aa5 <strtol+0x6c>
		base = 10;
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a82:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a85:	eb 50                	jmp    800ad7 <strtol+0x9e>
		s++;
  800a87:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8f:	eb d1                	jmp    800a62 <strtol+0x29>
		s++, neg = 1;
  800a91:	83 c1 01             	add    $0x1,%ecx
  800a94:	bf 01 00 00 00       	mov    $0x1,%edi
  800a99:	eb c7                	jmp    800a62 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a9f:	74 0e                	je     800aaf <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa1:	85 db                	test   %ebx,%ebx
  800aa3:	75 d8                	jne    800a7d <strtol+0x44>
		s++, base = 8;
  800aa5:	83 c1 01             	add    $0x1,%ecx
  800aa8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aad:	eb ce                	jmp    800a7d <strtol+0x44>
		s += 2, base = 16;
  800aaf:	83 c1 02             	add    $0x2,%ecx
  800ab2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab7:	eb c4                	jmp    800a7d <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ab9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800abc:	89 f3                	mov    %esi,%ebx
  800abe:	80 fb 19             	cmp    $0x19,%bl
  800ac1:	77 29                	ja     800aec <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ac3:	0f be d2             	movsbl %dl,%edx
  800ac6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800acc:	7d 30                	jge    800afe <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ace:	83 c1 01             	add    $0x1,%ecx
  800ad1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad7:	0f b6 11             	movzbl (%ecx),%edx
  800ada:	8d 72 d0             	lea    -0x30(%edx),%esi
  800add:	89 f3                	mov    %esi,%ebx
  800adf:	80 fb 09             	cmp    $0x9,%bl
  800ae2:	77 d5                	ja     800ab9 <strtol+0x80>
			dig = *s - '0';
  800ae4:	0f be d2             	movsbl %dl,%edx
  800ae7:	83 ea 30             	sub    $0x30,%edx
  800aea:	eb dd                	jmp    800ac9 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800aec:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aef:	89 f3                	mov    %esi,%ebx
  800af1:	80 fb 19             	cmp    $0x19,%bl
  800af4:	77 08                	ja     800afe <strtol+0xc5>
			dig = *s - 'A' + 10;
  800af6:	0f be d2             	movsbl %dl,%edx
  800af9:	83 ea 37             	sub    $0x37,%edx
  800afc:	eb cb                	jmp    800ac9 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800afe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b02:	74 05                	je     800b09 <strtol+0xd0>
		*endptr = (char *) s;
  800b04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b07:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b09:	89 c2                	mov    %eax,%edx
  800b0b:	f7 da                	neg    %edx
  800b0d:	85 ff                	test   %edi,%edi
  800b0f:	0f 45 c2             	cmovne %edx,%eax
}
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	57                   	push   %edi
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b28:	89 c3                	mov    %eax,%ebx
  800b2a:	89 c7                	mov    %eax,%edi
  800b2c:	89 c6                	mov    %eax,%esi
  800b2e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5f                   	pop    %edi
  800b33:	5d                   	pop    %ebp
  800b34:	c3                   	ret    

00800b35 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	57                   	push   %edi
  800b39:	56                   	push   %esi
  800b3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b40:	b8 01 00 00 00       	mov    $0x1,%eax
  800b45:	89 d1                	mov    %edx,%ecx
  800b47:	89 d3                	mov    %edx,%ebx
  800b49:	89 d7                	mov    %edx,%edi
  800b4b:	89 d6                	mov    %edx,%esi
  800b4d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6a:	89 cb                	mov    %ecx,%ebx
  800b6c:	89 cf                	mov    %ecx,%edi
  800b6e:	89 ce                	mov    %ecx,%esi
  800b70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b72:	85 c0                	test   %eax,%eax
  800b74:	7f 08                	jg     800b7e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5f                   	pop    %edi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	50                   	push   %eax
  800b82:	6a 03                	push   $0x3
  800b84:	68 9f 21 80 00       	push   $0x80219f
  800b89:	6a 23                	push   $0x23
  800b8b:	68 bc 21 80 00       	push   $0x8021bc
  800b90:	e8 80 f5 ff ff       	call   800115 <_panic>

00800b95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	57                   	push   %edi
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba5:	89 d1                	mov    %edx,%ecx
  800ba7:	89 d3                	mov    %edx,%ebx
  800ba9:	89 d7                	mov    %edx,%edi
  800bab:	89 d6                	mov    %edx,%esi
  800bad:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <sys_yield>:

void
sys_yield(void)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bc4:	89 d1                	mov    %edx,%ecx
  800bc6:	89 d3                	mov    %edx,%ebx
  800bc8:	89 d7                	mov    %edx,%edi
  800bca:	89 d6                	mov    %edx,%esi
  800bcc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bdc:	be 00 00 00 00       	mov    $0x0,%esi
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be7:	b8 04 00 00 00       	mov    $0x4,%eax
  800bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bef:	89 f7                	mov    %esi,%edi
  800bf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	7f 08                	jg     800bff <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bff:	83 ec 0c             	sub    $0xc,%esp
  800c02:	50                   	push   %eax
  800c03:	6a 04                	push   $0x4
  800c05:	68 9f 21 80 00       	push   $0x80219f
  800c0a:	6a 23                	push   $0x23
  800c0c:	68 bc 21 80 00       	push   $0x8021bc
  800c11:	e8 ff f4 ff ff       	call   800115 <_panic>

00800c16 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
  800c1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c25:	b8 05 00 00 00       	mov    $0x5,%eax
  800c2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c30:	8b 75 18             	mov    0x18(%ebp),%esi
  800c33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c35:	85 c0                	test   %eax,%eax
  800c37:	7f 08                	jg     800c41 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3c:	5b                   	pop    %ebx
  800c3d:	5e                   	pop    %esi
  800c3e:	5f                   	pop    %edi
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c41:	83 ec 0c             	sub    $0xc,%esp
  800c44:	50                   	push   %eax
  800c45:	6a 05                	push   $0x5
  800c47:	68 9f 21 80 00       	push   $0x80219f
  800c4c:	6a 23                	push   $0x23
  800c4e:	68 bc 21 80 00       	push   $0x8021bc
  800c53:	e8 bd f4 ff ff       	call   800115 <_panic>

00800c58 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6c:	b8 06 00 00 00       	mov    $0x6,%eax
  800c71:	89 df                	mov    %ebx,%edi
  800c73:	89 de                	mov    %ebx,%esi
  800c75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c77:	85 c0                	test   %eax,%eax
  800c79:	7f 08                	jg     800c83 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c83:	83 ec 0c             	sub    $0xc,%esp
  800c86:	50                   	push   %eax
  800c87:	6a 06                	push   $0x6
  800c89:	68 9f 21 80 00       	push   $0x80219f
  800c8e:	6a 23                	push   $0x23
  800c90:	68 bc 21 80 00       	push   $0x8021bc
  800c95:	e8 7b f4 ff ff       	call   800115 <_panic>

00800c9a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	57                   	push   %edi
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cae:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb3:	89 df                	mov    %ebx,%edi
  800cb5:	89 de                	mov    %ebx,%esi
  800cb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb9:	85 c0                	test   %eax,%eax
  800cbb:	7f 08                	jg     800cc5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc5:	83 ec 0c             	sub    $0xc,%esp
  800cc8:	50                   	push   %eax
  800cc9:	6a 08                	push   $0x8
  800ccb:	68 9f 21 80 00       	push   $0x80219f
  800cd0:	6a 23                	push   $0x23
  800cd2:	68 bc 21 80 00       	push   $0x8021bc
  800cd7:	e8 39 f4 ff ff       	call   800115 <_panic>

00800cdc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf0:	b8 09 00 00 00       	mov    $0x9,%eax
  800cf5:	89 df                	mov    %ebx,%edi
  800cf7:	89 de                	mov    %ebx,%esi
  800cf9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	7f 08                	jg     800d07 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d07:	83 ec 0c             	sub    $0xc,%esp
  800d0a:	50                   	push   %eax
  800d0b:	6a 09                	push   $0x9
  800d0d:	68 9f 21 80 00       	push   $0x80219f
  800d12:	6a 23                	push   $0x23
  800d14:	68 bc 21 80 00       	push   $0x8021bc
  800d19:	e8 f7 f3 ff ff       	call   800115 <_panic>

00800d1e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d37:	89 df                	mov    %ebx,%edi
  800d39:	89 de                	mov    %ebx,%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 0a                	push   $0xa
  800d4f:	68 9f 21 80 00       	push   $0x80219f
  800d54:	6a 23                	push   $0x23
  800d56:	68 bc 21 80 00       	push   $0x8021bc
  800d5b:	e8 b5 f3 ff ff       	call   800115 <_panic>

00800d60 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d71:	be 00 00 00 00       	mov    $0x0,%esi
  800d76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d79:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d99:	89 cb                	mov    %ecx,%ebx
  800d9b:	89 cf                	mov    %ecx,%edi
  800d9d:	89 ce                	mov    %ecx,%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 0d                	push   $0xd
  800db3:	68 9f 21 80 00       	push   $0x80219f
  800db8:	6a 23                	push   $0x23
  800dba:	68 bc 21 80 00       	push   $0x8021bc
  800dbf:	e8 51 f3 ff ff       	call   800115 <_panic>

00800dc4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  800dcb:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800dd2:	74 0d                	je     800de1 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800ddc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  800de1:	e8 af fd ff ff       	call   800b95 <sys_getenvid>
  800de6:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800de8:	83 ec 04             	sub    $0x4,%esp
  800deb:	6a 07                	push   $0x7
  800ded:	68 00 f0 bf ee       	push   $0xeebff000
  800df2:	50                   	push   %eax
  800df3:	e8 db fd ff ff       	call   800bd3 <sys_page_alloc>
        	if (r < 0) {
  800df8:	83 c4 10             	add    $0x10,%esp
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	78 27                	js     800e26 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	68 38 0e 80 00       	push   $0x800e38
  800e07:	53                   	push   %ebx
  800e08:	e8 11 ff ff ff       	call   800d1e <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	85 c0                	test   %eax,%eax
  800e12:	79 c0                	jns    800dd4 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  800e14:	50                   	push   %eax
  800e15:	68 ca 21 80 00       	push   $0x8021ca
  800e1a:	6a 28                	push   $0x28
  800e1c:	68 de 21 80 00       	push   $0x8021de
  800e21:	e8 ef f2 ff ff       	call   800115 <_panic>
            		panic("pgfault_handler: %e", r);
  800e26:	50                   	push   %eax
  800e27:	68 ca 21 80 00       	push   $0x8021ca
  800e2c:	6a 24                	push   $0x24
  800e2e:	68 de 21 80 00       	push   $0x8021de
  800e33:	e8 dd f2 ff ff       	call   800115 <_panic>

00800e38 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e38:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e39:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800e3e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e40:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  800e43:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  800e47:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  800e4a:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  800e4e:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  800e52:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800e55:	83 c4 08             	add    $0x8,%esp
	popal
  800e58:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  800e59:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  800e5c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  800e5d:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  800e5e:	c3                   	ret    

00800e5f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	05 00 00 00 30       	add    $0x30000000,%eax
  800e6a:	c1 e8 0c             	shr    $0xc,%eax
}
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e7f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e91:	89 c2                	mov    %eax,%edx
  800e93:	c1 ea 16             	shr    $0x16,%edx
  800e96:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e9d:	f6 c2 01             	test   $0x1,%dl
  800ea0:	74 2a                	je     800ecc <fd_alloc+0x46>
  800ea2:	89 c2                	mov    %eax,%edx
  800ea4:	c1 ea 0c             	shr    $0xc,%edx
  800ea7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eae:	f6 c2 01             	test   $0x1,%dl
  800eb1:	74 19                	je     800ecc <fd_alloc+0x46>
  800eb3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eb8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ebd:	75 d2                	jne    800e91 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ebf:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ec5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eca:	eb 07                	jmp    800ed3 <fd_alloc+0x4d>
			*fd_store = fd;
  800ecc:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800edb:	83 f8 1f             	cmp    $0x1f,%eax
  800ede:	77 36                	ja     800f16 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ee0:	c1 e0 0c             	shl    $0xc,%eax
  800ee3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	c1 ea 16             	shr    $0x16,%edx
  800eed:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ef4:	f6 c2 01             	test   $0x1,%dl
  800ef7:	74 24                	je     800f1d <fd_lookup+0x48>
  800ef9:	89 c2                	mov    %eax,%edx
  800efb:	c1 ea 0c             	shr    $0xc,%edx
  800efe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f05:	f6 c2 01             	test   $0x1,%dl
  800f08:	74 1a                	je     800f24 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0d:	89 02                	mov    %eax,(%edx)
	return 0;
  800f0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
		return -E_INVAL;
  800f16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1b:	eb f7                	jmp    800f14 <fd_lookup+0x3f>
		return -E_INVAL;
  800f1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f22:	eb f0                	jmp    800f14 <fd_lookup+0x3f>
  800f24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f29:	eb e9                	jmp    800f14 <fd_lookup+0x3f>

00800f2b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f34:	ba 6c 22 80 00       	mov    $0x80226c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f39:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f3e:	39 08                	cmp    %ecx,(%eax)
  800f40:	74 33                	je     800f75 <dev_lookup+0x4a>
  800f42:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f45:	8b 02                	mov    (%edx),%eax
  800f47:	85 c0                	test   %eax,%eax
  800f49:	75 f3                	jne    800f3e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f4b:	a1 04 40 80 00       	mov    0x804004,%eax
  800f50:	8b 40 48             	mov    0x48(%eax),%eax
  800f53:	83 ec 04             	sub    $0x4,%esp
  800f56:	51                   	push   %ecx
  800f57:	50                   	push   %eax
  800f58:	68 ec 21 80 00       	push   $0x8021ec
  800f5d:	e8 8e f2 ff ff       	call   8001f0 <cprintf>
	*dev = 0;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f6b:	83 c4 10             	add    $0x10,%esp
  800f6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f73:	c9                   	leave  
  800f74:	c3                   	ret    
			*dev = devtab[i];
  800f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f78:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7f:	eb f2                	jmp    800f73 <dev_lookup+0x48>

00800f81 <fd_close>:
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
  800f87:	83 ec 1c             	sub    $0x1c,%esp
  800f8a:	8b 75 08             	mov    0x8(%ebp),%esi
  800f8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f90:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f93:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f94:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f9a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f9d:	50                   	push   %eax
  800f9e:	e8 32 ff ff ff       	call   800ed5 <fd_lookup>
  800fa3:	89 c3                	mov    %eax,%ebx
  800fa5:	83 c4 08             	add    $0x8,%esp
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	78 05                	js     800fb1 <fd_close+0x30>
	    || fd != fd2)
  800fac:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800faf:	74 16                	je     800fc7 <fd_close+0x46>
		return (must_exist ? r : 0);
  800fb1:	89 f8                	mov    %edi,%eax
  800fb3:	84 c0                	test   %al,%al
  800fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fba:	0f 44 d8             	cmove  %eax,%ebx
}
  800fbd:	89 d8                	mov    %ebx,%eax
  800fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fcd:	50                   	push   %eax
  800fce:	ff 36                	pushl  (%esi)
  800fd0:	e8 56 ff ff ff       	call   800f2b <dev_lookup>
  800fd5:	89 c3                	mov    %eax,%ebx
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	78 15                	js     800ff3 <fd_close+0x72>
		if (dev->dev_close)
  800fde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe1:	8b 40 10             	mov    0x10(%eax),%eax
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	74 1b                	je     801003 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	56                   	push   %esi
  800fec:	ff d0                	call   *%eax
  800fee:	89 c3                	mov    %eax,%ebx
  800ff0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	56                   	push   %esi
  800ff7:	6a 00                	push   $0x0
  800ff9:	e8 5a fc ff ff       	call   800c58 <sys_page_unmap>
	return r;
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	eb ba                	jmp    800fbd <fd_close+0x3c>
			r = 0;
  801003:	bb 00 00 00 00       	mov    $0x0,%ebx
  801008:	eb e9                	jmp    800ff3 <fd_close+0x72>

0080100a <close>:

int
close(int fdnum)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801010:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801013:	50                   	push   %eax
  801014:	ff 75 08             	pushl  0x8(%ebp)
  801017:	e8 b9 fe ff ff       	call   800ed5 <fd_lookup>
  80101c:	83 c4 08             	add    $0x8,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 10                	js     801033 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	6a 01                	push   $0x1
  801028:	ff 75 f4             	pushl  -0xc(%ebp)
  80102b:	e8 51 ff ff ff       	call   800f81 <fd_close>
  801030:	83 c4 10             	add    $0x10,%esp
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    

00801035 <close_all>:

void
close_all(void)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	53                   	push   %ebx
  801039:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	53                   	push   %ebx
  801045:	e8 c0 ff ff ff       	call   80100a <close>
	for (i = 0; i < MAXFD; i++)
  80104a:	83 c3 01             	add    $0x1,%ebx
  80104d:	83 c4 10             	add    $0x10,%esp
  801050:	83 fb 20             	cmp    $0x20,%ebx
  801053:	75 ec                	jne    801041 <close_all+0xc>
}
  801055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801063:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801066:	50                   	push   %eax
  801067:	ff 75 08             	pushl  0x8(%ebp)
  80106a:	e8 66 fe ff ff       	call   800ed5 <fd_lookup>
  80106f:	89 c3                	mov    %eax,%ebx
  801071:	83 c4 08             	add    $0x8,%esp
  801074:	85 c0                	test   %eax,%eax
  801076:	0f 88 81 00 00 00    	js     8010fd <dup+0xa3>
		return r;
	close(newfdnum);
  80107c:	83 ec 0c             	sub    $0xc,%esp
  80107f:	ff 75 0c             	pushl  0xc(%ebp)
  801082:	e8 83 ff ff ff       	call   80100a <close>

	newfd = INDEX2FD(newfdnum);
  801087:	8b 75 0c             	mov    0xc(%ebp),%esi
  80108a:	c1 e6 0c             	shl    $0xc,%esi
  80108d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801093:	83 c4 04             	add    $0x4,%esp
  801096:	ff 75 e4             	pushl  -0x1c(%ebp)
  801099:	e8 d1 fd ff ff       	call   800e6f <fd2data>
  80109e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010a0:	89 34 24             	mov    %esi,(%esp)
  8010a3:	e8 c7 fd ff ff       	call   800e6f <fd2data>
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010ad:	89 d8                	mov    %ebx,%eax
  8010af:	c1 e8 16             	shr    $0x16,%eax
  8010b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010b9:	a8 01                	test   $0x1,%al
  8010bb:	74 11                	je     8010ce <dup+0x74>
  8010bd:	89 d8                	mov    %ebx,%eax
  8010bf:	c1 e8 0c             	shr    $0xc,%eax
  8010c2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010c9:	f6 c2 01             	test   $0x1,%dl
  8010cc:	75 39                	jne    801107 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010d1:	89 d0                	mov    %edx,%eax
  8010d3:	c1 e8 0c             	shr    $0xc,%eax
  8010d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010dd:	83 ec 0c             	sub    $0xc,%esp
  8010e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8010e5:	50                   	push   %eax
  8010e6:	56                   	push   %esi
  8010e7:	6a 00                	push   $0x0
  8010e9:	52                   	push   %edx
  8010ea:	6a 00                	push   $0x0
  8010ec:	e8 25 fb ff ff       	call   800c16 <sys_page_map>
  8010f1:	89 c3                	mov    %eax,%ebx
  8010f3:	83 c4 20             	add    $0x20,%esp
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	78 31                	js     80112b <dup+0xd1>
		goto err;

	return newfdnum;
  8010fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010fd:	89 d8                	mov    %ebx,%eax
  8010ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801107:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	25 07 0e 00 00       	and    $0xe07,%eax
  801116:	50                   	push   %eax
  801117:	57                   	push   %edi
  801118:	6a 00                	push   $0x0
  80111a:	53                   	push   %ebx
  80111b:	6a 00                	push   $0x0
  80111d:	e8 f4 fa ff ff       	call   800c16 <sys_page_map>
  801122:	89 c3                	mov    %eax,%ebx
  801124:	83 c4 20             	add    $0x20,%esp
  801127:	85 c0                	test   %eax,%eax
  801129:	79 a3                	jns    8010ce <dup+0x74>
	sys_page_unmap(0, newfd);
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	56                   	push   %esi
  80112f:	6a 00                	push   $0x0
  801131:	e8 22 fb ff ff       	call   800c58 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801136:	83 c4 08             	add    $0x8,%esp
  801139:	57                   	push   %edi
  80113a:	6a 00                	push   $0x0
  80113c:	e8 17 fb ff ff       	call   800c58 <sys_page_unmap>
	return r;
  801141:	83 c4 10             	add    $0x10,%esp
  801144:	eb b7                	jmp    8010fd <dup+0xa3>

00801146 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	53                   	push   %ebx
  80114a:	83 ec 14             	sub    $0x14,%esp
  80114d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801150:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801153:	50                   	push   %eax
  801154:	53                   	push   %ebx
  801155:	e8 7b fd ff ff       	call   800ed5 <fd_lookup>
  80115a:	83 c4 08             	add    $0x8,%esp
  80115d:	85 c0                	test   %eax,%eax
  80115f:	78 3f                	js     8011a0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801161:	83 ec 08             	sub    $0x8,%esp
  801164:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801167:	50                   	push   %eax
  801168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116b:	ff 30                	pushl  (%eax)
  80116d:	e8 b9 fd ff ff       	call   800f2b <dev_lookup>
  801172:	83 c4 10             	add    $0x10,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	78 27                	js     8011a0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117c:	8b 42 08             	mov    0x8(%edx),%eax
  80117f:	83 e0 03             	and    $0x3,%eax
  801182:	83 f8 01             	cmp    $0x1,%eax
  801185:	74 1e                	je     8011a5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118a:	8b 40 08             	mov    0x8(%eax),%eax
  80118d:	85 c0                	test   %eax,%eax
  80118f:	74 35                	je     8011c6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	ff 75 10             	pushl  0x10(%ebp)
  801197:	ff 75 0c             	pushl  0xc(%ebp)
  80119a:	52                   	push   %edx
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
}
  8011a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011a5:	a1 04 40 80 00       	mov    0x804004,%eax
  8011aa:	8b 40 48             	mov    0x48(%eax),%eax
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	53                   	push   %ebx
  8011b1:	50                   	push   %eax
  8011b2:	68 30 22 80 00       	push   $0x802230
  8011b7:	e8 34 f0 ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c4:	eb da                	jmp    8011a0 <read+0x5a>
		return -E_NOT_SUPP;
  8011c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011cb:	eb d3                	jmp    8011a0 <read+0x5a>

008011cd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	57                   	push   %edi
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
  8011d3:	83 ec 0c             	sub    $0xc,%esp
  8011d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e1:	39 f3                	cmp    %esi,%ebx
  8011e3:	73 25                	jae    80120a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	89 f0                	mov    %esi,%eax
  8011ea:	29 d8                	sub    %ebx,%eax
  8011ec:	50                   	push   %eax
  8011ed:	89 d8                	mov    %ebx,%eax
  8011ef:	03 45 0c             	add    0xc(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	57                   	push   %edi
  8011f4:	e8 4d ff ff ff       	call   801146 <read>
		if (m < 0)
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	78 08                	js     801208 <readn+0x3b>
			return m;
		if (m == 0)
  801200:	85 c0                	test   %eax,%eax
  801202:	74 06                	je     80120a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801204:	01 c3                	add    %eax,%ebx
  801206:	eb d9                	jmp    8011e1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801208:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80120a:	89 d8                	mov    %ebx,%eax
  80120c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120f:	5b                   	pop    %ebx
  801210:	5e                   	pop    %esi
  801211:	5f                   	pop    %edi
  801212:	5d                   	pop    %ebp
  801213:	c3                   	ret    

00801214 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	53                   	push   %ebx
  801218:	83 ec 14             	sub    $0x14,%esp
  80121b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80121e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801221:	50                   	push   %eax
  801222:	53                   	push   %ebx
  801223:	e8 ad fc ff ff       	call   800ed5 <fd_lookup>
  801228:	83 c4 08             	add    $0x8,%esp
  80122b:	85 c0                	test   %eax,%eax
  80122d:	78 3a                	js     801269 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80122f:	83 ec 08             	sub    $0x8,%esp
  801232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801235:	50                   	push   %eax
  801236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801239:	ff 30                	pushl  (%eax)
  80123b:	e8 eb fc ff ff       	call   800f2b <dev_lookup>
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	78 22                	js     801269 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80124e:	74 1e                	je     80126e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801253:	8b 52 0c             	mov    0xc(%edx),%edx
  801256:	85 d2                	test   %edx,%edx
  801258:	74 35                	je     80128f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80125a:	83 ec 04             	sub    $0x4,%esp
  80125d:	ff 75 10             	pushl  0x10(%ebp)
  801260:	ff 75 0c             	pushl  0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	ff d2                	call   *%edx
  801266:	83 c4 10             	add    $0x10,%esp
}
  801269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80126e:	a1 04 40 80 00       	mov    0x804004,%eax
  801273:	8b 40 48             	mov    0x48(%eax),%eax
  801276:	83 ec 04             	sub    $0x4,%esp
  801279:	53                   	push   %ebx
  80127a:	50                   	push   %eax
  80127b:	68 4c 22 80 00       	push   $0x80224c
  801280:	e8 6b ef ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128d:	eb da                	jmp    801269 <write+0x55>
		return -E_NOT_SUPP;
  80128f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801294:	eb d3                	jmp    801269 <write+0x55>

00801296 <seek>:

int
seek(int fdnum, off_t offset)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80129c:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80129f:	50                   	push   %eax
  8012a0:	ff 75 08             	pushl  0x8(%ebp)
  8012a3:	e8 2d fc ff ff       	call   800ed5 <fd_lookup>
  8012a8:	83 c4 08             	add    $0x8,%esp
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	78 0e                	js     8012bd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	53                   	push   %ebx
  8012c3:	83 ec 14             	sub    $0x14,%esp
  8012c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012cc:	50                   	push   %eax
  8012cd:	53                   	push   %ebx
  8012ce:	e8 02 fc ff ff       	call   800ed5 <fd_lookup>
  8012d3:	83 c4 08             	add    $0x8,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 37                	js     801311 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e0:	50                   	push   %eax
  8012e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e4:	ff 30                	pushl  (%eax)
  8012e6:	e8 40 fc ff ff       	call   800f2b <dev_lookup>
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 1f                	js     801311 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012f9:	74 1b                	je     801316 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	8b 52 18             	mov    0x18(%edx),%edx
  801301:	85 d2                	test   %edx,%edx
  801303:	74 32                	je     801337 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801305:	83 ec 08             	sub    $0x8,%esp
  801308:	ff 75 0c             	pushl  0xc(%ebp)
  80130b:	50                   	push   %eax
  80130c:	ff d2                	call   *%edx
  80130e:	83 c4 10             	add    $0x10,%esp
}
  801311:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801314:	c9                   	leave  
  801315:	c3                   	ret    
			thisenv->env_id, fdnum);
  801316:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80131b:	8b 40 48             	mov    0x48(%eax),%eax
  80131e:	83 ec 04             	sub    $0x4,%esp
  801321:	53                   	push   %ebx
  801322:	50                   	push   %eax
  801323:	68 0c 22 80 00       	push   $0x80220c
  801328:	e8 c3 ee ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  80132d:	83 c4 10             	add    $0x10,%esp
  801330:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801335:	eb da                	jmp    801311 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801337:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133c:	eb d3                	jmp    801311 <ftruncate+0x52>

0080133e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	53                   	push   %ebx
  801342:	83 ec 14             	sub    $0x14,%esp
  801345:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801348:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80134b:	50                   	push   %eax
  80134c:	ff 75 08             	pushl  0x8(%ebp)
  80134f:	e8 81 fb ff ff       	call   800ed5 <fd_lookup>
  801354:	83 c4 08             	add    $0x8,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	78 4b                	js     8013a6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135b:	83 ec 08             	sub    $0x8,%esp
  80135e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801361:	50                   	push   %eax
  801362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801365:	ff 30                	pushl  (%eax)
  801367:	e8 bf fb ff ff       	call   800f2b <dev_lookup>
  80136c:	83 c4 10             	add    $0x10,%esp
  80136f:	85 c0                	test   %eax,%eax
  801371:	78 33                	js     8013a6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801376:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80137a:	74 2f                	je     8013ab <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80137c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80137f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801386:	00 00 00 
	stat->st_isdir = 0;
  801389:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801390:	00 00 00 
	stat->st_dev = dev;
  801393:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801399:	83 ec 08             	sub    $0x8,%esp
  80139c:	53                   	push   %ebx
  80139d:	ff 75 f0             	pushl  -0x10(%ebp)
  8013a0:	ff 50 14             	call   *0x14(%eax)
  8013a3:	83 c4 10             	add    $0x10,%esp
}
  8013a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    
		return -E_NOT_SUPP;
  8013ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b0:	eb f4                	jmp    8013a6 <fstat+0x68>

008013b2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	56                   	push   %esi
  8013b6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013b7:	83 ec 08             	sub    $0x8,%esp
  8013ba:	6a 00                	push   $0x0
  8013bc:	ff 75 08             	pushl  0x8(%ebp)
  8013bf:	e8 e7 01 00 00       	call   8015ab <open>
  8013c4:	89 c3                	mov    %eax,%ebx
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 1b                	js     8013e8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013cd:	83 ec 08             	sub    $0x8,%esp
  8013d0:	ff 75 0c             	pushl  0xc(%ebp)
  8013d3:	50                   	push   %eax
  8013d4:	e8 65 ff ff ff       	call   80133e <fstat>
  8013d9:	89 c6                	mov    %eax,%esi
	close(fd);
  8013db:	89 1c 24             	mov    %ebx,(%esp)
  8013de:	e8 27 fc ff ff       	call   80100a <close>
	return r;
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	89 f3                	mov    %esi,%ebx
}
  8013e8:	89 d8                	mov    %ebx,%eax
  8013ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ed:	5b                   	pop    %ebx
  8013ee:	5e                   	pop    %esi
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    

008013f1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	89 c6                	mov    %eax,%esi
  8013f8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013fa:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801401:	74 27                	je     80142a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801403:	6a 07                	push   $0x7
  801405:	68 00 50 80 00       	push   $0x805000
  80140a:	56                   	push   %esi
  80140b:	ff 35 00 40 80 00    	pushl  0x804000
  801411:	e8 1b 07 00 00       	call   801b31 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801416:	83 c4 0c             	add    $0xc,%esp
  801419:	6a 00                	push   $0x0
  80141b:	53                   	push   %ebx
  80141c:	6a 00                	push   $0x0
  80141e:	e8 f7 06 00 00       	call   801b1a <ipc_recv>
}
  801423:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5d                   	pop    %ebp
  801429:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80142a:	83 ec 0c             	sub    $0xc,%esp
  80142d:	6a 01                	push   $0x1
  80142f:	e8 14 07 00 00       	call   801b48 <ipc_find_env>
  801434:	a3 00 40 80 00       	mov    %eax,0x804000
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	eb c5                	jmp    801403 <fsipc+0x12>

0080143e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8b 40 0c             	mov    0xc(%eax),%eax
  80144a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801457:	ba 00 00 00 00       	mov    $0x0,%edx
  80145c:	b8 02 00 00 00       	mov    $0x2,%eax
  801461:	e8 8b ff ff ff       	call   8013f1 <fsipc>
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <devfile_flush>:
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8b 40 0c             	mov    0xc(%eax),%eax
  801474:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801479:	ba 00 00 00 00       	mov    $0x0,%edx
  80147e:	b8 06 00 00 00       	mov    $0x6,%eax
  801483:	e8 69 ff ff ff       	call   8013f1 <fsipc>
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <devfile_stat>:
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	53                   	push   %ebx
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8b 40 0c             	mov    0xc(%eax),%eax
  80149a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80149f:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a4:	b8 05 00 00 00       	mov    $0x5,%eax
  8014a9:	e8 43 ff ff ff       	call   8013f1 <fsipc>
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 2c                	js     8014de <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	68 00 50 80 00       	push   $0x805000
  8014ba:	53                   	push   %ebx
  8014bb:	e8 1a f3 ff ff       	call   8007da <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014c0:	a1 80 50 80 00       	mov    0x805080,%eax
  8014c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014cb:	a1 84 50 80 00       	mov    0x805084,%eax
  8014d0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <devfile_write>:
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014f1:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014f6:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fc:	8b 52 0c             	mov    0xc(%edx),%edx
  8014ff:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801505:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80150a:	50                   	push   %eax
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	68 08 50 80 00       	push   $0x805008
  801513:	e8 50 f4 ff ff       	call   800968 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801518:	ba 00 00 00 00       	mov    $0x0,%edx
  80151d:	b8 04 00 00 00       	mov    $0x4,%eax
  801522:	e8 ca fe ff ff       	call   8013f1 <fsipc>
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <devfile_read>:
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	56                   	push   %esi
  80152d:	53                   	push   %ebx
  80152e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8b 40 0c             	mov    0xc(%eax),%eax
  801537:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80153c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801542:	ba 00 00 00 00       	mov    $0x0,%edx
  801547:	b8 03 00 00 00       	mov    $0x3,%eax
  80154c:	e8 a0 fe ff ff       	call   8013f1 <fsipc>
  801551:	89 c3                	mov    %eax,%ebx
  801553:	85 c0                	test   %eax,%eax
  801555:	78 1f                	js     801576 <devfile_read+0x4d>
	assert(r <= n);
  801557:	39 f0                	cmp    %esi,%eax
  801559:	77 24                	ja     80157f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80155b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801560:	7f 33                	jg     801595 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	50                   	push   %eax
  801566:	68 00 50 80 00       	push   $0x805000
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	e8 f5 f3 ff ff       	call   800968 <memmove>
	return r;
  801573:	83 c4 10             	add    $0x10,%esp
}
  801576:	89 d8                	mov    %ebx,%eax
  801578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    
	assert(r <= n);
  80157f:	68 7c 22 80 00       	push   $0x80227c
  801584:	68 83 22 80 00       	push   $0x802283
  801589:	6a 7c                	push   $0x7c
  80158b:	68 98 22 80 00       	push   $0x802298
  801590:	e8 80 eb ff ff       	call   800115 <_panic>
	assert(r <= PGSIZE);
  801595:	68 a3 22 80 00       	push   $0x8022a3
  80159a:	68 83 22 80 00       	push   $0x802283
  80159f:	6a 7d                	push   $0x7d
  8015a1:	68 98 22 80 00       	push   $0x802298
  8015a6:	e8 6a eb ff ff       	call   800115 <_panic>

008015ab <open>:
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 1c             	sub    $0x1c,%esp
  8015b3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015b6:	56                   	push   %esi
  8015b7:	e8 e7 f1 ff ff       	call   8007a3 <strlen>
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015c4:	7f 6c                	jg     801632 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cc:	50                   	push   %eax
  8015cd:	e8 b4 f8 ff ff       	call   800e86 <fd_alloc>
  8015d2:	89 c3                	mov    %eax,%ebx
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 3c                	js     801617 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	56                   	push   %esi
  8015df:	68 00 50 80 00       	push   $0x805000
  8015e4:	e8 f1 f1 ff ff       	call   8007da <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ec:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f9:	e8 f3 fd ff ff       	call   8013f1 <fsipc>
  8015fe:	89 c3                	mov    %eax,%ebx
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 19                	js     801620 <open+0x75>
	return fd2num(fd);
  801607:	83 ec 0c             	sub    $0xc,%esp
  80160a:	ff 75 f4             	pushl  -0xc(%ebp)
  80160d:	e8 4d f8 ff ff       	call   800e5f <fd2num>
  801612:	89 c3                	mov    %eax,%ebx
  801614:	83 c4 10             	add    $0x10,%esp
}
  801617:	89 d8                	mov    %ebx,%eax
  801619:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80161c:	5b                   	pop    %ebx
  80161d:	5e                   	pop    %esi
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    
		fd_close(fd, 0);
  801620:	83 ec 08             	sub    $0x8,%esp
  801623:	6a 00                	push   $0x0
  801625:	ff 75 f4             	pushl  -0xc(%ebp)
  801628:	e8 54 f9 ff ff       	call   800f81 <fd_close>
		return r;
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	eb e5                	jmp    801617 <open+0x6c>
		return -E_BAD_PATH;
  801632:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801637:	eb de                	jmp    801617 <open+0x6c>

00801639 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80163f:	ba 00 00 00 00       	mov    $0x0,%edx
  801644:	b8 08 00 00 00       	mov    $0x8,%eax
  801649:	e8 a3 fd ff ff       	call   8013f1 <fsipc>
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	ff 75 08             	pushl  0x8(%ebp)
  80165e:	e8 0c f8 ff ff       	call   800e6f <fd2data>
  801663:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801665:	83 c4 08             	add    $0x8,%esp
  801668:	68 af 22 80 00       	push   $0x8022af
  80166d:	53                   	push   %ebx
  80166e:	e8 67 f1 ff ff       	call   8007da <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801673:	8b 46 04             	mov    0x4(%esi),%eax
  801676:	2b 06                	sub    (%esi),%eax
  801678:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80167e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801685:	00 00 00 
	stat->st_dev = &devpipe;
  801688:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80168f:	30 80 00 
	return 0;
}
  801692:	b8 00 00 00 00       	mov    $0x0,%eax
  801697:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169a:	5b                   	pop    %ebx
  80169b:	5e                   	pop    %esi
  80169c:	5d                   	pop    %ebp
  80169d:	c3                   	ret    

0080169e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 0c             	sub    $0xc,%esp
  8016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016a8:	53                   	push   %ebx
  8016a9:	6a 00                	push   $0x0
  8016ab:	e8 a8 f5 ff ff       	call   800c58 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016b0:	89 1c 24             	mov    %ebx,(%esp)
  8016b3:	e8 b7 f7 ff ff       	call   800e6f <fd2data>
  8016b8:	83 c4 08             	add    $0x8,%esp
  8016bb:	50                   	push   %eax
  8016bc:	6a 00                	push   $0x0
  8016be:	e8 95 f5 ff ff       	call   800c58 <sys_page_unmap>
}
  8016c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <_pipeisclosed>:
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	57                   	push   %edi
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 1c             	sub    $0x1c,%esp
  8016d1:	89 c7                	mov    %eax,%edi
  8016d3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8016da:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016dd:	83 ec 0c             	sub    $0xc,%esp
  8016e0:	57                   	push   %edi
  8016e1:	e8 9b 04 00 00       	call   801b81 <pageref>
  8016e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016e9:	89 34 24             	mov    %esi,(%esp)
  8016ec:	e8 90 04 00 00       	call   801b81 <pageref>
		nn = thisenv->env_runs;
  8016f1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016f7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	39 cb                	cmp    %ecx,%ebx
  8016ff:	74 1b                	je     80171c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801701:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801704:	75 cf                	jne    8016d5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801706:	8b 42 58             	mov    0x58(%edx),%eax
  801709:	6a 01                	push   $0x1
  80170b:	50                   	push   %eax
  80170c:	53                   	push   %ebx
  80170d:	68 b6 22 80 00       	push   $0x8022b6
  801712:	e8 d9 ea ff ff       	call   8001f0 <cprintf>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	eb b9                	jmp    8016d5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80171c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80171f:	0f 94 c0             	sete   %al
  801722:	0f b6 c0             	movzbl %al,%eax
}
  801725:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801728:	5b                   	pop    %ebx
  801729:	5e                   	pop    %esi
  80172a:	5f                   	pop    %edi
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    

0080172d <devpipe_write>:
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	57                   	push   %edi
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
  801733:	83 ec 28             	sub    $0x28,%esp
  801736:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801739:	56                   	push   %esi
  80173a:	e8 30 f7 ff ff       	call   800e6f <fd2data>
  80173f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	bf 00 00 00 00       	mov    $0x0,%edi
  801749:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80174c:	74 4f                	je     80179d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80174e:	8b 43 04             	mov    0x4(%ebx),%eax
  801751:	8b 0b                	mov    (%ebx),%ecx
  801753:	8d 51 20             	lea    0x20(%ecx),%edx
  801756:	39 d0                	cmp    %edx,%eax
  801758:	72 14                	jb     80176e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80175a:	89 da                	mov    %ebx,%edx
  80175c:	89 f0                	mov    %esi,%eax
  80175e:	e8 65 ff ff ff       	call   8016c8 <_pipeisclosed>
  801763:	85 c0                	test   %eax,%eax
  801765:	75 3a                	jne    8017a1 <devpipe_write+0x74>
			sys_yield();
  801767:	e8 48 f4 ff ff       	call   800bb4 <sys_yield>
  80176c:	eb e0                	jmp    80174e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80176e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801771:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801775:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801778:	89 c2                	mov    %eax,%edx
  80177a:	c1 fa 1f             	sar    $0x1f,%edx
  80177d:	89 d1                	mov    %edx,%ecx
  80177f:	c1 e9 1b             	shr    $0x1b,%ecx
  801782:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801785:	83 e2 1f             	and    $0x1f,%edx
  801788:	29 ca                	sub    %ecx,%edx
  80178a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80178e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801792:	83 c0 01             	add    $0x1,%eax
  801795:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801798:	83 c7 01             	add    $0x1,%edi
  80179b:	eb ac                	jmp    801749 <devpipe_write+0x1c>
	return i;
  80179d:	89 f8                	mov    %edi,%eax
  80179f:	eb 05                	jmp    8017a6 <devpipe_write+0x79>
				return 0;
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5e                   	pop    %esi
  8017ab:	5f                   	pop    %edi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    

008017ae <devpipe_read>:
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	57                   	push   %edi
  8017b2:	56                   	push   %esi
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 18             	sub    $0x18,%esp
  8017b7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017ba:	57                   	push   %edi
  8017bb:	e8 af f6 ff ff       	call   800e6f <fd2data>
  8017c0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	be 00 00 00 00       	mov    $0x0,%esi
  8017ca:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017cd:	74 47                	je     801816 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8017cf:	8b 03                	mov    (%ebx),%eax
  8017d1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017d4:	75 22                	jne    8017f8 <devpipe_read+0x4a>
			if (i > 0)
  8017d6:	85 f6                	test   %esi,%esi
  8017d8:	75 14                	jne    8017ee <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8017da:	89 da                	mov    %ebx,%edx
  8017dc:	89 f8                	mov    %edi,%eax
  8017de:	e8 e5 fe ff ff       	call   8016c8 <_pipeisclosed>
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	75 33                	jne    80181a <devpipe_read+0x6c>
			sys_yield();
  8017e7:	e8 c8 f3 ff ff       	call   800bb4 <sys_yield>
  8017ec:	eb e1                	jmp    8017cf <devpipe_read+0x21>
				return i;
  8017ee:	89 f0                	mov    %esi,%eax
}
  8017f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f3:	5b                   	pop    %ebx
  8017f4:	5e                   	pop    %esi
  8017f5:	5f                   	pop    %edi
  8017f6:	5d                   	pop    %ebp
  8017f7:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017f8:	99                   	cltd   
  8017f9:	c1 ea 1b             	shr    $0x1b,%edx
  8017fc:	01 d0                	add    %edx,%eax
  8017fe:	83 e0 1f             	and    $0x1f,%eax
  801801:	29 d0                	sub    %edx,%eax
  801803:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801808:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80180e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801811:	83 c6 01             	add    $0x1,%esi
  801814:	eb b4                	jmp    8017ca <devpipe_read+0x1c>
	return i;
  801816:	89 f0                	mov    %esi,%eax
  801818:	eb d6                	jmp    8017f0 <devpipe_read+0x42>
				return 0;
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
  80181f:	eb cf                	jmp    8017f0 <devpipe_read+0x42>

00801821 <pipe>:
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	56                   	push   %esi
  801825:	53                   	push   %ebx
  801826:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801829:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182c:	50                   	push   %eax
  80182d:	e8 54 f6 ff ff       	call   800e86 <fd_alloc>
  801832:	89 c3                	mov    %eax,%ebx
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	78 5b                	js     801896 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	68 07 04 00 00       	push   $0x407
  801843:	ff 75 f4             	pushl  -0xc(%ebp)
  801846:	6a 00                	push   $0x0
  801848:	e8 86 f3 ff ff       	call   800bd3 <sys_page_alloc>
  80184d:	89 c3                	mov    %eax,%ebx
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	85 c0                	test   %eax,%eax
  801854:	78 40                	js     801896 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801856:	83 ec 0c             	sub    $0xc,%esp
  801859:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185c:	50                   	push   %eax
  80185d:	e8 24 f6 ff ff       	call   800e86 <fd_alloc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 1b                	js     801886 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80186b:	83 ec 04             	sub    $0x4,%esp
  80186e:	68 07 04 00 00       	push   $0x407
  801873:	ff 75 f0             	pushl  -0x10(%ebp)
  801876:	6a 00                	push   $0x0
  801878:	e8 56 f3 ff ff       	call   800bd3 <sys_page_alloc>
  80187d:	89 c3                	mov    %eax,%ebx
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	79 19                	jns    80189f <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	ff 75 f4             	pushl  -0xc(%ebp)
  80188c:	6a 00                	push   $0x0
  80188e:	e8 c5 f3 ff ff       	call   800c58 <sys_page_unmap>
  801893:	83 c4 10             	add    $0x10,%esp
}
  801896:	89 d8                	mov    %ebx,%eax
  801898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5e                   	pop    %esi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    
	va = fd2data(fd0);
  80189f:	83 ec 0c             	sub    $0xc,%esp
  8018a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a5:	e8 c5 f5 ff ff       	call   800e6f <fd2data>
  8018aa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018ac:	83 c4 0c             	add    $0xc,%esp
  8018af:	68 07 04 00 00       	push   $0x407
  8018b4:	50                   	push   %eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	e8 17 f3 ff ff       	call   800bd3 <sys_page_alloc>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	0f 88 8c 00 00 00    	js     801955 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8018cf:	e8 9b f5 ff ff       	call   800e6f <fd2data>
  8018d4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018db:	50                   	push   %eax
  8018dc:	6a 00                	push   $0x0
  8018de:	56                   	push   %esi
  8018df:	6a 00                	push   $0x0
  8018e1:	e8 30 f3 ff ff       	call   800c16 <sys_page_map>
  8018e6:	89 c3                	mov    %eax,%ebx
  8018e8:	83 c4 20             	add    $0x20,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 58                	js     801947 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018f8:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801907:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80190d:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801912:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801919:	83 ec 0c             	sub    $0xc,%esp
  80191c:	ff 75 f4             	pushl  -0xc(%ebp)
  80191f:	e8 3b f5 ff ff       	call   800e5f <fd2num>
  801924:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801927:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801929:	83 c4 04             	add    $0x4,%esp
  80192c:	ff 75 f0             	pushl  -0x10(%ebp)
  80192f:	e8 2b f5 ff ff       	call   800e5f <fd2num>
  801934:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801937:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801942:	e9 4f ff ff ff       	jmp    801896 <pipe+0x75>
	sys_page_unmap(0, va);
  801947:	83 ec 08             	sub    $0x8,%esp
  80194a:	56                   	push   %esi
  80194b:	6a 00                	push   $0x0
  80194d:	e8 06 f3 ff ff       	call   800c58 <sys_page_unmap>
  801952:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	ff 75 f0             	pushl  -0x10(%ebp)
  80195b:	6a 00                	push   $0x0
  80195d:	e8 f6 f2 ff ff       	call   800c58 <sys_page_unmap>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	e9 1c ff ff ff       	jmp    801886 <pipe+0x65>

0080196a <pipeisclosed>:
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801970:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801973:	50                   	push   %eax
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	e8 59 f5 ff ff       	call   800ed5 <fd_lookup>
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 18                	js     80199b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801983:	83 ec 0c             	sub    $0xc,%esp
  801986:	ff 75 f4             	pushl  -0xc(%ebp)
  801989:	e8 e1 f4 ff ff       	call   800e6f <fd2data>
	return _pipeisclosed(fd, p);
  80198e:	89 c2                	mov    %eax,%edx
  801990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801993:	e8 30 fd ff ff       	call   8016c8 <_pipeisclosed>
  801998:	83 c4 10             	add    $0x10,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8019a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a5:	5d                   	pop    %ebp
  8019a6:	c3                   	ret    

008019a7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8019ad:	68 ce 22 80 00       	push   $0x8022ce
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	e8 20 ee ff ff       	call   8007da <strcpy>
	return 0;
}
  8019ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <devcons_write>:
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	57                   	push   %edi
  8019c5:	56                   	push   %esi
  8019c6:	53                   	push   %ebx
  8019c7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8019cd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019d2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019d8:	eb 2f                	jmp    801a09 <devcons_write+0x48>
		m = n - tot;
  8019da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019dd:	29 f3                	sub    %esi,%ebx
  8019df:	83 fb 7f             	cmp    $0x7f,%ebx
  8019e2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8019e7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	53                   	push   %ebx
  8019ee:	89 f0                	mov    %esi,%eax
  8019f0:	03 45 0c             	add    0xc(%ebp),%eax
  8019f3:	50                   	push   %eax
  8019f4:	57                   	push   %edi
  8019f5:	e8 6e ef ff ff       	call   800968 <memmove>
		sys_cputs(buf, m);
  8019fa:	83 c4 08             	add    $0x8,%esp
  8019fd:	53                   	push   %ebx
  8019fe:	57                   	push   %edi
  8019ff:	e8 13 f1 ff ff       	call   800b17 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a04:	01 de                	add    %ebx,%esi
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a0c:	72 cc                	jb     8019da <devcons_write+0x19>
}
  801a0e:	89 f0                	mov    %esi,%eax
  801a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a13:	5b                   	pop    %ebx
  801a14:	5e                   	pop    %esi
  801a15:	5f                   	pop    %edi
  801a16:	5d                   	pop    %ebp
  801a17:	c3                   	ret    

00801a18 <devcons_read>:
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 08             	sub    $0x8,%esp
  801a1e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a27:	75 07                	jne    801a30 <devcons_read+0x18>
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    
		sys_yield();
  801a2b:	e8 84 f1 ff ff       	call   800bb4 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801a30:	e8 00 f1 ff ff       	call   800b35 <sys_cgetc>
  801a35:	85 c0                	test   %eax,%eax
  801a37:	74 f2                	je     801a2b <devcons_read+0x13>
	if (c < 0)
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	78 ec                	js     801a29 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801a3d:	83 f8 04             	cmp    $0x4,%eax
  801a40:	74 0c                	je     801a4e <devcons_read+0x36>
	*(char*)vbuf = c;
  801a42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a45:	88 02                	mov    %al,(%edx)
	return 1;
  801a47:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4c:	eb db                	jmp    801a29 <devcons_read+0x11>
		return 0;
  801a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a53:	eb d4                	jmp    801a29 <devcons_read+0x11>

00801a55 <cputchar>:
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a61:	6a 01                	push   $0x1
  801a63:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a66:	50                   	push   %eax
  801a67:	e8 ab f0 ff ff       	call   800b17 <sys_cputs>
}
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <getchar>:
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a77:	6a 01                	push   $0x1
  801a79:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a7c:	50                   	push   %eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	e8 c2 f6 ff ff       	call   801146 <read>
	if (r < 0)
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	85 c0                	test   %eax,%eax
  801a89:	78 08                	js     801a93 <getchar+0x22>
	if (r < 1)
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	7e 06                	jle    801a95 <getchar+0x24>
	return c;
  801a8f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    
		return -E_EOF;
  801a95:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a9a:	eb f7                	jmp    801a93 <getchar+0x22>

00801a9c <iscons>:
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aa2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa5:	50                   	push   %eax
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	e8 27 f4 ff ff       	call   800ed5 <fd_lookup>
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 11                	js     801ac6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801abe:	39 10                	cmp    %edx,(%eax)
  801ac0:	0f 94 c0             	sete   %al
  801ac3:	0f b6 c0             	movzbl %al,%eax
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <opencons>:
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ace:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad1:	50                   	push   %eax
  801ad2:	e8 af f3 ff ff       	call   800e86 <fd_alloc>
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 3a                	js     801b18 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	68 07 04 00 00       	push   $0x407
  801ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae9:	6a 00                	push   $0x0
  801aeb:	e8 e3 f0 ff ff       	call   800bd3 <sys_page_alloc>
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 21                	js     801b18 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afa:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b00:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b0c:	83 ec 0c             	sub    $0xc,%esp
  801b0f:	50                   	push   %eax
  801b10:	e8 4a f3 ff ff       	call   800e5f <fd2num>
  801b15:	83 c4 10             	add    $0x10,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801b20:	68 da 22 80 00       	push   $0x8022da
  801b25:	6a 1a                	push   $0x1a
  801b27:	68 f3 22 80 00       	push   $0x8022f3
  801b2c:	e8 e4 e5 ff ff       	call   800115 <_panic>

00801b31 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801b37:	68 fd 22 80 00       	push   $0x8022fd
  801b3c:	6a 2a                	push   $0x2a
  801b3e:	68 f3 22 80 00       	push   $0x8022f3
  801b43:	e8 cd e5 ff ff       	call   800115 <_panic>

00801b48 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b53:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b56:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b5c:	8b 52 50             	mov    0x50(%edx),%edx
  801b5f:	39 ca                	cmp    %ecx,%edx
  801b61:	74 11                	je     801b74 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801b63:	83 c0 01             	add    $0x1,%eax
  801b66:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b6b:	75 e6                	jne    801b53 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b72:	eb 0b                	jmp    801b7f <ipc_find_env+0x37>
			return envs[i].env_id;
  801b74:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b77:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b7c:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    

00801b81 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b87:	89 d0                	mov    %edx,%eax
  801b89:	c1 e8 16             	shr    $0x16,%eax
  801b8c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b93:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801b98:	f6 c1 01             	test   $0x1,%cl
  801b9b:	74 1d                	je     801bba <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801b9d:	c1 ea 0c             	shr    $0xc,%edx
  801ba0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ba7:	f6 c2 01             	test   $0x1,%dl
  801baa:	74 0e                	je     801bba <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801bac:	c1 ea 0c             	shr    $0xc,%edx
  801baf:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801bb6:	ef 
  801bb7:	0f b7 c0             	movzwl %ax,%eax
}
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	66 90                	xchg   %ax,%ax
  801bbe:	66 90                	xchg   %ax,%ax

00801bc0 <__udivdi3>:
  801bc0:	55                   	push   %ebp
  801bc1:	57                   	push   %edi
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 1c             	sub    $0x1c,%esp
  801bc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bcb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801bcf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bd3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801bd7:	85 d2                	test   %edx,%edx
  801bd9:	75 35                	jne    801c10 <__udivdi3+0x50>
  801bdb:	39 f3                	cmp    %esi,%ebx
  801bdd:	0f 87 bd 00 00 00    	ja     801ca0 <__udivdi3+0xe0>
  801be3:	85 db                	test   %ebx,%ebx
  801be5:	89 d9                	mov    %ebx,%ecx
  801be7:	75 0b                	jne    801bf4 <__udivdi3+0x34>
  801be9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bee:	31 d2                	xor    %edx,%edx
  801bf0:	f7 f3                	div    %ebx
  801bf2:	89 c1                	mov    %eax,%ecx
  801bf4:	31 d2                	xor    %edx,%edx
  801bf6:	89 f0                	mov    %esi,%eax
  801bf8:	f7 f1                	div    %ecx
  801bfa:	89 c6                	mov    %eax,%esi
  801bfc:	89 e8                	mov    %ebp,%eax
  801bfe:	89 f7                	mov    %esi,%edi
  801c00:	f7 f1                	div    %ecx
  801c02:	89 fa                	mov    %edi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c10:	39 f2                	cmp    %esi,%edx
  801c12:	77 7c                	ja     801c90 <__udivdi3+0xd0>
  801c14:	0f bd fa             	bsr    %edx,%edi
  801c17:	83 f7 1f             	xor    $0x1f,%edi
  801c1a:	0f 84 98 00 00 00    	je     801cb8 <__udivdi3+0xf8>
  801c20:	89 f9                	mov    %edi,%ecx
  801c22:	b8 20 00 00 00       	mov    $0x20,%eax
  801c27:	29 f8                	sub    %edi,%eax
  801c29:	d3 e2                	shl    %cl,%edx
  801c2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c2f:	89 c1                	mov    %eax,%ecx
  801c31:	89 da                	mov    %ebx,%edx
  801c33:	d3 ea                	shr    %cl,%edx
  801c35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801c39:	09 d1                	or     %edx,%ecx
  801c3b:	89 f2                	mov    %esi,%edx
  801c3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c41:	89 f9                	mov    %edi,%ecx
  801c43:	d3 e3                	shl    %cl,%ebx
  801c45:	89 c1                	mov    %eax,%ecx
  801c47:	d3 ea                	shr    %cl,%edx
  801c49:	89 f9                	mov    %edi,%ecx
  801c4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801c4f:	d3 e6                	shl    %cl,%esi
  801c51:	89 eb                	mov    %ebp,%ebx
  801c53:	89 c1                	mov    %eax,%ecx
  801c55:	d3 eb                	shr    %cl,%ebx
  801c57:	09 de                	or     %ebx,%esi
  801c59:	89 f0                	mov    %esi,%eax
  801c5b:	f7 74 24 08          	divl   0x8(%esp)
  801c5f:	89 d6                	mov    %edx,%esi
  801c61:	89 c3                	mov    %eax,%ebx
  801c63:	f7 64 24 0c          	mull   0xc(%esp)
  801c67:	39 d6                	cmp    %edx,%esi
  801c69:	72 0c                	jb     801c77 <__udivdi3+0xb7>
  801c6b:	89 f9                	mov    %edi,%ecx
  801c6d:	d3 e5                	shl    %cl,%ebp
  801c6f:	39 c5                	cmp    %eax,%ebp
  801c71:	73 5d                	jae    801cd0 <__udivdi3+0x110>
  801c73:	39 d6                	cmp    %edx,%esi
  801c75:	75 59                	jne    801cd0 <__udivdi3+0x110>
  801c77:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c7a:	31 ff                	xor    %edi,%edi
  801c7c:	89 fa                	mov    %edi,%edx
  801c7e:	83 c4 1c             	add    $0x1c,%esp
  801c81:	5b                   	pop    %ebx
  801c82:	5e                   	pop    %esi
  801c83:	5f                   	pop    %edi
  801c84:	5d                   	pop    %ebp
  801c85:	c3                   	ret    
  801c86:	8d 76 00             	lea    0x0(%esi),%esi
  801c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801c90:	31 ff                	xor    %edi,%edi
  801c92:	31 c0                	xor    %eax,%eax
  801c94:	89 fa                	mov    %edi,%edx
  801c96:	83 c4 1c             	add    $0x1c,%esp
  801c99:	5b                   	pop    %ebx
  801c9a:	5e                   	pop    %esi
  801c9b:	5f                   	pop    %edi
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    
  801c9e:	66 90                	xchg   %ax,%ax
  801ca0:	31 ff                	xor    %edi,%edi
  801ca2:	89 e8                	mov    %ebp,%eax
  801ca4:	89 f2                	mov    %esi,%edx
  801ca6:	f7 f3                	div    %ebx
  801ca8:	89 fa                	mov    %edi,%edx
  801caa:	83 c4 1c             	add    $0x1c,%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5e                   	pop    %esi
  801caf:	5f                   	pop    %edi
  801cb0:	5d                   	pop    %ebp
  801cb1:	c3                   	ret    
  801cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cb8:	39 f2                	cmp    %esi,%edx
  801cba:	72 06                	jb     801cc2 <__udivdi3+0x102>
  801cbc:	31 c0                	xor    %eax,%eax
  801cbe:	39 eb                	cmp    %ebp,%ebx
  801cc0:	77 d2                	ja     801c94 <__udivdi3+0xd4>
  801cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc7:	eb cb                	jmp    801c94 <__udivdi3+0xd4>
  801cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cd0:	89 d8                	mov    %ebx,%eax
  801cd2:	31 ff                	xor    %edi,%edi
  801cd4:	eb be                	jmp    801c94 <__udivdi3+0xd4>
  801cd6:	66 90                	xchg   %ax,%ax
  801cd8:	66 90                	xchg   %ax,%ax
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	66 90                	xchg   %ax,%ax
  801cde:	66 90                	xchg   %ax,%ax

00801ce0 <__umoddi3>:
  801ce0:	55                   	push   %ebp
  801ce1:	57                   	push   %edi
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 1c             	sub    $0x1c,%esp
  801ce7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801ceb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801cef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801cf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cf7:	85 ed                	test   %ebp,%ebp
  801cf9:	89 f0                	mov    %esi,%eax
  801cfb:	89 da                	mov    %ebx,%edx
  801cfd:	75 19                	jne    801d18 <__umoddi3+0x38>
  801cff:	39 df                	cmp    %ebx,%edi
  801d01:	0f 86 b1 00 00 00    	jbe    801db8 <__umoddi3+0xd8>
  801d07:	f7 f7                	div    %edi
  801d09:	89 d0                	mov    %edx,%eax
  801d0b:	31 d2                	xor    %edx,%edx
  801d0d:	83 c4 1c             	add    $0x1c,%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5f                   	pop    %edi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    
  801d15:	8d 76 00             	lea    0x0(%esi),%esi
  801d18:	39 dd                	cmp    %ebx,%ebp
  801d1a:	77 f1                	ja     801d0d <__umoddi3+0x2d>
  801d1c:	0f bd cd             	bsr    %ebp,%ecx
  801d1f:	83 f1 1f             	xor    $0x1f,%ecx
  801d22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d26:	0f 84 b4 00 00 00    	je     801de0 <__umoddi3+0x100>
  801d2c:	b8 20 00 00 00       	mov    $0x20,%eax
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d37:	29 c2                	sub    %eax,%edx
  801d39:	89 c1                	mov    %eax,%ecx
  801d3b:	89 f8                	mov    %edi,%eax
  801d3d:	d3 e5                	shl    %cl,%ebp
  801d3f:	89 d1                	mov    %edx,%ecx
  801d41:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d45:	d3 e8                	shr    %cl,%eax
  801d47:	09 c5                	or     %eax,%ebp
  801d49:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d4d:	89 c1                	mov    %eax,%ecx
  801d4f:	d3 e7                	shl    %cl,%edi
  801d51:	89 d1                	mov    %edx,%ecx
  801d53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801d57:	89 df                	mov    %ebx,%edi
  801d59:	d3 ef                	shr    %cl,%edi
  801d5b:	89 c1                	mov    %eax,%ecx
  801d5d:	89 f0                	mov    %esi,%eax
  801d5f:	d3 e3                	shl    %cl,%ebx
  801d61:	89 d1                	mov    %edx,%ecx
  801d63:	89 fa                	mov    %edi,%edx
  801d65:	d3 e8                	shr    %cl,%eax
  801d67:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801d6c:	09 d8                	or     %ebx,%eax
  801d6e:	f7 f5                	div    %ebp
  801d70:	d3 e6                	shl    %cl,%esi
  801d72:	89 d1                	mov    %edx,%ecx
  801d74:	f7 64 24 08          	mull   0x8(%esp)
  801d78:	39 d1                	cmp    %edx,%ecx
  801d7a:	89 c3                	mov    %eax,%ebx
  801d7c:	89 d7                	mov    %edx,%edi
  801d7e:	72 06                	jb     801d86 <__umoddi3+0xa6>
  801d80:	75 0e                	jne    801d90 <__umoddi3+0xb0>
  801d82:	39 c6                	cmp    %eax,%esi
  801d84:	73 0a                	jae    801d90 <__umoddi3+0xb0>
  801d86:	2b 44 24 08          	sub    0x8(%esp),%eax
  801d8a:	19 ea                	sbb    %ebp,%edx
  801d8c:	89 d7                	mov    %edx,%edi
  801d8e:	89 c3                	mov    %eax,%ebx
  801d90:	89 ca                	mov    %ecx,%edx
  801d92:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801d97:	29 de                	sub    %ebx,%esi
  801d99:	19 fa                	sbb    %edi,%edx
  801d9b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d9f:	89 d0                	mov    %edx,%eax
  801da1:	d3 e0                	shl    %cl,%eax
  801da3:	89 d9                	mov    %ebx,%ecx
  801da5:	d3 ee                	shr    %cl,%esi
  801da7:	d3 ea                	shr    %cl,%edx
  801da9:	09 f0                	or     %esi,%eax
  801dab:	83 c4 1c             	add    $0x1c,%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5e                   	pop    %esi
  801db0:	5f                   	pop    %edi
  801db1:	5d                   	pop    %ebp
  801db2:	c3                   	ret    
  801db3:	90                   	nop
  801db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801db8:	85 ff                	test   %edi,%edi
  801dba:	89 f9                	mov    %edi,%ecx
  801dbc:	75 0b                	jne    801dc9 <__umoddi3+0xe9>
  801dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc3:	31 d2                	xor    %edx,%edx
  801dc5:	f7 f7                	div    %edi
  801dc7:	89 c1                	mov    %eax,%ecx
  801dc9:	89 d8                	mov    %ebx,%eax
  801dcb:	31 d2                	xor    %edx,%edx
  801dcd:	f7 f1                	div    %ecx
  801dcf:	89 f0                	mov    %esi,%eax
  801dd1:	f7 f1                	div    %ecx
  801dd3:	e9 31 ff ff ff       	jmp    801d09 <__umoddi3+0x29>
  801dd8:	90                   	nop
  801dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801de0:	39 dd                	cmp    %ebx,%ebp
  801de2:	72 08                	jb     801dec <__umoddi3+0x10c>
  801de4:	39 f7                	cmp    %esi,%edi
  801de6:	0f 87 21 ff ff ff    	ja     801d0d <__umoddi3+0x2d>
  801dec:	89 da                	mov    %ebx,%edx
  801dee:	89 f0                	mov    %esi,%eax
  801df0:	29 f8                	sub    %edi,%eax
  801df2:	19 ea                	sbb    %ebp,%edx
  801df4:	e9 14 ff ff ff       	jmp    801d0d <__umoddi3+0x2d>
