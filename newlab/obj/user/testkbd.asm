
obj/user/testkbd.debug：     文件格式 elf32-i386


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
  80002c:	e8 33 02 00 00       	call   800264 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 0f 0e 00 00       	call   800e53 <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 bb 11 00 00       	call   80120e <close>
	if ((r = opencons()) < 0)
  800053:	e8 ba 01 00 00       	call   800212 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	78 16                	js     800075 <umain+0x42>
		panic("opencons: %e", r);
	if (r != 0)
  80005f:	85 c0                	test   %eax,%eax
  800061:	74 24                	je     800087 <umain+0x54>
		panic("first opencons used fd %d", r);
  800063:	50                   	push   %eax
  800064:	68 bc 1f 80 00       	push   $0x801fbc
  800069:	6a 11                	push   $0x11
  80006b:	68 ad 1f 80 00       	push   $0x801fad
  800070:	e8 4f 02 00 00       	call   8002c4 <_panic>
		panic("opencons: %e", r);
  800075:	50                   	push   %eax
  800076:	68 a0 1f 80 00       	push   $0x801fa0
  80007b:	6a 0f                	push   $0xf
  80007d:	68 ad 1f 80 00       	push   $0x801fad
  800082:	e8 3d 02 00 00       	call   8002c4 <_panic>
	if ((r = dup(0, 1)) < 0)
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	6a 01                	push   $0x1
  80008c:	6a 00                	push   $0x0
  80008e:	e8 cb 11 00 00       	call   80125e <dup>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	79 24                	jns    8000be <umain+0x8b>
		panic("dup: %e", r);
  80009a:	50                   	push   %eax
  80009b:	68 d6 1f 80 00       	push   $0x801fd6
  8000a0:	6a 13                	push   $0x13
  8000a2:	68 ad 1f 80 00       	push   $0x801fad
  8000a7:	e8 18 02 00 00       	call   8002c4 <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	68 f0 1f 80 00       	push   $0x801ff0
  8000b4:	6a 01                	push   $0x1
  8000b6:	e8 81 18 00 00       	call   80193c <fprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 de 1f 80 00       	push   $0x801fde
  8000c6:	e8 87 08 00 00       	call   800952 <readline>
		if (buf != NULL)
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	74 da                	je     8000ac <umain+0x79>
			fprintf(1, "%s\n", buf);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	50                   	push   %eax
  8000d6:	68 ec 1f 80 00       	push   $0x801fec
  8000db:	6a 01                	push   $0x1
  8000dd:	e8 5a 18 00 00       	call   80193c <fprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb d7                	jmp    8000be <umain+0x8b>

008000e7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f7:	68 08 20 80 00       	push   $0x802008
  8000fc:	ff 75 0c             	pushl  0xc(%ebp)
  8000ff:	e8 75 09 00 00       	call   800a79 <strcpy>
	return 0;
}
  800104:	b8 00 00 00 00       	mov    $0x0,%eax
  800109:	c9                   	leave  
  80010a:	c3                   	ret    

0080010b <devcons_write>:
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	57                   	push   %edi
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
  800111:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800117:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80011c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800122:	eb 2f                	jmp    800153 <devcons_write+0x48>
		m = n - tot;
  800124:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800127:	29 f3                	sub    %esi,%ebx
  800129:	83 fb 7f             	cmp    $0x7f,%ebx
  80012c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800131:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	53                   	push   %ebx
  800138:	89 f0                	mov    %esi,%eax
  80013a:	03 45 0c             	add    0xc(%ebp),%eax
  80013d:	50                   	push   %eax
  80013e:	57                   	push   %edi
  80013f:	e8 c3 0a 00 00       	call   800c07 <memmove>
		sys_cputs(buf, m);
  800144:	83 c4 08             	add    $0x8,%esp
  800147:	53                   	push   %ebx
  800148:	57                   	push   %edi
  800149:	e8 68 0c 00 00       	call   800db6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80014e:	01 de                	add    %ebx,%esi
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	3b 75 10             	cmp    0x10(%ebp),%esi
  800156:	72 cc                	jb     800124 <devcons_write+0x19>
}
  800158:	89 f0                	mov    %esi,%eax
  80015a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <devcons_read>:
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80016d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800171:	75 07                	jne    80017a <devcons_read+0x18>
}
  800173:	c9                   	leave  
  800174:	c3                   	ret    
		sys_yield();
  800175:	e8 d9 0c 00 00       	call   800e53 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80017a:	e8 55 0c 00 00       	call   800dd4 <sys_cgetc>
  80017f:	85 c0                	test   %eax,%eax
  800181:	74 f2                	je     800175 <devcons_read+0x13>
	if (c < 0)
  800183:	85 c0                	test   %eax,%eax
  800185:	78 ec                	js     800173 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  800187:	83 f8 04             	cmp    $0x4,%eax
  80018a:	74 0c                	je     800198 <devcons_read+0x36>
	*(char*)vbuf = c;
  80018c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018f:	88 02                	mov    %al,(%edx)
	return 1;
  800191:	b8 01 00 00 00       	mov    $0x1,%eax
  800196:	eb db                	jmp    800173 <devcons_read+0x11>
		return 0;
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	eb d4                	jmp    800173 <devcons_read+0x11>

0080019f <cputchar>:
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8001a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001ab:	6a 01                	push   $0x1
  8001ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 00 0c 00 00       	call   800db6 <sys_cputs>
}
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <getchar>:
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001c1:	6a 01                	push   $0x1
  8001c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	6a 00                	push   $0x0
  8001c9:	e8 7c 11 00 00       	call   80134a <read>
	if (r < 0)
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	78 08                	js     8001dd <getchar+0x22>
	if (r < 1)
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	7e 06                	jle    8001df <getchar+0x24>
	return c;
  8001d9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001dd:	c9                   	leave  
  8001de:	c3                   	ret    
		return -E_EOF;
  8001df:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001e4:	eb f7                	jmp    8001dd <getchar+0x22>

008001e6 <iscons>:
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	ff 75 08             	pushl  0x8(%ebp)
  8001f3:	e8 e1 0e 00 00       	call   8010d9 <fd_lookup>
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	85 c0                	test   %eax,%eax
  8001fd:	78 11                	js     800210 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8001ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800202:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800208:	39 10                	cmp    %edx,(%eax)
  80020a:	0f 94 c0             	sete   %al
  80020d:	0f b6 c0             	movzbl %al,%eax
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <opencons>:
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800218:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	e8 69 0e 00 00       	call   80108a <fd_alloc>
  800221:	83 c4 10             	add    $0x10,%esp
  800224:	85 c0                	test   %eax,%eax
  800226:	78 3a                	js     800262 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	68 07 04 00 00       	push   $0x407
  800230:	ff 75 f4             	pushl  -0xc(%ebp)
  800233:	6a 00                	push   $0x0
  800235:	e8 38 0c 00 00       	call   800e72 <sys_page_alloc>
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	85 c0                	test   %eax,%eax
  80023f:	78 21                	js     800262 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800244:	8b 15 00 30 80 00    	mov    0x803000,%edx
  80024a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80024c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80024f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	e8 04 0e 00 00       	call   801063 <fd2num>
  80025f:	83 c4 10             	add    $0x10,%esp
}
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80026c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80026f:	e8 c0 0b 00 00       	call   800e34 <sys_getenvid>
  800274:	25 ff 03 00 00       	and    $0x3ff,%eax
  800279:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 04 44 80 00       	mov    %eax,0x804404

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800286:	85 db                	test   %ebx,%ebx
  800288:	7e 07                	jle    800291 <libmain+0x2d>
		binaryname = argv[0];
  80028a:	8b 06                	mov    (%esi),%eax
  80028c:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	e8 98 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80029b:	e8 0a 00 00 00       	call   8002aa <exit>
}
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002a6:	5b                   	pop    %ebx
  8002a7:	5e                   	pop    %esi
  8002a8:	5d                   	pop    %ebp
  8002a9:	c3                   	ret    

008002aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002b0:	e8 84 0f 00 00       	call   801239 <close_all>
	sys_env_destroy(0);
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	6a 00                	push   $0x0
  8002ba:	e8 34 0b 00 00       	call   800df3 <sys_env_destroy>
}
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	56                   	push   %esi
  8002c8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002c9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002cc:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002d2:	e8 5d 0b 00 00       	call   800e34 <sys_getenvid>
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 0c             	pushl  0xc(%ebp)
  8002dd:	ff 75 08             	pushl  0x8(%ebp)
  8002e0:	56                   	push   %esi
  8002e1:	50                   	push   %eax
  8002e2:	68 20 20 80 00       	push   $0x802020
  8002e7:	e8 b3 00 00 00       	call   80039f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002ec:	83 c4 18             	add    $0x18,%esp
  8002ef:	53                   	push   %ebx
  8002f0:	ff 75 10             	pushl  0x10(%ebp)
  8002f3:	e8 56 00 00 00       	call   80034e <vcprintf>
	cprintf("\n");
  8002f8:	c7 04 24 06 20 80 00 	movl   $0x802006,(%esp)
  8002ff:	e8 9b 00 00 00       	call   80039f <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800307:	cc                   	int3   
  800308:	eb fd                	jmp    800307 <_panic+0x43>

0080030a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	53                   	push   %ebx
  80030e:	83 ec 04             	sub    $0x4,%esp
  800311:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800314:	8b 13                	mov    (%ebx),%edx
  800316:	8d 42 01             	lea    0x1(%edx),%eax
  800319:	89 03                	mov    %eax,(%ebx)
  80031b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80031e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800322:	3d ff 00 00 00       	cmp    $0xff,%eax
  800327:	74 09                	je     800332 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800329:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80032d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800330:	c9                   	leave  
  800331:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	68 ff 00 00 00       	push   $0xff
  80033a:	8d 43 08             	lea    0x8(%ebx),%eax
  80033d:	50                   	push   %eax
  80033e:	e8 73 0a 00 00       	call   800db6 <sys_cputs>
		b->idx = 0;
  800343:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	eb db                	jmp    800329 <putch+0x1f>

0080034e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800357:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80035e:	00 00 00 
	b.cnt = 0;
  800361:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800368:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80036b:	ff 75 0c             	pushl  0xc(%ebp)
  80036e:	ff 75 08             	pushl  0x8(%ebp)
  800371:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800377:	50                   	push   %eax
  800378:	68 0a 03 80 00       	push   $0x80030a
  80037d:	e8 1a 01 00 00       	call   80049c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800382:	83 c4 08             	add    $0x8,%esp
  800385:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80038b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800391:	50                   	push   %eax
  800392:	e8 1f 0a 00 00       	call   800db6 <sys_cputs>

	return b.cnt;
}
  800397:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 08             	pushl  0x8(%ebp)
  8003ac:	e8 9d ff ff ff       	call   80034e <vcprintf>
	va_end(ap);

	return cnt;
}
  8003b1:	c9                   	leave  
  8003b2:	c3                   	ret    

008003b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	57                   	push   %edi
  8003b7:	56                   	push   %esi
  8003b8:	53                   	push   %ebx
  8003b9:	83 ec 1c             	sub    $0x1c,%esp
  8003bc:	89 c7                	mov    %eax,%edi
  8003be:	89 d6                	mov    %edx,%esi
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003d7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003da:	39 d3                	cmp    %edx,%ebx
  8003dc:	72 05                	jb     8003e3 <printnum+0x30>
  8003de:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003e1:	77 7a                	ja     80045d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e3:	83 ec 0c             	sub    $0xc,%esp
  8003e6:	ff 75 18             	pushl  0x18(%ebp)
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003ef:	53                   	push   %ebx
  8003f0:	ff 75 10             	pushl  0x10(%ebp)
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8003fc:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800402:	e8 59 19 00 00       	call   801d60 <__udivdi3>
  800407:	83 c4 18             	add    $0x18,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	89 f2                	mov    %esi,%edx
  80040e:	89 f8                	mov    %edi,%eax
  800410:	e8 9e ff ff ff       	call   8003b3 <printnum>
  800415:	83 c4 20             	add    $0x20,%esp
  800418:	eb 13                	jmp    80042d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	56                   	push   %esi
  80041e:	ff 75 18             	pushl  0x18(%ebp)
  800421:	ff d7                	call   *%edi
  800423:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800426:	83 eb 01             	sub    $0x1,%ebx
  800429:	85 db                	test   %ebx,%ebx
  80042b:	7f ed                	jg     80041a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	56                   	push   %esi
  800431:	83 ec 04             	sub    $0x4,%esp
  800434:	ff 75 e4             	pushl  -0x1c(%ebp)
  800437:	ff 75 e0             	pushl  -0x20(%ebp)
  80043a:	ff 75 dc             	pushl  -0x24(%ebp)
  80043d:	ff 75 d8             	pushl  -0x28(%ebp)
  800440:	e8 3b 1a 00 00       	call   801e80 <__umoddi3>
  800445:	83 c4 14             	add    $0x14,%esp
  800448:	0f be 80 43 20 80 00 	movsbl 0x802043(%eax),%eax
  80044f:	50                   	push   %eax
  800450:	ff d7                	call   *%edi
}
  800452:	83 c4 10             	add    $0x10,%esp
  800455:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800458:	5b                   	pop    %ebx
  800459:	5e                   	pop    %esi
  80045a:	5f                   	pop    %edi
  80045b:	5d                   	pop    %ebp
  80045c:	c3                   	ret    
  80045d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800460:	eb c4                	jmp    800426 <printnum+0x73>

