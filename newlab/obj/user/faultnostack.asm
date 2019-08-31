
obj/user/faultnostack.debug：     文件格式 elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 61 03 80 00       	push   $0x800361
  80003e:	6a 00                	push   $0x0
  800040:	e8 76 02 00 00       	call   8002bb <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005f:	e8 ce 00 00 00       	call   800132 <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800071:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x2d>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a0:	e8 b9 04 00 00       	call   80055e <close_all>
	sys_env_destroy(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 42 00 00 00       	call   8000f1 <sys_env_destroy>
}
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	c9                   	leave  
  8000b3:	c3                   	ret    

008000b4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	89 c7                	mov    %eax,%edi
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e2:	89 d1                	mov    %edx,%ecx
  8000e4:	89 d3                	mov    %edx,%ebx
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	89 d6                	mov    %edx,%esi
  8000ea:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800102:	b8 03 00 00 00       	mov    $0x3,%eax
  800107:	89 cb                	mov    %ecx,%ebx
  800109:	89 cf                	mov    %ecx,%edi
  80010b:	89 ce                	mov    %ecx,%esi
  80010d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	7f 08                	jg     80011b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800113:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800116:	5b                   	pop    %ebx
  800117:	5e                   	pop    %esi
  800118:	5f                   	pop    %edi
  800119:	5d                   	pop    %ebp
  80011a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	6a 03                	push   $0x3
  800121:	68 aa 1d 80 00       	push   $0x801daa
  800126:	6a 23                	push   $0x23
  800128:	68 c7 1d 80 00       	push   $0x801dc7
  80012d:	e8 11 0f 00 00       	call   801043 <_panic>

00800132 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
	asm volatile("int %1\n"
  800138:	ba 00 00 00 00       	mov    $0x0,%edx
  80013d:	b8 02 00 00 00       	mov    $0x2,%eax
  800142:	89 d1                	mov    %edx,%ecx
  800144:	89 d3                	mov    %edx,%ebx
  800146:	89 d7                	mov    %edx,%edi
  800148:	89 d6                	mov    %edx,%esi
  80014a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <sys_yield>:

void
sys_yield(void)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	57                   	push   %edi
  800155:	56                   	push   %esi
  800156:	53                   	push   %ebx
	asm volatile("int %1\n"
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800161:	89 d1                	mov    %edx,%ecx
  800163:	89 d3                	mov    %edx,%ebx
  800165:	89 d7                	mov    %edx,%edi
  800167:	89 d6                	mov    %edx,%esi
  800169:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016b:	5b                   	pop    %ebx
  80016c:	5e                   	pop    %esi
  80016d:	5f                   	pop    %edi
  80016e:	5d                   	pop    %ebp
  80016f:	c3                   	ret    

00800170 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800179:	be 00 00 00 00       	mov    $0x0,%esi
  80017e:	8b 55 08             	mov    0x8(%ebp),%edx
  800181:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800184:	b8 04 00 00 00       	mov    $0x4,%eax
  800189:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80018c:	89 f7                	mov    %esi,%edi
  80018e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800190:	85 c0                	test   %eax,%eax
  800192:	7f 08                	jg     80019c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800197:	5b                   	pop    %ebx
  800198:	5e                   	pop    %esi
  800199:	5f                   	pop    %edi
  80019a:	5d                   	pop    %ebp
  80019b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	50                   	push   %eax
  8001a0:	6a 04                	push   $0x4
  8001a2:	68 aa 1d 80 00       	push   $0x801daa
  8001a7:	6a 23                	push   $0x23
  8001a9:	68 c7 1d 80 00       	push   $0x801dc7
  8001ae:	e8 90 0e 00 00       	call   801043 <_panic>

008001b3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	57                   	push   %edi
  8001b7:	56                   	push   %esi
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c2:	b8 05 00 00 00       	mov    $0x5,%eax
  8001c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ca:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	7f 08                	jg     8001de <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	6a 05                	push   $0x5
  8001e4:	68 aa 1d 80 00       	push   $0x801daa
  8001e9:	6a 23                	push   $0x23
  8001eb:	68 c7 1d 80 00       	push   $0x801dc7
  8001f0:	e8 4e 0e 00 00       	call   801043 <_panic>

008001f5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	57                   	push   %edi
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800203:	8b 55 08             	mov    0x8(%ebp),%edx
  800206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800209:	b8 06 00 00 00       	mov    $0x6,%eax
  80020e:	89 df                	mov    %ebx,%edi
  800210:	89 de                	mov    %ebx,%esi
  800212:	cd 30                	int    $0x30
	if(check && ret > 0)
  800214:	85 c0                	test   %eax,%eax
  800216:	7f 08                	jg     800220 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021b:	5b                   	pop    %ebx
  80021c:	5e                   	pop    %esi
  80021d:	5f                   	pop    %edi
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	50                   	push   %eax
  800224:	6a 06                	push   $0x6
  800226:	68 aa 1d 80 00       	push   $0x801daa
  80022b:	6a 23                	push   $0x23
  80022d:	68 c7 1d 80 00       	push   $0x801dc7
  800232:	e8 0c 0e 00 00       	call   801043 <_panic>

00800237 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800240:	bb 00 00 00 00       	mov    $0x0,%ebx
  800245:	8b 55 08             	mov    0x8(%ebp),%edx
  800248:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024b:	b8 08 00 00 00       	mov    $0x8,%eax
  800250:	89 df                	mov    %ebx,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	cd 30                	int    $0x30
	if(check && ret > 0)
  800256:	85 c0                	test   %eax,%eax
  800258:	7f 08                	jg     800262 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80025a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025d:	5b                   	pop    %ebx
  80025e:	5e                   	pop    %esi
  80025f:	5f                   	pop    %edi
  800260:	5d                   	pop    %ebp
  800261:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	50                   	push   %eax
  800266:	6a 08                	push   $0x8
  800268:	68 aa 1d 80 00       	push   $0x801daa
  80026d:	6a 23                	push   $0x23
  80026f:	68 c7 1d 80 00       	push   $0x801dc7
  800274:	e8 ca 0d 00 00       	call   801043 <_panic>

00800279 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	57                   	push   %edi
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800282:	bb 00 00 00 00       	mov    $0x0,%ebx
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028d:	b8 09 00 00 00       	mov    $0x9,%eax
  800292:	89 df                	mov    %ebx,%edi
  800294:	89 de                	mov    %ebx,%esi
  800296:	cd 30                	int    $0x30
	if(check && ret > 0)
  800298:	85 c0                	test   %eax,%eax
  80029a:	7f 08                	jg     8002a4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	50                   	push   %eax
  8002a8:	6a 09                	push   $0x9
  8002aa:	68 aa 1d 80 00       	push   $0x801daa
  8002af:	6a 23                	push   $0x23
  8002b1:	68 c7 1d 80 00       	push   $0x801dc7
  8002b6:	e8 88 0d 00 00       	call   801043 <_panic>

008002bb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	57                   	push   %edi
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002d4:	89 df                	mov    %ebx,%edi
  8002d6:	89 de                	mov    %ebx,%esi
  8002d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	7f 08                	jg     8002e6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	6a 0a                	push   $0xa
  8002ec:	68 aa 1d 80 00       	push   $0x801daa
  8002f1:	6a 23                	push   $0x23
  8002f3:	68 c7 1d 80 00       	push   $0x801dc7
  8002f8:	e8 46 0d 00 00       	call   801043 <_panic>

008002fd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	57                   	push   %edi
  800301:	56                   	push   %esi
  800302:	53                   	push   %ebx
	asm volatile("int %1\n"
  800303:	8b 55 08             	mov    0x8(%ebp),%edx
  800306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800309:	b8 0c 00 00 00       	mov    $0xc,%eax
  80030e:	be 00 00 00 00       	mov    $0x0,%esi
  800313:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800316:	8b 7d 14             	mov    0x14(%ebp),%edi
  800319:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800329:	b9 00 00 00 00       	mov    $0x0,%ecx
  80032e:	8b 55 08             	mov    0x8(%ebp),%edx
  800331:	b8 0d 00 00 00       	mov    $0xd,%eax
  800336:	89 cb                	mov    %ecx,%ebx
  800338:	89 cf                	mov    %ecx,%edi
  80033a:	89 ce                	mov    %ecx,%esi
  80033c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80033e:	85 c0                	test   %eax,%eax
  800340:	7f 08                	jg     80034a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5f                   	pop    %edi
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	50                   	push   %eax
  80034e:	6a 0d                	push   $0xd
  800350:	68 aa 1d 80 00       	push   $0x801daa
  800355:	6a 23                	push   $0x23
  800357:	68 c7 1d 80 00       	push   $0x801dc7
  80035c:	e8 e2 0c 00 00       	call   801043 <_panic>

00800361 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800361:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800362:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  800367:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800369:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  80036c:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  800370:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  800373:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  800377:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  80037b:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80037e:	83 c4 08             	add    $0x8,%esp
	popal
  800381:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  800382:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  800385:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  800386:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  800387:	c3                   	ret    

00800388 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	05 00 00 00 30       	add    $0x30000000,%eax
  800393:	c1 e8 0c             	shr    $0xc,%eax
}
  800396:	5d                   	pop    %ebp
  800397:	c3                   	ret    

00800398 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003b5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003ba:	89 c2                	mov    %eax,%edx
  8003bc:	c1 ea 16             	shr    $0x16,%edx
  8003bf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003c6:	f6 c2 01             	test   $0x1,%dl
  8003c9:	74 2a                	je     8003f5 <fd_alloc+0x46>
  8003cb:	89 c2                	mov    %eax,%edx
  8003cd:	c1 ea 0c             	shr    $0xc,%edx
  8003d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003d7:	f6 c2 01             	test   $0x1,%dl
  8003da:	74 19                	je     8003f5 <fd_alloc+0x46>
  8003dc:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003e1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003e6:	75 d2                	jne    8003ba <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003e8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003f3:	eb 07                	jmp    8003fc <fd_alloc+0x4d>
			*fd_store = fd;
  8003f5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003fc:	5d                   	pop    %ebp
  8003fd:	c3                   	ret    

008003fe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800404:	83 f8 1f             	cmp    $0x1f,%eax
  800407:	77 36                	ja     80043f <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800409:	c1 e0 0c             	shl    $0xc,%eax
  80040c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800411:	89 c2                	mov    %eax,%edx
  800413:	c1 ea 16             	shr    $0x16,%edx
  800416:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80041d:	f6 c2 01             	test   $0x1,%dl
  800420:	74 24                	je     800446 <fd_lookup+0x48>
  800422:	89 c2                	mov    %eax,%edx
  800424:	c1 ea 0c             	shr    $0xc,%edx
  800427:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80042e:	f6 c2 01             	test   $0x1,%dl
  800431:	74 1a                	je     80044d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800433:	8b 55 0c             	mov    0xc(%ebp),%edx
  800436:	89 02                	mov    %eax,(%edx)
	return 0;
  800438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80043d:	5d                   	pop    %ebp
  80043e:	c3                   	ret    
		return -E_INVAL;
  80043f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800444:	eb f7                	jmp    80043d <fd_lookup+0x3f>
		return -E_INVAL;
  800446:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80044b:	eb f0                	jmp    80043d <fd_lookup+0x3f>
  80044d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800452:	eb e9                	jmp    80043d <fd_lookup+0x3f>

00800454 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80045d:	ba 54 1e 80 00       	mov    $0x801e54,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800462:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800467:	39 08                	cmp    %ecx,(%eax)
  800469:	74 33                	je     80049e <dev_lookup+0x4a>
  80046b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80046e:	8b 02                	mov    (%edx),%eax
  800470:	85 c0                	test   %eax,%eax
  800472:	75 f3                	jne    800467 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800474:	a1 04 40 80 00       	mov    0x804004,%eax
  800479:	8b 40 48             	mov    0x48(%eax),%eax
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	51                   	push   %ecx
  800480:	50                   	push   %eax
  800481:	68 d8 1d 80 00       	push   $0x801dd8
  800486:	e8 93 0c 00 00       	call   80111e <cprintf>
	*dev = 0;
  80048b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
			*dev = devtab[i];
  80049e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a8:	eb f2                	jmp    80049c <dev_lookup+0x48>

008004aa <fd_close>:
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	57                   	push   %edi
  8004ae:	56                   	push   %esi
  8004af:	53                   	push   %ebx
  8004b0:	83 ec 1c             	sub    $0x1c,%esp
  8004b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004bc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004bd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004c3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004c6:	50                   	push   %eax
  8004c7:	e8 32 ff ff ff       	call   8003fe <fd_lookup>
  8004cc:	89 c3                	mov    %eax,%ebx
  8004ce:	83 c4 08             	add    $0x8,%esp
  8004d1:	85 c0                	test   %eax,%eax
  8004d3:	78 05                	js     8004da <fd_close+0x30>
	    || fd != fd2)
  8004d5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004d8:	74 16                	je     8004f0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004da:	89 f8                	mov    %edi,%eax
  8004dc:	84 c0                	test   %al,%al
  8004de:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e3:	0f 44 d8             	cmove  %eax,%ebx
}
  8004e6:	89 d8                	mov    %ebx,%eax
  8004e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004eb:	5b                   	pop    %ebx
  8004ec:	5e                   	pop    %esi
  8004ed:	5f                   	pop    %edi
  8004ee:	5d                   	pop    %ebp
  8004ef:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004f6:	50                   	push   %eax
  8004f7:	ff 36                	pushl  (%esi)
  8004f9:	e8 56 ff ff ff       	call   800454 <dev_lookup>
  8004fe:	89 c3                	mov    %eax,%ebx
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	85 c0                	test   %eax,%eax
  800505:	78 15                	js     80051c <fd_close+0x72>
		if (dev->dev_close)
  800507:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80050a:	8b 40 10             	mov    0x10(%eax),%eax
  80050d:	85 c0                	test   %eax,%eax
  80050f:	74 1b                	je     80052c <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800511:	83 ec 0c             	sub    $0xc,%esp
  800514:	56                   	push   %esi
  800515:	ff d0                	call   *%eax
  800517:	89 c3                	mov    %eax,%ebx
  800519:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	56                   	push   %esi
  800520:	6a 00                	push   $0x0
  800522:	e8 ce fc ff ff       	call   8001f5 <sys_page_unmap>
	return r;
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	eb ba                	jmp    8004e6 <fd_close+0x3c>
			r = 0;
  80052c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800531:	eb e9                	jmp    80051c <fd_close+0x72>