00800462 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800468:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80046c:	8b 10                	mov    (%eax),%edx
  80046e:	3b 50 04             	cmp    0x4(%eax),%edx
  800471:	73 0a                	jae    80047d <sprintputch+0x1b>
		*b->buf++ = ch;
  800473:	8d 4a 01             	lea    0x1(%edx),%ecx
  800476:	89 08                	mov    %ecx,(%eax)
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	88 02                	mov    %al,(%edx)
}
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <printfmt>:
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
  800482:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800485:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800488:	50                   	push   %eax
  800489:	ff 75 10             	pushl  0x10(%ebp)
  80048c:	ff 75 0c             	pushl  0xc(%ebp)
  80048f:	ff 75 08             	pushl  0x8(%ebp)
  800492:	e8 05 00 00 00       	call   80049c <vprintfmt>
}
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	c9                   	leave  
  80049b:	c3                   	ret    

0080049c <vprintfmt>:
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	57                   	push   %edi
  8004a0:	56                   	push   %esi
  8004a1:	53                   	push   %ebx
  8004a2:	83 ec 2c             	sub    $0x2c,%esp
  8004a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ab:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004ae:	e9 8c 03 00 00       	jmp    80083f <vprintfmt+0x3a3>
		padc = ' ';
  8004b3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004b7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004be:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d1:	8d 47 01             	lea    0x1(%edi),%eax
  8004d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004d7:	0f b6 17             	movzbl (%edi),%edx
  8004da:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004dd:	3c 55                	cmp    $0x55,%al
  8004df:	0f 87 dd 03 00 00    	ja     8008c2 <vprintfmt+0x426>
  8004e5:	0f b6 c0             	movzbl %al,%eax
  8004e8:	ff 24 85 80 21 80 00 	jmp    *0x802180(,%eax,4)
  8004ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004f2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004f6:	eb d9                	jmp    8004d1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004fb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004ff:	eb d0                	jmp    8004d1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800501:	0f b6 d2             	movzbl %dl,%edx
  800504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800507:	b8 00 00 00 00       	mov    $0x0,%eax
  80050c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80050f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800512:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800516:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800519:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80051c:	83 f9 09             	cmp    $0x9,%ecx
  80051f:	77 55                	ja     800576 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800521:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800524:	eb e9                	jmp    80050f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 40 04             	lea    0x4(%eax),%eax
  800534:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800537:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80053a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80053e:	79 91                	jns    8004d1 <vprintfmt+0x35>
				width = precision, precision = -1;
  800540:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800546:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80054d:	eb 82                	jmp    8004d1 <vprintfmt+0x35>
  80054f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800552:	85 c0                	test   %eax,%eax
  800554:	ba 00 00 00 00       	mov    $0x0,%edx
  800559:	0f 49 d0             	cmovns %eax,%edx
  80055c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80055f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800562:	e9 6a ff ff ff       	jmp    8004d1 <vprintfmt+0x35>
  800567:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80056a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800571:	e9 5b ff ff ff       	jmp    8004d1 <vprintfmt+0x35>
  800576:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800579:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80057c:	eb bc                	jmp    80053a <vprintfmt+0x9e>
			lflag++;
  80057e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800581:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800584:	e9 48 ff ff ff       	jmp    8004d1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8d 78 04             	lea    0x4(%eax),%edi
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	53                   	push   %ebx
  800593:	ff 30                	pushl  (%eax)
  800595:	ff d6                	call   *%esi
			break;
  800597:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80059a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80059d:	e9 9a 02 00 00       	jmp    80083c <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 78 04             	lea    0x4(%eax),%edi
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	99                   	cltd   
  8005ab:	31 d0                	xor    %edx,%eax
  8005ad:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005af:	83 f8 0f             	cmp    $0xf,%eax
  8005b2:	7f 23                	jg     8005d7 <vprintfmt+0x13b>
  8005b4:	8b 14 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%edx
  8005bb:	85 d2                	test   %edx,%edx
  8005bd:	74 18                	je     8005d7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005bf:	52                   	push   %edx
  8005c0:	68 25 24 80 00       	push   $0x802425
  8005c5:	53                   	push   %ebx
  8005c6:	56                   	push   %esi
  8005c7:	e8 b3 fe ff ff       	call   80047f <printfmt>
  8005cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005cf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005d2:	e9 65 02 00 00       	jmp    80083c <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8005d7:	50                   	push   %eax
  8005d8:	68 5b 20 80 00       	push   $0x80205b
  8005dd:	53                   	push   %ebx
  8005de:	56                   	push   %esi
  8005df:	e8 9b fe ff ff       	call   80047f <printfmt>
  8005e4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005ea:	e9 4d 02 00 00       	jmp    80083c <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	83 c0 04             	add    $0x4,%eax
  8005f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005fd:	85 ff                	test   %edi,%edi
  8005ff:	b8 54 20 80 00       	mov    $0x802054,%eax
  800604:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800607:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80060b:	0f 8e bd 00 00 00    	jle    8006ce <vprintfmt+0x232>
  800611:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800615:	75 0e                	jne    800625 <vprintfmt+0x189>
  800617:	89 75 08             	mov    %esi,0x8(%ebp)
  80061a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80061d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800620:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800623:	eb 6d                	jmp    800692 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 d0             	pushl  -0x30(%ebp)
  80062b:	57                   	push   %edi
  80062c:	e8 29 04 00 00       	call   800a5a <strnlen>
  800631:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800634:	29 c1                	sub    %eax,%ecx
  800636:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800639:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80063c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800640:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800643:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800646:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	eb 0f                	jmp    800659 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	ff 75 e0             	pushl  -0x20(%ebp)
  800651:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800653:	83 ef 01             	sub    $0x1,%edi
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	85 ff                	test   %edi,%edi
  80065b:	7f ed                	jg     80064a <vprintfmt+0x1ae>
  80065d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800660:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800663:	85 c9                	test   %ecx,%ecx
  800665:	b8 00 00 00 00       	mov    $0x0,%eax
  80066a:	0f 49 c1             	cmovns %ecx,%eax
  80066d:	29 c1                	sub    %eax,%ecx
  80066f:	89 75 08             	mov    %esi,0x8(%ebp)
  800672:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800675:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800678:	89 cb                	mov    %ecx,%ebx
  80067a:	eb 16                	jmp    800692 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80067c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800680:	75 31                	jne    8006b3 <vprintfmt+0x217>
					putch(ch, putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	50                   	push   %eax
  800689:	ff 55 08             	call   *0x8(%ebp)
  80068c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068f:	83 eb 01             	sub    $0x1,%ebx
  800692:	83 c7 01             	add    $0x1,%edi
  800695:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800699:	0f be c2             	movsbl %dl,%eax
  80069c:	85 c0                	test   %eax,%eax
  80069e:	74 59                	je     8006f9 <vprintfmt+0x25d>
  8006a0:	85 f6                	test   %esi,%esi
  8006a2:	78 d8                	js     80067c <vprintfmt+0x1e0>
  8006a4:	83 ee 01             	sub    $0x1,%esi
  8006a7:	79 d3                	jns    80067c <vprintfmt+0x1e0>
  8006a9:	89 df                	mov    %ebx,%edi
  8006ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006b1:	eb 37                	jmp    8006ea <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b3:	0f be d2             	movsbl %dl,%edx
  8006b6:	83 ea 20             	sub    $0x20,%edx
  8006b9:	83 fa 5e             	cmp    $0x5e,%edx
  8006bc:	76 c4                	jbe    800682 <vprintfmt+0x1e6>
					putch('?', putdat);
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 0c             	pushl  0xc(%ebp)
  8006c4:	6a 3f                	push   $0x3f
  8006c6:	ff 55 08             	call   *0x8(%ebp)
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	eb c1                	jmp    80068f <vprintfmt+0x1f3>
  8006ce:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006d7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006da:	eb b6                	jmp    800692 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	53                   	push   %ebx
  8006e0:	6a 20                	push   $0x20
  8006e2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006e4:	83 ef 01             	sub    $0x1,%edi
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	85 ff                	test   %edi,%edi
  8006ec:	7f ee                	jg     8006dc <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f4:	e9 43 01 00 00       	jmp    80083c <vprintfmt+0x3a0>
  8006f9:	89 df                	mov    %ebx,%edi
  8006fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800701:	eb e7                	jmp    8006ea <vprintfmt+0x24e>
	if (lflag >= 2)
  800703:	83 f9 01             	cmp    $0x1,%ecx
  800706:	7e 3f                	jle    800747 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 50 04             	mov    0x4(%eax),%edx
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800713:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 40 08             	lea    0x8(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80071f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800723:	79 5c                	jns    800781 <vprintfmt+0x2e5>
				putch('-', putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	53                   	push   %ebx
  800729:	6a 2d                	push   $0x2d
  80072b:	ff d6                	call   *%esi
				num = -(long long) num;
  80072d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800730:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800733:	f7 da                	neg    %edx
  800735:	83 d1 00             	adc    $0x0,%ecx
  800738:	f7 d9                	neg    %ecx
  80073a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80073d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800742:	e9 db 00 00 00       	jmp    800822 <vprintfmt+0x386>
	else if (lflag)
  800747:	85 c9                	test   %ecx,%ecx
  800749:	75 1b                	jne    800766 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	89 c1                	mov    %eax,%ecx
  800755:	c1 f9 1f             	sar    $0x1f,%ecx
  800758:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8d 40 04             	lea    0x4(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
  800764:	eb b9                	jmp    80071f <vprintfmt+0x283>
		return va_arg(*ap, long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076e:	89 c1                	mov    %eax,%ecx
  800770:	c1 f9 1f             	sar    $0x1f,%ecx
  800773:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
  80077f:	eb 9e                	jmp    80071f <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800781:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800784:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800787:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078c:	e9 91 00 00 00       	jmp    800822 <vprintfmt+0x386>
	if (lflag >= 2)
  800791:	83 f9 01             	cmp    $0x1,%ecx
  800794:	7e 15                	jle    8007ab <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 10                	mov    (%eax),%edx
  80079b:	8b 48 04             	mov    0x4(%eax),%ecx
  80079e:	8d 40 08             	lea    0x8(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a9:	eb 77                	jmp    800822 <vprintfmt+0x386>
	else if (lflag)
  8007ab:	85 c9                	test   %ecx,%ecx
  8007ad:	75 17                	jne    8007c6 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 10                	mov    (%eax),%edx
  8007b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b9:	8d 40 04             	lea    0x4(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c4:	eb 5c                	jmp    800822 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 10                	mov    (%eax),%edx
  8007cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007db:	eb 45                	jmp    800822 <vprintfmt+0x386>
			putch('X', putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	53                   	push   %ebx
  8007e1:	6a 58                	push   $0x58
  8007e3:	ff d6                	call   *%esi
			putch('X', putdat);
  8007e5:	83 c4 08             	add    $0x8,%esp
  8007e8:	53                   	push   %ebx
  8007e9:	6a 58                	push   $0x58
  8007eb:	ff d6                	call   *%esi
			putch('X', putdat);
  8007ed:	83 c4 08             	add    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	6a 58                	push   $0x58
  8007f3:	ff d6                	call   *%esi
			break;
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	eb 42                	jmp    80083c <vprintfmt+0x3a0>
			putch('0', putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	53                   	push   %ebx
  8007fe:	6a 30                	push   $0x30
  800800:	ff d6                	call   *%esi
			putch('x', putdat);
  800802:	83 c4 08             	add    $0x8,%esp
  800805:	53                   	push   %ebx
  800806:	6a 78                	push   $0x78
  800808:	ff d6                	call   *%esi
			num = (unsigned long long)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8b 10                	mov    (%eax),%edx
  80080f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800814:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800829:	57                   	push   %edi
  80082a:	ff 75 e0             	pushl  -0x20(%ebp)
  80082d:	50                   	push   %eax
  80082e:	51                   	push   %ecx
  80082f:	52                   	push   %edx
  800830:	89 da                	mov    %ebx,%edx
  800832:	89 f0                	mov    %esi,%eax
  800834:	e8 7a fb ff ff       	call   8003b3 <printnum>
			break;
  800839:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80083c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	83 c7 01             	add    $0x1,%edi
  800842:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800846:	83 f8 25             	cmp    $0x25,%eax
  800849:	0f 84 64 fc ff ff    	je     8004b3 <vprintfmt+0x17>
			if (ch == '\0')
  80084f:	85 c0                	test   %eax,%eax
  800851:	0f 84 8b 00 00 00    	je     8008e2 <vprintfmt+0x446>
			putch(ch, putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	53                   	push   %ebx
  80085b:	50                   	push   %eax
  80085c:	ff d6                	call   *%esi
  80085e:	83 c4 10             	add    $0x10,%esp
  800861:	eb dc                	jmp    80083f <vprintfmt+0x3a3>
	if (lflag >= 2)
  800863:	83 f9 01             	cmp    $0x1,%ecx
  800866:	7e 15                	jle    80087d <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 10                	mov    (%eax),%edx
  80086d:	8b 48 04             	mov    0x4(%eax),%ecx
  800870:	8d 40 08             	lea    0x8(%eax),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800876:	b8 10 00 00 00       	mov    $0x10,%eax
  80087b:	eb a5                	jmp    800822 <vprintfmt+0x386>
	else if (lflag)
  80087d:	85 c9                	test   %ecx,%ecx
  80087f:	75 17                	jne    800898 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8b 10                	mov    (%eax),%edx
  800886:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088b:	8d 40 04             	lea    0x4(%eax),%eax
  80088e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800891:	b8 10 00 00 00       	mov    $0x10,%eax
  800896:	eb 8a                	jmp    800822 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	8b 10                	mov    (%eax),%edx
  80089d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008a2:	8d 40 04             	lea    0x4(%eax),%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ad:	e9 70 ff ff ff       	jmp    800822 <vprintfmt+0x386>
			putch(ch, putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	6a 25                	push   $0x25
  8008b8:	ff d6                	call   *%esi
			break;
  8008ba:	83 c4 10             	add    $0x10,%esp
  8008bd:	e9 7a ff ff ff       	jmp    80083c <vprintfmt+0x3a0>
			putch('%', putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	6a 25                	push   $0x25
  8008c8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	89 f8                	mov    %edi,%eax
  8008cf:	eb 03                	jmp    8008d4 <vprintfmt+0x438>
  8008d1:	83 e8 01             	sub    $0x1,%eax
  8008d4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008d8:	75 f7                	jne    8008d1 <vprintfmt+0x435>
  8008da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008dd:	e9 5a ff ff ff       	jmp    80083c <vprintfmt+0x3a0>
}
  8008e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e5:	5b                   	pop    %ebx
  8008e6:	5e                   	pop    %esi
  8008e7:	5f                   	pop    %edi
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	83 ec 18             	sub    $0x18,%esp
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800907:	85 c0                	test   %eax,%eax
  800909:	74 26                	je     800931 <vsnprintf+0x47>
  80090b:	85 d2                	test   %edx,%edx
  80090d:	7e 22                	jle    800931 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090f:	ff 75 14             	pushl  0x14(%ebp)
  800912:	ff 75 10             	pushl  0x10(%ebp)
  800915:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800918:	50                   	push   %eax
  800919:	68 62 04 80 00       	push   $0x800462
  80091e:	e8 79 fb ff ff       	call   80049c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800926:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092c:	83 c4 10             	add    $0x10,%esp
}
  80092f:	c9                   	leave  
  800930:	c3                   	ret    
		return -E_INVAL;
  800931:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800936:	eb f7                	jmp    80092f <vsnprintf+0x45>

00800938 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800941:	50                   	push   %eax
  800942:	ff 75 10             	pushl  0x10(%ebp)
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	ff 75 08             	pushl  0x8(%ebp)
  80094b:	e8 9a ff ff ff       	call   8008ea <vsnprintf>
	va_end(ap);

	return rc;
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	57                   	push   %edi
  800956:	56                   	push   %esi
  800957:	53                   	push   %ebx
  800958:	83 ec 0c             	sub    $0xc,%esp
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80095e:	85 c0                	test   %eax,%eax
  800960:	74 13                	je     800975 <readline+0x23>
		fprintf(1, "%s", prompt);
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	50                   	push   %eax
  800966:	68 25 24 80 00       	push   $0x802425
  80096b:	6a 01                	push   $0x1
  80096d:	e8 ca 0f 00 00       	call   80193c <fprintf>
  800972:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  800975:	83 ec 0c             	sub    $0xc,%esp
  800978:	6a 00                	push   $0x0
  80097a:	e8 67 f8 ff ff       	call   8001e6 <iscons>
  80097f:	89 c7                	mov    %eax,%edi
  800981:	83 c4 10             	add    $0x10,%esp
	i = 0;
  800984:	be 00 00 00 00       	mov    $0x0,%esi
  800989:	eb 4b                	jmp    8009d6 <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  800990:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800993:	75 08                	jne    80099d <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  800995:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5f                   	pop    %edi
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    
				cprintf("read error: %e\n", c);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	53                   	push   %ebx
  8009a1:	68 3f 23 80 00       	push   $0x80233f
  8009a6:	e8 f4 f9 ff ff       	call   80039f <cprintf>
  8009ab:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8009ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b3:	eb e0                	jmp    800995 <readline+0x43>
			if (echoing)
  8009b5:	85 ff                	test   %edi,%edi
  8009b7:	75 05                	jne    8009be <readline+0x6c>
			i--;
  8009b9:	83 ee 01             	sub    $0x1,%esi
  8009bc:	eb 18                	jmp    8009d6 <readline+0x84>
				cputchar('\b');
  8009be:	83 ec 0c             	sub    $0xc,%esp
  8009c1:	6a 08                	push   $0x8
  8009c3:	e8 d7 f7 ff ff       	call   80019f <cputchar>
  8009c8:	83 c4 10             	add    $0x10,%esp
  8009cb:	eb ec                	jmp    8009b9 <readline+0x67>
			buf[i++] = c;
  8009cd:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  8009d3:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8009d6:	e8 e0 f7 ff ff       	call   8001bb <getchar>
  8009db:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8009dd:	85 c0                	test   %eax,%eax
  8009df:	78 aa                	js     80098b <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8009e1:	83 f8 08             	cmp    $0x8,%eax
  8009e4:	0f 94 c2             	sete   %dl
  8009e7:	83 f8 7f             	cmp    $0x7f,%eax
  8009ea:	0f 94 c0             	sete   %al
  8009ed:	08 c2                	or     %al,%dl
  8009ef:	74 04                	je     8009f5 <readline+0xa3>
  8009f1:	85 f6                	test   %esi,%esi
  8009f3:	7f c0                	jg     8009b5 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009f5:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f8:	7e 1a                	jle    800a14 <readline+0xc2>
  8009fa:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800a00:	7f 12                	jg     800a14 <readline+0xc2>
			if (echoing)
  800a02:	85 ff                	test   %edi,%edi
  800a04:	74 c7                	je     8009cd <readline+0x7b>
				cputchar(c);
  800a06:	83 ec 0c             	sub    $0xc,%esp
  800a09:	53                   	push   %ebx
  800a0a:	e8 90 f7 ff ff       	call   80019f <cputchar>
  800a0f:	83 c4 10             	add    $0x10,%esp
  800a12:	eb b9                	jmp    8009cd <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800a14:	83 fb 0a             	cmp    $0xa,%ebx
  800a17:	74 05                	je     800a1e <readline+0xcc>
  800a19:	83 fb 0d             	cmp    $0xd,%ebx
  800a1c:	75 b8                	jne    8009d6 <readline+0x84>
			if (echoing)
  800a1e:	85 ff                	test   %edi,%edi
  800a20:	75 11                	jne    800a33 <readline+0xe1>
			buf[i] = 0;
  800a22:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800a29:	b8 00 40 80 00       	mov    $0x804000,%eax
  800a2e:	e9 62 ff ff ff       	jmp    800995 <readline+0x43>
				cputchar('\n');
  800a33:	83 ec 0c             	sub    $0xc,%esp
  800a36:	6a 0a                	push   $0xa
  800a38:	e8 62 f7 ff ff       	call   80019f <cputchar>
  800a3d:	83 c4 10             	add    $0x10,%esp
  800a40:	eb e0                	jmp    800a22 <readline+0xd0>

00800a42 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4d:	eb 03                	jmp    800a52 <strlen+0x10>
		n++;
  800a4f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a52:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a56:	75 f7                	jne    800a4f <strlen+0xd>
	return n;
}
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a63:	b8 00 00 00 00       	mov    $0x0,%eax
  800a68:	eb 03                	jmp    800a6d <strnlen+0x13>
		n++;
  800a6a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a6d:	39 d0                	cmp    %edx,%eax
  800a6f:	74 06                	je     800a77 <strnlen+0x1d>
  800a71:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a75:	75 f3                	jne    800a6a <strnlen+0x10>
	return n;
}
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	53                   	push   %ebx
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a83:	89 c2                	mov    %eax,%edx
  800a85:	83 c1 01             	add    $0x1,%ecx
  800a88:	83 c2 01             	add    $0x1,%edx
  800a8b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a8f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a92:	84 db                	test   %bl,%bl
  800a94:	75 ef                	jne    800a85 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a96:	5b                   	pop    %ebx
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	53                   	push   %ebx
  800a9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800aa0:	53                   	push   %ebx
  800aa1:	e8 9c ff ff ff       	call   800a42 <strlen>
  800aa6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	01 d8                	add    %ebx,%eax
  800aae:	50                   	push   %eax
  800aaf:	e8 c5 ff ff ff       	call   800a79 <strcpy>
	return dst;
}
  800ab4:	89 d8                	mov    %ebx,%eax
  800ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	56                   	push   %esi
  800abf:	53                   	push   %ebx
  800ac0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac6:	89 f3                	mov    %esi,%ebx
  800ac8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800acb:	89 f2                	mov    %esi,%edx
  800acd:	eb 0f                	jmp    800ade <strncpy+0x23>
		*dst++ = *src;
  800acf:	83 c2 01             	add    $0x1,%edx
  800ad2:	0f b6 01             	movzbl (%ecx),%eax
  800ad5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ad8:	80 39 01             	cmpb   $0x1,(%ecx)
  800adb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ade:	39 da                	cmp    %ebx,%edx
  800ae0:	75 ed                	jne    800acf <strncpy+0x14>
	}
	return ret;
}
  800ae2:	89 f0                	mov    %esi,%eax
  800ae4:	5b                   	pop    %ebx
  800ae5:	5e                   	pop    %esi
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
  800aed:	8b 75 08             	mov    0x8(%ebp),%esi
  800af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800af6:	89 f0                	mov    %esi,%eax
  800af8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800afc:	85 c9                	test   %ecx,%ecx
  800afe:	75 0b                	jne    800b0b <strlcpy+0x23>
  800b00:	eb 17                	jmp    800b19 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b02:	83 c2 01             	add    $0x1,%edx
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b0b:	39 d8                	cmp    %ebx,%eax
  800b0d:	74 07                	je     800b16 <strlcpy+0x2e>
  800b0f:	0f b6 0a             	movzbl (%edx),%ecx
  800b12:	84 c9                	test   %cl,%cl
  800b14:	75 ec                	jne    800b02 <strlcpy+0x1a>
		*dst = '\0';
  800b16:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b19:	29 f0                	sub    %esi,%eax
}
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b25:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b28:	eb 06                	jmp    800b30 <strcmp+0x11>
		p++, q++;
  800b2a:	83 c1 01             	add    $0x1,%ecx
  800b2d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b30:	0f b6 01             	movzbl (%ecx),%eax
  800b33:	84 c0                	test   %al,%al
  800b35:	74 04                	je     800b3b <strcmp+0x1c>
  800b37:	3a 02                	cmp    (%edx),%al
  800b39:	74 ef                	je     800b2a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3b:	0f b6 c0             	movzbl %al,%eax
  800b3e:	0f b6 12             	movzbl (%edx),%edx
  800b41:	29 d0                	sub    %edx,%eax
}
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	53                   	push   %ebx
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4f:	89 c3                	mov    %eax,%ebx
  800b51:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b54:	eb 06                	jmp    800b5c <strncmp+0x17>
		n--, p++, q++;
  800b56:	83 c0 01             	add    $0x1,%eax
  800b59:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b5c:	39 d8                	cmp    %ebx,%eax
  800b5e:	74 16                	je     800b76 <strncmp+0x31>
  800b60:	0f b6 08             	movzbl (%eax),%ecx
  800b63:	84 c9                	test   %cl,%cl
  800b65:	74 04                	je     800b6b <strncmp+0x26>
  800b67:	3a 0a                	cmp    (%edx),%cl
  800b69:	74 eb                	je     800b56 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6b:	0f b6 00             	movzbl (%eax),%eax
  800b6e:	0f b6 12             	movzbl (%edx),%edx
  800b71:	29 d0                	sub    %edx,%eax
}
  800b73:	5b                   	pop    %ebx
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    
		return 0;
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7b:	eb f6                	jmp    800b73 <strncmp+0x2e>

00800b7d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b87:	0f b6 10             	movzbl (%eax),%edx
  800b8a:	84 d2                	test   %dl,%dl
  800b8c:	74 09                	je     800b97 <strchr+0x1a>
		if (*s == c)
  800b8e:	38 ca                	cmp    %cl,%dl
  800b90:	74 0a                	je     800b9c <strchr+0x1f>
	for (; *s; s++)
  800b92:	83 c0 01             	add    $0x1,%eax
  800b95:	eb f0                	jmp    800b87 <strchr+0xa>
			return (char *) s;
	return 0;
  800b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba8:	eb 03                	jmp    800bad <strfind+0xf>
  800baa:	83 c0 01             	add    $0x1,%eax
  800bad:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bb0:	38 ca                	cmp    %cl,%dl
  800bb2:	74 04                	je     800bb8 <strfind+0x1a>
  800bb4:	84 d2                	test   %dl,%dl
  800bb6:	75 f2                	jne    800baa <strfind+0xc>
			break;
	return (char *) s;
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	53                   	push   %ebx
  800bc0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bc6:	85 c9                	test   %ecx,%ecx
  800bc8:	74 13                	je     800bdd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bca:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bd0:	75 05                	jne    800bd7 <memset+0x1d>
  800bd2:	f6 c1 03             	test   $0x3,%cl
  800bd5:	74 0d                	je     800be4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	fc                   	cld    
  800bdb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bdd:	89 f8                	mov    %edi,%eax
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    
		c &= 0xFF;
  800be4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800be8:	89 d3                	mov    %edx,%ebx
  800bea:	c1 e3 08             	shl    $0x8,%ebx
  800bed:	89 d0                	mov    %edx,%eax
  800bef:	c1 e0 18             	shl    $0x18,%eax
  800bf2:	89 d6                	mov    %edx,%esi
  800bf4:	c1 e6 10             	shl    $0x10,%esi
  800bf7:	09 f0                	or     %esi,%eax
  800bf9:	09 c2                	or     %eax,%edx
  800bfb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bfd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c00:	89 d0                	mov    %edx,%eax
  800c02:	fc                   	cld    
  800c03:	f3 ab                	rep stos %eax,%es:(%edi)
  800c05:	eb d6                	jmp    800bdd <memset+0x23>

00800c07 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c12:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c15:	39 c6                	cmp    %eax,%esi
  800c17:	73 35                	jae    800c4e <memmove+0x47>
  800c19:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c1c:	39 c2                	cmp    %eax,%edx
  800c1e:	76 2e                	jbe    800c4e <memmove+0x47>
		s += n;
		d += n;
  800c20:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c23:	89 d6                	mov    %edx,%esi
  800c25:	09 fe                	or     %edi,%esi
  800c27:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c2d:	74 0c                	je     800c3b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c2f:	83 ef 01             	sub    $0x1,%edi
  800c32:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c35:	fd                   	std    
  800c36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c38:	fc                   	cld    
  800c39:	eb 21                	jmp    800c5c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c3b:	f6 c1 03             	test   $0x3,%cl
  800c3e:	75 ef                	jne    800c2f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c40:	83 ef 04             	sub    $0x4,%edi
  800c43:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c46:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c49:	fd                   	std    
  800c4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c4c:	eb ea                	jmp    800c38 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c4e:	89 f2                	mov    %esi,%edx
  800c50:	09 c2                	or     %eax,%edx
  800c52:	f6 c2 03             	test   $0x3,%dl
  800c55:	74 09                	je     800c60 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c57:	89 c7                	mov    %eax,%edi
  800c59:	fc                   	cld    
  800c5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c60:	f6 c1 03             	test   $0x3,%cl
  800c63:	75 f2                	jne    800c57 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c65:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c68:	89 c7                	mov    %eax,%edi
  800c6a:	fc                   	cld    
  800c6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6d:	eb ed                	jmp    800c5c <memmove+0x55>

00800c6f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c72:	ff 75 10             	pushl  0x10(%ebp)
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	ff 75 08             	pushl  0x8(%ebp)
  800c7b:	e8 87 ff ff ff       	call   800c07 <memmove>
}
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8d:	89 c6                	mov    %eax,%esi
  800c8f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c92:	39 f0                	cmp    %esi,%eax
  800c94:	74 1c                	je     800cb2 <memcmp+0x30>
		if (*s1 != *s2)
  800c96:	0f b6 08             	movzbl (%eax),%ecx
  800c99:	0f b6 1a             	movzbl (%edx),%ebx
  800c9c:	38 d9                	cmp    %bl,%cl
  800c9e:	75 08                	jne    800ca8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ca0:	83 c0 01             	add    $0x1,%eax
  800ca3:	83 c2 01             	add    $0x1,%edx
  800ca6:	eb ea                	jmp    800c92 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ca8:	0f b6 c1             	movzbl %cl,%eax
  800cab:	0f b6 db             	movzbl %bl,%ebx
  800cae:	29 d8                	sub    %ebx,%eax
  800cb0:	eb 05                	jmp    800cb7 <memcmp+0x35>
	}

	return 0;
  800cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cc4:	89 c2                	mov    %eax,%edx
  800cc6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cc9:	39 d0                	cmp    %edx,%eax
  800ccb:	73 09                	jae    800cd6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ccd:	38 08                	cmp    %cl,(%eax)
  800ccf:	74 05                	je     800cd6 <memfind+0x1b>
	for (; s < ends; s++)
  800cd1:	83 c0 01             	add    $0x1,%eax
  800cd4:	eb f3                	jmp    800cc9 <memfind+0xe>
			break;
	return (void *) s;
}
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
  800cde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce4:	eb 03                	jmp    800ce9 <strtol+0x11>
		s++;
  800ce6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ce9:	0f b6 01             	movzbl (%ecx),%eax
  800cec:	3c 20                	cmp    $0x20,%al
  800cee:	74 f6                	je     800ce6 <strtol+0xe>
  800cf0:	3c 09                	cmp    $0x9,%al
  800cf2:	74 f2                	je     800ce6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cf4:	3c 2b                	cmp    $0x2b,%al
  800cf6:	74 2e                	je     800d26 <strtol+0x4e>
	int neg = 0;
  800cf8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cfd:	3c 2d                	cmp    $0x2d,%al
  800cff:	74 2f                	je     800d30 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d01:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d07:	75 05                	jne    800d0e <strtol+0x36>
  800d09:	80 39 30             	cmpb   $0x30,(%ecx)
  800d0c:	74 2c                	je     800d3a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d0e:	85 db                	test   %ebx,%ebx
  800d10:	75 0a                	jne    800d1c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d12:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d17:	80 39 30             	cmpb   $0x30,(%ecx)
  800d1a:	74 28                	je     800d44 <strtol+0x6c>
		base = 10;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d24:	eb 50                	jmp    800d76 <strtol+0x9e>
		s++;
  800d26:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d29:	bf 00 00 00 00       	mov    $0x0,%edi
  800d2e:	eb d1                	jmp    800d01 <strtol+0x29>
		s++, neg = 1;
  800d30:	83 c1 01             	add    $0x1,%ecx
  800d33:	bf 01 00 00 00       	mov    $0x1,%edi
  800d38:	eb c7                	jmp    800d01 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d3a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d3e:	74 0e                	je     800d4e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d40:	85 db                	test   %ebx,%ebx
  800d42:	75 d8                	jne    800d1c <strtol+0x44>
		s++, base = 8;
  800d44:	83 c1 01             	add    $0x1,%ecx
  800d47:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d4c:	eb ce                	jmp    800d1c <strtol+0x44>
		s += 2, base = 16;
  800d4e:	83 c1 02             	add    $0x2,%ecx
  800d51:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d56:	eb c4                	jmp    800d1c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d58:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d5b:	89 f3                	mov    %esi,%ebx
  800d5d:	80 fb 19             	cmp    $0x19,%bl
  800d60:	77 29                	ja     800d8b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d62:	0f be d2             	movsbl %dl,%edx
  800d65:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d68:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d6b:	7d 30                	jge    800d9d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d6d:	83 c1 01             	add    $0x1,%ecx
  800d70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d74:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d76:	0f b6 11             	movzbl (%ecx),%edx
  800d79:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d7c:	89 f3                	mov    %esi,%ebx
  800d7e:	80 fb 09             	cmp    $0x9,%bl
  800d81:	77 d5                	ja     800d58 <strtol+0x80>
			dig = *s - '0';
  800d83:	0f be d2             	movsbl %dl,%edx
  800d86:	83 ea 30             	sub    $0x30,%edx
  800d89:	eb dd                	jmp    800d68 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d8b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d8e:	89 f3                	mov    %esi,%ebx
  800d90:	80 fb 19             	cmp    $0x19,%bl
  800d93:	77 08                	ja     800d9d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d95:	0f be d2             	movsbl %dl,%edx
  800d98:	83 ea 37             	sub    $0x37,%edx
  800d9b:	eb cb                	jmp    800d68 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da1:	74 05                	je     800da8 <strtol+0xd0>
		*endptr = (char *) s;
  800da3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800da6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800da8:	89 c2                	mov    %eax,%edx
  800daa:	f7 da                	neg    %edx
  800dac:	85 ff                	test   %edi,%edi
  800dae:	0f 45 c2             	cmovne %edx,%eax
}
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	89 c3                	mov    %eax,%ebx
  800dc9:	89 c7                	mov    %eax,%edi
  800dcb:	89 c6                	mov    %eax,%esi
  800dcd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dda:	ba 00 00 00 00       	mov    $0x0,%edx
  800ddf:	b8 01 00 00 00       	mov    $0x1,%eax
  800de4:	89 d1                	mov    %edx,%ecx
  800de6:	89 d3                	mov    %edx,%ebx
  800de8:	89 d7                	mov    %edx,%edi
  800dea:	89 d6                	mov    %edx,%esi
  800dec:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	b8 03 00 00 00       	mov    $0x3,%eax
  800e09:	89 cb                	mov    %ecx,%ebx
  800e0b:	89 cf                	mov    %ecx,%edi
  800e0d:	89 ce                	mov    %ecx,%esi
  800e0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7f 08                	jg     800e1d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	50                   	push   %eax
  800e21:	6a 03                	push   $0x3
  800e23:	68 4f 23 80 00       	push   $0x80234f
  800e28:	6a 23                	push   $0x23
  800e2a:	68 6c 23 80 00       	push   $0x80236c
  800e2f:	e8 90 f4 ff ff       	call   8002c4 <_panic>

00800e34 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3f:	b8 02 00 00 00       	mov    $0x2,%eax
  800e44:	89 d1                	mov    %edx,%ecx
  800e46:	89 d3                	mov    %edx,%ebx
  800e48:	89 d7                	mov    %edx,%edi
  800e4a:	89 d6                	mov    %edx,%esi
  800e4c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_yield>:

void
sys_yield(void)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e59:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e63:	89 d1                	mov    %edx,%ecx
  800e65:	89 d3                	mov    %edx,%ebx
  800e67:	89 d7                	mov    %edx,%edi
  800e69:	89 d6                	mov    %edx,%esi
  800e6b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    

00800e72 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	57                   	push   %edi
  800e76:	56                   	push   %esi
  800e77:	53                   	push   %ebx
  800e78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7b:	be 00 00 00 00       	mov    $0x0,%esi
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	b8 04 00 00 00       	mov    $0x4,%eax
  800e8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8e:	89 f7                	mov    %esi,%edi
  800e90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7f 08                	jg     800e9e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	50                   	push   %eax
  800ea2:	6a 04                	push   $0x4
  800ea4:	68 4f 23 80 00       	push   $0x80234f
  800ea9:	6a 23                	push   $0x23
  800eab:	68 6c 23 80 00       	push   $0x80236c
  800eb0:	e8 0f f4 ff ff       	call   8002c4 <_panic>