00800533 <close>:

int
close(int fdnum)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800539:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80053c:	50                   	push   %eax
  80053d:	ff 75 08             	pushl  0x8(%ebp)
  800540:	e8 b9 fe ff ff       	call   8003fe <fd_lookup>
  800545:	83 c4 08             	add    $0x8,%esp
  800548:	85 c0                	test   %eax,%eax
  80054a:	78 10                	js     80055c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	6a 01                	push   $0x1
  800551:	ff 75 f4             	pushl  -0xc(%ebp)
  800554:	e8 51 ff ff ff       	call   8004aa <fd_close>
  800559:	83 c4 10             	add    $0x10,%esp
}
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <close_all>:

void
close_all(void)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	53                   	push   %ebx
  800562:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800565:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80056a:	83 ec 0c             	sub    $0xc,%esp
  80056d:	53                   	push   %ebx
  80056e:	e8 c0 ff ff ff       	call   800533 <close>
	for (i = 0; i < MAXFD; i++)
  800573:	83 c3 01             	add    $0x1,%ebx
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	83 fb 20             	cmp    $0x20,%ebx
  80057c:	75 ec                	jne    80056a <close_all+0xc>
}
  80057e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800581:	c9                   	leave  
  800582:	c3                   	ret    

00800583 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800583:	55                   	push   %ebp
  800584:	89 e5                	mov    %esp,%ebp
  800586:	57                   	push   %edi
  800587:	56                   	push   %esi
  800588:	53                   	push   %ebx
  800589:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80058c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80058f:	50                   	push   %eax
  800590:	ff 75 08             	pushl  0x8(%ebp)
  800593:	e8 66 fe ff ff       	call   8003fe <fd_lookup>
  800598:	89 c3                	mov    %eax,%ebx
  80059a:	83 c4 08             	add    $0x8,%esp
  80059d:	85 c0                	test   %eax,%eax
  80059f:	0f 88 81 00 00 00    	js     800626 <dup+0xa3>
		return r;
	close(newfdnum);
  8005a5:	83 ec 0c             	sub    $0xc,%esp
  8005a8:	ff 75 0c             	pushl  0xc(%ebp)
  8005ab:	e8 83 ff ff ff       	call   800533 <close>

	newfd = INDEX2FD(newfdnum);
  8005b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005b3:	c1 e6 0c             	shl    $0xc,%esi
  8005b6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005bc:	83 c4 04             	add    $0x4,%esp
  8005bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005c2:	e8 d1 fd ff ff       	call   800398 <fd2data>
  8005c7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005c9:	89 34 24             	mov    %esi,(%esp)
  8005cc:	e8 c7 fd ff ff       	call   800398 <fd2data>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005d6:	89 d8                	mov    %ebx,%eax
  8005d8:	c1 e8 16             	shr    $0x16,%eax
  8005db:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005e2:	a8 01                	test   $0x1,%al
  8005e4:	74 11                	je     8005f7 <dup+0x74>
  8005e6:	89 d8                	mov    %ebx,%eax
  8005e8:	c1 e8 0c             	shr    $0xc,%eax
  8005eb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005f2:	f6 c2 01             	test   $0x1,%dl
  8005f5:	75 39                	jne    800630 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005fa:	89 d0                	mov    %edx,%eax
  8005fc:	c1 e8 0c             	shr    $0xc,%eax
  8005ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800606:	83 ec 0c             	sub    $0xc,%esp
  800609:	25 07 0e 00 00       	and    $0xe07,%eax
  80060e:	50                   	push   %eax
  80060f:	56                   	push   %esi
  800610:	6a 00                	push   $0x0
  800612:	52                   	push   %edx
  800613:	6a 00                	push   $0x0
  800615:	e8 99 fb ff ff       	call   8001b3 <sys_page_map>
  80061a:	89 c3                	mov    %eax,%ebx
  80061c:	83 c4 20             	add    $0x20,%esp
  80061f:	85 c0                	test   %eax,%eax
  800621:	78 31                	js     800654 <dup+0xd1>
		goto err;

	return newfdnum;
  800623:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800626:	89 d8                	mov    %ebx,%eax
  800628:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80062b:	5b                   	pop    %ebx
  80062c:	5e                   	pop    %esi
  80062d:	5f                   	pop    %edi
  80062e:	5d                   	pop    %ebp
  80062f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800630:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800637:	83 ec 0c             	sub    $0xc,%esp
  80063a:	25 07 0e 00 00       	and    $0xe07,%eax
  80063f:	50                   	push   %eax
  800640:	57                   	push   %edi
  800641:	6a 00                	push   $0x0
  800643:	53                   	push   %ebx
  800644:	6a 00                	push   $0x0
  800646:	e8 68 fb ff ff       	call   8001b3 <sys_page_map>
  80064b:	89 c3                	mov    %eax,%ebx
  80064d:	83 c4 20             	add    $0x20,%esp
  800650:	85 c0                	test   %eax,%eax
  800652:	79 a3                	jns    8005f7 <dup+0x74>
	sys_page_unmap(0, newfd);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	56                   	push   %esi
  800658:	6a 00                	push   $0x0
  80065a:	e8 96 fb ff ff       	call   8001f5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80065f:	83 c4 08             	add    $0x8,%esp
  800662:	57                   	push   %edi
  800663:	6a 00                	push   $0x0
  800665:	e8 8b fb ff ff       	call   8001f5 <sys_page_unmap>
	return r;
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	eb b7                	jmp    800626 <dup+0xa3>

0080066f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	53                   	push   %ebx
  800673:	83 ec 14             	sub    $0x14,%esp
  800676:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800679:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80067c:	50                   	push   %eax
  80067d:	53                   	push   %ebx
  80067e:	e8 7b fd ff ff       	call   8003fe <fd_lookup>
  800683:	83 c4 08             	add    $0x8,%esp
  800686:	85 c0                	test   %eax,%eax
  800688:	78 3f                	js     8006c9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800690:	50                   	push   %eax
  800691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800694:	ff 30                	pushl  (%eax)
  800696:	e8 b9 fd ff ff       	call   800454 <dev_lookup>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	85 c0                	test   %eax,%eax
  8006a0:	78 27                	js     8006c9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006a5:	8b 42 08             	mov    0x8(%edx),%eax
  8006a8:	83 e0 03             	and    $0x3,%eax
  8006ab:	83 f8 01             	cmp    $0x1,%eax
  8006ae:	74 1e                	je     8006ce <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b3:	8b 40 08             	mov    0x8(%eax),%eax
  8006b6:	85 c0                	test   %eax,%eax
  8006b8:	74 35                	je     8006ef <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006ba:	83 ec 04             	sub    $0x4,%esp
  8006bd:	ff 75 10             	pushl  0x10(%ebp)
  8006c0:	ff 75 0c             	pushl  0xc(%ebp)
  8006c3:	52                   	push   %edx
  8006c4:	ff d0                	call   *%eax
  8006c6:	83 c4 10             	add    $0x10,%esp
}
  8006c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006cc:	c9                   	leave  
  8006cd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ce:	a1 04 40 80 00       	mov    0x804004,%eax
  8006d3:	8b 40 48             	mov    0x48(%eax),%eax
  8006d6:	83 ec 04             	sub    $0x4,%esp
  8006d9:	53                   	push   %ebx
  8006da:	50                   	push   %eax
  8006db:	68 19 1e 80 00       	push   $0x801e19
  8006e0:	e8 39 0a 00 00       	call   80111e <cprintf>
		return -E_INVAL;
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ed:	eb da                	jmp    8006c9 <read+0x5a>
		return -E_NOT_SUPP;
  8006ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006f4:	eb d3                	jmp    8006c9 <read+0x5a>

008006f6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	57                   	push   %edi
  8006fa:	56                   	push   %esi
  8006fb:	53                   	push   %ebx
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800702:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800705:	bb 00 00 00 00       	mov    $0x0,%ebx
  80070a:	39 f3                	cmp    %esi,%ebx
  80070c:	73 25                	jae    800733 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80070e:	83 ec 04             	sub    $0x4,%esp
  800711:	89 f0                	mov    %esi,%eax
  800713:	29 d8                	sub    %ebx,%eax
  800715:	50                   	push   %eax
  800716:	89 d8                	mov    %ebx,%eax
  800718:	03 45 0c             	add    0xc(%ebp),%eax
  80071b:	50                   	push   %eax
  80071c:	57                   	push   %edi
  80071d:	e8 4d ff ff ff       	call   80066f <read>
		if (m < 0)
  800722:	83 c4 10             	add    $0x10,%esp
  800725:	85 c0                	test   %eax,%eax
  800727:	78 08                	js     800731 <readn+0x3b>
			return m;
		if (m == 0)
  800729:	85 c0                	test   %eax,%eax
  80072b:	74 06                	je     800733 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80072d:	01 c3                	add    %eax,%ebx
  80072f:	eb d9                	jmp    80070a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800731:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800733:	89 d8                	mov    %ebx,%eax
  800735:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800738:	5b                   	pop    %ebx
  800739:	5e                   	pop    %esi
  80073a:	5f                   	pop    %edi
  80073b:	5d                   	pop    %ebp
  80073c:	c3                   	ret    

0080073d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	53                   	push   %ebx
  800741:	83 ec 14             	sub    $0x14,%esp
  800744:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800747:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80074a:	50                   	push   %eax
  80074b:	53                   	push   %ebx
  80074c:	e8 ad fc ff ff       	call   8003fe <fd_lookup>
  800751:	83 c4 08             	add    $0x8,%esp
  800754:	85 c0                	test   %eax,%eax
  800756:	78 3a                	js     800792 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80075e:	50                   	push   %eax
  80075f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800762:	ff 30                	pushl  (%eax)
  800764:	e8 eb fc ff ff       	call   800454 <dev_lookup>
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	85 c0                	test   %eax,%eax
  80076e:	78 22                	js     800792 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800773:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800777:	74 1e                	je     800797 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800779:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077c:	8b 52 0c             	mov    0xc(%edx),%edx
  80077f:	85 d2                	test   %edx,%edx
  800781:	74 35                	je     8007b8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800783:	83 ec 04             	sub    $0x4,%esp
  800786:	ff 75 10             	pushl  0x10(%ebp)
  800789:	ff 75 0c             	pushl  0xc(%ebp)
  80078c:	50                   	push   %eax
  80078d:	ff d2                	call   *%edx
  80078f:	83 c4 10             	add    $0x10,%esp
}
  800792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800795:	c9                   	leave  
  800796:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800797:	a1 04 40 80 00       	mov    0x804004,%eax
  80079c:	8b 40 48             	mov    0x48(%eax),%eax
  80079f:	83 ec 04             	sub    $0x4,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	50                   	push   %eax
  8007a4:	68 35 1e 80 00       	push   $0x801e35
  8007a9:	e8 70 09 00 00       	call   80111e <cprintf>
		return -E_INVAL;
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b6:	eb da                	jmp    800792 <write+0x55>
		return -E_NOT_SUPP;
  8007b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007bd:	eb d3                	jmp    800792 <write+0x55>

008007bf <seek>:

int
seek(int fdnum, off_t offset)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007c5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8007c8:	50                   	push   %eax
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 2d fc ff ff       	call   8003fe <fd_lookup>
  8007d1:	83 c4 08             	add    $0x8,%esp
  8007d4:	85 c0                	test   %eax,%eax
  8007d6:	78 0e                	js     8007e6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007de:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	53                   	push   %ebx
  8007ec:	83 ec 14             	sub    $0x14,%esp
  8007ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007f5:	50                   	push   %eax
  8007f6:	53                   	push   %ebx
  8007f7:	e8 02 fc ff ff       	call   8003fe <fd_lookup>
  8007fc:	83 c4 08             	add    $0x8,%esp
  8007ff:	85 c0                	test   %eax,%eax
  800801:	78 37                	js     80083a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800809:	50                   	push   %eax
  80080a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080d:	ff 30                	pushl  (%eax)
  80080f:	e8 40 fc ff ff       	call   800454 <dev_lookup>
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	85 c0                	test   %eax,%eax
  800819:	78 1f                	js     80083a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800822:	74 1b                	je     80083f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800824:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800827:	8b 52 18             	mov    0x18(%edx),%edx
  80082a:	85 d2                	test   %edx,%edx
  80082c:	74 32                	je     800860 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	50                   	push   %eax
  800835:	ff d2                	call   *%edx
  800837:	83 c4 10             	add    $0x10,%esp
}
  80083a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80083d:	c9                   	leave  
  80083e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80083f:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800844:	8b 40 48             	mov    0x48(%eax),%eax
  800847:	83 ec 04             	sub    $0x4,%esp
  80084a:	53                   	push   %ebx
  80084b:	50                   	push   %eax
  80084c:	68 f8 1d 80 00       	push   $0x801df8
  800851:	e8 c8 08 00 00       	call   80111e <cprintf>
		return -E_INVAL;
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085e:	eb da                	jmp    80083a <ftruncate+0x52>
		return -E_NOT_SUPP;
  800860:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800865:	eb d3                	jmp    80083a <ftruncate+0x52>