00800eb5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
  800ebb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec4:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ecf:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	7f 08                	jg     800ee0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edb:	5b                   	pop    %ebx
  800edc:	5e                   	pop    %esi
  800edd:	5f                   	pop    %edi
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	83 ec 0c             	sub    $0xc,%esp
  800ee3:	50                   	push   %eax
  800ee4:	6a 05                	push   $0x5
  800ee6:	68 4f 23 80 00       	push   $0x80234f
  800eeb:	6a 23                	push   $0x23
  800eed:	68 6c 23 80 00       	push   $0x80236c
  800ef2:	e8 cd f3 ff ff       	call   8002c4 <_panic>

00800ef7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	57                   	push   %edi
  800efb:	56                   	push   %esi
  800efc:	53                   	push   %ebx
  800efd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0b:	b8 06 00 00 00       	mov    $0x6,%eax
  800f10:	89 df                	mov    %ebx,%edi
  800f12:	89 de                	mov    %ebx,%esi
  800f14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f16:	85 c0                	test   %eax,%eax
  800f18:	7f 08                	jg     800f22 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f22:	83 ec 0c             	sub    $0xc,%esp
  800f25:	50                   	push   %eax
  800f26:	6a 06                	push   $0x6
  800f28:	68 4f 23 80 00       	push   $0x80234f
  800f2d:	6a 23                	push   $0x23
  800f2f:	68 6c 23 80 00       	push   $0x80236c
  800f34:	e8 8b f3 ff ff       	call   8002c4 <_panic>

00800f39 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
  800f3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4d:	b8 08 00 00 00       	mov    $0x8,%eax
  800f52:	89 df                	mov    %ebx,%edi
  800f54:	89 de                	mov    %ebx,%esi
  800f56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	7f 08                	jg     800f64 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5f:	5b                   	pop    %ebx
  800f60:	5e                   	pop    %esi
  800f61:	5f                   	pop    %edi
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f64:	83 ec 0c             	sub    $0xc,%esp
  800f67:	50                   	push   %eax
  800f68:	6a 08                	push   $0x8
  800f6a:	68 4f 23 80 00       	push   $0x80234f
  800f6f:	6a 23                	push   $0x23
  800f71:	68 6c 23 80 00       	push   $0x80236c
  800f76:	e8 49 f3 ff ff       	call   8002c4 <_panic>

00800f7b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	57                   	push   %edi
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
  800f81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	b8 09 00 00 00       	mov    $0x9,%eax
  800f94:	89 df                	mov    %ebx,%edi
  800f96:	89 de                	mov    %ebx,%esi
  800f98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	7f 08                	jg     800fa6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa6:	83 ec 0c             	sub    $0xc,%esp
  800fa9:	50                   	push   %eax
  800faa:	6a 09                	push   $0x9
  800fac:	68 4f 23 80 00       	push   $0x80234f
  800fb1:	6a 23                	push   $0x23
  800fb3:	68 6c 23 80 00       	push   $0x80236c
  800fb8:	e8 07 f3 ff ff       	call   8002c4 <_panic>

00800fbd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
  800fc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7f 08                	jg     800fe8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe3:	5b                   	pop    %ebx
  800fe4:	5e                   	pop    %esi
  800fe5:	5f                   	pop    %edi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	50                   	push   %eax
  800fec:	6a 0a                	push   $0xa
  800fee:	68 4f 23 80 00       	push   $0x80234f
  800ff3:	6a 23                	push   $0x23
  800ff5:	68 6c 23 80 00       	push   $0x80236c
  800ffa:	e8 c5 f2 ff ff       	call   8002c4 <_panic>

00800fff <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
	asm volatile("int %1\n"
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100b:	b8 0c 00 00 00       	mov    $0xc,%eax
  801010:	be 00 00 00 00       	mov    $0x0,%esi
  801015:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801018:	8b 7d 14             	mov    0x14(%ebp),%edi
  80101b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	57                   	push   %edi
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
  801028:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	b8 0d 00 00 00       	mov    $0xd,%eax
  801038:	89 cb                	mov    %ecx,%ebx
  80103a:	89 cf                	mov    %ecx,%edi
  80103c:	89 ce                	mov    %ecx,%esi
  80103e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801040:	85 c0                	test   %eax,%eax
  801042:	7f 08                	jg     80104c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801044:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104c:	83 ec 0c             	sub    $0xc,%esp
  80104f:	50                   	push   %eax
  801050:	6a 0d                	push   $0xd
  801052:	68 4f 23 80 00       	push   $0x80234f
  801057:	6a 23                	push   $0x23
  801059:	68 6c 23 80 00       	push   $0x80236c
  80105e:	e8 61 f2 ff ff       	call   8002c4 <_panic>

00801063 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	05 00 00 00 30       	add    $0x30000000,%eax
  80106e:	c1 e8 0c             	shr    $0xc,%eax
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80107e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801083:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    

0080108a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801090:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801095:	89 c2                	mov    %eax,%edx
  801097:	c1 ea 16             	shr    $0x16,%edx
  80109a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010a1:	f6 c2 01             	test   $0x1,%dl
  8010a4:	74 2a                	je     8010d0 <fd_alloc+0x46>
  8010a6:	89 c2                	mov    %eax,%edx
  8010a8:	c1 ea 0c             	shr    $0xc,%edx
  8010ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b2:	f6 c2 01             	test   $0x1,%dl
  8010b5:	74 19                	je     8010d0 <fd_alloc+0x46>
  8010b7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010bc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010c1:	75 d2                	jne    801095 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010c3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010c9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010ce:	eb 07                	jmp    8010d7 <fd_alloc+0x4d>
			*fd_store = fd;
  8010d0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010df:	83 f8 1f             	cmp    $0x1f,%eax
  8010e2:	77 36                	ja     80111a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010e4:	c1 e0 0c             	shl    $0xc,%eax
  8010e7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	c1 ea 16             	shr    $0x16,%edx
  8010f1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010f8:	f6 c2 01             	test   $0x1,%dl
  8010fb:	74 24                	je     801121 <fd_lookup+0x48>
  8010fd:	89 c2                	mov    %eax,%edx
  8010ff:	c1 ea 0c             	shr    $0xc,%edx
  801102:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801109:	f6 c2 01             	test   $0x1,%dl
  80110c:	74 1a                	je     801128 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80110e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801111:	89 02                	mov    %eax,(%edx)
	return 0;
  801113:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    
		return -E_INVAL;
  80111a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111f:	eb f7                	jmp    801118 <fd_lookup+0x3f>
		return -E_INVAL;
  801121:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801126:	eb f0                	jmp    801118 <fd_lookup+0x3f>
  801128:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112d:	eb e9                	jmp    801118 <fd_lookup+0x3f>

0080112f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 08             	sub    $0x8,%esp
  801135:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801138:	ba fc 23 80 00       	mov    $0x8023fc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80113d:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801142:	39 08                	cmp    %ecx,(%eax)
  801144:	74 33                	je     801179 <dev_lookup+0x4a>
  801146:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801149:	8b 02                	mov    (%edx),%eax
  80114b:	85 c0                	test   %eax,%eax
  80114d:	75 f3                	jne    801142 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80114f:	a1 04 44 80 00       	mov    0x804404,%eax
  801154:	8b 40 48             	mov    0x48(%eax),%eax
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	51                   	push   %ecx
  80115b:	50                   	push   %eax
  80115c:	68 7c 23 80 00       	push   $0x80237c
  801161:	e8 39 f2 ff ff       	call   80039f <cprintf>
	*dev = 0;
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80116f:	83 c4 10             	add    $0x10,%esp
  801172:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    
			*dev = devtab[i];
  801179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80117e:	b8 00 00 00 00       	mov    $0x0,%eax
  801183:	eb f2                	jmp    801177 <dev_lookup+0x48>

00801185 <fd_close>:
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	57                   	push   %edi
  801189:	56                   	push   %esi
  80118a:	53                   	push   %ebx
  80118b:	83 ec 1c             	sub    $0x1c,%esp
  80118e:	8b 75 08             	mov    0x8(%ebp),%esi
  801191:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801194:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801197:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801198:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80119e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a1:	50                   	push   %eax
  8011a2:	e8 32 ff ff ff       	call   8010d9 <fd_lookup>
  8011a7:	89 c3                	mov    %eax,%ebx
  8011a9:	83 c4 08             	add    $0x8,%esp
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 05                	js     8011b5 <fd_close+0x30>
	    || fd != fd2)
  8011b0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011b3:	74 16                	je     8011cb <fd_close+0x46>
		return (must_exist ? r : 0);
  8011b5:	89 f8                	mov    %edi,%eax
  8011b7:	84 c0                	test   %al,%al
  8011b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011be:	0f 44 d8             	cmove  %eax,%ebx
}
  8011c1:	89 d8                	mov    %ebx,%eax
  8011c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c6:	5b                   	pop    %ebx
  8011c7:	5e                   	pop    %esi
  8011c8:	5f                   	pop    %edi
  8011c9:	5d                   	pop    %ebp
  8011ca:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011cb:	83 ec 08             	sub    $0x8,%esp
  8011ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011d1:	50                   	push   %eax
  8011d2:	ff 36                	pushl  (%esi)
  8011d4:	e8 56 ff ff ff       	call   80112f <dev_lookup>
  8011d9:	89 c3                	mov    %eax,%ebx
  8011db:	83 c4 10             	add    $0x10,%esp
  8011de:	85 c0                	test   %eax,%eax
  8011e0:	78 15                	js     8011f7 <fd_close+0x72>
		if (dev->dev_close)
  8011e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e5:	8b 40 10             	mov    0x10(%eax),%eax
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	74 1b                	je     801207 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8011ec:	83 ec 0c             	sub    $0xc,%esp
  8011ef:	56                   	push   %esi
  8011f0:	ff d0                	call   *%eax
  8011f2:	89 c3                	mov    %eax,%ebx
  8011f4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011f7:	83 ec 08             	sub    $0x8,%esp
  8011fa:	56                   	push   %esi
  8011fb:	6a 00                	push   $0x0
  8011fd:	e8 f5 fc ff ff       	call   800ef7 <sys_page_unmap>
	return r;
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	eb ba                	jmp    8011c1 <fd_close+0x3c>
			r = 0;
  801207:	bb 00 00 00 00       	mov    $0x0,%ebx
  80120c:	eb e9                	jmp    8011f7 <fd_close+0x72>

0080120e <close>:

int
close(int fdnum)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801214:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801217:	50                   	push   %eax
  801218:	ff 75 08             	pushl  0x8(%ebp)
  80121b:	e8 b9 fe ff ff       	call   8010d9 <fd_lookup>
  801220:	83 c4 08             	add    $0x8,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	78 10                	js     801237 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	6a 01                	push   $0x1
  80122c:	ff 75 f4             	pushl  -0xc(%ebp)
  80122f:	e8 51 ff ff ff       	call   801185 <fd_close>
  801234:	83 c4 10             	add    $0x10,%esp
}
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <close_all>:

void
close_all(void)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	53                   	push   %ebx
  80123d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801240:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801245:	83 ec 0c             	sub    $0xc,%esp
  801248:	53                   	push   %ebx
  801249:	e8 c0 ff ff ff       	call   80120e <close>
	for (i = 0; i < MAXFD; i++)
  80124e:	83 c3 01             	add    $0x1,%ebx
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	83 fb 20             	cmp    $0x20,%ebx
  801257:	75 ec                	jne    801245 <close_all+0xc>
}
  801259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	57                   	push   %edi
  801262:	56                   	push   %esi
  801263:	53                   	push   %ebx
  801264:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801267:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80126a:	50                   	push   %eax
  80126b:	ff 75 08             	pushl  0x8(%ebp)
  80126e:	e8 66 fe ff ff       	call   8010d9 <fd_lookup>
  801273:	89 c3                	mov    %eax,%ebx
  801275:	83 c4 08             	add    $0x8,%esp
  801278:	85 c0                	test   %eax,%eax
  80127a:	0f 88 81 00 00 00    	js     801301 <dup+0xa3>
		return r;
	close(newfdnum);
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	ff 75 0c             	pushl  0xc(%ebp)
  801286:	e8 83 ff ff ff       	call   80120e <close>

	newfd = INDEX2FD(newfdnum);
  80128b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80128e:	c1 e6 0c             	shl    $0xc,%esi
  801291:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801297:	83 c4 04             	add    $0x4,%esp
  80129a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129d:	e8 d1 fd ff ff       	call   801073 <fd2data>
  8012a2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012a4:	89 34 24             	mov    %esi,(%esp)
  8012a7:	e8 c7 fd ff ff       	call   801073 <fd2data>
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	c1 e8 16             	shr    $0x16,%eax
  8012b6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012bd:	a8 01                	test   $0x1,%al
  8012bf:	74 11                	je     8012d2 <dup+0x74>
  8012c1:	89 d8                	mov    %ebx,%eax
  8012c3:	c1 e8 0c             	shr    $0xc,%eax
  8012c6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012cd:	f6 c2 01             	test   $0x1,%dl
  8012d0:	75 39                	jne    80130b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012d5:	89 d0                	mov    %edx,%eax
  8012d7:	c1 e8 0c             	shr    $0xc,%eax
  8012da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e1:	83 ec 0c             	sub    $0xc,%esp
  8012e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e9:	50                   	push   %eax
  8012ea:	56                   	push   %esi
  8012eb:	6a 00                	push   $0x0
  8012ed:	52                   	push   %edx
  8012ee:	6a 00                	push   $0x0
  8012f0:	e8 c0 fb ff ff       	call   800eb5 <sys_page_map>
  8012f5:	89 c3                	mov    %eax,%ebx
  8012f7:	83 c4 20             	add    $0x20,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 31                	js     80132f <dup+0xd1>
		goto err;

	return newfdnum;
  8012fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801301:	89 d8                	mov    %ebx,%eax
  801303:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801306:	5b                   	pop    %ebx
  801307:	5e                   	pop    %esi
  801308:	5f                   	pop    %edi
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80130b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	25 07 0e 00 00       	and    $0xe07,%eax
  80131a:	50                   	push   %eax
  80131b:	57                   	push   %edi
  80131c:	6a 00                	push   $0x0
  80131e:	53                   	push   %ebx
  80131f:	6a 00                	push   $0x0
  801321:	e8 8f fb ff ff       	call   800eb5 <sys_page_map>
  801326:	89 c3                	mov    %eax,%ebx
  801328:	83 c4 20             	add    $0x20,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	79 a3                	jns    8012d2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	56                   	push   %esi
  801333:	6a 00                	push   $0x0
  801335:	e8 bd fb ff ff       	call   800ef7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80133a:	83 c4 08             	add    $0x8,%esp
  80133d:	57                   	push   %edi
  80133e:	6a 00                	push   $0x0
  801340:	e8 b2 fb ff ff       	call   800ef7 <sys_page_unmap>
	return r;
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	eb b7                	jmp    801301 <dup+0xa3>

0080134a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	83 ec 14             	sub    $0x14,%esp
  801351:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801354:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801357:	50                   	push   %eax
  801358:	53                   	push   %ebx
  801359:	e8 7b fd ff ff       	call   8010d9 <fd_lookup>
  80135e:	83 c4 08             	add    $0x8,%esp
  801361:	85 c0                	test   %eax,%eax
  801363:	78 3f                	js     8013a4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136b:	50                   	push   %eax
  80136c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136f:	ff 30                	pushl  (%eax)
  801371:	e8 b9 fd ff ff       	call   80112f <dev_lookup>
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	78 27                	js     8013a4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80137d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801380:	8b 42 08             	mov    0x8(%edx),%eax
  801383:	83 e0 03             	and    $0x3,%eax
  801386:	83 f8 01             	cmp    $0x1,%eax
  801389:	74 1e                	je     8013a9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80138b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138e:	8b 40 08             	mov    0x8(%eax),%eax
  801391:	85 c0                	test   %eax,%eax
  801393:	74 35                	je     8013ca <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801395:	83 ec 04             	sub    $0x4,%esp
  801398:	ff 75 10             	pushl  0x10(%ebp)
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	52                   	push   %edx
  80139f:	ff d0                	call   *%eax
  8013a1:	83 c4 10             	add    $0x10,%esp
}
  8013a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013a9:	a1 04 44 80 00       	mov    0x804404,%eax
  8013ae:	8b 40 48             	mov    0x48(%eax),%eax
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	53                   	push   %ebx
  8013b5:	50                   	push   %eax
  8013b6:	68 c0 23 80 00       	push   $0x8023c0
  8013bb:	e8 df ef ff ff       	call   80039f <cprintf>
		return -E_INVAL;
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c8:	eb da                	jmp    8013a4 <read+0x5a>
		return -E_NOT_SUPP;
  8013ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013cf:	eb d3                	jmp    8013a4 <read+0x5a>

008013d1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	57                   	push   %edi
  8013d5:	56                   	push   %esi
  8013d6:	53                   	push   %ebx
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013dd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e5:	39 f3                	cmp    %esi,%ebx
  8013e7:	73 25                	jae    80140e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	89 f0                	mov    %esi,%eax
  8013ee:	29 d8                	sub    %ebx,%eax
  8013f0:	50                   	push   %eax
  8013f1:	89 d8                	mov    %ebx,%eax
  8013f3:	03 45 0c             	add    0xc(%ebp),%eax
  8013f6:	50                   	push   %eax
  8013f7:	57                   	push   %edi
  8013f8:	e8 4d ff ff ff       	call   80134a <read>
		if (m < 0)
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	78 08                	js     80140c <readn+0x3b>
			return m;
		if (m == 0)
  801404:	85 c0                	test   %eax,%eax
  801406:	74 06                	je     80140e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801408:	01 c3                	add    %eax,%ebx
  80140a:	eb d9                	jmp    8013e5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80140c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80140e:	89 d8                	mov    %ebx,%eax
  801410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801413:	5b                   	pop    %ebx
  801414:	5e                   	pop    %esi
  801415:	5f                   	pop    %edi
  801416:	5d                   	pop    %ebp
  801417:	c3                   	ret    