00800867 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	83 ec 14             	sub    $0x14,%esp
  80086e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800871:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800874:	50                   	push   %eax
  800875:	ff 75 08             	pushl  0x8(%ebp)
  800878:	e8 81 fb ff ff       	call   8003fe <fd_lookup>
  80087d:	83 c4 08             	add    $0x8,%esp
  800880:	85 c0                	test   %eax,%eax
  800882:	78 4b                	js     8008cf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80088a:	50                   	push   %eax
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088e:	ff 30                	pushl  (%eax)
  800890:	e8 bf fb ff ff       	call   800454 <dev_lookup>
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	85 c0                	test   %eax,%eax
  80089a:	78 33                	js     8008cf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80089c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008a3:	74 2f                	je     8008d4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8008a5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8008a8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8008af:	00 00 00 
	stat->st_isdir = 0;
  8008b2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008b9:	00 00 00 
	stat->st_dev = dev;
  8008bc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8008c9:	ff 50 14             	call   *0x14(%eax)
  8008cc:	83 c4 10             	add    $0x10,%esp
}
  8008cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d2:	c9                   	leave  
  8008d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8008d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008d9:	eb f4                	jmp    8008cf <fstat+0x68>

008008db <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	56                   	push   %esi
  8008df:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	6a 00                	push   $0x0
  8008e5:	ff 75 08             	pushl  0x8(%ebp)
  8008e8:	e8 e7 01 00 00       	call   800ad4 <open>
  8008ed:	89 c3                	mov    %eax,%ebx
  8008ef:	83 c4 10             	add    $0x10,%esp
  8008f2:	85 c0                	test   %eax,%eax
  8008f4:	78 1b                	js     800911 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	ff 75 0c             	pushl  0xc(%ebp)
  8008fc:	50                   	push   %eax
  8008fd:	e8 65 ff ff ff       	call   800867 <fstat>
  800902:	89 c6                	mov    %eax,%esi
	close(fd);
  800904:	89 1c 24             	mov    %ebx,(%esp)
  800907:	e8 27 fc ff ff       	call   800533 <close>
	return r;
  80090c:	83 c4 10             	add    $0x10,%esp
  80090f:	89 f3                	mov    %esi,%ebx
}
  800911:	89 d8                	mov    %ebx,%eax
  800913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800916:	5b                   	pop    %ebx
  800917:	5e                   	pop    %esi
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	56                   	push   %esi
  80091e:	53                   	push   %ebx
  80091f:	89 c6                	mov    %eax,%esi
  800921:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800923:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80092a:	74 27                	je     800953 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80092c:	6a 07                	push   $0x7
  80092e:	68 00 50 80 00       	push   $0x805000
  800933:	56                   	push   %esi
  800934:	ff 35 00 40 80 00    	pushl  0x804000
  80093a:	e8 91 11 00 00       	call   801ad0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80093f:	83 c4 0c             	add    $0xc,%esp
  800942:	6a 00                	push   $0x0
  800944:	53                   	push   %ebx
  800945:	6a 00                	push   $0x0
  800947:	e8 6d 11 00 00       	call   801ab9 <ipc_recv>
}
  80094c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80094f:	5b                   	pop    %ebx
  800950:	5e                   	pop    %esi
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800953:	83 ec 0c             	sub    $0xc,%esp
  800956:	6a 01                	push   $0x1
  800958:	e8 8a 11 00 00       	call   801ae7 <ipc_find_env>
  80095d:	a3 00 40 80 00       	mov    %eax,0x804000
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	eb c5                	jmp    80092c <fsipc+0x12>

00800967 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 40 0c             	mov    0xc(%eax),%eax
  800973:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
  800985:	b8 02 00 00 00       	mov    $0x2,%eax
  80098a:	e8 8b ff ff ff       	call   80091a <fsipc>
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <devfile_flush>:
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 40 0c             	mov    0xc(%eax),%eax
  80099d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8009a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a7:	b8 06 00 00 00       	mov    $0x6,%eax
  8009ac:	e8 69 ff ff ff       	call   80091a <fsipc>
}
  8009b1:	c9                   	leave  
  8009b2:	c3                   	ret    

008009b3 <devfile_stat>:
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	53                   	push   %ebx
  8009b7:	83 ec 04             	sub    $0x4,%esp
  8009ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8009c3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cd:	b8 05 00 00 00       	mov    $0x5,%eax
  8009d2:	e8 43 ff ff ff       	call   80091a <fsipc>
  8009d7:	85 c0                	test   %eax,%eax
  8009d9:	78 2c                	js     800a07 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	68 00 50 80 00       	push   $0x805000
  8009e3:	53                   	push   %ebx
  8009e4:	e8 1f 0d 00 00       	call   801708 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009e9:	a1 80 50 80 00       	mov    0x805080,%eax
  8009ee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009f4:	a1 84 50 80 00       	mov    0x805084,%eax
  8009f9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ff:	83 c4 10             	add    $0x10,%esp
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <devfile_write>:
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 0c             	sub    $0xc,%esp
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
  800a15:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800a1a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800a1f:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a22:	8b 55 08             	mov    0x8(%ebp),%edx
  800a25:	8b 52 0c             	mov    0xc(%edx),%edx
  800a28:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  800a2e:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	68 08 50 80 00       	push   $0x805008
  800a3c:	e8 55 0e 00 00       	call   801896 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a41:	ba 00 00 00 00       	mov    $0x0,%edx
  800a46:	b8 04 00 00 00       	mov    $0x4,%eax
  800a4b:	e8 ca fe ff ff       	call   80091a <fsipc>
}
  800a50:	c9                   	leave  
  800a51:	c3                   	ret    

00800a52 <devfile_read>:
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	56                   	push   %esi
  800a56:	53                   	push   %ebx
  800a57:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8b 40 0c             	mov    0xc(%eax),%eax
  800a60:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a65:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a70:	b8 03 00 00 00       	mov    $0x3,%eax
  800a75:	e8 a0 fe ff ff       	call   80091a <fsipc>
  800a7a:	89 c3                	mov    %eax,%ebx
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	78 1f                	js     800a9f <devfile_read+0x4d>
	assert(r <= n);
  800a80:	39 f0                	cmp    %esi,%eax
  800a82:	77 24                	ja     800aa8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a84:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a89:	7f 33                	jg     800abe <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a8b:	83 ec 04             	sub    $0x4,%esp
  800a8e:	50                   	push   %eax
  800a8f:	68 00 50 80 00       	push   $0x805000
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	e8 fa 0d 00 00       	call   801896 <memmove>
	return r;
  800a9c:	83 c4 10             	add    $0x10,%esp
}
  800a9f:	89 d8                	mov    %ebx,%eax
  800aa1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aa4:	5b                   	pop    %ebx
  800aa5:	5e                   	pop    %esi
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    
	assert(r <= n);
  800aa8:	68 64 1e 80 00       	push   $0x801e64
  800aad:	68 6b 1e 80 00       	push   $0x801e6b
  800ab2:	6a 7c                	push   $0x7c
  800ab4:	68 80 1e 80 00       	push   $0x801e80
  800ab9:	e8 85 05 00 00       	call   801043 <_panic>
	assert(r <= PGSIZE);
  800abe:	68 8b 1e 80 00       	push   $0x801e8b
  800ac3:	68 6b 1e 80 00       	push   $0x801e6b
  800ac8:	6a 7d                	push   $0x7d
  800aca:	68 80 1e 80 00       	push   $0x801e80
  800acf:	e8 6f 05 00 00       	call   801043 <_panic>

00800ad4 <open>:
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	56                   	push   %esi
  800ad8:	53                   	push   %ebx
  800ad9:	83 ec 1c             	sub    $0x1c,%esp
  800adc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800adf:	56                   	push   %esi
  800ae0:	e8 ec 0b 00 00       	call   8016d1 <strlen>
  800ae5:	83 c4 10             	add    $0x10,%esp
  800ae8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800aed:	7f 6c                	jg     800b5b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800aef:	83 ec 0c             	sub    $0xc,%esp
  800af2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800af5:	50                   	push   %eax
  800af6:	e8 b4 f8 ff ff       	call   8003af <fd_alloc>
  800afb:	89 c3                	mov    %eax,%ebx
  800afd:	83 c4 10             	add    $0x10,%esp
  800b00:	85 c0                	test   %eax,%eax
  800b02:	78 3c                	js     800b40 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	56                   	push   %esi
  800b08:	68 00 50 80 00       	push   $0x805000
  800b0d:	e8 f6 0b 00 00       	call   801708 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b22:	e8 f3 fd ff ff       	call   80091a <fsipc>
  800b27:	89 c3                	mov    %eax,%ebx
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	85 c0                	test   %eax,%eax
  800b2e:	78 19                	js     800b49 <open+0x75>
	return fd2num(fd);
  800b30:	83 ec 0c             	sub    $0xc,%esp
  800b33:	ff 75 f4             	pushl  -0xc(%ebp)
  800b36:	e8 4d f8 ff ff       	call   800388 <fd2num>
  800b3b:	89 c3                	mov    %eax,%ebx
  800b3d:	83 c4 10             	add    $0x10,%esp
}
  800b40:	89 d8                	mov    %ebx,%eax
  800b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    
		fd_close(fd, 0);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	6a 00                	push   $0x0
  800b4e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b51:	e8 54 f9 ff ff       	call   8004aa <fd_close>
		return r;
  800b56:	83 c4 10             	add    $0x10,%esp
  800b59:	eb e5                	jmp    800b40 <open+0x6c>
		return -E_BAD_PATH;
  800b5b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b60:	eb de                	jmp    800b40 <open+0x6c>

00800b62 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b68:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6d:	b8 08 00 00 00       	mov    $0x8,%eax
  800b72:	e8 a3 fd ff ff       	call   80091a <fsipc>
}
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	56                   	push   %esi
  800b7d:	53                   	push   %ebx
  800b7e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b81:	83 ec 0c             	sub    $0xc,%esp
  800b84:	ff 75 08             	pushl  0x8(%ebp)
  800b87:	e8 0c f8 ff ff       	call   800398 <fd2data>
  800b8c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b8e:	83 c4 08             	add    $0x8,%esp
  800b91:	68 97 1e 80 00       	push   $0x801e97
  800b96:	53                   	push   %ebx
  800b97:	e8 6c 0b 00 00       	call   801708 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b9c:	8b 46 04             	mov    0x4(%esi),%eax
  800b9f:	2b 06                	sub    (%esi),%eax
  800ba1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800ba7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bae:	00 00 00 
	stat->st_dev = &devpipe;
  800bb1:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800bb8:	30 80 00 
	return 0;
}
  800bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	53                   	push   %ebx
  800bcb:	83 ec 0c             	sub    $0xc,%esp
  800bce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bd1:	53                   	push   %ebx
  800bd2:	6a 00                	push   $0x0
  800bd4:	e8 1c f6 ff ff       	call   8001f5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800bd9:	89 1c 24             	mov    %ebx,(%esp)
  800bdc:	e8 b7 f7 ff ff       	call   800398 <fd2data>
  800be1:	83 c4 08             	add    $0x8,%esp
  800be4:	50                   	push   %eax
  800be5:	6a 00                	push   $0x0
  800be7:	e8 09 f6 ff ff       	call   8001f5 <sys_page_unmap>
}
  800bec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <_pipeisclosed>:
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
  800bf7:	83 ec 1c             	sub    $0x1c,%esp
  800bfa:	89 c7                	mov    %eax,%edi
  800bfc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800bfe:	a1 04 40 80 00       	mov    0x804004,%eax
  800c03:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c06:	83 ec 0c             	sub    $0xc,%esp
  800c09:	57                   	push   %edi
  800c0a:	e8 11 0f 00 00       	call   801b20 <pageref>
  800c0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c12:	89 34 24             	mov    %esi,(%esp)
  800c15:	e8 06 0f 00 00       	call   801b20 <pageref>
		nn = thisenv->env_runs;
  800c1a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800c20:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c23:	83 c4 10             	add    $0x10,%esp
  800c26:	39 cb                	cmp    %ecx,%ebx
  800c28:	74 1b                	je     800c45 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c2a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c2d:	75 cf                	jne    800bfe <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c2f:	8b 42 58             	mov    0x58(%edx),%eax
  800c32:	6a 01                	push   $0x1
  800c34:	50                   	push   %eax
  800c35:	53                   	push   %ebx
  800c36:	68 9e 1e 80 00       	push   $0x801e9e
  800c3b:	e8 de 04 00 00       	call   80111e <cprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	eb b9                	jmp    800bfe <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c45:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c48:	0f 94 c0             	sete   %al
  800c4b:	0f b6 c0             	movzbl %al,%eax
}
  800c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <devpipe_write>:
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	57                   	push   %edi
  800c5a:	56                   	push   %esi
  800c5b:	53                   	push   %ebx
  800c5c:	83 ec 28             	sub    $0x28,%esp
  800c5f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c62:	56                   	push   %esi
  800c63:	e8 30 f7 ff ff       	call   800398 <fd2data>
  800c68:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c72:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c75:	74 4f                	je     800cc6 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c77:	8b 43 04             	mov    0x4(%ebx),%eax
  800c7a:	8b 0b                	mov    (%ebx),%ecx
  800c7c:	8d 51 20             	lea    0x20(%ecx),%edx
  800c7f:	39 d0                	cmp    %edx,%eax
  800c81:	72 14                	jb     800c97 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800c83:	89 da                	mov    %ebx,%edx
  800c85:	89 f0                	mov    %esi,%eax
  800c87:	e8 65 ff ff ff       	call   800bf1 <_pipeisclosed>
  800c8c:	85 c0                	test   %eax,%eax
  800c8e:	75 3a                	jne    800cca <devpipe_write+0x74>
			sys_yield();
  800c90:	e8 bc f4 ff ff       	call   800151 <sys_yield>
  800c95:	eb e0                	jmp    800c77 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800ca1:	89 c2                	mov    %eax,%edx
  800ca3:	c1 fa 1f             	sar    $0x1f,%edx
  800ca6:	89 d1                	mov    %edx,%ecx
  800ca8:	c1 e9 1b             	shr    $0x1b,%ecx
  800cab:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cae:	83 e2 1f             	and    $0x1f,%edx
  800cb1:	29 ca                	sub    %ecx,%edx
  800cb3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cb7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cbb:	83 c0 01             	add    $0x1,%eax
  800cbe:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cc1:	83 c7 01             	add    $0x1,%edi
  800cc4:	eb ac                	jmp    800c72 <devpipe_write+0x1c>
	return i;
  800cc6:	89 f8                	mov    %edi,%eax
  800cc8:	eb 05                	jmp    800ccf <devpipe_write+0x79>
				return 0;
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <devpipe_read>:
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 18             	sub    $0x18,%esp
  800ce0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800ce3:	57                   	push   %edi
  800ce4:	e8 af f6 ff ff       	call   800398 <fd2data>
  800ce9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800ceb:	83 c4 10             	add    $0x10,%esp
  800cee:	be 00 00 00 00       	mov    $0x0,%esi
  800cf3:	3b 75 10             	cmp    0x10(%ebp),%esi
  800cf6:	74 47                	je     800d3f <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800cf8:	8b 03                	mov    (%ebx),%eax
  800cfa:	3b 43 04             	cmp    0x4(%ebx),%eax
  800cfd:	75 22                	jne    800d21 <devpipe_read+0x4a>
			if (i > 0)
  800cff:	85 f6                	test   %esi,%esi
  800d01:	75 14                	jne    800d17 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800d03:	89 da                	mov    %ebx,%edx
  800d05:	89 f8                	mov    %edi,%eax
  800d07:	e8 e5 fe ff ff       	call   800bf1 <_pipeisclosed>
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	75 33                	jne    800d43 <devpipe_read+0x6c>
			sys_yield();
  800d10:	e8 3c f4 ff ff       	call   800151 <sys_yield>
  800d15:	eb e1                	jmp    800cf8 <devpipe_read+0x21>
				return i;
  800d17:	89 f0                	mov    %esi,%eax
}
  800d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d21:	99                   	cltd   
  800d22:	c1 ea 1b             	shr    $0x1b,%edx
  800d25:	01 d0                	add    %edx,%eax
  800d27:	83 e0 1f             	and    $0x1f,%eax
  800d2a:	29 d0                	sub    %edx,%eax
  800d2c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d34:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d37:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d3a:	83 c6 01             	add    $0x1,%esi
  800d3d:	eb b4                	jmp    800cf3 <devpipe_read+0x1c>
	return i;
  800d3f:	89 f0                	mov    %esi,%eax
  800d41:	eb d6                	jmp    800d19 <devpipe_read+0x42>
				return 0;
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
  800d48:	eb cf                	jmp    800d19 <devpipe_read+0x42>