00801418 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	53                   	push   %ebx
  80141c:	83 ec 14             	sub    $0x14,%esp
  80141f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801422:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	53                   	push   %ebx
  801427:	e8 ad fc ff ff       	call   8010d9 <fd_lookup>
  80142c:	83 c4 08             	add    $0x8,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 3a                	js     80146d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801439:	50                   	push   %eax
  80143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143d:	ff 30                	pushl  (%eax)
  80143f:	e8 eb fc ff ff       	call   80112f <dev_lookup>
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	78 22                	js     80146d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801452:	74 1e                	je     801472 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801457:	8b 52 0c             	mov    0xc(%edx),%edx
  80145a:	85 d2                	test   %edx,%edx
  80145c:	74 35                	je     801493 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	ff 75 10             	pushl  0x10(%ebp)
  801464:	ff 75 0c             	pushl  0xc(%ebp)
  801467:	50                   	push   %eax
  801468:	ff d2                	call   *%edx
  80146a:	83 c4 10             	add    $0x10,%esp
}
  80146d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801470:	c9                   	leave  
  801471:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801472:	a1 04 44 80 00       	mov    0x804404,%eax
  801477:	8b 40 48             	mov    0x48(%eax),%eax
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	53                   	push   %ebx
  80147e:	50                   	push   %eax
  80147f:	68 dc 23 80 00       	push   $0x8023dc
  801484:	e8 16 ef ff ff       	call   80039f <cprintf>
		return -E_INVAL;
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801491:	eb da                	jmp    80146d <write+0x55>
		return -E_NOT_SUPP;
  801493:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801498:	eb d3                	jmp    80146d <write+0x55>

0080149a <seek>:

int
seek(int fdnum, off_t offset)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 2d fc ff ff       	call   8010d9 <fd_lookup>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 0e                	js     8014c1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	53                   	push   %ebx
  8014c7:	83 ec 14             	sub    $0x14,%esp
  8014ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	53                   	push   %ebx
  8014d2:	e8 02 fc ff ff       	call   8010d9 <fd_lookup>
  8014d7:	83 c4 08             	add    $0x8,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 37                	js     801515 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014de:	83 ec 08             	sub    $0x8,%esp
  8014e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e4:	50                   	push   %eax
  8014e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e8:	ff 30                	pushl  (%eax)
  8014ea:	e8 40 fc ff ff       	call   80112f <dev_lookup>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 1f                	js     801515 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014fd:	74 1b                	je     80151a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801502:	8b 52 18             	mov    0x18(%edx),%edx
  801505:	85 d2                	test   %edx,%edx
  801507:	74 32                	je     80153b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	ff 75 0c             	pushl  0xc(%ebp)
  80150f:	50                   	push   %eax
  801510:	ff d2                	call   *%edx
  801512:	83 c4 10             	add    $0x10,%esp
}
  801515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801518:	c9                   	leave  
  801519:	c3                   	ret    
			thisenv->env_id, fdnum);
  80151a:	a1 04 44 80 00       	mov    0x804404,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80151f:	8b 40 48             	mov    0x48(%eax),%eax
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	53                   	push   %ebx
  801526:	50                   	push   %eax
  801527:	68 9c 23 80 00       	push   $0x80239c
  80152c:	e8 6e ee ff ff       	call   80039f <cprintf>
		return -E_INVAL;
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801539:	eb da                	jmp    801515 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80153b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801540:	eb d3                	jmp    801515 <ftruncate+0x52>

00801542 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	53                   	push   %ebx
  801546:	83 ec 14             	sub    $0x14,%esp
  801549:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154f:	50                   	push   %eax
  801550:	ff 75 08             	pushl  0x8(%ebp)
  801553:	e8 81 fb ff ff       	call   8010d9 <fd_lookup>
  801558:	83 c4 08             	add    $0x8,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 4b                	js     8015aa <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801565:	50                   	push   %eax
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	ff 30                	pushl  (%eax)
  80156b:	e8 bf fb ff ff       	call   80112f <dev_lookup>
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	85 c0                	test   %eax,%eax
  801575:	78 33                	js     8015aa <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80157e:	74 2f                	je     8015af <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801580:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801583:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80158a:	00 00 00 
	stat->st_isdir = 0;
  80158d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801594:	00 00 00 
	stat->st_dev = dev;
  801597:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80159d:	83 ec 08             	sub    $0x8,%esp
  8015a0:	53                   	push   %ebx
  8015a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a4:	ff 50 14             	call   *0x14(%eax)
  8015a7:	83 c4 10             	add    $0x10,%esp
}
  8015aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    
		return -E_NOT_SUPP;
  8015af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b4:	eb f4                	jmp    8015aa <fstat+0x68>

008015b6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	56                   	push   %esi
  8015ba:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	6a 00                	push   $0x0
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	e8 e7 01 00 00       	call   8017af <open>
  8015c8:	89 c3                	mov    %eax,%ebx
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 1b                	js     8015ec <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015d1:	83 ec 08             	sub    $0x8,%esp
  8015d4:	ff 75 0c             	pushl  0xc(%ebp)
  8015d7:	50                   	push   %eax
  8015d8:	e8 65 ff ff ff       	call   801542 <fstat>
  8015dd:	89 c6                	mov    %eax,%esi
	close(fd);
  8015df:	89 1c 24             	mov    %ebx,(%esp)
  8015e2:	e8 27 fc ff ff       	call   80120e <close>
	return r;
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	89 f3                	mov    %esi,%ebx
}
  8015ec:	89 d8                	mov    %ebx,%eax
  8015ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5e                   	pop    %esi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	56                   	push   %esi
  8015f9:	53                   	push   %ebx
  8015fa:	89 c6                	mov    %eax,%esi
  8015fc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015fe:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801605:	74 27                	je     80162e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801607:	6a 07                	push   $0x7
  801609:	68 00 50 80 00       	push   $0x805000
  80160e:	56                   	push   %esi
  80160f:	ff 35 00 44 80 00    	pushl  0x804400
  801615:	e8 b3 06 00 00       	call   801ccd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80161a:	83 c4 0c             	add    $0xc,%esp
  80161d:	6a 00                	push   $0x0
  80161f:	53                   	push   %ebx
  801620:	6a 00                	push   $0x0
  801622:	e8 8f 06 00 00       	call   801cb6 <ipc_recv>
}
  801627:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80162a:	5b                   	pop    %ebx
  80162b:	5e                   	pop    %esi
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	6a 01                	push   $0x1
  801633:	e8 ac 06 00 00       	call   801ce4 <ipc_find_env>
  801638:	a3 00 44 80 00       	mov    %eax,0x804400
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	eb c5                	jmp    801607 <fsipc+0x12>

00801642 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8b 40 0c             	mov    0xc(%eax),%eax
  80164e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801653:	8b 45 0c             	mov    0xc(%ebp),%eax
  801656:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80165b:	ba 00 00 00 00       	mov    $0x0,%edx
  801660:	b8 02 00 00 00       	mov    $0x2,%eax
  801665:	e8 8b ff ff ff       	call   8015f5 <fsipc>
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <devfile_flush>:
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8b 40 0c             	mov    0xc(%eax),%eax
  801678:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80167d:	ba 00 00 00 00       	mov    $0x0,%edx
  801682:	b8 06 00 00 00       	mov    $0x6,%eax
  801687:	e8 69 ff ff ff       	call   8015f5 <fsipc>
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <devfile_stat>:
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	53                   	push   %ebx
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8b 40 0c             	mov    0xc(%eax),%eax
  80169e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ad:	e8 43 ff ff ff       	call   8015f5 <fsipc>
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	78 2c                	js     8016e2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016b6:	83 ec 08             	sub    $0x8,%esp
  8016b9:	68 00 50 80 00       	push   $0x805000
  8016be:	53                   	push   %ebx
  8016bf:	e8 b5 f3 ff ff       	call   800a79 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016c4:	a1 80 50 80 00       	mov    0x805080,%eax
  8016c9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016cf:	a1 84 50 80 00       	mov    0x805084,%eax
  8016d4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <devfile_write>:
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016f5:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016fa:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801700:	8b 52 0c             	mov    0xc(%edx),%edx
  801703:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801709:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80170e:	50                   	push   %eax
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	68 08 50 80 00       	push   $0x805008
  801717:	e8 eb f4 ff ff       	call   800c07 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80171c:	ba 00 00 00 00       	mov    $0x0,%edx
  801721:	b8 04 00 00 00       	mov    $0x4,%eax
  801726:	e8 ca fe ff ff       	call   8015f5 <fsipc>
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <devfile_read>:
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	8b 40 0c             	mov    0xc(%eax),%eax
  80173b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801740:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	b8 03 00 00 00       	mov    $0x3,%eax
  801750:	e8 a0 fe ff ff       	call   8015f5 <fsipc>
  801755:	89 c3                	mov    %eax,%ebx
  801757:	85 c0                	test   %eax,%eax
  801759:	78 1f                	js     80177a <devfile_read+0x4d>
	assert(r <= n);
  80175b:	39 f0                	cmp    %esi,%eax
  80175d:	77 24                	ja     801783 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80175f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801764:	7f 33                	jg     801799 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	50                   	push   %eax
  80176a:	68 00 50 80 00       	push   $0x805000
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	e8 90 f4 ff ff       	call   800c07 <memmove>
	return r;
  801777:	83 c4 10             	add    $0x10,%esp
}
  80177a:	89 d8                	mov    %ebx,%eax
  80177c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5d                   	pop    %ebp
  801782:	c3                   	ret    
	assert(r <= n);
  801783:	68 0c 24 80 00       	push   $0x80240c
  801788:	68 13 24 80 00       	push   $0x802413
  80178d:	6a 7c                	push   $0x7c
  80178f:	68 28 24 80 00       	push   $0x802428
  801794:	e8 2b eb ff ff       	call   8002c4 <_panic>
	assert(r <= PGSIZE);
  801799:	68 33 24 80 00       	push   $0x802433
  80179e:	68 13 24 80 00       	push   $0x802413
  8017a3:	6a 7d                	push   $0x7d
  8017a5:	68 28 24 80 00       	push   $0x802428
  8017aa:	e8 15 eb ff ff       	call   8002c4 <_panic>

008017af <open>:
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	56                   	push   %esi
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 1c             	sub    $0x1c,%esp
  8017b7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ba:	56                   	push   %esi
  8017bb:	e8 82 f2 ff ff       	call   800a42 <strlen>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017c8:	7f 6c                	jg     801836 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017ca:	83 ec 0c             	sub    $0xc,%esp
  8017cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	e8 b4 f8 ff ff       	call   80108a <fd_alloc>
  8017d6:	89 c3                	mov    %eax,%ebx
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 3c                	js     80181b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	56                   	push   %esi
  8017e3:	68 00 50 80 00       	push   $0x805000
  8017e8:	e8 8c f2 ff ff       	call   800a79 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017fd:	e8 f3 fd ff ff       	call   8015f5 <fsipc>
  801802:	89 c3                	mov    %eax,%ebx
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	78 19                	js     801824 <open+0x75>
	return fd2num(fd);
  80180b:	83 ec 0c             	sub    $0xc,%esp
  80180e:	ff 75 f4             	pushl  -0xc(%ebp)
  801811:	e8 4d f8 ff ff       	call   801063 <fd2num>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	83 c4 10             	add    $0x10,%esp
}
  80181b:	89 d8                	mov    %ebx,%eax
  80181d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801820:	5b                   	pop    %ebx
  801821:	5e                   	pop    %esi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    
		fd_close(fd, 0);
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	6a 00                	push   $0x0
  801829:	ff 75 f4             	pushl  -0xc(%ebp)
  80182c:	e8 54 f9 ff ff       	call   801185 <fd_close>
		return r;
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	eb e5                	jmp    80181b <open+0x6c>
		return -E_BAD_PATH;
  801836:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80183b:	eb de                	jmp    80181b <open+0x6c>

0080183d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801843:	ba 00 00 00 00       	mov    $0x0,%edx
  801848:	b8 08 00 00 00       	mov    $0x8,%eax
  80184d:	e8 a3 fd ff ff       	call   8015f5 <fsipc>
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801854:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801858:	7e 38                	jle    801892 <writebuf+0x3e>
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	53                   	push   %ebx
  80185e:	83 ec 08             	sub    $0x8,%esp
  801861:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801863:	ff 70 04             	pushl  0x4(%eax)
  801866:	8d 40 10             	lea    0x10(%eax),%eax
  801869:	50                   	push   %eax
  80186a:	ff 33                	pushl  (%ebx)
  80186c:	e8 a7 fb ff ff       	call   801418 <write>
		if (result > 0)
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	85 c0                	test   %eax,%eax
  801876:	7e 03                	jle    80187b <writebuf+0x27>
			b->result += result;
  801878:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80187b:	39 43 04             	cmp    %eax,0x4(%ebx)
  80187e:	74 0d                	je     80188d <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  801880:	85 c0                	test   %eax,%eax
  801882:	ba 00 00 00 00       	mov    $0x0,%edx
  801887:	0f 4f c2             	cmovg  %edx,%eax
  80188a:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80188d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801890:	c9                   	leave  
  801891:	c3                   	ret    
  801892:	f3 c3                	repz ret 

00801894 <putch>:

static void
putch(int ch, void *thunk)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80189e:	8b 53 04             	mov    0x4(%ebx),%edx
  8018a1:	8d 42 01             	lea    0x1(%edx),%eax
  8018a4:	89 43 04             	mov    %eax,0x4(%ebx)
  8018a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018aa:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8018ae:	3d 00 01 00 00       	cmp    $0x100,%eax
  8018b3:	74 06                	je     8018bb <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8018b5:	83 c4 04             	add    $0x4,%esp
  8018b8:	5b                   	pop    %ebx
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    
		writebuf(b);
  8018bb:	89 d8                	mov    %ebx,%eax
  8018bd:	e8 92 ff ff ff       	call   801854 <writebuf>
		b->idx = 0;
  8018c2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8018c9:	eb ea                	jmp    8018b5 <putch+0x21>