00800d4a <pipe>:
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d55:	50                   	push   %eax
  800d56:	e8 54 f6 ff ff       	call   8003af <fd_alloc>
  800d5b:	89 c3                	mov    %eax,%ebx
  800d5d:	83 c4 10             	add    $0x10,%esp
  800d60:	85 c0                	test   %eax,%eax
  800d62:	78 5b                	js     800dbf <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d64:	83 ec 04             	sub    $0x4,%esp
  800d67:	68 07 04 00 00       	push   $0x407
  800d6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6f:	6a 00                	push   $0x0
  800d71:	e8 fa f3 ff ff       	call   800170 <sys_page_alloc>
  800d76:	89 c3                	mov    %eax,%ebx
  800d78:	83 c4 10             	add    $0x10,%esp
  800d7b:	85 c0                	test   %eax,%eax
  800d7d:	78 40                	js     800dbf <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800d7f:	83 ec 0c             	sub    $0xc,%esp
  800d82:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d85:	50                   	push   %eax
  800d86:	e8 24 f6 ff ff       	call   8003af <fd_alloc>
  800d8b:	89 c3                	mov    %eax,%ebx
  800d8d:	83 c4 10             	add    $0x10,%esp
  800d90:	85 c0                	test   %eax,%eax
  800d92:	78 1b                	js     800daf <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 07 04 00 00       	push   $0x407
  800d9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800d9f:	6a 00                	push   $0x0
  800da1:	e8 ca f3 ff ff       	call   800170 <sys_page_alloc>
  800da6:	89 c3                	mov    %eax,%ebx
  800da8:	83 c4 10             	add    $0x10,%esp
  800dab:	85 c0                	test   %eax,%eax
  800dad:	79 19                	jns    800dc8 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800daf:	83 ec 08             	sub    $0x8,%esp
  800db2:	ff 75 f4             	pushl  -0xc(%ebp)
  800db5:	6a 00                	push   $0x0
  800db7:	e8 39 f4 ff ff       	call   8001f5 <sys_page_unmap>
  800dbc:	83 c4 10             	add    $0x10,%esp
}
  800dbf:	89 d8                	mov    %ebx,%eax
  800dc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    
	va = fd2data(fd0);
  800dc8:	83 ec 0c             	sub    $0xc,%esp
  800dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dce:	e8 c5 f5 ff ff       	call   800398 <fd2data>
  800dd3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd5:	83 c4 0c             	add    $0xc,%esp
  800dd8:	68 07 04 00 00       	push   $0x407
  800ddd:	50                   	push   %eax
  800dde:	6a 00                	push   $0x0
  800de0:	e8 8b f3 ff ff       	call   800170 <sys_page_alloc>
  800de5:	89 c3                	mov    %eax,%ebx
  800de7:	83 c4 10             	add    $0x10,%esp
  800dea:	85 c0                	test   %eax,%eax
  800dec:	0f 88 8c 00 00 00    	js     800e7e <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	ff 75 f0             	pushl  -0x10(%ebp)
  800df8:	e8 9b f5 ff ff       	call   800398 <fd2data>
  800dfd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e04:	50                   	push   %eax
  800e05:	6a 00                	push   $0x0
  800e07:	56                   	push   %esi
  800e08:	6a 00                	push   $0x0
  800e0a:	e8 a4 f3 ff ff       	call   8001b3 <sys_page_map>
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	83 c4 20             	add    $0x20,%esp
  800e14:	85 c0                	test   %eax,%eax
  800e16:	78 58                	js     800e70 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e1b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e21:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e30:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e36:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e42:	83 ec 0c             	sub    $0xc,%esp
  800e45:	ff 75 f4             	pushl  -0xc(%ebp)
  800e48:	e8 3b f5 ff ff       	call   800388 <fd2num>
  800e4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e50:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e52:	83 c4 04             	add    $0x4,%esp
  800e55:	ff 75 f0             	pushl  -0x10(%ebp)
  800e58:	e8 2b f5 ff ff       	call   800388 <fd2num>
  800e5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e60:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e63:	83 c4 10             	add    $0x10,%esp
  800e66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6b:	e9 4f ff ff ff       	jmp    800dbf <pipe+0x75>
	sys_page_unmap(0, va);
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	56                   	push   %esi
  800e74:	6a 00                	push   $0x0
  800e76:	e8 7a f3 ff ff       	call   8001f5 <sys_page_unmap>
  800e7b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e7e:	83 ec 08             	sub    $0x8,%esp
  800e81:	ff 75 f0             	pushl  -0x10(%ebp)
  800e84:	6a 00                	push   $0x0
  800e86:	e8 6a f3 ff ff       	call   8001f5 <sys_page_unmap>
  800e8b:	83 c4 10             	add    $0x10,%esp
  800e8e:	e9 1c ff ff ff       	jmp    800daf <pipe+0x65>

00800e93 <pipeisclosed>:
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e9c:	50                   	push   %eax
  800e9d:	ff 75 08             	pushl  0x8(%ebp)
  800ea0:	e8 59 f5 ff ff       	call   8003fe <fd_lookup>
  800ea5:	83 c4 10             	add    $0x10,%esp
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	78 18                	js     800ec4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800eac:	83 ec 0c             	sub    $0xc,%esp
  800eaf:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb2:	e8 e1 f4 ff ff       	call   800398 <fd2data>
	return _pipeisclosed(fd, p);
  800eb7:	89 c2                	mov    %eax,%edx
  800eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebc:	e8 30 fd ff ff       	call   800bf1 <_pipeisclosed>
  800ec1:	83 c4 10             	add    $0x10,%esp
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800ed6:	68 b6 1e 80 00       	push   $0x801eb6
  800edb:	ff 75 0c             	pushl  0xc(%ebp)
  800ede:	e8 25 08 00 00       	call   801708 <strcpy>
	return 0;
}
  800ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee8:	c9                   	leave  
  800ee9:	c3                   	ret    

00800eea <devcons_write>:
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
  800ef0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800ef6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800efb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800f01:	eb 2f                	jmp    800f32 <devcons_write+0x48>
		m = n - tot;
  800f03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f06:	29 f3                	sub    %esi,%ebx
  800f08:	83 fb 7f             	cmp    $0x7f,%ebx
  800f0b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800f10:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800f13:	83 ec 04             	sub    $0x4,%esp
  800f16:	53                   	push   %ebx
  800f17:	89 f0                	mov    %esi,%eax
  800f19:	03 45 0c             	add    0xc(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	57                   	push   %edi
  800f1e:	e8 73 09 00 00       	call   801896 <memmove>
		sys_cputs(buf, m);
  800f23:	83 c4 08             	add    $0x8,%esp
  800f26:	53                   	push   %ebx
  800f27:	57                   	push   %edi
  800f28:	e8 87 f1 ff ff       	call   8000b4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800f2d:	01 de                	add    %ebx,%esi
  800f2f:	83 c4 10             	add    $0x10,%esp
  800f32:	3b 75 10             	cmp    0x10(%ebp),%esi
  800f35:	72 cc                	jb     800f03 <devcons_write+0x19>
}
  800f37:	89 f0                	mov    %esi,%eax
  800f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <devcons_read>:
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <devcons_read+0x18>
}
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    
		sys_yield();
  800f54:	e8 f8 f1 ff ff       	call   800151 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800f59:	e8 74 f1 ff ff       	call   8000d2 <sys_cgetc>
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	74 f2                	je     800f54 <devcons_read+0x13>
	if (c < 0)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	78 ec                	js     800f52 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  800f66:	83 f8 04             	cmp    $0x4,%eax
  800f69:	74 0c                	je     800f77 <devcons_read+0x36>
	*(char*)vbuf = c;
  800f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6e:	88 02                	mov    %al,(%edx)
	return 1;
  800f70:	b8 01 00 00 00       	mov    $0x1,%eax
  800f75:	eb db                	jmp    800f52 <devcons_read+0x11>
		return 0;
  800f77:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7c:	eb d4                	jmp    800f52 <devcons_read+0x11>

00800f7e <cputchar>:
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800f8a:	6a 01                	push   $0x1
  800f8c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f8f:	50                   	push   %eax
  800f90:	e8 1f f1 ff ff       	call   8000b4 <sys_cputs>
}
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <getchar>:
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800fa0:	6a 01                	push   $0x1
  800fa2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800fa5:	50                   	push   %eax
  800fa6:	6a 00                	push   $0x0
  800fa8:	e8 c2 f6 ff ff       	call   80066f <read>
	if (r < 0)
  800fad:	83 c4 10             	add    $0x10,%esp
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	78 08                	js     800fbc <getchar+0x22>
	if (r < 1)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7e 06                	jle    800fbe <getchar+0x24>
	return c;
  800fb8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    
		return -E_EOF;
  800fbe:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800fc3:	eb f7                	jmp    800fbc <getchar+0x22>

00800fc5 <iscons>:
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fce:	50                   	push   %eax
  800fcf:	ff 75 08             	pushl  0x8(%ebp)
  800fd2:	e8 27 f4 ff ff       	call   8003fe <fd_lookup>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	78 11                	js     800fef <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fe7:	39 10                	cmp    %edx,(%eax)
  800fe9:	0f 94 c0             	sete   %al
  800fec:	0f b6 c0             	movzbl %al,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <opencons>:
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800ff7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ffa:	50                   	push   %eax
  800ffb:	e8 af f3 ff ff       	call   8003af <fd_alloc>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	85 c0                	test   %eax,%eax
  801005:	78 3a                	js     801041 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801007:	83 ec 04             	sub    $0x4,%esp
  80100a:	68 07 04 00 00       	push   $0x407
  80100f:	ff 75 f4             	pushl  -0xc(%ebp)
  801012:	6a 00                	push   $0x0
  801014:	e8 57 f1 ff ff       	call   800170 <sys_page_alloc>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	78 21                	js     801041 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801023:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801029:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801035:	83 ec 0c             	sub    $0xc,%esp
  801038:	50                   	push   %eax
  801039:	e8 4a f3 ff ff       	call   800388 <fd2num>
  80103e:	83 c4 10             	add    $0x10,%esp
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801048:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80104b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801051:	e8 dc f0 ff ff       	call   800132 <sys_getenvid>
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	56                   	push   %esi
  801060:	50                   	push   %eax
  801061:	68 c4 1e 80 00       	push   $0x801ec4
  801066:	e8 b3 00 00 00       	call   80111e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80106b:	83 c4 18             	add    $0x18,%esp
  80106e:	53                   	push   %ebx
  80106f:	ff 75 10             	pushl  0x10(%ebp)
  801072:	e8 56 00 00 00       	call   8010cd <vcprintf>
	cprintf("\n");
  801077:	c7 04 24 af 1e 80 00 	movl   $0x801eaf,(%esp)
  80107e:	e8 9b 00 00 00       	call   80111e <cprintf>
  801083:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801086:	cc                   	int3   
  801087:	eb fd                	jmp    801086 <_panic+0x43>