008018cb <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018dd:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018e4:	00 00 00 
	b.result = 0;
  8018e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018ee:	00 00 00 
	b.error = 1;
  8018f1:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018f8:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018fb:	ff 75 10             	pushl  0x10(%ebp)
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801907:	50                   	push   %eax
  801908:	68 94 18 80 00       	push   $0x801894
  80190d:	e8 8a eb ff ff       	call   80049c <vprintfmt>
	if (b.idx > 0)
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80191c:	7f 11                	jg     80192f <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80191e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801924:	85 c0                	test   %eax,%eax
  801926:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    
		writebuf(&b);
  80192f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801935:	e8 1a ff ff ff       	call   801854 <writebuf>
  80193a:	eb e2                	jmp    80191e <vfprintf+0x53>

0080193c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801942:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801945:	50                   	push   %eax
  801946:	ff 75 0c             	pushl  0xc(%ebp)
  801949:	ff 75 08             	pushl  0x8(%ebp)
  80194c:	e8 7a ff ff ff       	call   8018cb <vfprintf>
	va_end(ap);

	return cnt;
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <printf>:

int
printf(const char *fmt, ...)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801959:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80195c:	50                   	push   %eax
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	6a 01                	push   $0x1
  801962:	e8 64 ff ff ff       	call   8018cb <vfprintf>
	va_end(ap);

	return cnt;
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	56                   	push   %esi
  80196d:	53                   	push   %ebx
  80196e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801971:	83 ec 0c             	sub    $0xc,%esp
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	e8 f7 f6 ff ff       	call   801073 <fd2data>
  80197c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80197e:	83 c4 08             	add    $0x8,%esp
  801981:	68 3f 24 80 00       	push   $0x80243f
  801986:	53                   	push   %ebx
  801987:	e8 ed f0 ff ff       	call   800a79 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80198c:	8b 46 04             	mov    0x4(%esi),%eax
  80198f:	2b 06                	sub    (%esi),%eax
  801991:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801997:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80199e:	00 00 00 
	stat->st_dev = &devpipe;
  8019a1:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8019a8:	30 80 00 
	return 0;
}
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5d                   	pop    %ebp
  8019b6:	c3                   	ret    

008019b7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	53                   	push   %ebx
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019c1:	53                   	push   %ebx
  8019c2:	6a 00                	push   $0x0
  8019c4:	e8 2e f5 ff ff       	call   800ef7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019c9:	89 1c 24             	mov    %ebx,(%esp)
  8019cc:	e8 a2 f6 ff ff       	call   801073 <fd2data>
  8019d1:	83 c4 08             	add    $0x8,%esp
  8019d4:	50                   	push   %eax
  8019d5:	6a 00                	push   $0x0
  8019d7:	e8 1b f5 ff ff       	call   800ef7 <sys_page_unmap>
}
  8019dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <_pipeisclosed>:
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	57                   	push   %edi
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 1c             	sub    $0x1c,%esp
  8019ea:	89 c7                	mov    %eax,%edi
  8019ec:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019ee:	a1 04 44 80 00       	mov    0x804404,%eax
  8019f3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	57                   	push   %edi
  8019fa:	e8 1e 03 00 00       	call   801d1d <pageref>
  8019ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a02:	89 34 24             	mov    %esi,(%esp)
  801a05:	e8 13 03 00 00       	call   801d1d <pageref>
		nn = thisenv->env_runs;
  801a0a:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801a10:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	39 cb                	cmp    %ecx,%ebx
  801a18:	74 1b                	je     801a35 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a1a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a1d:	75 cf                	jne    8019ee <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a1f:	8b 42 58             	mov    0x58(%edx),%eax
  801a22:	6a 01                	push   $0x1
  801a24:	50                   	push   %eax
  801a25:	53                   	push   %ebx
  801a26:	68 46 24 80 00       	push   $0x802446
  801a2b:	e8 6f e9 ff ff       	call   80039f <cprintf>
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	eb b9                	jmp    8019ee <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a35:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a38:	0f 94 c0             	sete   %al
  801a3b:	0f b6 c0             	movzbl %al,%eax
}
  801a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a41:	5b                   	pop    %ebx
  801a42:	5e                   	pop    %esi
  801a43:	5f                   	pop    %edi
  801a44:	5d                   	pop    %ebp
  801a45:	c3                   	ret    

00801a46 <devpipe_write>:
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	57                   	push   %edi
  801a4a:	56                   	push   %esi
  801a4b:	53                   	push   %ebx
  801a4c:	83 ec 28             	sub    $0x28,%esp
  801a4f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a52:	56                   	push   %esi
  801a53:	e8 1b f6 ff ff       	call   801073 <fd2data>
  801a58:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	bf 00 00 00 00       	mov    $0x0,%edi
  801a62:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a65:	74 4f                	je     801ab6 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a67:	8b 43 04             	mov    0x4(%ebx),%eax
  801a6a:	8b 0b                	mov    (%ebx),%ecx
  801a6c:	8d 51 20             	lea    0x20(%ecx),%edx
  801a6f:	39 d0                	cmp    %edx,%eax
  801a71:	72 14                	jb     801a87 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a73:	89 da                	mov    %ebx,%edx
  801a75:	89 f0                	mov    %esi,%eax
  801a77:	e8 65 ff ff ff       	call   8019e1 <_pipeisclosed>
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	75 3a                	jne    801aba <devpipe_write+0x74>
			sys_yield();
  801a80:	e8 ce f3 ff ff       	call   800e53 <sys_yield>
  801a85:	eb e0                	jmp    801a67 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a8e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a91:	89 c2                	mov    %eax,%edx
  801a93:	c1 fa 1f             	sar    $0x1f,%edx
  801a96:	89 d1                	mov    %edx,%ecx
  801a98:	c1 e9 1b             	shr    $0x1b,%ecx
  801a9b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a9e:	83 e2 1f             	and    $0x1f,%edx
  801aa1:	29 ca                	sub    %ecx,%edx
  801aa3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aa7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801aab:	83 c0 01             	add    $0x1,%eax
  801aae:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ab1:	83 c7 01             	add    $0x1,%edi
  801ab4:	eb ac                	jmp    801a62 <devpipe_write+0x1c>
	return i;
  801ab6:	89 f8                	mov    %edi,%eax
  801ab8:	eb 05                	jmp    801abf <devpipe_write+0x79>
				return 0;
  801aba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac2:	5b                   	pop    %ebx
  801ac3:	5e                   	pop    %esi
  801ac4:	5f                   	pop    %edi
  801ac5:	5d                   	pop    %ebp
  801ac6:	c3                   	ret    

00801ac7 <devpipe_read>:
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	57                   	push   %edi
  801acb:	56                   	push   %esi
  801acc:	53                   	push   %ebx
  801acd:	83 ec 18             	sub    $0x18,%esp
  801ad0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ad3:	57                   	push   %edi
  801ad4:	e8 9a f5 ff ff       	call   801073 <fd2data>
  801ad9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	be 00 00 00 00       	mov    $0x0,%esi
  801ae3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ae6:	74 47                	je     801b2f <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801ae8:	8b 03                	mov    (%ebx),%eax
  801aea:	3b 43 04             	cmp    0x4(%ebx),%eax
  801aed:	75 22                	jne    801b11 <devpipe_read+0x4a>
			if (i > 0)
  801aef:	85 f6                	test   %esi,%esi
  801af1:	75 14                	jne    801b07 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801af3:	89 da                	mov    %ebx,%edx
  801af5:	89 f8                	mov    %edi,%eax
  801af7:	e8 e5 fe ff ff       	call   8019e1 <_pipeisclosed>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	75 33                	jne    801b33 <devpipe_read+0x6c>
			sys_yield();
  801b00:	e8 4e f3 ff ff       	call   800e53 <sys_yield>
  801b05:	eb e1                	jmp    801ae8 <devpipe_read+0x21>
				return i;
  801b07:	89 f0                	mov    %esi,%eax
}
  801b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5f                   	pop    %edi
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b11:	99                   	cltd   
  801b12:	c1 ea 1b             	shr    $0x1b,%edx
  801b15:	01 d0                	add    %edx,%eax
  801b17:	83 e0 1f             	and    $0x1f,%eax
  801b1a:	29 d0                	sub    %edx,%eax
  801b1c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b24:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b27:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b2a:	83 c6 01             	add    $0x1,%esi
  801b2d:	eb b4                	jmp    801ae3 <devpipe_read+0x1c>
	return i;
  801b2f:	89 f0                	mov    %esi,%eax
  801b31:	eb d6                	jmp    801b09 <devpipe_read+0x42>
				return 0;
  801b33:	b8 00 00 00 00       	mov    $0x0,%eax
  801b38:	eb cf                	jmp    801b09 <devpipe_read+0x42>

00801b3a <pipe>:
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	56                   	push   %esi
  801b3e:	53                   	push   %ebx
  801b3f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b45:	50                   	push   %eax
  801b46:	e8 3f f5 ff ff       	call   80108a <fd_alloc>
  801b4b:	89 c3                	mov    %eax,%ebx
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 5b                	js     801baf <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	68 07 04 00 00       	push   $0x407
  801b5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b5f:	6a 00                	push   $0x0
  801b61:	e8 0c f3 ff ff       	call   800e72 <sys_page_alloc>
  801b66:	89 c3                	mov    %eax,%ebx
  801b68:	83 c4 10             	add    $0x10,%esp
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 40                	js     801baf <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801b6f:	83 ec 0c             	sub    $0xc,%esp
  801b72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b75:	50                   	push   %eax
  801b76:	e8 0f f5 ff ff       	call   80108a <fd_alloc>
  801b7b:	89 c3                	mov    %eax,%ebx
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	85 c0                	test   %eax,%eax
  801b82:	78 1b                	js     801b9f <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	68 07 04 00 00       	push   $0x407
  801b8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b8f:	6a 00                	push   $0x0
  801b91:	e8 dc f2 ff ff       	call   800e72 <sys_page_alloc>
  801b96:	89 c3                	mov    %eax,%ebx
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	79 19                	jns    801bb8 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801b9f:	83 ec 08             	sub    $0x8,%esp
  801ba2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba5:	6a 00                	push   $0x0
  801ba7:	e8 4b f3 ff ff       	call   800ef7 <sys_page_unmap>
  801bac:	83 c4 10             	add    $0x10,%esp
}
  801baf:	89 d8                	mov    %ebx,%eax
  801bb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5e                   	pop    %esi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    
	va = fd2data(fd0);
  801bb8:	83 ec 0c             	sub    $0xc,%esp
  801bbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbe:	e8 b0 f4 ff ff       	call   801073 <fd2data>
  801bc3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc5:	83 c4 0c             	add    $0xc,%esp
  801bc8:	68 07 04 00 00       	push   $0x407
  801bcd:	50                   	push   %eax
  801bce:	6a 00                	push   $0x0
  801bd0:	e8 9d f2 ff ff       	call   800e72 <sys_page_alloc>
  801bd5:	89 c3                	mov    %eax,%ebx
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	0f 88 8c 00 00 00    	js     801c6e <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	ff 75 f0             	pushl  -0x10(%ebp)
  801be8:	e8 86 f4 ff ff       	call   801073 <fd2data>
  801bed:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bf4:	50                   	push   %eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	56                   	push   %esi
  801bf8:	6a 00                	push   $0x0
  801bfa:	e8 b6 f2 ff ff       	call   800eb5 <sys_page_map>
  801bff:	89 c3                	mov    %eax,%ebx
  801c01:	83 c4 20             	add    $0x20,%esp
  801c04:	85 c0                	test   %eax,%eax
  801c06:	78 58                	js     801c60 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c11:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c20:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c26:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c32:	83 ec 0c             	sub    $0xc,%esp
  801c35:	ff 75 f4             	pushl  -0xc(%ebp)
  801c38:	e8 26 f4 ff ff       	call   801063 <fd2num>
  801c3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c40:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c42:	83 c4 04             	add    $0x4,%esp
  801c45:	ff 75 f0             	pushl  -0x10(%ebp)
  801c48:	e8 16 f4 ff ff       	call   801063 <fd2num>
  801c4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c50:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c5b:	e9 4f ff ff ff       	jmp    801baf <pipe+0x75>
	sys_page_unmap(0, va);
  801c60:	83 ec 08             	sub    $0x8,%esp
  801c63:	56                   	push   %esi
  801c64:	6a 00                	push   $0x0
  801c66:	e8 8c f2 ff ff       	call   800ef7 <sys_page_unmap>
  801c6b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c6e:	83 ec 08             	sub    $0x8,%esp
  801c71:	ff 75 f0             	pushl  -0x10(%ebp)
  801c74:	6a 00                	push   $0x0
  801c76:	e8 7c f2 ff ff       	call   800ef7 <sys_page_unmap>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	e9 1c ff ff ff       	jmp    801b9f <pipe+0x65>

00801c83 <pipeisclosed>:
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8c:	50                   	push   %eax
  801c8d:	ff 75 08             	pushl  0x8(%ebp)
  801c90:	e8 44 f4 ff ff       	call   8010d9 <fd_lookup>
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 18                	js     801cb4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c9c:	83 ec 0c             	sub    $0xc,%esp
  801c9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca2:	e8 cc f3 ff ff       	call   801073 <fd2data>
	return _pipeisclosed(fd, p);
  801ca7:	89 c2                	mov    %eax,%edx
  801ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cac:	e8 30 fd ff ff       	call   8019e1 <_pipeisclosed>
  801cb1:	83 c4 10             	add    $0x10,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801cbc:	68 5e 24 80 00       	push   $0x80245e
  801cc1:	6a 1a                	push   $0x1a
  801cc3:	68 77 24 80 00       	push   $0x802477
  801cc8:	e8 f7 e5 ff ff       	call   8002c4 <_panic>