00801089 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	53                   	push   %ebx
  80108d:	83 ec 04             	sub    $0x4,%esp
  801090:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801093:	8b 13                	mov    (%ebx),%edx
  801095:	8d 42 01             	lea    0x1(%edx),%eax
  801098:	89 03                	mov    %eax,(%ebx)
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8010a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010a6:	74 09                	je     8010b1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8010a8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8010ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8010b1:	83 ec 08             	sub    $0x8,%esp
  8010b4:	68 ff 00 00 00       	push   $0xff
  8010b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8010bc:	50                   	push   %eax
  8010bd:	e8 f2 ef ff ff       	call   8000b4 <sys_cputs>
		b->idx = 0;
  8010c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8010c8:	83 c4 10             	add    $0x10,%esp
  8010cb:	eb db                	jmp    8010a8 <putch+0x1f>

008010cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8010d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8010dd:	00 00 00 
	b.cnt = 0;
  8010e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8010e7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8010ea:	ff 75 0c             	pushl  0xc(%ebp)
  8010ed:	ff 75 08             	pushl  0x8(%ebp)
  8010f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8010f6:	50                   	push   %eax
  8010f7:	68 89 10 80 00       	push   $0x801089
  8010fc:	e8 1a 01 00 00       	call   80121b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801101:	83 c4 08             	add    $0x8,%esp
  801104:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80110a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801110:	50                   	push   %eax
  801111:	e8 9e ef ff ff       	call   8000b4 <sys_cputs>

	return b.cnt;
}
  801116:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801124:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801127:	50                   	push   %eax
  801128:	ff 75 08             	pushl  0x8(%ebp)
  80112b:	e8 9d ff ff ff       	call   8010cd <vcprintf>
	va_end(ap);

	return cnt;
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
  801138:	83 ec 1c             	sub    $0x1c,%esp
  80113b:	89 c7                	mov    %eax,%edi
  80113d:	89 d6                	mov    %edx,%esi
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8b 55 0c             	mov    0xc(%ebp),%edx
  801145:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801148:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80114b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80114e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801153:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801156:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801159:	39 d3                	cmp    %edx,%ebx
  80115b:	72 05                	jb     801162 <printnum+0x30>
  80115d:	39 45 10             	cmp    %eax,0x10(%ebp)
  801160:	77 7a                	ja     8011dc <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	ff 75 18             	pushl  0x18(%ebp)
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80116e:	53                   	push   %ebx
  80116f:	ff 75 10             	pushl  0x10(%ebp)
  801172:	83 ec 08             	sub    $0x8,%esp
  801175:	ff 75 e4             	pushl  -0x1c(%ebp)
  801178:	ff 75 e0             	pushl  -0x20(%ebp)
  80117b:	ff 75 dc             	pushl  -0x24(%ebp)
  80117e:	ff 75 d8             	pushl  -0x28(%ebp)
  801181:	e8 da 09 00 00       	call   801b60 <__udivdi3>
  801186:	83 c4 18             	add    $0x18,%esp
  801189:	52                   	push   %edx
  80118a:	50                   	push   %eax
  80118b:	89 f2                	mov    %esi,%edx
  80118d:	89 f8                	mov    %edi,%eax
  80118f:	e8 9e ff ff ff       	call   801132 <printnum>
  801194:	83 c4 20             	add    $0x20,%esp
  801197:	eb 13                	jmp    8011ac <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	56                   	push   %esi
  80119d:	ff 75 18             	pushl  0x18(%ebp)
  8011a0:	ff d7                	call   *%edi
  8011a2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8011a5:	83 eb 01             	sub    $0x1,%ebx
  8011a8:	85 db                	test   %ebx,%ebx
  8011aa:	7f ed                	jg     801199 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	56                   	push   %esi
  8011b0:	83 ec 04             	sub    $0x4,%esp
  8011b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8011b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8011bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8011bf:	e8 bc 0a 00 00       	call   801c80 <__umoddi3>
  8011c4:	83 c4 14             	add    $0x14,%esp
  8011c7:	0f be 80 e7 1e 80 00 	movsbl 0x801ee7(%eax),%eax
  8011ce:	50                   	push   %eax
  8011cf:	ff d7                	call   *%edi
}
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5f                   	pop    %edi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    
  8011dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011df:	eb c4                	jmp    8011a5 <printnum+0x73>

008011e1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011e7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011eb:	8b 10                	mov    (%eax),%edx
  8011ed:	3b 50 04             	cmp    0x4(%eax),%edx
  8011f0:	73 0a                	jae    8011fc <sprintputch+0x1b>
		*b->buf++ = ch;
  8011f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f5:	89 08                	mov    %ecx,(%eax)
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	88 02                	mov    %al,(%edx)
}
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <printfmt>:
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801204:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801207:	50                   	push   %eax
  801208:	ff 75 10             	pushl  0x10(%ebp)
  80120b:	ff 75 0c             	pushl  0xc(%ebp)
  80120e:	ff 75 08             	pushl  0x8(%ebp)
  801211:	e8 05 00 00 00       	call   80121b <vprintfmt>
}
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <vprintfmt>:
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	57                   	push   %edi
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
  801221:	83 ec 2c             	sub    $0x2c,%esp
  801224:	8b 75 08             	mov    0x8(%ebp),%esi
  801227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80122a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80122d:	e9 8c 03 00 00       	jmp    8015be <vprintfmt+0x3a3>
		padc = ' ';
  801232:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801236:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80123d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801244:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80124b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801250:	8d 47 01             	lea    0x1(%edi),%eax
  801253:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801256:	0f b6 17             	movzbl (%edi),%edx
  801259:	8d 42 dd             	lea    -0x23(%edx),%eax
  80125c:	3c 55                	cmp    $0x55,%al
  80125e:	0f 87 dd 03 00 00    	ja     801641 <vprintfmt+0x426>
  801264:	0f b6 c0             	movzbl %al,%eax
  801267:	ff 24 85 20 20 80 00 	jmp    *0x802020(,%eax,4)
  80126e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801271:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801275:	eb d9                	jmp    801250 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801277:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80127a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80127e:	eb d0                	jmp    801250 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801280:	0f b6 d2             	movzbl %dl,%edx
  801283:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801286:	b8 00 00 00 00       	mov    $0x0,%eax
  80128b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80128e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801291:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801295:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801298:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80129b:	83 f9 09             	cmp    $0x9,%ecx
  80129e:	77 55                	ja     8012f5 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8012a0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8012a3:	eb e9                	jmp    80128e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8012a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a8:	8b 00                	mov    (%eax),%eax
  8012aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8012ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b0:	8d 40 04             	lea    0x4(%eax),%eax
  8012b3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8012b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8012b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012bd:	79 91                	jns    801250 <vprintfmt+0x35>
				width = precision, precision = -1;
  8012bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012c5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8012cc:	eb 82                	jmp    801250 <vprintfmt+0x35>
  8012ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d8:	0f 49 d0             	cmovns %eax,%edx
  8012db:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8012de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012e1:	e9 6a ff ff ff       	jmp    801250 <vprintfmt+0x35>
  8012e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8012e9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012f0:	e9 5b ff ff ff       	jmp    801250 <vprintfmt+0x35>
  8012f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8012f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8012fb:	eb bc                	jmp    8012b9 <vprintfmt+0x9e>
			lflag++;
  8012fd:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801303:	e9 48 ff ff ff       	jmp    801250 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801308:	8b 45 14             	mov    0x14(%ebp),%eax
  80130b:	8d 78 04             	lea    0x4(%eax),%edi
  80130e:	83 ec 08             	sub    $0x8,%esp
  801311:	53                   	push   %ebx
  801312:	ff 30                	pushl  (%eax)
  801314:	ff d6                	call   *%esi
			break;
  801316:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801319:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80131c:	e9 9a 02 00 00       	jmp    8015bb <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  801321:	8b 45 14             	mov    0x14(%ebp),%eax
  801324:	8d 78 04             	lea    0x4(%eax),%edi
  801327:	8b 00                	mov    (%eax),%eax
  801329:	99                   	cltd   
  80132a:	31 d0                	xor    %edx,%eax
  80132c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80132e:	83 f8 0f             	cmp    $0xf,%eax
  801331:	7f 23                	jg     801356 <vprintfmt+0x13b>
  801333:	8b 14 85 80 21 80 00 	mov    0x802180(,%eax,4),%edx
  80133a:	85 d2                	test   %edx,%edx
  80133c:	74 18                	je     801356 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80133e:	52                   	push   %edx
  80133f:	68 7d 1e 80 00       	push   $0x801e7d
  801344:	53                   	push   %ebx
  801345:	56                   	push   %esi
  801346:	e8 b3 fe ff ff       	call   8011fe <printfmt>
  80134b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80134e:	89 7d 14             	mov    %edi,0x14(%ebp)
  801351:	e9 65 02 00 00       	jmp    8015bb <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  801356:	50                   	push   %eax
  801357:	68 ff 1e 80 00       	push   $0x801eff
  80135c:	53                   	push   %ebx
  80135d:	56                   	push   %esi
  80135e:	e8 9b fe ff ff       	call   8011fe <printfmt>
  801363:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801366:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801369:	e9 4d 02 00 00       	jmp    8015bb <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80136e:	8b 45 14             	mov    0x14(%ebp),%eax
  801371:	83 c0 04             	add    $0x4,%eax
  801374:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801377:	8b 45 14             	mov    0x14(%ebp),%eax
  80137a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80137c:	85 ff                	test   %edi,%edi
  80137e:	b8 f8 1e 80 00       	mov    $0x801ef8,%eax
  801383:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801386:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80138a:	0f 8e bd 00 00 00    	jle    80144d <vprintfmt+0x232>
  801390:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801394:	75 0e                	jne    8013a4 <vprintfmt+0x189>
  801396:	89 75 08             	mov    %esi,0x8(%ebp)
  801399:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80139c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80139f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8013a2:	eb 6d                	jmp    801411 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	ff 75 d0             	pushl  -0x30(%ebp)
  8013aa:	57                   	push   %edi
  8013ab:	e8 39 03 00 00       	call   8016e9 <strnlen>
  8013b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013b3:	29 c1                	sub    %eax,%ecx
  8013b5:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8013b8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013bb:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013c2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013c5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c7:	eb 0f                	jmp    8013d8 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8013c9:	83 ec 08             	sub    $0x8,%esp
  8013cc:	53                   	push   %ebx
  8013cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8013d0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d2:	83 ef 01             	sub    $0x1,%edi
  8013d5:	83 c4 10             	add    $0x10,%esp
  8013d8:	85 ff                	test   %edi,%edi
  8013da:	7f ed                	jg     8013c9 <vprintfmt+0x1ae>
  8013dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013df:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8013e2:	85 c9                	test   %ecx,%ecx
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e9:	0f 49 c1             	cmovns %ecx,%eax
  8013ec:	29 c1                	sub    %eax,%ecx
  8013ee:	89 75 08             	mov    %esi,0x8(%ebp)
  8013f1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8013f4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8013f7:	89 cb                	mov    %ecx,%ebx
  8013f9:	eb 16                	jmp    801411 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8013fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013ff:	75 31                	jne    801432 <vprintfmt+0x217>
					putch(ch, putdat);
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	50                   	push   %eax
  801408:	ff 55 08             	call   *0x8(%ebp)
  80140b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80140e:	83 eb 01             	sub    $0x1,%ebx
  801411:	83 c7 01             	add    $0x1,%edi
  801414:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801418:	0f be c2             	movsbl %dl,%eax
  80141b:	85 c0                	test   %eax,%eax
  80141d:	74 59                	je     801478 <vprintfmt+0x25d>
  80141f:	85 f6                	test   %esi,%esi
  801421:	78 d8                	js     8013fb <vprintfmt+0x1e0>
  801423:	83 ee 01             	sub    $0x1,%esi
  801426:	79 d3                	jns    8013fb <vprintfmt+0x1e0>
  801428:	89 df                	mov    %ebx,%edi
  80142a:	8b 75 08             	mov    0x8(%ebp),%esi
  80142d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801430:	eb 37                	jmp    801469 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801432:	0f be d2             	movsbl %dl,%edx
  801435:	83 ea 20             	sub    $0x20,%edx
  801438:	83 fa 5e             	cmp    $0x5e,%edx
  80143b:	76 c4                	jbe    801401 <vprintfmt+0x1e6>
					putch('?', putdat);
  80143d:	83 ec 08             	sub    $0x8,%esp
  801440:	ff 75 0c             	pushl  0xc(%ebp)
  801443:	6a 3f                	push   $0x3f
  801445:	ff 55 08             	call   *0x8(%ebp)
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	eb c1                	jmp    80140e <vprintfmt+0x1f3>
  80144d:	89 75 08             	mov    %esi,0x8(%ebp)
  801450:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801453:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801456:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801459:	eb b6                	jmp    801411 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	53                   	push   %ebx
  80145f:	6a 20                	push   $0x20
  801461:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801463:	83 ef 01             	sub    $0x1,%edi
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 ff                	test   %edi,%edi
  80146b:	7f ee                	jg     80145b <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80146d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801470:	89 45 14             	mov    %eax,0x14(%ebp)
  801473:	e9 43 01 00 00       	jmp    8015bb <vprintfmt+0x3a0>
  801478:	89 df                	mov    %ebx,%edi
  80147a:	8b 75 08             	mov    0x8(%ebp),%esi
  80147d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801480:	eb e7                	jmp    801469 <vprintfmt+0x24e>
	if (lflag >= 2)
  801482:	83 f9 01             	cmp    $0x1,%ecx
  801485:	7e 3f                	jle    8014c6 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  801487:	8b 45 14             	mov    0x14(%ebp),%eax
  80148a:	8b 50 04             	mov    0x4(%eax),%edx
  80148d:	8b 00                	mov    (%eax),%eax
  80148f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801492:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801495:	8b 45 14             	mov    0x14(%ebp),%eax
  801498:	8d 40 08             	lea    0x8(%eax),%eax
  80149b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80149e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014a2:	79 5c                	jns    801500 <vprintfmt+0x2e5>
				putch('-', putdat);
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	53                   	push   %ebx
  8014a8:	6a 2d                	push   $0x2d
  8014aa:	ff d6                	call   *%esi
				num = -(long long) num;
  8014ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014af:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8014b2:	f7 da                	neg    %edx
  8014b4:	83 d1 00             	adc    $0x0,%ecx
  8014b7:	f7 d9                	neg    %ecx
  8014b9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8014bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014c1:	e9 db 00 00 00       	jmp    8015a1 <vprintfmt+0x386>
	else if (lflag)
  8014c6:	85 c9                	test   %ecx,%ecx
  8014c8:	75 1b                	jne    8014e5 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8014ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cd:	8b 00                	mov    (%eax),%eax
  8014cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014d2:	89 c1                	mov    %eax,%ecx
  8014d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8014d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8014da:	8b 45 14             	mov    0x14(%ebp),%eax
  8014dd:	8d 40 04             	lea    0x4(%eax),%eax
  8014e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e3:	eb b9                	jmp    80149e <vprintfmt+0x283>
		return va_arg(*ap, long);
  8014e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e8:	8b 00                	mov    (%eax),%eax
  8014ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014ed:	89 c1                	mov    %eax,%ecx
  8014ef:	c1 f9 1f             	sar    $0x1f,%ecx
  8014f2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8014f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f8:	8d 40 04             	lea    0x4(%eax),%eax
  8014fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8014fe:	eb 9e                	jmp    80149e <vprintfmt+0x283>
			num = getint(&ap, lflag);
  801500:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801503:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801506:	b8 0a 00 00 00       	mov    $0xa,%eax
  80150b:	e9 91 00 00 00       	jmp    8015a1 <vprintfmt+0x386>
	if (lflag >= 2)
  801510:	83 f9 01             	cmp    $0x1,%ecx
  801513:	7e 15                	jle    80152a <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  801515:	8b 45 14             	mov    0x14(%ebp),%eax
  801518:	8b 10                	mov    (%eax),%edx
  80151a:	8b 48 04             	mov    0x4(%eax),%ecx
  80151d:	8d 40 08             	lea    0x8(%eax),%eax
  801520:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801523:	b8 0a 00 00 00       	mov    $0xa,%eax
  801528:	eb 77                	jmp    8015a1 <vprintfmt+0x386>
	else if (lflag)
  80152a:	85 c9                	test   %ecx,%ecx
  80152c:	75 17                	jne    801545 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  80152e:	8b 45 14             	mov    0x14(%ebp),%eax
  801531:	8b 10                	mov    (%eax),%edx
  801533:	b9 00 00 00 00       	mov    $0x0,%ecx
  801538:	8d 40 04             	lea    0x4(%eax),%eax
  80153b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80153e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801543:	eb 5c                	jmp    8015a1 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  801545:	8b 45 14             	mov    0x14(%ebp),%eax
  801548:	8b 10                	mov    (%eax),%edx
  80154a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80154f:	8d 40 04             	lea    0x4(%eax),%eax
  801552:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801555:	b8 0a 00 00 00       	mov    $0xa,%eax
  80155a:	eb 45                	jmp    8015a1 <vprintfmt+0x386>
			putch('X', putdat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	53                   	push   %ebx
  801560:	6a 58                	push   $0x58
  801562:	ff d6                	call   *%esi
			putch('X', putdat);
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	53                   	push   %ebx
  801568:	6a 58                	push   $0x58
  80156a:	ff d6                	call   *%esi
			putch('X', putdat);
  80156c:	83 c4 08             	add    $0x8,%esp
  80156f:	53                   	push   %ebx
  801570:	6a 58                	push   $0x58
  801572:	ff d6                	call   *%esi
			break;
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	eb 42                	jmp    8015bb <vprintfmt+0x3a0>
			putch('0', putdat);
  801579:	83 ec 08             	sub    $0x8,%esp
  80157c:	53                   	push   %ebx
  80157d:	6a 30                	push   $0x30
  80157f:	ff d6                	call   *%esi
			putch('x', putdat);
  801581:	83 c4 08             	add    $0x8,%esp
  801584:	53                   	push   %ebx
  801585:	6a 78                	push   $0x78
  801587:	ff d6                	call   *%esi
			num = (unsigned long long)
  801589:	8b 45 14             	mov    0x14(%ebp),%eax
  80158c:	8b 10                	mov    (%eax),%edx
  80158e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801593:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801596:	8d 40 04             	lea    0x4(%eax),%eax
  801599:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80159c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8015a8:	57                   	push   %edi
  8015a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8015ac:	50                   	push   %eax
  8015ad:	51                   	push   %ecx
  8015ae:	52                   	push   %edx
  8015af:	89 da                	mov    %ebx,%edx
  8015b1:	89 f0                	mov    %esi,%eax
  8015b3:	e8 7a fb ff ff       	call   801132 <printnum>
			break;
  8015b8:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8015bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015be:	83 c7 01             	add    $0x1,%edi
  8015c1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8015c5:	83 f8 25             	cmp    $0x25,%eax
  8015c8:	0f 84 64 fc ff ff    	je     801232 <vprintfmt+0x17>
			if (ch == '\0')
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	0f 84 8b 00 00 00    	je     801661 <vprintfmt+0x446>
			putch(ch, putdat);
  8015d6:	83 ec 08             	sub    $0x8,%esp
  8015d9:	53                   	push   %ebx
  8015da:	50                   	push   %eax
  8015db:	ff d6                	call   *%esi
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	eb dc                	jmp    8015be <vprintfmt+0x3a3>
	if (lflag >= 2)
  8015e2:	83 f9 01             	cmp    $0x1,%ecx
  8015e5:	7e 15                	jle    8015fc <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8015e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ea:	8b 10                	mov    (%eax),%edx
  8015ec:	8b 48 04             	mov    0x4(%eax),%ecx
  8015ef:	8d 40 08             	lea    0x8(%eax),%eax
  8015f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8015fa:	eb a5                	jmp    8015a1 <vprintfmt+0x386>
	else if (lflag)
  8015fc:	85 c9                	test   %ecx,%ecx
  8015fe:	75 17                	jne    801617 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  801600:	8b 45 14             	mov    0x14(%ebp),%eax
  801603:	8b 10                	mov    (%eax),%edx
  801605:	b9 00 00 00 00       	mov    $0x0,%ecx
  80160a:	8d 40 04             	lea    0x4(%eax),%eax
  80160d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801610:	b8 10 00 00 00       	mov    $0x10,%eax
  801615:	eb 8a                	jmp    8015a1 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  801617:	8b 45 14             	mov    0x14(%ebp),%eax
  80161a:	8b 10                	mov    (%eax),%edx
  80161c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801621:	8d 40 04             	lea    0x4(%eax),%eax
  801624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801627:	b8 10 00 00 00       	mov    $0x10,%eax
  80162c:	e9 70 ff ff ff       	jmp    8015a1 <vprintfmt+0x386>
			putch(ch, putdat);
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	53                   	push   %ebx
  801635:	6a 25                	push   $0x25
  801637:	ff d6                	call   *%esi
			break;
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	e9 7a ff ff ff       	jmp    8015bb <vprintfmt+0x3a0>
			putch('%', putdat);
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	53                   	push   %ebx
  801645:	6a 25                	push   $0x25
  801647:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	89 f8                	mov    %edi,%eax
  80164e:	eb 03                	jmp    801653 <vprintfmt+0x438>
  801650:	83 e8 01             	sub    $0x1,%eax
  801653:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801657:	75 f7                	jne    801650 <vprintfmt+0x435>
  801659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80165c:	e9 5a ff ff ff       	jmp    8015bb <vprintfmt+0x3a0>
}
  801661:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801664:	5b                   	pop    %ebx
  801665:	5e                   	pop    %esi
  801666:	5f                   	pop    %edi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    

00801669 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 18             	sub    $0x18,%esp
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801675:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801678:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80167c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80167f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801686:	85 c0                	test   %eax,%eax
  801688:	74 26                	je     8016b0 <vsnprintf+0x47>
  80168a:	85 d2                	test   %edx,%edx
  80168c:	7e 22                	jle    8016b0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80168e:	ff 75 14             	pushl  0x14(%ebp)
  801691:	ff 75 10             	pushl  0x10(%ebp)
  801694:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801697:	50                   	push   %eax
  801698:	68 e1 11 80 00       	push   $0x8011e1
  80169d:	e8 79 fb ff ff       	call   80121b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8016a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ab:	83 c4 10             	add    $0x10,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    
		return -E_INVAL;
  8016b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b5:	eb f7                	jmp    8016ae <vsnprintf+0x45>

008016b7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8016bd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8016c0:	50                   	push   %eax
  8016c1:	ff 75 10             	pushl  0x10(%ebp)
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	e8 9a ff ff ff       	call   801669 <vsnprintf>
	va_end(ap);

	return rc;
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	eb 03                	jmp    8016e1 <strlen+0x10>
		n++;
  8016de:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8016e1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016e5:	75 f7                	jne    8016de <strlen+0xd>
	return n;
}
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f7:	eb 03                	jmp    8016fc <strnlen+0x13>
		n++;
  8016f9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016fc:	39 d0                	cmp    %edx,%eax
  8016fe:	74 06                	je     801706 <strnlen+0x1d>
  801700:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801704:	75 f3                	jne    8016f9 <strnlen+0x10>
	return n;
}
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    

00801708 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	53                   	push   %ebx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801712:	89 c2                	mov    %eax,%edx
  801714:	83 c1 01             	add    $0x1,%ecx
  801717:	83 c2 01             	add    $0x1,%edx
  80171a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80171e:	88 5a ff             	mov    %bl,-0x1(%edx)
  801721:	84 db                	test   %bl,%bl
  801723:	75 ef                	jne    801714 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801725:	5b                   	pop    %ebx
  801726:	5d                   	pop    %ebp
  801727:	c3                   	ret    

00801728 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	53                   	push   %ebx
  80172c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80172f:	53                   	push   %ebx
  801730:	e8 9c ff ff ff       	call   8016d1 <strlen>
  801735:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	01 d8                	add    %ebx,%eax
  80173d:	50                   	push   %eax
  80173e:	e8 c5 ff ff ff       	call   801708 <strcpy>
	return dst;
}
  801743:	89 d8                	mov    %ebx,%eax
  801745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	56                   	push   %esi
  80174e:	53                   	push   %ebx
  80174f:	8b 75 08             	mov    0x8(%ebp),%esi
  801752:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801755:	89 f3                	mov    %esi,%ebx
  801757:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80175a:	89 f2                	mov    %esi,%edx
  80175c:	eb 0f                	jmp    80176d <strncpy+0x23>
		*dst++ = *src;
  80175e:	83 c2 01             	add    $0x1,%edx
  801761:	0f b6 01             	movzbl (%ecx),%eax
  801764:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801767:	80 39 01             	cmpb   $0x1,(%ecx)
  80176a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80176d:	39 da                	cmp    %ebx,%edx
  80176f:	75 ed                	jne    80175e <strncpy+0x14>
	}
	return ret;
}
  801771:	89 f0                	mov    %esi,%eax
  801773:	5b                   	pop    %ebx
  801774:	5e                   	pop    %esi
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	56                   	push   %esi
  80177b:	53                   	push   %ebx
  80177c:	8b 75 08             	mov    0x8(%ebp),%esi
  80177f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801782:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801785:	89 f0                	mov    %esi,%eax
  801787:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80178b:	85 c9                	test   %ecx,%ecx
  80178d:	75 0b                	jne    80179a <strlcpy+0x23>
  80178f:	eb 17                	jmp    8017a8 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801791:	83 c2 01             	add    $0x1,%edx
  801794:	83 c0 01             	add    $0x1,%eax
  801797:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80179a:	39 d8                	cmp    %ebx,%eax
  80179c:	74 07                	je     8017a5 <strlcpy+0x2e>
  80179e:	0f b6 0a             	movzbl (%edx),%ecx
  8017a1:	84 c9                	test   %cl,%cl
  8017a3:	75 ec                	jne    801791 <strlcpy+0x1a>
		*dst = '\0';
  8017a5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8017a8:	29 f0                	sub    %esi,%eax
}
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    