00801ccd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801cd3:	68 81 24 80 00       	push   $0x802481
  801cd8:	6a 2a                	push   $0x2a
  801cda:	68 77 24 80 00       	push   $0x802477
  801cdf:	e8 e0 e5 ff ff       	call   8002c4 <_panic>

00801ce4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cef:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801cf2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801cf8:	8b 52 50             	mov    0x50(%edx),%edx
  801cfb:	39 ca                	cmp    %ecx,%edx
  801cfd:	74 11                	je     801d10 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801cff:	83 c0 01             	add    $0x1,%eax
  801d02:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d07:	75 e6                	jne    801cef <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0e:	eb 0b                	jmp    801d1b <ipc_find_env+0x37>
			return envs[i].env_id;
  801d10:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d13:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d18:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	c1 e8 16             	shr    $0x16,%eax
  801d28:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801d34:	f6 c1 01             	test   $0x1,%cl
  801d37:	74 1d                	je     801d56 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801d39:	c1 ea 0c             	shr    $0xc,%edx
  801d3c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801d43:	f6 c2 01             	test   $0x1,%dl
  801d46:	74 0e                	je     801d56 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d48:	c1 ea 0c             	shr    $0xc,%edx
  801d4b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801d52:	ef 
  801d53:	0f b7 c0             	movzwl %ax,%eax
}
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
  801d58:	66 90                	xchg   %ax,%ax
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	66 90                	xchg   %ax,%ax
  801d5e:	66 90                	xchg   %ax,%ax

00801d60 <__udivdi3>:
  801d60:	55                   	push   %ebp
  801d61:	57                   	push   %edi
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 1c             	sub    $0x1c,%esp
  801d67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d77:	85 d2                	test   %edx,%edx
  801d79:	75 35                	jne    801db0 <__udivdi3+0x50>
  801d7b:	39 f3                	cmp    %esi,%ebx
  801d7d:	0f 87 bd 00 00 00    	ja     801e40 <__udivdi3+0xe0>
  801d83:	85 db                	test   %ebx,%ebx
  801d85:	89 d9                	mov    %ebx,%ecx
  801d87:	75 0b                	jne    801d94 <__udivdi3+0x34>
  801d89:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8e:	31 d2                	xor    %edx,%edx
  801d90:	f7 f3                	div    %ebx
  801d92:	89 c1                	mov    %eax,%ecx
  801d94:	31 d2                	xor    %edx,%edx
  801d96:	89 f0                	mov    %esi,%eax
  801d98:	f7 f1                	div    %ecx
  801d9a:	89 c6                	mov    %eax,%esi
  801d9c:	89 e8                	mov    %ebp,%eax
  801d9e:	89 f7                	mov    %esi,%edi
  801da0:	f7 f1                	div    %ecx
  801da2:	89 fa                	mov    %edi,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801db0:	39 f2                	cmp    %esi,%edx
  801db2:	77 7c                	ja     801e30 <__udivdi3+0xd0>
  801db4:	0f bd fa             	bsr    %edx,%edi
  801db7:	83 f7 1f             	xor    $0x1f,%edi
  801dba:	0f 84 98 00 00 00    	je     801e58 <__udivdi3+0xf8>
  801dc0:	89 f9                	mov    %edi,%ecx
  801dc2:	b8 20 00 00 00       	mov    $0x20,%eax
  801dc7:	29 f8                	sub    %edi,%eax
  801dc9:	d3 e2                	shl    %cl,%edx
  801dcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dcf:	89 c1                	mov    %eax,%ecx
  801dd1:	89 da                	mov    %ebx,%edx
  801dd3:	d3 ea                	shr    %cl,%edx
  801dd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801dd9:	09 d1                	or     %edx,%ecx
  801ddb:	89 f2                	mov    %esi,%edx
  801ddd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801de1:	89 f9                	mov    %edi,%ecx
  801de3:	d3 e3                	shl    %cl,%ebx
  801de5:	89 c1                	mov    %eax,%ecx
  801de7:	d3 ea                	shr    %cl,%edx
  801de9:	89 f9                	mov    %edi,%ecx
  801deb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801def:	d3 e6                	shl    %cl,%esi
  801df1:	89 eb                	mov    %ebp,%ebx
  801df3:	89 c1                	mov    %eax,%ecx
  801df5:	d3 eb                	shr    %cl,%ebx
  801df7:	09 de                	or     %ebx,%esi
  801df9:	89 f0                	mov    %esi,%eax
  801dfb:	f7 74 24 08          	divl   0x8(%esp)
  801dff:	89 d6                	mov    %edx,%esi
  801e01:	89 c3                	mov    %eax,%ebx
  801e03:	f7 64 24 0c          	mull   0xc(%esp)
  801e07:	39 d6                	cmp    %edx,%esi
  801e09:	72 0c                	jb     801e17 <__udivdi3+0xb7>
  801e0b:	89 f9                	mov    %edi,%ecx
  801e0d:	d3 e5                	shl    %cl,%ebp
  801e0f:	39 c5                	cmp    %eax,%ebp
  801e11:	73 5d                	jae    801e70 <__udivdi3+0x110>
  801e13:	39 d6                	cmp    %edx,%esi
  801e15:	75 59                	jne    801e70 <__udivdi3+0x110>
  801e17:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e1a:	31 ff                	xor    %edi,%edi
  801e1c:	89 fa                	mov    %edi,%edx
  801e1e:	83 c4 1c             	add    $0x1c,%esp
  801e21:	5b                   	pop    %ebx
  801e22:	5e                   	pop    %esi
  801e23:	5f                   	pop    %edi
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    
  801e26:	8d 76 00             	lea    0x0(%esi),%esi
  801e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801e30:	31 ff                	xor    %edi,%edi
  801e32:	31 c0                	xor    %eax,%eax
  801e34:	89 fa                	mov    %edi,%edx
  801e36:	83 c4 1c             	add    $0x1c,%esp
  801e39:	5b                   	pop    %ebx
  801e3a:	5e                   	pop    %esi
  801e3b:	5f                   	pop    %edi
  801e3c:	5d                   	pop    %ebp
  801e3d:	c3                   	ret    
  801e3e:	66 90                	xchg   %ax,%ax
  801e40:	31 ff                	xor    %edi,%edi
  801e42:	89 e8                	mov    %ebp,%eax
  801e44:	89 f2                	mov    %esi,%edx
  801e46:	f7 f3                	div    %ebx
  801e48:	89 fa                	mov    %edi,%edx
  801e4a:	83 c4 1c             	add    $0x1c,%esp
  801e4d:	5b                   	pop    %ebx
  801e4e:	5e                   	pop    %esi
  801e4f:	5f                   	pop    %edi
  801e50:	5d                   	pop    %ebp
  801e51:	c3                   	ret    
  801e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e58:	39 f2                	cmp    %esi,%edx
  801e5a:	72 06                	jb     801e62 <__udivdi3+0x102>
  801e5c:	31 c0                	xor    %eax,%eax
  801e5e:	39 eb                	cmp    %ebp,%ebx
  801e60:	77 d2                	ja     801e34 <__udivdi3+0xd4>
  801e62:	b8 01 00 00 00       	mov    $0x1,%eax
  801e67:	eb cb                	jmp    801e34 <__udivdi3+0xd4>
  801e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e70:	89 d8                	mov    %ebx,%eax
  801e72:	31 ff                	xor    %edi,%edi
  801e74:	eb be                	jmp    801e34 <__udivdi3+0xd4>
  801e76:	66 90                	xchg   %ax,%ax
  801e78:	66 90                	xchg   %ax,%ax
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	66 90                	xchg   %ax,%ax
  801e7e:	66 90                	xchg   %ax,%ax

00801e80 <__umoddi3>:
  801e80:	55                   	push   %ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	83 ec 1c             	sub    $0x1c,%esp
  801e87:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801e8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e97:	85 ed                	test   %ebp,%ebp
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	89 da                	mov    %ebx,%edx
  801e9d:	75 19                	jne    801eb8 <__umoddi3+0x38>
  801e9f:	39 df                	cmp    %ebx,%edi
  801ea1:	0f 86 b1 00 00 00    	jbe    801f58 <__umoddi3+0xd8>
  801ea7:	f7 f7                	div    %edi
  801ea9:	89 d0                	mov    %edx,%eax
  801eab:	31 d2                	xor    %edx,%edx
  801ead:	83 c4 1c             	add    $0x1c,%esp
  801eb0:	5b                   	pop    %ebx
  801eb1:	5e                   	pop    %esi
  801eb2:	5f                   	pop    %edi
  801eb3:	5d                   	pop    %ebp
  801eb4:	c3                   	ret    
  801eb5:	8d 76 00             	lea    0x0(%esi),%esi
  801eb8:	39 dd                	cmp    %ebx,%ebp
  801eba:	77 f1                	ja     801ead <__umoddi3+0x2d>
  801ebc:	0f bd cd             	bsr    %ebp,%ecx
  801ebf:	83 f1 1f             	xor    $0x1f,%ecx
  801ec2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec6:	0f 84 b4 00 00 00    	je     801f80 <__umoddi3+0x100>
  801ecc:	b8 20 00 00 00       	mov    $0x20,%eax
  801ed1:	89 c2                	mov    %eax,%edx
  801ed3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ed7:	29 c2                	sub    %eax,%edx
  801ed9:	89 c1                	mov    %eax,%ecx
  801edb:	89 f8                	mov    %edi,%eax
  801edd:	d3 e5                	shl    %cl,%ebp
  801edf:	89 d1                	mov    %edx,%ecx
  801ee1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ee5:	d3 e8                	shr    %cl,%eax
  801ee7:	09 c5                	or     %eax,%ebp
  801ee9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801eed:	89 c1                	mov    %eax,%ecx
  801eef:	d3 e7                	shl    %cl,%edi
  801ef1:	89 d1                	mov    %edx,%ecx
  801ef3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ef7:	89 df                	mov    %ebx,%edi
  801ef9:	d3 ef                	shr    %cl,%edi
  801efb:	89 c1                	mov    %eax,%ecx
  801efd:	89 f0                	mov    %esi,%eax
  801eff:	d3 e3                	shl    %cl,%ebx
  801f01:	89 d1                	mov    %edx,%ecx
  801f03:	89 fa                	mov    %edi,%edx
  801f05:	d3 e8                	shr    %cl,%eax
  801f07:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f0c:	09 d8                	or     %ebx,%eax
  801f0e:	f7 f5                	div    %ebp
  801f10:	d3 e6                	shl    %cl,%esi
  801f12:	89 d1                	mov    %edx,%ecx
  801f14:	f7 64 24 08          	mull   0x8(%esp)
  801f18:	39 d1                	cmp    %edx,%ecx
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	89 d7                	mov    %edx,%edi
  801f1e:	72 06                	jb     801f26 <__umoddi3+0xa6>
  801f20:	75 0e                	jne    801f30 <__umoddi3+0xb0>
  801f22:	39 c6                	cmp    %eax,%esi
  801f24:	73 0a                	jae    801f30 <__umoddi3+0xb0>
  801f26:	2b 44 24 08          	sub    0x8(%esp),%eax
  801f2a:	19 ea                	sbb    %ebp,%edx
  801f2c:	89 d7                	mov    %edx,%edi
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	89 ca                	mov    %ecx,%edx
  801f32:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801f37:	29 de                	sub    %ebx,%esi
  801f39:	19 fa                	sbb    %edi,%edx
  801f3b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801f3f:	89 d0                	mov    %edx,%eax
  801f41:	d3 e0                	shl    %cl,%eax
  801f43:	89 d9                	mov    %ebx,%ecx
  801f45:	d3 ee                	shr    %cl,%esi
  801f47:	d3 ea                	shr    %cl,%edx
  801f49:	09 f0                	or     %esi,%eax
  801f4b:	83 c4 1c             	add    $0x1c,%esp
  801f4e:	5b                   	pop    %ebx
  801f4f:	5e                   	pop    %esi
  801f50:	5f                   	pop    %edi
  801f51:	5d                   	pop    %ebp
  801f52:	c3                   	ret    
  801f53:	90                   	nop
  801f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f58:	85 ff                	test   %edi,%edi
  801f5a:	89 f9                	mov    %edi,%ecx
  801f5c:	75 0b                	jne    801f69 <__umoddi3+0xe9>
  801f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f63:	31 d2                	xor    %edx,%edx
  801f65:	f7 f7                	div    %edi
  801f67:	89 c1                	mov    %eax,%ecx
  801f69:	89 d8                	mov    %ebx,%eax
  801f6b:	31 d2                	xor    %edx,%edx
  801f6d:	f7 f1                	div    %ecx
  801f6f:	89 f0                	mov    %esi,%eax
  801f71:	f7 f1                	div    %ecx
  801f73:	e9 31 ff ff ff       	jmp    801ea9 <__umoddi3+0x29>
  801f78:	90                   	nop
  801f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f80:	39 dd                	cmp    %ebx,%ebp
  801f82:	72 08                	jb     801f8c <__umoddi3+0x10c>
  801f84:	39 f7                	cmp    %esi,%edi
  801f86:	0f 87 21 ff ff ff    	ja     801ead <__umoddi3+0x2d>
  801f8c:	89 da                	mov    %ebx,%edx
  801f8e:	89 f0                	mov    %esi,%eax
  801f90:	29 f8                	sub    %edi,%eax
  801f92:	19 ea                	sbb    %ebp,%edx
  801f94:	e9 14 ff ff ff       	jmp    801ead <__umoddi3+0x2d>