008017ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8017b7:	eb 06                	jmp    8017bf <strcmp+0x11>
		p++, q++;
  8017b9:	83 c1 01             	add    $0x1,%ecx
  8017bc:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8017bf:	0f b6 01             	movzbl (%ecx),%eax
  8017c2:	84 c0                	test   %al,%al
  8017c4:	74 04                	je     8017ca <strcmp+0x1c>
  8017c6:	3a 02                	cmp    (%edx),%al
  8017c8:	74 ef                	je     8017b9 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8017ca:	0f b6 c0             	movzbl %al,%eax
  8017cd:	0f b6 12             	movzbl (%edx),%edx
  8017d0:	29 d0                	sub    %edx,%eax
}
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	53                   	push   %ebx
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017e3:	eb 06                	jmp    8017eb <strncmp+0x17>
		n--, p++, q++;
  8017e5:	83 c0 01             	add    $0x1,%eax
  8017e8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017eb:	39 d8                	cmp    %ebx,%eax
  8017ed:	74 16                	je     801805 <strncmp+0x31>
  8017ef:	0f b6 08             	movzbl (%eax),%ecx
  8017f2:	84 c9                	test   %cl,%cl
  8017f4:	74 04                	je     8017fa <strncmp+0x26>
  8017f6:	3a 0a                	cmp    (%edx),%cl
  8017f8:	74 eb                	je     8017e5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017fa:	0f b6 00             	movzbl (%eax),%eax
  8017fd:	0f b6 12             	movzbl (%edx),%edx
  801800:	29 d0                	sub    %edx,%eax
}
  801802:	5b                   	pop    %ebx
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    
		return 0;
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
  80180a:	eb f6                	jmp    801802 <strncmp+0x2e>

0080180c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801816:	0f b6 10             	movzbl (%eax),%edx
  801819:	84 d2                	test   %dl,%dl
  80181b:	74 09                	je     801826 <strchr+0x1a>
		if (*s == c)
  80181d:	38 ca                	cmp    %cl,%dl
  80181f:	74 0a                	je     80182b <strchr+0x1f>
	for (; *s; s++)
  801821:	83 c0 01             	add    $0x1,%eax
  801824:	eb f0                	jmp    801816 <strchr+0xa>
			return (char *) s;
	return 0;
  801826:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182b:	5d                   	pop    %ebp
  80182c:	c3                   	ret    

0080182d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801837:	eb 03                	jmp    80183c <strfind+0xf>
  801839:	83 c0 01             	add    $0x1,%eax
  80183c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80183f:	38 ca                	cmp    %cl,%dl
  801841:	74 04                	je     801847 <strfind+0x1a>
  801843:	84 d2                	test   %dl,%dl
  801845:	75 f2                	jne    801839 <strfind+0xc>
			break;
	return (char *) s;
}
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    

00801849 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	57                   	push   %edi
  80184d:	56                   	push   %esi
  80184e:	53                   	push   %ebx
  80184f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801852:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801855:	85 c9                	test   %ecx,%ecx
  801857:	74 13                	je     80186c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801859:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80185f:	75 05                	jne    801866 <memset+0x1d>
  801861:	f6 c1 03             	test   $0x3,%cl
  801864:	74 0d                	je     801873 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801866:	8b 45 0c             	mov    0xc(%ebp),%eax
  801869:	fc                   	cld    
  80186a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80186c:	89 f8                	mov    %edi,%eax
  80186e:	5b                   	pop    %ebx
  80186f:	5e                   	pop    %esi
  801870:	5f                   	pop    %edi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    
		c &= 0xFF;
  801873:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801877:	89 d3                	mov    %edx,%ebx
  801879:	c1 e3 08             	shl    $0x8,%ebx
  80187c:	89 d0                	mov    %edx,%eax
  80187e:	c1 e0 18             	shl    $0x18,%eax
  801881:	89 d6                	mov    %edx,%esi
  801883:	c1 e6 10             	shl    $0x10,%esi
  801886:	09 f0                	or     %esi,%eax
  801888:	09 c2                	or     %eax,%edx
  80188a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80188c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80188f:	89 d0                	mov    %edx,%eax
  801891:	fc                   	cld    
  801892:	f3 ab                	rep stos %eax,%es:(%edi)
  801894:	eb d6                	jmp    80186c <memset+0x23>

00801896 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	57                   	push   %edi
  80189a:	56                   	push   %esi
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018a4:	39 c6                	cmp    %eax,%esi
  8018a6:	73 35                	jae    8018dd <memmove+0x47>
  8018a8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8018ab:	39 c2                	cmp    %eax,%edx
  8018ad:	76 2e                	jbe    8018dd <memmove+0x47>
		s += n;
		d += n;
  8018af:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018b2:	89 d6                	mov    %edx,%esi
  8018b4:	09 fe                	or     %edi,%esi
  8018b6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8018bc:	74 0c                	je     8018ca <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8018be:	83 ef 01             	sub    $0x1,%edi
  8018c1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8018c4:	fd                   	std    
  8018c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8018c7:	fc                   	cld    
  8018c8:	eb 21                	jmp    8018eb <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018ca:	f6 c1 03             	test   $0x3,%cl
  8018cd:	75 ef                	jne    8018be <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8018cf:	83 ef 04             	sub    $0x4,%edi
  8018d2:	8d 72 fc             	lea    -0x4(%edx),%esi
  8018d5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8018d8:	fd                   	std    
  8018d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018db:	eb ea                	jmp    8018c7 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018dd:	89 f2                	mov    %esi,%edx
  8018df:	09 c2                	or     %eax,%edx
  8018e1:	f6 c2 03             	test   $0x3,%dl
  8018e4:	74 09                	je     8018ef <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018e6:	89 c7                	mov    %eax,%edi
  8018e8:	fc                   	cld    
  8018e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018eb:	5e                   	pop    %esi
  8018ec:	5f                   	pop    %edi
  8018ed:	5d                   	pop    %ebp
  8018ee:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018ef:	f6 c1 03             	test   $0x3,%cl
  8018f2:	75 f2                	jne    8018e6 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018f4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018f7:	89 c7                	mov    %eax,%edi
  8018f9:	fc                   	cld    
  8018fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018fc:	eb ed                	jmp    8018eb <memmove+0x55>

008018fe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801901:	ff 75 10             	pushl  0x10(%ebp)
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	ff 75 08             	pushl  0x8(%ebp)
  80190a:	e8 87 ff ff ff       	call   801896 <memmove>
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191c:	89 c6                	mov    %eax,%esi
  80191e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801921:	39 f0                	cmp    %esi,%eax
  801923:	74 1c                	je     801941 <memcmp+0x30>
		if (*s1 != *s2)
  801925:	0f b6 08             	movzbl (%eax),%ecx
  801928:	0f b6 1a             	movzbl (%edx),%ebx
  80192b:	38 d9                	cmp    %bl,%cl
  80192d:	75 08                	jne    801937 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80192f:	83 c0 01             	add    $0x1,%eax
  801932:	83 c2 01             	add    $0x1,%edx
  801935:	eb ea                	jmp    801921 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801937:	0f b6 c1             	movzbl %cl,%eax
  80193a:	0f b6 db             	movzbl %bl,%ebx
  80193d:	29 d8                	sub    %ebx,%eax
  80193f:	eb 05                	jmp    801946 <memcmp+0x35>
	}

	return 0;
  801941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801946:	5b                   	pop    %ebx
  801947:	5e                   	pop    %esi
  801948:	5d                   	pop    %ebp
  801949:	c3                   	ret    

0080194a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801953:	89 c2                	mov    %eax,%edx
  801955:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801958:	39 d0                	cmp    %edx,%eax
  80195a:	73 09                	jae    801965 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80195c:	38 08                	cmp    %cl,(%eax)
  80195e:	74 05                	je     801965 <memfind+0x1b>
	for (; s < ends; s++)
  801960:	83 c0 01             	add    $0x1,%eax
  801963:	eb f3                	jmp    801958 <memfind+0xe>
			break;
	return (void *) s;
}
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	57                   	push   %edi
  80196b:	56                   	push   %esi
  80196c:	53                   	push   %ebx
  80196d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801970:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801973:	eb 03                	jmp    801978 <strtol+0x11>
		s++;
  801975:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801978:	0f b6 01             	movzbl (%ecx),%eax
  80197b:	3c 20                	cmp    $0x20,%al
  80197d:	74 f6                	je     801975 <strtol+0xe>
  80197f:	3c 09                	cmp    $0x9,%al
  801981:	74 f2                	je     801975 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801983:	3c 2b                	cmp    $0x2b,%al
  801985:	74 2e                	je     8019b5 <strtol+0x4e>
	int neg = 0;
  801987:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80198c:	3c 2d                	cmp    $0x2d,%al
  80198e:	74 2f                	je     8019bf <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801990:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801996:	75 05                	jne    80199d <strtol+0x36>
  801998:	80 39 30             	cmpb   $0x30,(%ecx)
  80199b:	74 2c                	je     8019c9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80199d:	85 db                	test   %ebx,%ebx
  80199f:	75 0a                	jne    8019ab <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8019a1:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8019a6:	80 39 30             	cmpb   $0x30,(%ecx)
  8019a9:	74 28                	je     8019d3 <strtol+0x6c>
		base = 10;
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8019b3:	eb 50                	jmp    801a05 <strtol+0x9e>
		s++;
  8019b5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8019b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8019bd:	eb d1                	jmp    801990 <strtol+0x29>
		s++, neg = 1;
  8019bf:	83 c1 01             	add    $0x1,%ecx
  8019c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8019c7:	eb c7                	jmp    801990 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019c9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8019cd:	74 0e                	je     8019dd <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8019cf:	85 db                	test   %ebx,%ebx
  8019d1:	75 d8                	jne    8019ab <strtol+0x44>
		s++, base = 8;
  8019d3:	83 c1 01             	add    $0x1,%ecx
  8019d6:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019db:	eb ce                	jmp    8019ab <strtol+0x44>
		s += 2, base = 16;
  8019dd:	83 c1 02             	add    $0x2,%ecx
  8019e0:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019e5:	eb c4                	jmp    8019ab <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8019e7:	8d 72 9f             	lea    -0x61(%edx),%esi
  8019ea:	89 f3                	mov    %esi,%ebx
  8019ec:	80 fb 19             	cmp    $0x19,%bl
  8019ef:	77 29                	ja     801a1a <strtol+0xb3>
			dig = *s - 'a' + 10;
  8019f1:	0f be d2             	movsbl %dl,%edx
  8019f4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019f7:	3b 55 10             	cmp    0x10(%ebp),%edx
  8019fa:	7d 30                	jge    801a2c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8019fc:	83 c1 01             	add    $0x1,%ecx
  8019ff:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a03:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801a05:	0f b6 11             	movzbl (%ecx),%edx
  801a08:	8d 72 d0             	lea    -0x30(%edx),%esi
  801a0b:	89 f3                	mov    %esi,%ebx
  801a0d:	80 fb 09             	cmp    $0x9,%bl
  801a10:	77 d5                	ja     8019e7 <strtol+0x80>
			dig = *s - '0';
  801a12:	0f be d2             	movsbl %dl,%edx
  801a15:	83 ea 30             	sub    $0x30,%edx
  801a18:	eb dd                	jmp    8019f7 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801a1a:	8d 72 bf             	lea    -0x41(%edx),%esi
  801a1d:	89 f3                	mov    %esi,%ebx
  801a1f:	80 fb 19             	cmp    $0x19,%bl
  801a22:	77 08                	ja     801a2c <strtol+0xc5>
			dig = *s - 'A' + 10;
  801a24:	0f be d2             	movsbl %dl,%edx
  801a27:	83 ea 37             	sub    $0x37,%edx
  801a2a:	eb cb                	jmp    8019f7 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801a2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a30:	74 05                	je     801a37 <strtol+0xd0>
		*endptr = (char *) s;
  801a32:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a35:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801a37:	89 c2                	mov    %eax,%edx
  801a39:	f7 da                	neg    %edx
  801a3b:	85 ff                	test   %edi,%edi
  801a3d:	0f 45 c2             	cmovne %edx,%eax
}
  801a40:	5b                   	pop    %ebx
  801a41:	5e                   	pop    %esi
  801a42:	5f                   	pop    %edi
  801a43:	5d                   	pop    %ebp
  801a44:	c3                   	ret    

00801a45 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	53                   	push   %ebx
  801a49:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801a4c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801a53:	74 0d                	je     801a62 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801a5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801a62:	e8 cb e6 ff ff       	call   800132 <sys_getenvid>
  801a67:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	6a 07                	push   $0x7
  801a6e:	68 00 f0 bf ee       	push   $0xeebff000
  801a73:	50                   	push   %eax
  801a74:	e8 f7 e6 ff ff       	call   800170 <sys_page_alloc>
        	if (r < 0) {
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 27                	js     801aa7 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	68 61 03 80 00       	push   $0x800361
  801a88:	53                   	push   %ebx
  801a89:	e8 2d e8 ff ff       	call   8002bb <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	79 c0                	jns    801a55 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801a95:	50                   	push   %eax
  801a96:	68 e0 21 80 00       	push   $0x8021e0
  801a9b:	6a 28                	push   $0x28
  801a9d:	68 f4 21 80 00       	push   $0x8021f4
  801aa2:	e8 9c f5 ff ff       	call   801043 <_panic>
            		panic("pgfault_handler: %e", r);
  801aa7:	50                   	push   %eax
  801aa8:	68 e0 21 80 00       	push   $0x8021e0
  801aad:	6a 24                	push   $0x24
  801aaf:	68 f4 21 80 00       	push   $0x8021f4
  801ab4:	e8 8a f5 ff ff       	call   801043 <_panic>

00801ab9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801abf:	68 02 22 80 00       	push   $0x802202
  801ac4:	6a 1a                	push   $0x1a
  801ac6:	68 1b 22 80 00       	push   $0x80221b
  801acb:	e8 73 f5 ff ff       	call   801043 <_panic>

00801ad0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801ad6:	68 25 22 80 00       	push   $0x802225
  801adb:	6a 2a                	push   $0x2a
  801add:	68 1b 22 80 00       	push   $0x80221b
  801ae2:	e8 5c f5 ff ff       	call   801043 <_panic>

00801ae7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801aed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801af2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801af5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801afb:	8b 52 50             	mov    0x50(%edx),%edx
  801afe:	39 ca                	cmp    %ecx,%edx
  801b00:	74 11                	je     801b13 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801b02:	83 c0 01             	add    $0x1,%eax
  801b05:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b0a:	75 e6                	jne    801af2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b11:	eb 0b                	jmp    801b1e <ipc_find_env+0x37>
			return envs[i].env_id;
  801b13:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b16:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b1b:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    

00801b20 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b26:	89 d0                	mov    %edx,%eax
  801b28:	c1 e8 16             	shr    $0x16,%eax
  801b2b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801b37:	f6 c1 01             	test   $0x1,%cl
  801b3a:	74 1d                	je     801b59 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801b3c:	c1 ea 0c             	shr    $0xc,%edx
  801b3f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b46:	f6 c2 01             	test   $0x1,%dl
  801b49:	74 0e                	je     801b59 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b4b:	c1 ea 0c             	shr    $0xc,%edx
  801b4e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b55:	ef 
  801b56:	0f b7 c0             	movzwl %ax,%eax
}
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    
  801b5b:	66 90                	xchg   %ax,%ax
  801b5d:	66 90                	xchg   %ax,%ax
  801b5f:	90                   	nop

00801b60 <__udivdi3>:
  801b60:	55                   	push   %ebp
  801b61:	57                   	push   %edi
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	83 ec 1c             	sub    $0x1c,%esp
  801b67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801b6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801b6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801b77:	85 d2                	test   %edx,%edx
  801b79:	75 35                	jne    801bb0 <__udivdi3+0x50>
  801b7b:	39 f3                	cmp    %esi,%ebx
  801b7d:	0f 87 bd 00 00 00    	ja     801c40 <__udivdi3+0xe0>
  801b83:	85 db                	test   %ebx,%ebx
  801b85:	89 d9                	mov    %ebx,%ecx
  801b87:	75 0b                	jne    801b94 <__udivdi3+0x34>
  801b89:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8e:	31 d2                	xor    %edx,%edx
  801b90:	f7 f3                	div    %ebx
  801b92:	89 c1                	mov    %eax,%ecx
  801b94:	31 d2                	xor    %edx,%edx
  801b96:	89 f0                	mov    %esi,%eax
  801b98:	f7 f1                	div    %ecx
  801b9a:	89 c6                	mov    %eax,%esi
  801b9c:	89 e8                	mov    %ebp,%eax
  801b9e:	89 f7                	mov    %esi,%edi
  801ba0:	f7 f1                	div    %ecx
  801ba2:	89 fa                	mov    %edi,%edx
  801ba4:	83 c4 1c             	add    $0x1c,%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5f                   	pop    %edi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    
  801bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801bb0:	39 f2                	cmp    %esi,%edx
  801bb2:	77 7c                	ja     801c30 <__udivdi3+0xd0>
  801bb4:	0f bd fa             	bsr    %edx,%edi
  801bb7:	83 f7 1f             	xor    $0x1f,%edi
  801bba:	0f 84 98 00 00 00    	je     801c58 <__udivdi3+0xf8>
  801bc0:	89 f9                	mov    %edi,%ecx
  801bc2:	b8 20 00 00 00       	mov    $0x20,%eax
  801bc7:	29 f8                	sub    %edi,%eax
  801bc9:	d3 e2                	shl    %cl,%edx
  801bcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bcf:	89 c1                	mov    %eax,%ecx
  801bd1:	89 da                	mov    %ebx,%edx
  801bd3:	d3 ea                	shr    %cl,%edx
  801bd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801bd9:	09 d1                	or     %edx,%ecx
  801bdb:	89 f2                	mov    %esi,%edx
  801bdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801be1:	89 f9                	mov    %edi,%ecx
  801be3:	d3 e3                	shl    %cl,%ebx
  801be5:	89 c1                	mov    %eax,%ecx
  801be7:	d3 ea                	shr    %cl,%edx
  801be9:	89 f9                	mov    %edi,%ecx
  801beb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801bef:	d3 e6                	shl    %cl,%esi
  801bf1:	89 eb                	mov    %ebp,%ebx
  801bf3:	89 c1                	mov    %eax,%ecx
  801bf5:	d3 eb                	shr    %cl,%ebx
  801bf7:	09 de                	or     %ebx,%esi
  801bf9:	89 f0                	mov    %esi,%eax
  801bfb:	f7 74 24 08          	divl   0x8(%esp)
  801bff:	89 d6                	mov    %edx,%esi
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	f7 64 24 0c          	mull   0xc(%esp)
  801c07:	39 d6                	cmp    %edx,%esi
  801c09:	72 0c                	jb     801c17 <__udivdi3+0xb7>
  801c0b:	89 f9                	mov    %edi,%ecx
  801c0d:	d3 e5                	shl    %cl,%ebp
  801c0f:	39 c5                	cmp    %eax,%ebp
  801c11:	73 5d                	jae    801c70 <__udivdi3+0x110>
  801c13:	39 d6                	cmp    %edx,%esi
  801c15:	75 59                	jne    801c70 <__udivdi3+0x110>
  801c17:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c1a:	31 ff                	xor    %edi,%edi
  801c1c:	89 fa                	mov    %edi,%edx
  801c1e:	83 c4 1c             	add    $0x1c,%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5f                   	pop    %edi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    
  801c26:	8d 76 00             	lea    0x0(%esi),%esi
  801c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801c30:	31 ff                	xor    %edi,%edi
  801c32:	31 c0                	xor    %eax,%eax
  801c34:	89 fa                	mov    %edi,%edx
  801c36:	83 c4 1c             	add    $0x1c,%esp
  801c39:	5b                   	pop    %ebx
  801c3a:	5e                   	pop    %esi
  801c3b:	5f                   	pop    %edi
  801c3c:	5d                   	pop    %ebp
  801c3d:	c3                   	ret    
  801c3e:	66 90                	xchg   %ax,%ax
  801c40:	31 ff                	xor    %edi,%edi
  801c42:	89 e8                	mov    %ebp,%eax
  801c44:	89 f2                	mov    %esi,%edx
  801c46:	f7 f3                	div    %ebx
  801c48:	89 fa                	mov    %edi,%edx
  801c4a:	83 c4 1c             	add    $0x1c,%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5e                   	pop    %esi
  801c4f:	5f                   	pop    %edi
  801c50:	5d                   	pop    %ebp
  801c51:	c3                   	ret    
  801c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c58:	39 f2                	cmp    %esi,%edx
  801c5a:	72 06                	jb     801c62 <__udivdi3+0x102>
  801c5c:	31 c0                	xor    %eax,%eax
  801c5e:	39 eb                	cmp    %ebp,%ebx
  801c60:	77 d2                	ja     801c34 <__udivdi3+0xd4>
  801c62:	b8 01 00 00 00       	mov    $0x1,%eax
  801c67:	eb cb                	jmp    801c34 <__udivdi3+0xd4>
  801c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	31 ff                	xor    %edi,%edi
  801c74:	eb be                	jmp    801c34 <__udivdi3+0xd4>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	66 90                	xchg   %ax,%ax
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	66 90                	xchg   %ax,%ax
  801c7e:	66 90                	xchg   %ax,%ax

00801c80 <__umoddi3>:
  801c80:	55                   	push   %ebp
  801c81:	57                   	push   %edi
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	83 ec 1c             	sub    $0x1c,%esp
  801c87:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801c8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801c8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c97:	85 ed                	test   %ebp,%ebp
  801c99:	89 f0                	mov    %esi,%eax
  801c9b:	89 da                	mov    %ebx,%edx
  801c9d:	75 19                	jne    801cb8 <__umoddi3+0x38>
  801c9f:	39 df                	cmp    %ebx,%edi
  801ca1:	0f 86 b1 00 00 00    	jbe    801d58 <__umoddi3+0xd8>
  801ca7:	f7 f7                	div    %edi
  801ca9:	89 d0                	mov    %edx,%eax
  801cab:	31 d2                	xor    %edx,%edx
  801cad:	83 c4 1c             	add    $0x1c,%esp
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5f                   	pop    %edi
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    
  801cb5:	8d 76 00             	lea    0x0(%esi),%esi
  801cb8:	39 dd                	cmp    %ebx,%ebp
  801cba:	77 f1                	ja     801cad <__umoddi3+0x2d>
  801cbc:	0f bd cd             	bsr    %ebp,%ecx
  801cbf:	83 f1 1f             	xor    $0x1f,%ecx
  801cc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cc6:	0f 84 b4 00 00 00    	je     801d80 <__umoddi3+0x100>
  801ccc:	b8 20 00 00 00       	mov    $0x20,%eax
  801cd1:	89 c2                	mov    %eax,%edx
  801cd3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cd7:	29 c2                	sub    %eax,%edx
  801cd9:	89 c1                	mov    %eax,%ecx
  801cdb:	89 f8                	mov    %edi,%eax
  801cdd:	d3 e5                	shl    %cl,%ebp
  801cdf:	89 d1                	mov    %edx,%ecx
  801ce1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801ce5:	d3 e8                	shr    %cl,%eax
  801ce7:	09 c5                	or     %eax,%ebp
  801ce9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ced:	89 c1                	mov    %eax,%ecx
  801cef:	d3 e7                	shl    %cl,%edi
  801cf1:	89 d1                	mov    %edx,%ecx
  801cf3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801cf7:	89 df                	mov    %ebx,%edi
  801cf9:	d3 ef                	shr    %cl,%edi
  801cfb:	89 c1                	mov    %eax,%ecx
  801cfd:	89 f0                	mov    %esi,%eax
  801cff:	d3 e3                	shl    %cl,%ebx
  801d01:	89 d1                	mov    %edx,%ecx
  801d03:	89 fa                	mov    %edi,%edx
  801d05:	d3 e8                	shr    %cl,%eax
  801d07:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801d0c:	09 d8                	or     %ebx,%eax
  801d0e:	f7 f5                	div    %ebp
  801d10:	d3 e6                	shl    %cl,%esi
  801d12:	89 d1                	mov    %edx,%ecx
  801d14:	f7 64 24 08          	mull   0x8(%esp)
  801d18:	39 d1                	cmp    %edx,%ecx
  801d1a:	89 c3                	mov    %eax,%ebx
  801d1c:	89 d7                	mov    %edx,%edi
  801d1e:	72 06                	jb     801d26 <__umoddi3+0xa6>
  801d20:	75 0e                	jne    801d30 <__umoddi3+0xb0>
  801d22:	39 c6                	cmp    %eax,%esi
  801d24:	73 0a                	jae    801d30 <__umoddi3+0xb0>
  801d26:	2b 44 24 08          	sub    0x8(%esp),%eax
  801d2a:	19 ea                	sbb    %ebp,%edx
  801d2c:	89 d7                	mov    %edx,%edi
  801d2e:	89 c3                	mov    %eax,%ebx
  801d30:	89 ca                	mov    %ecx,%edx
  801d32:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801d37:	29 de                	sub    %ebx,%esi
  801d39:	19 fa                	sbb    %edi,%edx
  801d3b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d3f:	89 d0                	mov    %edx,%eax
  801d41:	d3 e0                	shl    %cl,%eax
  801d43:	89 d9                	mov    %ebx,%ecx
  801d45:	d3 ee                	shr    %cl,%esi
  801d47:	d3 ea                	shr    %cl,%edx
  801d49:	09 f0                	or     %esi,%eax
  801d4b:	83 c4 1c             	add    $0x1c,%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5e                   	pop    %esi
  801d50:	5f                   	pop    %edi
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    
  801d53:	90                   	nop
  801d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d58:	85 ff                	test   %edi,%edi
  801d5a:	89 f9                	mov    %edi,%ecx
  801d5c:	75 0b                	jne    801d69 <__umoddi3+0xe9>
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	31 d2                	xor    %edx,%edx
  801d65:	f7 f7                	div    %edi
  801d67:	89 c1                	mov    %eax,%ecx
  801d69:	89 d8                	mov    %ebx,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f1                	div    %ecx
  801d6f:	89 f0                	mov    %esi,%eax
  801d71:	f7 f1                	div    %ecx
  801d73:	e9 31 ff ff ff       	jmp    801ca9 <__umoddi3+0x29>
  801d78:	90                   	nop
  801d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d80:	39 dd                	cmp    %ebx,%ebp
  801d82:	72 08                	jb     801d8c <__umoddi3+0x10c>
  801d84:	39 f7                	cmp    %esi,%edi
  801d86:	0f 87 21 ff ff ff    	ja     801cad <__umoddi3+0x2d>
  801d8c:	89 da                	mov    %ebx,%edx
  801d8e:	89 f0                	mov    %esi,%eax
  801d90:	29 f8                	sub    %edi,%eax
  801d92:	19 ea                	sbb    %ebp,%edx
  801d94:	e9 14 ff ff ff       	jmp    801cad <__umoddi3+0x2d>
