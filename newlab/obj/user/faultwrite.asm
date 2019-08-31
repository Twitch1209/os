
obj/user/faultwrite.debug：     文件格式 elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0 = 0;
  800036:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80004d:	e8 ce 00 00 00       	call   800120 <sys_getenvid>
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x2d>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008e:	e8 92 04 00 00       	call   800525 <close_all>
	sys_env_destroy(0);
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	6a 00                	push   $0x0
  800098:	e8 42 00 00 00       	call   8000df <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	57                   	push   %edi
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f5:	89 cb                	mov    %ecx,%ebx
  8000f7:	89 cf                	mov    %ecx,%edi
  8000f9:	89 ce                	mov    %ecx,%esi
  8000fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	7f 08                	jg     800109 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	6a 03                	push   $0x3
  80010f:	68 0a 1d 80 00       	push   $0x801d0a
  800114:	6a 23                	push   $0x23
  800116:	68 27 1d 80 00       	push   $0x801d27
  80011b:	e8 ea 0e 00 00       	call   80100a <_panic>

00800120 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
	asm volatile("int %1\n"
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	b8 02 00 00 00       	mov    $0x2,%eax
  800130:	89 d1                	mov    %edx,%ecx
  800132:	89 d3                	mov    %edx,%ebx
  800134:	89 d7                	mov    %edx,%edi
  800136:	89 d6                	mov    %edx,%esi
  800138:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_yield>:

void
sys_yield(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	asm volatile("int %1\n"
  800145:	ba 00 00 00 00       	mov    $0x0,%edx
  80014a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014f:	89 d1                	mov    %edx,%ecx
  800151:	89 d3                	mov    %edx,%ebx
  800153:	89 d7                	mov    %edx,%edi
  800155:	89 d6                	mov    %edx,%esi
  800157:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	8b 55 08             	mov    0x8(%ebp),%edx
  80016f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800172:	b8 04 00 00 00       	mov    $0x4,%eax
  800177:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017a:	89 f7                	mov    %esi,%edi
  80017c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017e:	85 c0                	test   %eax,%eax
  800180:	7f 08                	jg     80018a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	6a 04                	push   $0x4
  800190:	68 0a 1d 80 00       	push   $0x801d0a
  800195:	6a 23                	push   $0x23
  800197:	68 27 1d 80 00       	push   $0x801d27
  80019c:	e8 69 0e 00 00       	call   80100a <_panic>

008001a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	7f 08                	jg     8001cc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	6a 05                	push   $0x5
  8001d2:	68 0a 1d 80 00       	push   $0x801d0a
  8001d7:	6a 23                	push   $0x23
  8001d9:	68 27 1d 80 00       	push   $0x801d27
  8001de:	e8 27 0e 00 00       	call   80100a <_panic>

008001e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001fc:	89 df                	mov    %ebx,%edi
  8001fe:	89 de                	mov    %ebx,%esi
  800200:	cd 30                	int    $0x30
	if(check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7f 08                	jg     80020e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800209:	5b                   	pop    %ebx
  80020a:	5e                   	pop    %esi
  80020b:	5f                   	pop    %edi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	6a 06                	push   $0x6
  800214:	68 0a 1d 80 00       	push   $0x801d0a
  800219:	6a 23                	push   $0x23
  80021b:	68 27 1d 80 00       	push   $0x801d27
  800220:	e8 e5 0d 00 00       	call   80100a <_panic>

00800225 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800239:	b8 08 00 00 00       	mov    $0x8,%eax
  80023e:	89 df                	mov    %ebx,%edi
  800240:	89 de                	mov    %ebx,%esi
  800242:	cd 30                	int    $0x30
	if(check && ret > 0)
  800244:	85 c0                	test   %eax,%eax
  800246:	7f 08                	jg     800250 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	50                   	push   %eax
  800254:	6a 08                	push   $0x8
  800256:	68 0a 1d 80 00       	push   $0x801d0a
  80025b:	6a 23                	push   $0x23
  80025d:	68 27 1d 80 00       	push   $0x801d27
  800262:	e8 a3 0d 00 00       	call   80100a <_panic>

00800267 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 09 00 00 00       	mov    $0x9,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if(check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 09                	push   $0x9
  800298:	68 0a 1d 80 00       	push   $0x801d0a
  80029d:	6a 23                	push   $0x23
  80029f:	68 27 1d 80 00       	push   $0x801d27
  8002a4:	e8 61 0d 00 00       	call   80100a <_panic>

008002a9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c2:	89 df                	mov    %ebx,%edi
  8002c4:	89 de                	mov    %ebx,%esi
  8002c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	7f 08                	jg     8002d4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5e                   	pop    %esi
  8002d1:	5f                   	pop    %edi
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	50                   	push   %eax
  8002d8:	6a 0a                	push   $0xa
  8002da:	68 0a 1d 80 00       	push   $0x801d0a
  8002df:	6a 23                	push   $0x23
  8002e1:	68 27 1d 80 00       	push   $0x801d27
  8002e6:	e8 1f 0d 00 00       	call   80100a <_panic>

008002eb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	57                   	push   %edi
  8002ef:	56                   	push   %esi
  8002f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800304:	8b 7d 14             	mov    0x14(%ebp),%edi
  800307:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
  800314:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800317:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031c:	8b 55 08             	mov    0x8(%ebp),%edx
  80031f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800324:	89 cb                	mov    %ecx,%ebx
  800326:	89 cf                	mov    %ecx,%edi
  800328:	89 ce                	mov    %ecx,%esi
  80032a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80032c:	85 c0                	test   %eax,%eax
  80032e:	7f 08                	jg     800338 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	50                   	push   %eax
  80033c:	6a 0d                	push   $0xd
  80033e:	68 0a 1d 80 00       	push   $0x801d0a
  800343:	6a 23                	push   $0x23
  800345:	68 27 1d 80 00       	push   $0x801d27
  80034a:	e8 bb 0c 00 00       	call   80100a <_panic>

0080034f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	05 00 00 00 30       	add    $0x30000000,%eax
  80035a:	c1 e8 0c             	shr    $0xc,%eax
}
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80036a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80036f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800381:	89 c2                	mov    %eax,%edx
  800383:	c1 ea 16             	shr    $0x16,%edx
  800386:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80038d:	f6 c2 01             	test   $0x1,%dl
  800390:	74 2a                	je     8003bc <fd_alloc+0x46>
  800392:	89 c2                	mov    %eax,%edx
  800394:	c1 ea 0c             	shr    $0xc,%edx
  800397:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80039e:	f6 c2 01             	test   $0x1,%dl
  8003a1:	74 19                	je     8003bc <fd_alloc+0x46>
  8003a3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003a8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003ad:	75 d2                	jne    800381 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003af:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003b5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003ba:	eb 07                	jmp    8003c3 <fd_alloc+0x4d>
			*fd_store = fd;
  8003bc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    

008003c5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003cb:	83 f8 1f             	cmp    $0x1f,%eax
  8003ce:	77 36                	ja     800406 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003d0:	c1 e0 0c             	shl    $0xc,%eax
  8003d3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003d8:	89 c2                	mov    %eax,%edx
  8003da:	c1 ea 16             	shr    $0x16,%edx
  8003dd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003e4:	f6 c2 01             	test   $0x1,%dl
  8003e7:	74 24                	je     80040d <fd_lookup+0x48>
  8003e9:	89 c2                	mov    %eax,%edx
  8003eb:	c1 ea 0c             	shr    $0xc,%edx
  8003ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003f5:	f6 c2 01             	test   $0x1,%dl
  8003f8:	74 1a                	je     800414 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003fd:	89 02                	mov    %eax,(%edx)
	return 0;
  8003ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    
		return -E_INVAL;
  800406:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80040b:	eb f7                	jmp    800404 <fd_lookup+0x3f>
		return -E_INVAL;
  80040d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800412:	eb f0                	jmp    800404 <fd_lookup+0x3f>
  800414:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800419:	eb e9                	jmp    800404 <fd_lookup+0x3f>

0080041b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800424:	ba b4 1d 80 00       	mov    $0x801db4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800429:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80042e:	39 08                	cmp    %ecx,(%eax)
  800430:	74 33                	je     800465 <dev_lookup+0x4a>
  800432:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800435:	8b 02                	mov    (%edx),%eax
  800437:	85 c0                	test   %eax,%eax
  800439:	75 f3                	jne    80042e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80043b:	a1 04 40 80 00       	mov    0x804004,%eax
  800440:	8b 40 48             	mov    0x48(%eax),%eax
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	51                   	push   %ecx
  800447:	50                   	push   %eax
  800448:	68 38 1d 80 00       	push   $0x801d38
  80044d:	e8 93 0c 00 00       	call   8010e5 <cprintf>
	*dev = 0;
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
  800455:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800463:	c9                   	leave  
  800464:	c3                   	ret    
			*dev = devtab[i];
  800465:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800468:	89 01                	mov    %eax,(%ecx)
			return 0;
  80046a:	b8 00 00 00 00       	mov    $0x0,%eax
  80046f:	eb f2                	jmp    800463 <dev_lookup+0x48>

00800471 <fd_close>:
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	57                   	push   %edi
  800475:	56                   	push   %esi
  800476:	53                   	push   %ebx
  800477:	83 ec 1c             	sub    $0x1c,%esp
  80047a:	8b 75 08             	mov    0x8(%ebp),%esi
  80047d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800480:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800483:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800484:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80048a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80048d:	50                   	push   %eax
  80048e:	e8 32 ff ff ff       	call   8003c5 <fd_lookup>
  800493:	89 c3                	mov    %eax,%ebx
  800495:	83 c4 08             	add    $0x8,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 05                	js     8004a1 <fd_close+0x30>
	    || fd != fd2)
  80049c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80049f:	74 16                	je     8004b7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004a1:	89 f8                	mov    %edi,%eax
  8004a3:	84 c0                	test   %al,%al
  8004a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004aa:	0f 44 d8             	cmove  %eax,%ebx
}
  8004ad:	89 d8                	mov    %ebx,%eax
  8004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b2:	5b                   	pop    %ebx
  8004b3:	5e                   	pop    %esi
  8004b4:	5f                   	pop    %edi
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004bd:	50                   	push   %eax
  8004be:	ff 36                	pushl  (%esi)
  8004c0:	e8 56 ff ff ff       	call   80041b <dev_lookup>
  8004c5:	89 c3                	mov    %eax,%ebx
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	85 c0                	test   %eax,%eax
  8004cc:	78 15                	js     8004e3 <fd_close+0x72>
		if (dev->dev_close)
  8004ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d1:	8b 40 10             	mov    0x10(%eax),%eax
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	74 1b                	je     8004f3 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004d8:	83 ec 0c             	sub    $0xc,%esp
  8004db:	56                   	push   %esi
  8004dc:	ff d0                	call   *%eax
  8004de:	89 c3                	mov    %eax,%ebx
  8004e0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	56                   	push   %esi
  8004e7:	6a 00                	push   $0x0
  8004e9:	e8 f5 fc ff ff       	call   8001e3 <sys_page_unmap>
	return r;
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	eb ba                	jmp    8004ad <fd_close+0x3c>
			r = 0;
  8004f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004f8:	eb e9                	jmp    8004e3 <fd_close+0x72>

008004fa <close>:

int
close(int fdnum)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800500:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800503:	50                   	push   %eax
  800504:	ff 75 08             	pushl  0x8(%ebp)
  800507:	e8 b9 fe ff ff       	call   8003c5 <fd_lookup>
  80050c:	83 c4 08             	add    $0x8,%esp
  80050f:	85 c0                	test   %eax,%eax
  800511:	78 10                	js     800523 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	6a 01                	push   $0x1
  800518:	ff 75 f4             	pushl  -0xc(%ebp)
  80051b:	e8 51 ff ff ff       	call   800471 <fd_close>
  800520:	83 c4 10             	add    $0x10,%esp
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <close_all>:

void
close_all(void)
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	53                   	push   %ebx
  800529:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80052c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800531:	83 ec 0c             	sub    $0xc,%esp
  800534:	53                   	push   %ebx
  800535:	e8 c0 ff ff ff       	call   8004fa <close>
	for (i = 0; i < MAXFD; i++)
  80053a:	83 c3 01             	add    $0x1,%ebx
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	83 fb 20             	cmp    $0x20,%ebx
  800543:	75 ec                	jne    800531 <close_all+0xc>
}
  800545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	57                   	push   %edi
  80054e:	56                   	push   %esi
  80054f:	53                   	push   %ebx
  800550:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800553:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800556:	50                   	push   %eax
  800557:	ff 75 08             	pushl  0x8(%ebp)
  80055a:	e8 66 fe ff ff       	call   8003c5 <fd_lookup>
  80055f:	89 c3                	mov    %eax,%ebx
  800561:	83 c4 08             	add    $0x8,%esp
  800564:	85 c0                	test   %eax,%eax
  800566:	0f 88 81 00 00 00    	js     8005ed <dup+0xa3>
		return r;
	close(newfdnum);
  80056c:	83 ec 0c             	sub    $0xc,%esp
  80056f:	ff 75 0c             	pushl  0xc(%ebp)
  800572:	e8 83 ff ff ff       	call   8004fa <close>

	newfd = INDEX2FD(newfdnum);
  800577:	8b 75 0c             	mov    0xc(%ebp),%esi
  80057a:	c1 e6 0c             	shl    $0xc,%esi
  80057d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800583:	83 c4 04             	add    $0x4,%esp
  800586:	ff 75 e4             	pushl  -0x1c(%ebp)
  800589:	e8 d1 fd ff ff       	call   80035f <fd2data>
  80058e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800590:	89 34 24             	mov    %esi,(%esp)
  800593:	e8 c7 fd ff ff       	call   80035f <fd2data>
  800598:	83 c4 10             	add    $0x10,%esp
  80059b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80059d:	89 d8                	mov    %ebx,%eax
  80059f:	c1 e8 16             	shr    $0x16,%eax
  8005a2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005a9:	a8 01                	test   $0x1,%al
  8005ab:	74 11                	je     8005be <dup+0x74>
  8005ad:	89 d8                	mov    %ebx,%eax
  8005af:	c1 e8 0c             	shr    $0xc,%eax
  8005b2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005b9:	f6 c2 01             	test   $0x1,%dl
  8005bc:	75 39                	jne    8005f7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005c1:	89 d0                	mov    %edx,%eax
  8005c3:	c1 e8 0c             	shr    $0xc,%eax
  8005c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005cd:	83 ec 0c             	sub    $0xc,%esp
  8005d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8005d5:	50                   	push   %eax
  8005d6:	56                   	push   %esi
  8005d7:	6a 00                	push   $0x0
  8005d9:	52                   	push   %edx
  8005da:	6a 00                	push   $0x0
  8005dc:	e8 c0 fb ff ff       	call   8001a1 <sys_page_map>
  8005e1:	89 c3                	mov    %eax,%ebx
  8005e3:	83 c4 20             	add    $0x20,%esp
  8005e6:	85 c0                	test   %eax,%eax
  8005e8:	78 31                	js     80061b <dup+0xd1>
		goto err;

	return newfdnum;
  8005ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005ed:	89 d8                	mov    %ebx,%eax
  8005ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005f2:	5b                   	pop    %ebx
  8005f3:	5e                   	pop    %esi
  8005f4:	5f                   	pop    %edi
  8005f5:	5d                   	pop    %ebp
  8005f6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005fe:	83 ec 0c             	sub    $0xc,%esp
  800601:	25 07 0e 00 00       	and    $0xe07,%eax
  800606:	50                   	push   %eax
  800607:	57                   	push   %edi
  800608:	6a 00                	push   $0x0
  80060a:	53                   	push   %ebx
  80060b:	6a 00                	push   $0x0
  80060d:	e8 8f fb ff ff       	call   8001a1 <sys_page_map>
  800612:	89 c3                	mov    %eax,%ebx
  800614:	83 c4 20             	add    $0x20,%esp
  800617:	85 c0                	test   %eax,%eax
  800619:	79 a3                	jns    8005be <dup+0x74>
	sys_page_unmap(0, newfd);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	56                   	push   %esi
  80061f:	6a 00                	push   $0x0
  800621:	e8 bd fb ff ff       	call   8001e3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800626:	83 c4 08             	add    $0x8,%esp
  800629:	57                   	push   %edi
  80062a:	6a 00                	push   $0x0
  80062c:	e8 b2 fb ff ff       	call   8001e3 <sys_page_unmap>
	return r;
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	eb b7                	jmp    8005ed <dup+0xa3>

00800636 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	53                   	push   %ebx
  80063a:	83 ec 14             	sub    $0x14,%esp
  80063d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800643:	50                   	push   %eax
  800644:	53                   	push   %ebx
  800645:	e8 7b fd ff ff       	call   8003c5 <fd_lookup>
  80064a:	83 c4 08             	add    $0x8,%esp
  80064d:	85 c0                	test   %eax,%eax
  80064f:	78 3f                	js     800690 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800657:	50                   	push   %eax
  800658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065b:	ff 30                	pushl  (%eax)
  80065d:	e8 b9 fd ff ff       	call   80041b <dev_lookup>
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	85 c0                	test   %eax,%eax
  800667:	78 27                	js     800690 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800669:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80066c:	8b 42 08             	mov    0x8(%edx),%eax
  80066f:	83 e0 03             	and    $0x3,%eax
  800672:	83 f8 01             	cmp    $0x1,%eax
  800675:	74 1e                	je     800695 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067a:	8b 40 08             	mov    0x8(%eax),%eax
  80067d:	85 c0                	test   %eax,%eax
  80067f:	74 35                	je     8006b6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800681:	83 ec 04             	sub    $0x4,%esp
  800684:	ff 75 10             	pushl  0x10(%ebp)
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	52                   	push   %edx
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800693:	c9                   	leave  
  800694:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800695:	a1 04 40 80 00       	mov    0x804004,%eax
  80069a:	8b 40 48             	mov    0x48(%eax),%eax
  80069d:	83 ec 04             	sub    $0x4,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	50                   	push   %eax
  8006a2:	68 79 1d 80 00       	push   $0x801d79
  8006a7:	e8 39 0a 00 00       	call   8010e5 <cprintf>
		return -E_INVAL;
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006b4:	eb da                	jmp    800690 <read+0x5a>
		return -E_NOT_SUPP;
  8006b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006bb:	eb d3                	jmp    800690 <read+0x5a>

008006bd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	57                   	push   %edi
  8006c1:	56                   	push   %esi
  8006c2:	53                   	push   %ebx
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006c9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d1:	39 f3                	cmp    %esi,%ebx
  8006d3:	73 25                	jae    8006fa <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006d5:	83 ec 04             	sub    $0x4,%esp
  8006d8:	89 f0                	mov    %esi,%eax
  8006da:	29 d8                	sub    %ebx,%eax
  8006dc:	50                   	push   %eax
  8006dd:	89 d8                	mov    %ebx,%eax
  8006df:	03 45 0c             	add    0xc(%ebp),%eax
  8006e2:	50                   	push   %eax
  8006e3:	57                   	push   %edi
  8006e4:	e8 4d ff ff ff       	call   800636 <read>
		if (m < 0)
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	78 08                	js     8006f8 <readn+0x3b>
			return m;
		if (m == 0)
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	74 06                	je     8006fa <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8006f4:	01 c3                	add    %eax,%ebx
  8006f6:	eb d9                	jmp    8006d1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006fa:	89 d8                	mov    %ebx,%eax
  8006fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ff:	5b                   	pop    %ebx
  800700:	5e                   	pop    %esi
  800701:	5f                   	pop    %edi
  800702:	5d                   	pop    %ebp
  800703:	c3                   	ret    

00800704 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	53                   	push   %ebx
  800708:	83 ec 14             	sub    $0x14,%esp
  80070b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80070e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800711:	50                   	push   %eax
  800712:	53                   	push   %ebx
  800713:	e8 ad fc ff ff       	call   8003c5 <fd_lookup>
  800718:	83 c4 08             	add    $0x8,%esp
  80071b:	85 c0                	test   %eax,%eax
  80071d:	78 3a                	js     800759 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800725:	50                   	push   %eax
  800726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800729:	ff 30                	pushl  (%eax)
  80072b:	e8 eb fc ff ff       	call   80041b <dev_lookup>
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	85 c0                	test   %eax,%eax
  800735:	78 22                	js     800759 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80073e:	74 1e                	je     80075e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800743:	8b 52 0c             	mov    0xc(%edx),%edx
  800746:	85 d2                	test   %edx,%edx
  800748:	74 35                	je     80077f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80074a:	83 ec 04             	sub    $0x4,%esp
  80074d:	ff 75 10             	pushl  0x10(%ebp)
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	50                   	push   %eax
  800754:	ff d2                	call   *%edx
  800756:	83 c4 10             	add    $0x10,%esp
}
  800759:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80075c:	c9                   	leave  
  80075d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80075e:	a1 04 40 80 00       	mov    0x804004,%eax
  800763:	8b 40 48             	mov    0x48(%eax),%eax
  800766:	83 ec 04             	sub    $0x4,%esp
  800769:	53                   	push   %ebx
  80076a:	50                   	push   %eax
  80076b:	68 95 1d 80 00       	push   $0x801d95
  800770:	e8 70 09 00 00       	call   8010e5 <cprintf>
		return -E_INVAL;
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80077d:	eb da                	jmp    800759 <write+0x55>
		return -E_NOT_SUPP;
  80077f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800784:	eb d3                	jmp    800759 <write+0x55>

00800786 <seek>:

int
seek(int fdnum, off_t offset)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80078c:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80078f:	50                   	push   %eax
  800790:	ff 75 08             	pushl  0x8(%ebp)
  800793:	e8 2d fc ff ff       	call   8003c5 <fd_lookup>
  800798:	83 c4 08             	add    $0x8,%esp
  80079b:	85 c0                	test   %eax,%eax
  80079d:	78 0e                	js     8007ad <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80079f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007a5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007ad:	c9                   	leave  
  8007ae:	c3                   	ret    

008007af <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	53                   	push   %ebx
  8007b3:	83 ec 14             	sub    $0x14,%esp
  8007b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	53                   	push   %ebx
  8007be:	e8 02 fc ff ff       	call   8003c5 <fd_lookup>
  8007c3:	83 c4 08             	add    $0x8,%esp
  8007c6:	85 c0                	test   %eax,%eax
  8007c8:	78 37                	js     800801 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d0:	50                   	push   %eax
  8007d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d4:	ff 30                	pushl  (%eax)
  8007d6:	e8 40 fc ff ff       	call   80041b <dev_lookup>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	85 c0                	test   %eax,%eax
  8007e0:	78 1f                	js     800801 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007e9:	74 1b                	je     800806 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ee:	8b 52 18             	mov    0x18(%edx),%edx
  8007f1:	85 d2                	test   %edx,%edx
  8007f3:	74 32                	je     800827 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	ff 75 0c             	pushl  0xc(%ebp)
  8007fb:	50                   	push   %eax
  8007fc:	ff d2                	call   *%edx
  8007fe:	83 c4 10             	add    $0x10,%esp
}
  800801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800804:	c9                   	leave  
  800805:	c3                   	ret    
			thisenv->env_id, fdnum);
  800806:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80080b:	8b 40 48             	mov    0x48(%eax),%eax
  80080e:	83 ec 04             	sub    $0x4,%esp
  800811:	53                   	push   %ebx
  800812:	50                   	push   %eax
  800813:	68 58 1d 80 00       	push   $0x801d58
  800818:	e8 c8 08 00 00       	call   8010e5 <cprintf>
		return -E_INVAL;
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800825:	eb da                	jmp    800801 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800827:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80082c:	eb d3                	jmp    800801 <ftruncate+0x52>

0080082e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	53                   	push   %ebx
  800832:	83 ec 14             	sub    $0x14,%esp
  800835:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800838:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80083b:	50                   	push   %eax
  80083c:	ff 75 08             	pushl  0x8(%ebp)
  80083f:	e8 81 fb ff ff       	call   8003c5 <fd_lookup>
  800844:	83 c4 08             	add    $0x8,%esp
  800847:	85 c0                	test   %eax,%eax
  800849:	78 4b                	js     800896 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800851:	50                   	push   %eax
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	ff 30                	pushl  (%eax)
  800857:	e8 bf fb ff ff       	call   80041b <dev_lookup>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	85 c0                	test   %eax,%eax
  800861:	78 33                	js     800896 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800866:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80086a:	74 2f                	je     80089b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80086c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80086f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800876:	00 00 00 
	stat->st_isdir = 0;
  800879:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800880:	00 00 00 
	stat->st_dev = dev;
  800883:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	53                   	push   %ebx
  80088d:	ff 75 f0             	pushl  -0x10(%ebp)
  800890:	ff 50 14             	call   *0x14(%eax)
  800893:	83 c4 10             	add    $0x10,%esp
}
  800896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800899:	c9                   	leave  
  80089a:	c3                   	ret    
		return -E_NOT_SUPP;
  80089b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008a0:	eb f4                	jmp    800896 <fstat+0x68>

008008a2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	56                   	push   %esi
  8008a6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	6a 00                	push   $0x0
  8008ac:	ff 75 08             	pushl  0x8(%ebp)
  8008af:	e8 e7 01 00 00       	call   800a9b <open>
  8008b4:	89 c3                	mov    %eax,%ebx
  8008b6:	83 c4 10             	add    $0x10,%esp
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	78 1b                	js     8008d8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	50                   	push   %eax
  8008c4:	e8 65 ff ff ff       	call   80082e <fstat>
  8008c9:	89 c6                	mov    %eax,%esi
	close(fd);
  8008cb:	89 1c 24             	mov    %ebx,(%esp)
  8008ce:	e8 27 fc ff ff       	call   8004fa <close>
	return r;
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	89 f3                	mov    %esi,%ebx
}
  8008d8:	89 d8                	mov    %ebx,%eax
  8008da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008dd:	5b                   	pop    %ebx
  8008de:	5e                   	pop    %esi
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	56                   	push   %esi
  8008e5:	53                   	push   %ebx
  8008e6:	89 c6                	mov    %eax,%esi
  8008e8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008ea:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008f1:	74 27                	je     80091a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008f3:	6a 07                	push   $0x7
  8008f5:	68 00 50 80 00       	push   $0x805000
  8008fa:	56                   	push   %esi
  8008fb:	ff 35 00 40 80 00    	pushl  0x804000
  800901:	e8 1d 11 00 00       	call   801a23 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800906:	83 c4 0c             	add    $0xc,%esp
  800909:	6a 00                	push   $0x0
  80090b:	53                   	push   %ebx
  80090c:	6a 00                	push   $0x0
  80090e:	e8 f9 10 00 00       	call   801a0c <ipc_recv>
}
  800913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800916:	5b                   	pop    %ebx
  800917:	5e                   	pop    %esi
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80091a:	83 ec 0c             	sub    $0xc,%esp
  80091d:	6a 01                	push   $0x1
  80091f:	e8 16 11 00 00       	call   801a3a <ipc_find_env>
  800924:	a3 00 40 80 00       	mov    %eax,0x804000
  800929:	83 c4 10             	add    $0x10,%esp
  80092c:	eb c5                	jmp    8008f3 <fsipc+0x12>

0080092e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 40 0c             	mov    0xc(%eax),%eax
  80093a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800947:	ba 00 00 00 00       	mov    $0x0,%edx
  80094c:	b8 02 00 00 00       	mov    $0x2,%eax
  800951:	e8 8b ff ff ff       	call   8008e1 <fsipc>
}
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <devfile_flush>:
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 40 0c             	mov    0xc(%eax),%eax
  800964:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
  80096e:	b8 06 00 00 00       	mov    $0x6,%eax
  800973:	e8 69 ff ff ff       	call   8008e1 <fsipc>
}
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <devfile_stat>:
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	53                   	push   %ebx
  80097e:	83 ec 04             	sub    $0x4,%esp
  800981:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 40 0c             	mov    0xc(%eax),%eax
  80098a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80098f:	ba 00 00 00 00       	mov    $0x0,%edx
  800994:	b8 05 00 00 00       	mov    $0x5,%eax
  800999:	e8 43 ff ff ff       	call   8008e1 <fsipc>
  80099e:	85 c0                	test   %eax,%eax
  8009a0:	78 2c                	js     8009ce <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	68 00 50 80 00       	push   $0x805000
  8009aa:	53                   	push   %ebx
  8009ab:	e8 1f 0d 00 00       	call   8016cf <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009b0:	a1 80 50 80 00       	mov    0x805080,%eax
  8009b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009bb:	a1 84 50 80 00       	mov    0x805084,%eax
  8009c0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <devfile_write>:
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	83 ec 0c             	sub    $0xc,%esp
  8009d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009dc:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8009e1:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8009e6:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ec:	8b 52 0c             	mov    0xc(%edx),%edx
  8009ef:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8009f5:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8009fa:	50                   	push   %eax
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	68 08 50 80 00       	push   $0x805008
  800a03:	e8 55 0e 00 00       	call   80185d <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	b8 04 00 00 00       	mov    $0x4,%eax
  800a12:	e8 ca fe ff ff       	call   8008e1 <fsipc>
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <devfile_read>:
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	56                   	push   %esi
  800a1d:	53                   	push   %ebx
  800a1e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8b 40 0c             	mov    0xc(%eax),%eax
  800a27:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a2c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a32:	ba 00 00 00 00       	mov    $0x0,%edx
  800a37:	b8 03 00 00 00       	mov    $0x3,%eax
  800a3c:	e8 a0 fe ff ff       	call   8008e1 <fsipc>
  800a41:	89 c3                	mov    %eax,%ebx
  800a43:	85 c0                	test   %eax,%eax
  800a45:	78 1f                	js     800a66 <devfile_read+0x4d>
	assert(r <= n);
  800a47:	39 f0                	cmp    %esi,%eax
  800a49:	77 24                	ja     800a6f <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a4b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a50:	7f 33                	jg     800a85 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a52:	83 ec 04             	sub    $0x4,%esp
  800a55:	50                   	push   %eax
  800a56:	68 00 50 80 00       	push   $0x805000
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	e8 fa 0d 00 00       	call   80185d <memmove>
	return r;
  800a63:	83 c4 10             	add    $0x10,%esp
}
  800a66:	89 d8                	mov    %ebx,%eax
  800a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a6b:	5b                   	pop    %ebx
  800a6c:	5e                   	pop    %esi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    
	assert(r <= n);
  800a6f:	68 c4 1d 80 00       	push   $0x801dc4
  800a74:	68 cb 1d 80 00       	push   $0x801dcb
  800a79:	6a 7c                	push   $0x7c
  800a7b:	68 e0 1d 80 00       	push   $0x801de0
  800a80:	e8 85 05 00 00       	call   80100a <_panic>
	assert(r <= PGSIZE);
  800a85:	68 eb 1d 80 00       	push   $0x801deb
  800a8a:	68 cb 1d 80 00       	push   $0x801dcb
  800a8f:	6a 7d                	push   $0x7d
  800a91:	68 e0 1d 80 00       	push   $0x801de0
  800a96:	e8 6f 05 00 00       	call   80100a <_panic>

00800a9b <open>:
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	56                   	push   %esi
  800a9f:	53                   	push   %ebx
  800aa0:	83 ec 1c             	sub    $0x1c,%esp
  800aa3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800aa6:	56                   	push   %esi
  800aa7:	e8 ec 0b 00 00       	call   801698 <strlen>
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ab4:	7f 6c                	jg     800b22 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ab6:	83 ec 0c             	sub    $0xc,%esp
  800ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 b4 f8 ff ff       	call   800376 <fd_alloc>
  800ac2:	89 c3                	mov    %eax,%ebx
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	85 c0                	test   %eax,%eax
  800ac9:	78 3c                	js     800b07 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	56                   	push   %esi
  800acf:	68 00 50 80 00       	push   $0x805000
  800ad4:	e8 f6 0b 00 00       	call   8016cf <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae4:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae9:	e8 f3 fd ff ff       	call   8008e1 <fsipc>
  800aee:	89 c3                	mov    %eax,%ebx
  800af0:	83 c4 10             	add    $0x10,%esp
  800af3:	85 c0                	test   %eax,%eax
  800af5:	78 19                	js     800b10 <open+0x75>
	return fd2num(fd);
  800af7:	83 ec 0c             	sub    $0xc,%esp
  800afa:	ff 75 f4             	pushl  -0xc(%ebp)
  800afd:	e8 4d f8 ff ff       	call   80034f <fd2num>
  800b02:	89 c3                	mov    %eax,%ebx
  800b04:	83 c4 10             	add    $0x10,%esp
}
  800b07:	89 d8                	mov    %ebx,%eax
  800b09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b0c:	5b                   	pop    %ebx
  800b0d:	5e                   	pop    %esi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    
		fd_close(fd, 0);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	6a 00                	push   $0x0
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	e8 54 f9 ff ff       	call   800471 <fd_close>
		return r;
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	eb e5                	jmp    800b07 <open+0x6c>
		return -E_BAD_PATH;
  800b22:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b27:	eb de                	jmp    800b07 <open+0x6c>

00800b29 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b34:	b8 08 00 00 00       	mov    $0x8,%eax
  800b39:	e8 a3 fd ff ff       	call   8008e1 <fsipc>
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	56                   	push   %esi
  800b44:	53                   	push   %ebx
  800b45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	ff 75 08             	pushl  0x8(%ebp)
  800b4e:	e8 0c f8 ff ff       	call   80035f <fd2data>
  800b53:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b55:	83 c4 08             	add    $0x8,%esp
  800b58:	68 f7 1d 80 00       	push   $0x801df7
  800b5d:	53                   	push   %ebx
  800b5e:	e8 6c 0b 00 00       	call   8016cf <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b63:	8b 46 04             	mov    0x4(%esi),%eax
  800b66:	2b 06                	sub    (%esi),%eax
  800b68:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b6e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b75:	00 00 00 
	stat->st_dev = &devpipe;
  800b78:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b7f:	30 80 00 
	return 0;
}
  800b82:	b8 00 00 00 00       	mov    $0x0,%eax
  800b87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	53                   	push   %ebx
  800b92:	83 ec 0c             	sub    $0xc,%esp
  800b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b98:	53                   	push   %ebx
  800b99:	6a 00                	push   $0x0
  800b9b:	e8 43 f6 ff ff       	call   8001e3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800ba0:	89 1c 24             	mov    %ebx,(%esp)
  800ba3:	e8 b7 f7 ff ff       	call   80035f <fd2data>
  800ba8:	83 c4 08             	add    $0x8,%esp
  800bab:	50                   	push   %eax
  800bac:	6a 00                	push   $0x0
  800bae:	e8 30 f6 ff ff       	call   8001e3 <sys_page_unmap>
}
  800bb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <_pipeisclosed>:
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
  800bbe:	83 ec 1c             	sub    $0x1c,%esp
  800bc1:	89 c7                	mov    %eax,%edi
  800bc3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800bc5:	a1 04 40 80 00       	mov    0x804004,%eax
  800bca:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800bcd:	83 ec 0c             	sub    $0xc,%esp
  800bd0:	57                   	push   %edi
  800bd1:	e8 9d 0e 00 00       	call   801a73 <pageref>
  800bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bd9:	89 34 24             	mov    %esi,(%esp)
  800bdc:	e8 92 0e 00 00       	call   801a73 <pageref>
		nn = thisenv->env_runs;
  800be1:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800be7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	39 cb                	cmp    %ecx,%ebx
  800bef:	74 1b                	je     800c0c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800bf1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800bf4:	75 cf                	jne    800bc5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bf6:	8b 42 58             	mov    0x58(%edx),%eax
  800bf9:	6a 01                	push   $0x1
  800bfb:	50                   	push   %eax
  800bfc:	53                   	push   %ebx
  800bfd:	68 fe 1d 80 00       	push   $0x801dfe
  800c02:	e8 de 04 00 00       	call   8010e5 <cprintf>
  800c07:	83 c4 10             	add    $0x10,%esp
  800c0a:	eb b9                	jmp    800bc5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c0c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c0f:	0f 94 c0             	sete   %al
  800c12:	0f b6 c0             	movzbl %al,%eax
}
  800c15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <devpipe_write>:
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
  800c23:	83 ec 28             	sub    $0x28,%esp
  800c26:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c29:	56                   	push   %esi
  800c2a:	e8 30 f7 ff ff       	call   80035f <fd2data>
  800c2f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	bf 00 00 00 00       	mov    $0x0,%edi
  800c39:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c3c:	74 4f                	je     800c8d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c3e:	8b 43 04             	mov    0x4(%ebx),%eax
  800c41:	8b 0b                	mov    (%ebx),%ecx
  800c43:	8d 51 20             	lea    0x20(%ecx),%edx
  800c46:	39 d0                	cmp    %edx,%eax
  800c48:	72 14                	jb     800c5e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800c4a:	89 da                	mov    %ebx,%edx
  800c4c:	89 f0                	mov    %esi,%eax
  800c4e:	e8 65 ff ff ff       	call   800bb8 <_pipeisclosed>
  800c53:	85 c0                	test   %eax,%eax
  800c55:	75 3a                	jne    800c91 <devpipe_write+0x74>
			sys_yield();
  800c57:	e8 e3 f4 ff ff       	call   80013f <sys_yield>
  800c5c:	eb e0                	jmp    800c3e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c61:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c65:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c68:	89 c2                	mov    %eax,%edx
  800c6a:	c1 fa 1f             	sar    $0x1f,%edx
  800c6d:	89 d1                	mov    %edx,%ecx
  800c6f:	c1 e9 1b             	shr    $0x1b,%ecx
  800c72:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c75:	83 e2 1f             	and    $0x1f,%edx
  800c78:	29 ca                	sub    %ecx,%edx
  800c7a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c7e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c82:	83 c0 01             	add    $0x1,%eax
  800c85:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800c88:	83 c7 01             	add    $0x1,%edi
  800c8b:	eb ac                	jmp    800c39 <devpipe_write+0x1c>
	return i;
  800c8d:	89 f8                	mov    %edi,%eax
  800c8f:	eb 05                	jmp    800c96 <devpipe_write+0x79>
				return 0;
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <devpipe_read>:
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
  800ca4:	83 ec 18             	sub    $0x18,%esp
  800ca7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800caa:	57                   	push   %edi
  800cab:	e8 af f6 ff ff       	call   80035f <fd2data>
  800cb0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	be 00 00 00 00       	mov    $0x0,%esi
  800cba:	3b 75 10             	cmp    0x10(%ebp),%esi
  800cbd:	74 47                	je     800d06 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800cbf:	8b 03                	mov    (%ebx),%eax
  800cc1:	3b 43 04             	cmp    0x4(%ebx),%eax
  800cc4:	75 22                	jne    800ce8 <devpipe_read+0x4a>
			if (i > 0)
  800cc6:	85 f6                	test   %esi,%esi
  800cc8:	75 14                	jne    800cde <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800cca:	89 da                	mov    %ebx,%edx
  800ccc:	89 f8                	mov    %edi,%eax
  800cce:	e8 e5 fe ff ff       	call   800bb8 <_pipeisclosed>
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	75 33                	jne    800d0a <devpipe_read+0x6c>
			sys_yield();
  800cd7:	e8 63 f4 ff ff       	call   80013f <sys_yield>
  800cdc:	eb e1                	jmp    800cbf <devpipe_read+0x21>
				return i;
  800cde:	89 f0                	mov    %esi,%eax
}
  800ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ce8:	99                   	cltd   
  800ce9:	c1 ea 1b             	shr    $0x1b,%edx
  800cec:	01 d0                	add    %edx,%eax
  800cee:	83 e0 1f             	and    $0x1f,%eax
  800cf1:	29 d0                	sub    %edx,%eax
  800cf3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800cf8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800cfe:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d01:	83 c6 01             	add    $0x1,%esi
  800d04:	eb b4                	jmp    800cba <devpipe_read+0x1c>
	return i;
  800d06:	89 f0                	mov    %esi,%eax
  800d08:	eb d6                	jmp    800ce0 <devpipe_read+0x42>
				return 0;
  800d0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0f:	eb cf                	jmp    800ce0 <devpipe_read+0x42>

00800d11 <pipe>:
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
  800d16:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d1c:	50                   	push   %eax
  800d1d:	e8 54 f6 ff ff       	call   800376 <fd_alloc>
  800d22:	89 c3                	mov    %eax,%ebx
  800d24:	83 c4 10             	add    $0x10,%esp
  800d27:	85 c0                	test   %eax,%eax
  800d29:	78 5b                	js     800d86 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d2b:	83 ec 04             	sub    $0x4,%esp
  800d2e:	68 07 04 00 00       	push   $0x407
  800d33:	ff 75 f4             	pushl  -0xc(%ebp)
  800d36:	6a 00                	push   $0x0
  800d38:	e8 21 f4 ff ff       	call   80015e <sys_page_alloc>
  800d3d:	89 c3                	mov    %eax,%ebx
  800d3f:	83 c4 10             	add    $0x10,%esp
  800d42:	85 c0                	test   %eax,%eax
  800d44:	78 40                	js     800d86 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800d46:	83 ec 0c             	sub    $0xc,%esp
  800d49:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d4c:	50                   	push   %eax
  800d4d:	e8 24 f6 ff ff       	call   800376 <fd_alloc>
  800d52:	89 c3                	mov    %eax,%ebx
  800d54:	83 c4 10             	add    $0x10,%esp
  800d57:	85 c0                	test   %eax,%eax
  800d59:	78 1b                	js     800d76 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	68 07 04 00 00       	push   $0x407
  800d63:	ff 75 f0             	pushl  -0x10(%ebp)
  800d66:	6a 00                	push   $0x0
  800d68:	e8 f1 f3 ff ff       	call   80015e <sys_page_alloc>
  800d6d:	89 c3                	mov    %eax,%ebx
  800d6f:	83 c4 10             	add    $0x10,%esp
  800d72:	85 c0                	test   %eax,%eax
  800d74:	79 19                	jns    800d8f <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7c:	6a 00                	push   $0x0
  800d7e:	e8 60 f4 ff ff       	call   8001e3 <sys_page_unmap>
  800d83:	83 c4 10             	add    $0x10,%esp
}
  800d86:	89 d8                	mov    %ebx,%eax
  800d88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
	va = fd2data(fd0);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	ff 75 f4             	pushl  -0xc(%ebp)
  800d95:	e8 c5 f5 ff ff       	call   80035f <fd2data>
  800d9a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d9c:	83 c4 0c             	add    $0xc,%esp
  800d9f:	68 07 04 00 00       	push   $0x407
  800da4:	50                   	push   %eax
  800da5:	6a 00                	push   $0x0
  800da7:	e8 b2 f3 ff ff       	call   80015e <sys_page_alloc>
  800dac:	89 c3                	mov    %eax,%ebx
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	85 c0                	test   %eax,%eax
  800db3:	0f 88 8c 00 00 00    	js     800e45 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db9:	83 ec 0c             	sub    $0xc,%esp
  800dbc:	ff 75 f0             	pushl  -0x10(%ebp)
  800dbf:	e8 9b f5 ff ff       	call   80035f <fd2data>
  800dc4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800dcb:	50                   	push   %eax
  800dcc:	6a 00                	push   $0x0
  800dce:	56                   	push   %esi
  800dcf:	6a 00                	push   $0x0
  800dd1:	e8 cb f3 ff ff       	call   8001a1 <sys_page_map>
  800dd6:	89 c3                	mov    %eax,%ebx
  800dd8:	83 c4 20             	add    $0x20,%esp
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	78 58                	js     800e37 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800de8:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ded:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800dfd:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e02:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e09:	83 ec 0c             	sub    $0xc,%esp
  800e0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0f:	e8 3b f5 ff ff       	call   80034f <fd2num>
  800e14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e17:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e19:	83 c4 04             	add    $0x4,%esp
  800e1c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e1f:	e8 2b f5 ff ff       	call   80034f <fd2num>
  800e24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e27:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e2a:	83 c4 10             	add    $0x10,%esp
  800e2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e32:	e9 4f ff ff ff       	jmp    800d86 <pipe+0x75>
	sys_page_unmap(0, va);
  800e37:	83 ec 08             	sub    $0x8,%esp
  800e3a:	56                   	push   %esi
  800e3b:	6a 00                	push   $0x0
  800e3d:	e8 a1 f3 ff ff       	call   8001e3 <sys_page_unmap>
  800e42:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	ff 75 f0             	pushl  -0x10(%ebp)
  800e4b:	6a 00                	push   $0x0
  800e4d:	e8 91 f3 ff ff       	call   8001e3 <sys_page_unmap>
  800e52:	83 c4 10             	add    $0x10,%esp
  800e55:	e9 1c ff ff ff       	jmp    800d76 <pipe+0x65>

00800e5a <pipeisclosed>:
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e63:	50                   	push   %eax
  800e64:	ff 75 08             	pushl  0x8(%ebp)
  800e67:	e8 59 f5 ff ff       	call   8003c5 <fd_lookup>
  800e6c:	83 c4 10             	add    $0x10,%esp
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	78 18                	js     800e8b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	ff 75 f4             	pushl  -0xc(%ebp)
  800e79:	e8 e1 f4 ff ff       	call   80035f <fd2data>
	return _pipeisclosed(fd, p);
  800e7e:	89 c2                	mov    %eax,%edx
  800e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e83:	e8 30 fd ff ff       	call   800bb8 <_pipeisclosed>
  800e88:	83 c4 10             	add    $0x10,%esp
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e90:	b8 00 00 00 00       	mov    $0x0,%eax
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e9d:	68 16 1e 80 00       	push   $0x801e16
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	e8 25 08 00 00       	call   8016cf <strcpy>
	return 0;
}
  800eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  800eaf:	c9                   	leave  
  800eb0:	c3                   	ret    

00800eb1 <devcons_write>:
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
  800eb7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800ebd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800ec2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800ec8:	eb 2f                	jmp    800ef9 <devcons_write+0x48>
		m = n - tot;
  800eca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecd:	29 f3                	sub    %esi,%ebx
  800ecf:	83 fb 7f             	cmp    $0x7f,%ebx
  800ed2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800ed7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800eda:	83 ec 04             	sub    $0x4,%esp
  800edd:	53                   	push   %ebx
  800ede:	89 f0                	mov    %esi,%eax
  800ee0:	03 45 0c             	add    0xc(%ebp),%eax
  800ee3:	50                   	push   %eax
  800ee4:	57                   	push   %edi
  800ee5:	e8 73 09 00 00       	call   80185d <memmove>
		sys_cputs(buf, m);
  800eea:	83 c4 08             	add    $0x8,%esp
  800eed:	53                   	push   %ebx
  800eee:	57                   	push   %edi
  800eef:	e8 ae f1 ff ff       	call   8000a2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800ef4:	01 de                	add    %ebx,%esi
  800ef6:	83 c4 10             	add    $0x10,%esp
  800ef9:	3b 75 10             	cmp    0x10(%ebp),%esi
  800efc:	72 cc                	jb     800eca <devcons_write+0x19>
}
  800efe:	89 f0                	mov    %esi,%eax
  800f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <devcons_read>:
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
  800f0e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	75 07                	jne    800f20 <devcons_read+0x18>
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    
		sys_yield();
  800f1b:	e8 1f f2 ff ff       	call   80013f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800f20:	e8 9b f1 ff ff       	call   8000c0 <sys_cgetc>
  800f25:	85 c0                	test   %eax,%eax
  800f27:	74 f2                	je     800f1b <devcons_read+0x13>
	if (c < 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	78 ec                	js     800f19 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  800f2d:	83 f8 04             	cmp    $0x4,%eax
  800f30:	74 0c                	je     800f3e <devcons_read+0x36>
	*(char*)vbuf = c;
  800f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f35:	88 02                	mov    %al,(%edx)
	return 1;
  800f37:	b8 01 00 00 00       	mov    $0x1,%eax
  800f3c:	eb db                	jmp    800f19 <devcons_read+0x11>
		return 0;
  800f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f43:	eb d4                	jmp    800f19 <devcons_read+0x11>

00800f45 <cputchar>:
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800f51:	6a 01                	push   $0x1
  800f53:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f56:	50                   	push   %eax
  800f57:	e8 46 f1 ff ff       	call   8000a2 <sys_cputs>
}
  800f5c:	83 c4 10             	add    $0x10,%esp
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    

00800f61 <getchar>:
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800f67:	6a 01                	push   $0x1
  800f69:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	6a 00                	push   $0x0
  800f6f:	e8 c2 f6 ff ff       	call   800636 <read>
	if (r < 0)
  800f74:	83 c4 10             	add    $0x10,%esp
  800f77:	85 c0                	test   %eax,%eax
  800f79:	78 08                	js     800f83 <getchar+0x22>
	if (r < 1)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	7e 06                	jle    800f85 <getchar+0x24>
	return c;
  800f7f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    
		return -E_EOF;
  800f85:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800f8a:	eb f7                	jmp    800f83 <getchar+0x22>

00800f8c <iscons>:
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f95:	50                   	push   %eax
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 27 f4 ff ff       	call   8003c5 <fd_lookup>
  800f9e:	83 c4 10             	add    $0x10,%esp
  800fa1:	85 c0                	test   %eax,%eax
  800fa3:	78 11                	js     800fb6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa8:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fae:	39 10                	cmp    %edx,(%eax)
  800fb0:	0f 94 c0             	sete   %al
  800fb3:	0f b6 c0             	movzbl %al,%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <opencons>:
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800fbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fc1:	50                   	push   %eax
  800fc2:	e8 af f3 ff ff       	call   800376 <fd_alloc>
  800fc7:	83 c4 10             	add    $0x10,%esp
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	78 3a                	js     801008 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	68 07 04 00 00       	push   $0x407
  800fd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd9:	6a 00                	push   $0x0
  800fdb:	e8 7e f1 ff ff       	call   80015e <sys_page_alloc>
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	78 21                	js     801008 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fea:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800ff0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	50                   	push   %eax
  801000:	e8 4a f3 ff ff       	call   80034f <fd2num>
  801005:	83 c4 10             	add    $0x10,%esp
}
  801008:	c9                   	leave  
  801009:	c3                   	ret    

0080100a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80100f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801012:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801018:	e8 03 f1 ff ff       	call   800120 <sys_getenvid>
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	ff 75 0c             	pushl  0xc(%ebp)
  801023:	ff 75 08             	pushl  0x8(%ebp)
  801026:	56                   	push   %esi
  801027:	50                   	push   %eax
  801028:	68 24 1e 80 00       	push   $0x801e24
  80102d:	e8 b3 00 00 00       	call   8010e5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801032:	83 c4 18             	add    $0x18,%esp
  801035:	53                   	push   %ebx
  801036:	ff 75 10             	pushl  0x10(%ebp)
  801039:	e8 56 00 00 00       	call   801094 <vcprintf>
	cprintf("\n");
  80103e:	c7 04 24 0f 1e 80 00 	movl   $0x801e0f,(%esp)
  801045:	e8 9b 00 00 00       	call   8010e5 <cprintf>
  80104a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80104d:	cc                   	int3   
  80104e:	eb fd                	jmp    80104d <_panic+0x43>

00801050 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	53                   	push   %ebx
  801054:	83 ec 04             	sub    $0x4,%esp
  801057:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80105a:	8b 13                	mov    (%ebx),%edx
  80105c:	8d 42 01             	lea    0x1(%edx),%eax
  80105f:	89 03                	mov    %eax,(%ebx)
  801061:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801064:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801068:	3d ff 00 00 00       	cmp    $0xff,%eax
  80106d:	74 09                	je     801078 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80106f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801073:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801076:	c9                   	leave  
  801077:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	68 ff 00 00 00       	push   $0xff
  801080:	8d 43 08             	lea    0x8(%ebx),%eax
  801083:	50                   	push   %eax
  801084:	e8 19 f0 ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  801089:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80108f:	83 c4 10             	add    $0x10,%esp
  801092:	eb db                	jmp    80106f <putch+0x1f>

00801094 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80109d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8010a4:	00 00 00 
	b.cnt = 0;
  8010a7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8010ae:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8010bd:	50                   	push   %eax
  8010be:	68 50 10 80 00       	push   $0x801050
  8010c3:	e8 1a 01 00 00       	call   8011e2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8010c8:	83 c4 08             	add    $0x8,%esp
  8010cb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8010d1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8010d7:	50                   	push   %eax
  8010d8:	e8 c5 ef ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  8010dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010eb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010ee:	50                   	push   %eax
  8010ef:	ff 75 08             	pushl  0x8(%ebp)
  8010f2:	e8 9d ff ff ff       	call   801094 <vcprintf>
	va_end(ap);

	return cnt;
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	57                   	push   %edi
  8010fd:	56                   	push   %esi
  8010fe:	53                   	push   %ebx
  8010ff:	83 ec 1c             	sub    $0x1c,%esp
  801102:	89 c7                	mov    %eax,%edi
  801104:	89 d6                	mov    %edx,%esi
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80110f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801112:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801115:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80111d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801120:	39 d3                	cmp    %edx,%ebx
  801122:	72 05                	jb     801129 <printnum+0x30>
  801124:	39 45 10             	cmp    %eax,0x10(%ebp)
  801127:	77 7a                	ja     8011a3 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801129:	83 ec 0c             	sub    $0xc,%esp
  80112c:	ff 75 18             	pushl  0x18(%ebp)
  80112f:	8b 45 14             	mov    0x14(%ebp),%eax
  801132:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801135:	53                   	push   %ebx
  801136:	ff 75 10             	pushl  0x10(%ebp)
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113f:	ff 75 e0             	pushl  -0x20(%ebp)
  801142:	ff 75 dc             	pushl  -0x24(%ebp)
  801145:	ff 75 d8             	pushl  -0x28(%ebp)
  801148:	e8 63 09 00 00       	call   801ab0 <__udivdi3>
  80114d:	83 c4 18             	add    $0x18,%esp
  801150:	52                   	push   %edx
  801151:	50                   	push   %eax
  801152:	89 f2                	mov    %esi,%edx
  801154:	89 f8                	mov    %edi,%eax
  801156:	e8 9e ff ff ff       	call   8010f9 <printnum>
  80115b:	83 c4 20             	add    $0x20,%esp
  80115e:	eb 13                	jmp    801173 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801160:	83 ec 08             	sub    $0x8,%esp
  801163:	56                   	push   %esi
  801164:	ff 75 18             	pushl  0x18(%ebp)
  801167:	ff d7                	call   *%edi
  801169:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80116c:	83 eb 01             	sub    $0x1,%ebx
  80116f:	85 db                	test   %ebx,%ebx
  801171:	7f ed                	jg     801160 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801173:	83 ec 08             	sub    $0x8,%esp
  801176:	56                   	push   %esi
  801177:	83 ec 04             	sub    $0x4,%esp
  80117a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117d:	ff 75 e0             	pushl  -0x20(%ebp)
  801180:	ff 75 dc             	pushl  -0x24(%ebp)
  801183:	ff 75 d8             	pushl  -0x28(%ebp)
  801186:	e8 45 0a 00 00       	call   801bd0 <__umoddi3>
  80118b:	83 c4 14             	add    $0x14,%esp
  80118e:	0f be 80 47 1e 80 00 	movsbl 0x801e47(%eax),%eax
  801195:	50                   	push   %eax
  801196:	ff d7                	call   *%edi
}
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119e:	5b                   	pop    %ebx
  80119f:	5e                   	pop    %esi
  8011a0:	5f                   	pop    %edi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    
  8011a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011a6:	eb c4                	jmp    80116c <printnum+0x73>

008011a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011ae:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011b2:	8b 10                	mov    (%eax),%edx
  8011b4:	3b 50 04             	cmp    0x4(%eax),%edx
  8011b7:	73 0a                	jae    8011c3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8011b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011bc:	89 08                	mov    %ecx,(%eax)
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	88 02                	mov    %al,(%edx)
}
  8011c3:	5d                   	pop    %ebp
  8011c4:	c3                   	ret    

008011c5 <printfmt>:
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8011cb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8011ce:	50                   	push   %eax
  8011cf:	ff 75 10             	pushl  0x10(%ebp)
  8011d2:	ff 75 0c             	pushl  0xc(%ebp)
  8011d5:	ff 75 08             	pushl  0x8(%ebp)
  8011d8:	e8 05 00 00 00       	call   8011e2 <vprintfmt>
}
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	c9                   	leave  
  8011e1:	c3                   	ret    

008011e2 <vprintfmt>:
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	57                   	push   %edi
  8011e6:	56                   	push   %esi
  8011e7:	53                   	push   %ebx
  8011e8:	83 ec 2c             	sub    $0x2c,%esp
  8011eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011f1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8011f4:	e9 8c 03 00 00       	jmp    801585 <vprintfmt+0x3a3>
		padc = ' ';
  8011f9:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8011fd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801204:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80120b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801212:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801217:	8d 47 01             	lea    0x1(%edi),%eax
  80121a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80121d:	0f b6 17             	movzbl (%edi),%edx
  801220:	8d 42 dd             	lea    -0x23(%edx),%eax
  801223:	3c 55                	cmp    $0x55,%al
  801225:	0f 87 dd 03 00 00    	ja     801608 <vprintfmt+0x426>
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	ff 24 85 80 1f 80 00 	jmp    *0x801f80(,%eax,4)
  801235:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801238:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80123c:	eb d9                	jmp    801217 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80123e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801241:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801245:	eb d0                	jmp    801217 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801247:	0f b6 d2             	movzbl %dl,%edx
  80124a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
  801252:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801255:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801258:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80125c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80125f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801262:	83 f9 09             	cmp    $0x9,%ecx
  801265:	77 55                	ja     8012bc <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801267:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80126a:	eb e9                	jmp    801255 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	8b 00                	mov    (%eax),%eax
  801271:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	8d 40 04             	lea    0x4(%eax),%eax
  80127a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80127d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801280:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801284:	79 91                	jns    801217 <vprintfmt+0x35>
				width = precision, precision = -1;
  801286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801289:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80128c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801293:	eb 82                	jmp    801217 <vprintfmt+0x35>
  801295:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801298:	85 c0                	test   %eax,%eax
  80129a:	ba 00 00 00 00       	mov    $0x0,%edx
  80129f:	0f 49 d0             	cmovns %eax,%edx
  8012a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8012a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012a8:	e9 6a ff ff ff       	jmp    801217 <vprintfmt+0x35>
  8012ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8012b0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012b7:	e9 5b ff ff ff       	jmp    801217 <vprintfmt+0x35>
  8012bc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8012bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8012c2:	eb bc                	jmp    801280 <vprintfmt+0x9e>
			lflag++;
  8012c4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8012ca:	e9 48 ff ff ff       	jmp    801217 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8012cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d2:	8d 78 04             	lea    0x4(%eax),%edi
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	53                   	push   %ebx
  8012d9:	ff 30                	pushl  (%eax)
  8012db:	ff d6                	call   *%esi
			break;
  8012dd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8012e0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8012e3:	e9 9a 02 00 00       	jmp    801582 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8012e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012eb:	8d 78 04             	lea    0x4(%eax),%edi
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	99                   	cltd   
  8012f1:	31 d0                	xor    %edx,%eax
  8012f3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012f5:	83 f8 0f             	cmp    $0xf,%eax
  8012f8:	7f 23                	jg     80131d <vprintfmt+0x13b>
  8012fa:	8b 14 85 e0 20 80 00 	mov    0x8020e0(,%eax,4),%edx
  801301:	85 d2                	test   %edx,%edx
  801303:	74 18                	je     80131d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801305:	52                   	push   %edx
  801306:	68 dd 1d 80 00       	push   $0x801ddd
  80130b:	53                   	push   %ebx
  80130c:	56                   	push   %esi
  80130d:	e8 b3 fe ff ff       	call   8011c5 <printfmt>
  801312:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801315:	89 7d 14             	mov    %edi,0x14(%ebp)
  801318:	e9 65 02 00 00       	jmp    801582 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80131d:	50                   	push   %eax
  80131e:	68 5f 1e 80 00       	push   $0x801e5f
  801323:	53                   	push   %ebx
  801324:	56                   	push   %esi
  801325:	e8 9b fe ff ff       	call   8011c5 <printfmt>
  80132a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80132d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801330:	e9 4d 02 00 00       	jmp    801582 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	83 c0 04             	add    $0x4,%eax
  80133b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80133e:	8b 45 14             	mov    0x14(%ebp),%eax
  801341:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801343:	85 ff                	test   %edi,%edi
  801345:	b8 58 1e 80 00       	mov    $0x801e58,%eax
  80134a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80134d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801351:	0f 8e bd 00 00 00    	jle    801414 <vprintfmt+0x232>
  801357:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80135b:	75 0e                	jne    80136b <vprintfmt+0x189>
  80135d:	89 75 08             	mov    %esi,0x8(%ebp)
  801360:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801363:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801366:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801369:	eb 6d                	jmp    8013d8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 d0             	pushl  -0x30(%ebp)
  801371:	57                   	push   %edi
  801372:	e8 39 03 00 00       	call   8016b0 <strnlen>
  801377:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80137a:	29 c1                	sub    %eax,%ecx
  80137c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80137f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801382:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801386:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801389:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80138c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80138e:	eb 0f                	jmp    80139f <vprintfmt+0x1bd>
					putch(padc, putdat);
  801390:	83 ec 08             	sub    $0x8,%esp
  801393:	53                   	push   %ebx
  801394:	ff 75 e0             	pushl  -0x20(%ebp)
  801397:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801399:	83 ef 01             	sub    $0x1,%edi
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 ff                	test   %edi,%edi
  8013a1:	7f ed                	jg     801390 <vprintfmt+0x1ae>
  8013a3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013a6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8013a9:	85 c9                	test   %ecx,%ecx
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b0:	0f 49 c1             	cmovns %ecx,%eax
  8013b3:	29 c1                	sub    %eax,%ecx
  8013b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8013b8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8013bb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8013be:	89 cb                	mov    %ecx,%ebx
  8013c0:	eb 16                	jmp    8013d8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8013c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013c6:	75 31                	jne    8013f9 <vprintfmt+0x217>
					putch(ch, putdat);
  8013c8:	83 ec 08             	sub    $0x8,%esp
  8013cb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ce:	50                   	push   %eax
  8013cf:	ff 55 08             	call   *0x8(%ebp)
  8013d2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d5:	83 eb 01             	sub    $0x1,%ebx
  8013d8:	83 c7 01             	add    $0x1,%edi
  8013db:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8013df:	0f be c2             	movsbl %dl,%eax
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	74 59                	je     80143f <vprintfmt+0x25d>
  8013e6:	85 f6                	test   %esi,%esi
  8013e8:	78 d8                	js     8013c2 <vprintfmt+0x1e0>
  8013ea:	83 ee 01             	sub    $0x1,%esi
  8013ed:	79 d3                	jns    8013c2 <vprintfmt+0x1e0>
  8013ef:	89 df                	mov    %ebx,%edi
  8013f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8013f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8013f7:	eb 37                	jmp    801430 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8013f9:	0f be d2             	movsbl %dl,%edx
  8013fc:	83 ea 20             	sub    $0x20,%edx
  8013ff:	83 fa 5e             	cmp    $0x5e,%edx
  801402:	76 c4                	jbe    8013c8 <vprintfmt+0x1e6>
					putch('?', putdat);
  801404:	83 ec 08             	sub    $0x8,%esp
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	6a 3f                	push   $0x3f
  80140c:	ff 55 08             	call   *0x8(%ebp)
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	eb c1                	jmp    8013d5 <vprintfmt+0x1f3>
  801414:	89 75 08             	mov    %esi,0x8(%ebp)
  801417:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80141a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80141d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801420:	eb b6                	jmp    8013d8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  801422:	83 ec 08             	sub    $0x8,%esp
  801425:	53                   	push   %ebx
  801426:	6a 20                	push   $0x20
  801428:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80142a:	83 ef 01             	sub    $0x1,%edi
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 ff                	test   %edi,%edi
  801432:	7f ee                	jg     801422 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801434:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801437:	89 45 14             	mov    %eax,0x14(%ebp)
  80143a:	e9 43 01 00 00       	jmp    801582 <vprintfmt+0x3a0>
  80143f:	89 df                	mov    %ebx,%edi
  801441:	8b 75 08             	mov    0x8(%ebp),%esi
  801444:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801447:	eb e7                	jmp    801430 <vprintfmt+0x24e>
	if (lflag >= 2)
  801449:	83 f9 01             	cmp    $0x1,%ecx
  80144c:	7e 3f                	jle    80148d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 50 04             	mov    0x4(%eax),%edx
  801454:	8b 00                	mov    (%eax),%eax
  801456:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801459:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80145c:	8b 45 14             	mov    0x14(%ebp),%eax
  80145f:	8d 40 08             	lea    0x8(%eax),%eax
  801462:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801465:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801469:	79 5c                	jns    8014c7 <vprintfmt+0x2e5>
				putch('-', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	53                   	push   %ebx
  80146f:	6a 2d                	push   $0x2d
  801471:	ff d6                	call   *%esi
				num = -(long long) num;
  801473:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801476:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801479:	f7 da                	neg    %edx
  80147b:	83 d1 00             	adc    $0x0,%ecx
  80147e:	f7 d9                	neg    %ecx
  801480:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801483:	b8 0a 00 00 00       	mov    $0xa,%eax
  801488:	e9 db 00 00 00       	jmp    801568 <vprintfmt+0x386>
	else if (lflag)
  80148d:	85 c9                	test   %ecx,%ecx
  80148f:	75 1b                	jne    8014ac <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801499:	89 c1                	mov    %eax,%ecx
  80149b:	c1 f9 1f             	sar    $0x1f,%ecx
  80149e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8014a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a4:	8d 40 04             	lea    0x4(%eax),%eax
  8014a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8014aa:	eb b9                	jmp    801465 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014b4:	89 c1                	mov    %eax,%ecx
  8014b6:	c1 f9 1f             	sar    $0x1f,%ecx
  8014b9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8014bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bf:	8d 40 04             	lea    0x4(%eax),%eax
  8014c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8014c5:	eb 9e                	jmp    801465 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8014c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8014cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014d2:	e9 91 00 00 00       	jmp    801568 <vprintfmt+0x386>
	if (lflag >= 2)
  8014d7:	83 f9 01             	cmp    $0x1,%ecx
  8014da:	7e 15                	jle    8014f1 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	8b 10                	mov    (%eax),%edx
  8014e1:	8b 48 04             	mov    0x4(%eax),%ecx
  8014e4:	8d 40 08             	lea    0x8(%eax),%eax
  8014e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8014ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014ef:	eb 77                	jmp    801568 <vprintfmt+0x386>
	else if (lflag)
  8014f1:	85 c9                	test   %ecx,%ecx
  8014f3:	75 17                	jne    80150c <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8014f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f8:	8b 10                	mov    (%eax),%edx
  8014fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014ff:	8d 40 04             	lea    0x4(%eax),%eax
  801502:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801505:	b8 0a 00 00 00       	mov    $0xa,%eax
  80150a:	eb 5c                	jmp    801568 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80150c:	8b 45 14             	mov    0x14(%ebp),%eax
  80150f:	8b 10                	mov    (%eax),%edx
  801511:	b9 00 00 00 00       	mov    $0x0,%ecx
  801516:	8d 40 04             	lea    0x4(%eax),%eax
  801519:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80151c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801521:	eb 45                	jmp    801568 <vprintfmt+0x386>
			putch('X', putdat);
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	53                   	push   %ebx
  801527:	6a 58                	push   $0x58
  801529:	ff d6                	call   *%esi
			putch('X', putdat);
  80152b:	83 c4 08             	add    $0x8,%esp
  80152e:	53                   	push   %ebx
  80152f:	6a 58                	push   $0x58
  801531:	ff d6                	call   *%esi
			putch('X', putdat);
  801533:	83 c4 08             	add    $0x8,%esp
  801536:	53                   	push   %ebx
  801537:	6a 58                	push   $0x58
  801539:	ff d6                	call   *%esi
			break;
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	eb 42                	jmp    801582 <vprintfmt+0x3a0>
			putch('0', putdat);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	53                   	push   %ebx
  801544:	6a 30                	push   $0x30
  801546:	ff d6                	call   *%esi
			putch('x', putdat);
  801548:	83 c4 08             	add    $0x8,%esp
  80154b:	53                   	push   %ebx
  80154c:	6a 78                	push   $0x78
  80154e:	ff d6                	call   *%esi
			num = (unsigned long long)
  801550:	8b 45 14             	mov    0x14(%ebp),%eax
  801553:	8b 10                	mov    (%eax),%edx
  801555:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80155a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80155d:	8d 40 04             	lea    0x4(%eax),%eax
  801560:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801563:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801568:	83 ec 0c             	sub    $0xc,%esp
  80156b:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80156f:	57                   	push   %edi
  801570:	ff 75 e0             	pushl  -0x20(%ebp)
  801573:	50                   	push   %eax
  801574:	51                   	push   %ecx
  801575:	52                   	push   %edx
  801576:	89 da                	mov    %ebx,%edx
  801578:	89 f0                	mov    %esi,%eax
  80157a:	e8 7a fb ff ff       	call   8010f9 <printnum>
			break;
  80157f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801582:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801585:	83 c7 01             	add    $0x1,%edi
  801588:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80158c:	83 f8 25             	cmp    $0x25,%eax
  80158f:	0f 84 64 fc ff ff    	je     8011f9 <vprintfmt+0x17>
			if (ch == '\0')
  801595:	85 c0                	test   %eax,%eax
  801597:	0f 84 8b 00 00 00    	je     801628 <vprintfmt+0x446>
			putch(ch, putdat);
  80159d:	83 ec 08             	sub    $0x8,%esp
  8015a0:	53                   	push   %ebx
  8015a1:	50                   	push   %eax
  8015a2:	ff d6                	call   *%esi
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	eb dc                	jmp    801585 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8015a9:	83 f9 01             	cmp    $0x1,%ecx
  8015ac:	7e 15                	jle    8015c3 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8015ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b1:	8b 10                	mov    (%eax),%edx
  8015b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8015b6:	8d 40 08             	lea    0x8(%eax),%eax
  8015b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015bc:	b8 10 00 00 00       	mov    $0x10,%eax
  8015c1:	eb a5                	jmp    801568 <vprintfmt+0x386>
	else if (lflag)
  8015c3:	85 c9                	test   %ecx,%ecx
  8015c5:	75 17                	jne    8015de <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	8b 10                	mov    (%eax),%edx
  8015cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015d1:	8d 40 04             	lea    0x4(%eax),%eax
  8015d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015d7:	b8 10 00 00 00       	mov    $0x10,%eax
  8015dc:	eb 8a                	jmp    801568 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8015de:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e1:	8b 10                	mov    (%eax),%edx
  8015e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015e8:	8d 40 04             	lea    0x4(%eax),%eax
  8015eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8015f3:	e9 70 ff ff ff       	jmp    801568 <vprintfmt+0x386>
			putch(ch, putdat);
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	53                   	push   %ebx
  8015fc:	6a 25                	push   $0x25
  8015fe:	ff d6                	call   *%esi
			break;
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	e9 7a ff ff ff       	jmp    801582 <vprintfmt+0x3a0>
			putch('%', putdat);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	53                   	push   %ebx
  80160c:	6a 25                	push   $0x25
  80160e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	89 f8                	mov    %edi,%eax
  801615:	eb 03                	jmp    80161a <vprintfmt+0x438>
  801617:	83 e8 01             	sub    $0x1,%eax
  80161a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80161e:	75 f7                	jne    801617 <vprintfmt+0x435>
  801620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801623:	e9 5a ff ff ff       	jmp    801582 <vprintfmt+0x3a0>
}
  801628:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162b:	5b                   	pop    %ebx
  80162c:	5e                   	pop    %esi
  80162d:	5f                   	pop    %edi
  80162e:	5d                   	pop    %ebp
  80162f:	c3                   	ret    

00801630 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 18             	sub    $0x18,%esp
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80163c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80163f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801643:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801646:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80164d:	85 c0                	test   %eax,%eax
  80164f:	74 26                	je     801677 <vsnprintf+0x47>
  801651:	85 d2                	test   %edx,%edx
  801653:	7e 22                	jle    801677 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801655:	ff 75 14             	pushl  0x14(%ebp)
  801658:	ff 75 10             	pushl  0x10(%ebp)
  80165b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80165e:	50                   	push   %eax
  80165f:	68 a8 11 80 00       	push   $0x8011a8
  801664:	e8 79 fb ff ff       	call   8011e2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801672:	83 c4 10             	add    $0x10,%esp
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    
		return -E_INVAL;
  801677:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167c:	eb f7                	jmp    801675 <vsnprintf+0x45>

0080167e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801684:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801687:	50                   	push   %eax
  801688:	ff 75 10             	pushl  0x10(%ebp)
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	e8 9a ff ff ff       	call   801630 <vsnprintf>
	va_end(ap);

	return rc;
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 03                	jmp    8016a8 <strlen+0x10>
		n++;
  8016a5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8016a8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016ac:	75 f7                	jne    8016a5 <strlen+0xd>
	return n;
}
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016be:	eb 03                	jmp    8016c3 <strnlen+0x13>
		n++;
  8016c0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016c3:	39 d0                	cmp    %edx,%eax
  8016c5:	74 06                	je     8016cd <strnlen+0x1d>
  8016c7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016cb:	75 f3                	jne    8016c0 <strnlen+0x10>
	return n;
}
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    

008016cf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	53                   	push   %ebx
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	83 c1 01             	add    $0x1,%ecx
  8016de:	83 c2 01             	add    $0x1,%edx
  8016e1:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8016e5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8016e8:	84 db                	test   %bl,%bl
  8016ea:	75 ef                	jne    8016db <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8016ec:	5b                   	pop    %ebx
  8016ed:	5d                   	pop    %ebp
  8016ee:	c3                   	ret    

008016ef <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	53                   	push   %ebx
  8016f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8016f6:	53                   	push   %ebx
  8016f7:	e8 9c ff ff ff       	call   801698 <strlen>
  8016fc:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	01 d8                	add    %ebx,%eax
  801704:	50                   	push   %eax
  801705:	e8 c5 ff ff ff       	call   8016cf <strcpy>
	return dst;
}
  80170a:	89 d8                	mov    %ebx,%eax
  80170c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	56                   	push   %esi
  801715:	53                   	push   %ebx
  801716:	8b 75 08             	mov    0x8(%ebp),%esi
  801719:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80171c:	89 f3                	mov    %esi,%ebx
  80171e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801721:	89 f2                	mov    %esi,%edx
  801723:	eb 0f                	jmp    801734 <strncpy+0x23>
		*dst++ = *src;
  801725:	83 c2 01             	add    $0x1,%edx
  801728:	0f b6 01             	movzbl (%ecx),%eax
  80172b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80172e:	80 39 01             	cmpb   $0x1,(%ecx)
  801731:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801734:	39 da                	cmp    %ebx,%edx
  801736:	75 ed                	jne    801725 <strncpy+0x14>
	}
	return ret;
}
  801738:	89 f0                	mov    %esi,%eax
  80173a:	5b                   	pop    %ebx
  80173b:	5e                   	pop    %esi
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	56                   	push   %esi
  801742:	53                   	push   %ebx
  801743:	8b 75 08             	mov    0x8(%ebp),%esi
  801746:	8b 55 0c             	mov    0xc(%ebp),%edx
  801749:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174c:	89 f0                	mov    %esi,%eax
  80174e:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801752:	85 c9                	test   %ecx,%ecx
  801754:	75 0b                	jne    801761 <strlcpy+0x23>
  801756:	eb 17                	jmp    80176f <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801758:	83 c2 01             	add    $0x1,%edx
  80175b:	83 c0 01             	add    $0x1,%eax
  80175e:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801761:	39 d8                	cmp    %ebx,%eax
  801763:	74 07                	je     80176c <strlcpy+0x2e>
  801765:	0f b6 0a             	movzbl (%edx),%ecx
  801768:	84 c9                	test   %cl,%cl
  80176a:	75 ec                	jne    801758 <strlcpy+0x1a>
		*dst = '\0';
  80176c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80176f:	29 f0                	sub    %esi,%eax
}
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    

00801775 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80177b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80177e:	eb 06                	jmp    801786 <strcmp+0x11>
		p++, q++;
  801780:	83 c1 01             	add    $0x1,%ecx
  801783:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801786:	0f b6 01             	movzbl (%ecx),%eax
  801789:	84 c0                	test   %al,%al
  80178b:	74 04                	je     801791 <strcmp+0x1c>
  80178d:	3a 02                	cmp    (%edx),%al
  80178f:	74 ef                	je     801780 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801791:	0f b6 c0             	movzbl %al,%eax
  801794:	0f b6 12             	movzbl (%edx),%edx
  801797:	29 d0                	sub    %edx,%eax
}
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    

0080179b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	53                   	push   %ebx
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	89 c3                	mov    %eax,%ebx
  8017a7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017aa:	eb 06                	jmp    8017b2 <strncmp+0x17>
		n--, p++, q++;
  8017ac:	83 c0 01             	add    $0x1,%eax
  8017af:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017b2:	39 d8                	cmp    %ebx,%eax
  8017b4:	74 16                	je     8017cc <strncmp+0x31>
  8017b6:	0f b6 08             	movzbl (%eax),%ecx
  8017b9:	84 c9                	test   %cl,%cl
  8017bb:	74 04                	je     8017c1 <strncmp+0x26>
  8017bd:	3a 0a                	cmp    (%edx),%cl
  8017bf:	74 eb                	je     8017ac <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017c1:	0f b6 00             	movzbl (%eax),%eax
  8017c4:	0f b6 12             	movzbl (%edx),%edx
  8017c7:	29 d0                	sub    %edx,%eax
}
  8017c9:	5b                   	pop    %ebx
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    
		return 0;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	eb f6                	jmp    8017c9 <strncmp+0x2e>

008017d3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8017dd:	0f b6 10             	movzbl (%eax),%edx
  8017e0:	84 d2                	test   %dl,%dl
  8017e2:	74 09                	je     8017ed <strchr+0x1a>
		if (*s == c)
  8017e4:	38 ca                	cmp    %cl,%dl
  8017e6:	74 0a                	je     8017f2 <strchr+0x1f>
	for (; *s; s++)
  8017e8:	83 c0 01             	add    $0x1,%eax
  8017eb:	eb f0                	jmp    8017dd <strchr+0xa>
			return (char *) s;
	return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    

008017f4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8017fe:	eb 03                	jmp    801803 <strfind+0xf>
  801800:	83 c0 01             	add    $0x1,%eax
  801803:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801806:	38 ca                	cmp    %cl,%dl
  801808:	74 04                	je     80180e <strfind+0x1a>
  80180a:	84 d2                	test   %dl,%dl
  80180c:	75 f2                	jne    801800 <strfind+0xc>
			break;
	return (char *) s;
}
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    

00801810 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	57                   	push   %edi
  801814:	56                   	push   %esi
  801815:	53                   	push   %ebx
  801816:	8b 7d 08             	mov    0x8(%ebp),%edi
  801819:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80181c:	85 c9                	test   %ecx,%ecx
  80181e:	74 13                	je     801833 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801820:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801826:	75 05                	jne    80182d <memset+0x1d>
  801828:	f6 c1 03             	test   $0x3,%cl
  80182b:	74 0d                	je     80183a <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80182d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801830:	fc                   	cld    
  801831:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801833:	89 f8                	mov    %edi,%eax
  801835:	5b                   	pop    %ebx
  801836:	5e                   	pop    %esi
  801837:	5f                   	pop    %edi
  801838:	5d                   	pop    %ebp
  801839:	c3                   	ret    
		c &= 0xFF;
  80183a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80183e:	89 d3                	mov    %edx,%ebx
  801840:	c1 e3 08             	shl    $0x8,%ebx
  801843:	89 d0                	mov    %edx,%eax
  801845:	c1 e0 18             	shl    $0x18,%eax
  801848:	89 d6                	mov    %edx,%esi
  80184a:	c1 e6 10             	shl    $0x10,%esi
  80184d:	09 f0                	or     %esi,%eax
  80184f:	09 c2                	or     %eax,%edx
  801851:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801853:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801856:	89 d0                	mov    %edx,%eax
  801858:	fc                   	cld    
  801859:	f3 ab                	rep stos %eax,%es:(%edi)
  80185b:	eb d6                	jmp    801833 <memset+0x23>

0080185d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	57                   	push   %edi
  801861:	56                   	push   %esi
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	8b 75 0c             	mov    0xc(%ebp),%esi
  801868:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80186b:	39 c6                	cmp    %eax,%esi
  80186d:	73 35                	jae    8018a4 <memmove+0x47>
  80186f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801872:	39 c2                	cmp    %eax,%edx
  801874:	76 2e                	jbe    8018a4 <memmove+0x47>
		s += n;
		d += n;
  801876:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801879:	89 d6                	mov    %edx,%esi
  80187b:	09 fe                	or     %edi,%esi
  80187d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801883:	74 0c                	je     801891 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801885:	83 ef 01             	sub    $0x1,%edi
  801888:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80188b:	fd                   	std    
  80188c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80188e:	fc                   	cld    
  80188f:	eb 21                	jmp    8018b2 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801891:	f6 c1 03             	test   $0x3,%cl
  801894:	75 ef                	jne    801885 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801896:	83 ef 04             	sub    $0x4,%edi
  801899:	8d 72 fc             	lea    -0x4(%edx),%esi
  80189c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80189f:	fd                   	std    
  8018a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018a2:	eb ea                	jmp    80188e <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018a4:	89 f2                	mov    %esi,%edx
  8018a6:	09 c2                	or     %eax,%edx
  8018a8:	f6 c2 03             	test   $0x3,%dl
  8018ab:	74 09                	je     8018b6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018ad:	89 c7                	mov    %eax,%edi
  8018af:	fc                   	cld    
  8018b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018b2:	5e                   	pop    %esi
  8018b3:	5f                   	pop    %edi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018b6:	f6 c1 03             	test   $0x3,%cl
  8018b9:	75 f2                	jne    8018ad <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018bb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018be:	89 c7                	mov    %eax,%edi
  8018c0:	fc                   	cld    
  8018c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018c3:	eb ed                	jmp    8018b2 <memmove+0x55>

008018c5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8018c8:	ff 75 10             	pushl  0x10(%ebp)
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	e8 87 ff ff ff       	call   80185d <memmove>
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e3:	89 c6                	mov    %eax,%esi
  8018e5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018e8:	39 f0                	cmp    %esi,%eax
  8018ea:	74 1c                	je     801908 <memcmp+0x30>
		if (*s1 != *s2)
  8018ec:	0f b6 08             	movzbl (%eax),%ecx
  8018ef:	0f b6 1a             	movzbl (%edx),%ebx
  8018f2:	38 d9                	cmp    %bl,%cl
  8018f4:	75 08                	jne    8018fe <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8018f6:	83 c0 01             	add    $0x1,%eax
  8018f9:	83 c2 01             	add    $0x1,%edx
  8018fc:	eb ea                	jmp    8018e8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8018fe:	0f b6 c1             	movzbl %cl,%eax
  801901:	0f b6 db             	movzbl %bl,%ebx
  801904:	29 d8                	sub    %ebx,%eax
  801906:	eb 05                	jmp    80190d <memcmp+0x35>
	}

	return 0;
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190d:	5b                   	pop    %ebx
  80190e:	5e                   	pop    %esi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    

00801911 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80191a:	89 c2                	mov    %eax,%edx
  80191c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80191f:	39 d0                	cmp    %edx,%eax
  801921:	73 09                	jae    80192c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801923:	38 08                	cmp    %cl,(%eax)
  801925:	74 05                	je     80192c <memfind+0x1b>
	for (; s < ends; s++)
  801927:	83 c0 01             	add    $0x1,%eax
  80192a:	eb f3                	jmp    80191f <memfind+0xe>
			break;
	return (void *) s;
}
  80192c:	5d                   	pop    %ebp
  80192d:	c3                   	ret    

0080192e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	57                   	push   %edi
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801937:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80193a:	eb 03                	jmp    80193f <strtol+0x11>
		s++;
  80193c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80193f:	0f b6 01             	movzbl (%ecx),%eax
  801942:	3c 20                	cmp    $0x20,%al
  801944:	74 f6                	je     80193c <strtol+0xe>
  801946:	3c 09                	cmp    $0x9,%al
  801948:	74 f2                	je     80193c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80194a:	3c 2b                	cmp    $0x2b,%al
  80194c:	74 2e                	je     80197c <strtol+0x4e>
	int neg = 0;
  80194e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801953:	3c 2d                	cmp    $0x2d,%al
  801955:	74 2f                	je     801986 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801957:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80195d:	75 05                	jne    801964 <strtol+0x36>
  80195f:	80 39 30             	cmpb   $0x30,(%ecx)
  801962:	74 2c                	je     801990 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801964:	85 db                	test   %ebx,%ebx
  801966:	75 0a                	jne    801972 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801968:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  80196d:	80 39 30             	cmpb   $0x30,(%ecx)
  801970:	74 28                	je     80199a <strtol+0x6c>
		base = 10;
  801972:	b8 00 00 00 00       	mov    $0x0,%eax
  801977:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80197a:	eb 50                	jmp    8019cc <strtol+0x9e>
		s++;
  80197c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80197f:	bf 00 00 00 00       	mov    $0x0,%edi
  801984:	eb d1                	jmp    801957 <strtol+0x29>
		s++, neg = 1;
  801986:	83 c1 01             	add    $0x1,%ecx
  801989:	bf 01 00 00 00       	mov    $0x1,%edi
  80198e:	eb c7                	jmp    801957 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801990:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801994:	74 0e                	je     8019a4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801996:	85 db                	test   %ebx,%ebx
  801998:	75 d8                	jne    801972 <strtol+0x44>
		s++, base = 8;
  80199a:	83 c1 01             	add    $0x1,%ecx
  80199d:	bb 08 00 00 00       	mov    $0x8,%ebx
  8019a2:	eb ce                	jmp    801972 <strtol+0x44>
		s += 2, base = 16;
  8019a4:	83 c1 02             	add    $0x2,%ecx
  8019a7:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019ac:	eb c4                	jmp    801972 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8019ae:	8d 72 9f             	lea    -0x61(%edx),%esi
  8019b1:	89 f3                	mov    %esi,%ebx
  8019b3:	80 fb 19             	cmp    $0x19,%bl
  8019b6:	77 29                	ja     8019e1 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8019b8:	0f be d2             	movsbl %dl,%edx
  8019bb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019be:	3b 55 10             	cmp    0x10(%ebp),%edx
  8019c1:	7d 30                	jge    8019f3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8019c3:	83 c1 01             	add    $0x1,%ecx
  8019c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019ca:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8019cc:	0f b6 11             	movzbl (%ecx),%edx
  8019cf:	8d 72 d0             	lea    -0x30(%edx),%esi
  8019d2:	89 f3                	mov    %esi,%ebx
  8019d4:	80 fb 09             	cmp    $0x9,%bl
  8019d7:	77 d5                	ja     8019ae <strtol+0x80>
			dig = *s - '0';
  8019d9:	0f be d2             	movsbl %dl,%edx
  8019dc:	83 ea 30             	sub    $0x30,%edx
  8019df:	eb dd                	jmp    8019be <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8019e1:	8d 72 bf             	lea    -0x41(%edx),%esi
  8019e4:	89 f3                	mov    %esi,%ebx
  8019e6:	80 fb 19             	cmp    $0x19,%bl
  8019e9:	77 08                	ja     8019f3 <strtol+0xc5>
			dig = *s - 'A' + 10;
  8019eb:	0f be d2             	movsbl %dl,%edx
  8019ee:	83 ea 37             	sub    $0x37,%edx
  8019f1:	eb cb                	jmp    8019be <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  8019f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019f7:	74 05                	je     8019fe <strtol+0xd0>
		*endptr = (char *) s;
  8019f9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019fc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8019fe:	89 c2                	mov    %eax,%edx
  801a00:	f7 da                	neg    %edx
  801a02:	85 ff                	test   %edi,%edi
  801a04:	0f 45 c2             	cmovne %edx,%eax
}
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5f                   	pop    %edi
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801a12:	68 40 21 80 00       	push   $0x802140
  801a17:	6a 1a                	push   $0x1a
  801a19:	68 59 21 80 00       	push   $0x802159
  801a1e:	e8 e7 f5 ff ff       	call   80100a <_panic>

00801a23 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801a29:	68 63 21 80 00       	push   $0x802163
  801a2e:	6a 2a                	push   $0x2a
  801a30:	68 59 21 80 00       	push   $0x802159
  801a35:	e8 d0 f5 ff ff       	call   80100a <_panic>

00801a3a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a45:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a48:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a4e:	8b 52 50             	mov    0x50(%edx),%edx
  801a51:	39 ca                	cmp    %ecx,%edx
  801a53:	74 11                	je     801a66 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801a55:	83 c0 01             	add    $0x1,%eax
  801a58:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a5d:	75 e6                	jne    801a45 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a64:	eb 0b                	jmp    801a71 <ipc_find_env+0x37>
			return envs[i].env_id;
  801a66:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a69:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a6e:	8b 40 48             	mov    0x48(%eax),%eax
}
  801a71:	5d                   	pop    %ebp
  801a72:	c3                   	ret    

00801a73 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a79:	89 d0                	mov    %edx,%eax
  801a7b:	c1 e8 16             	shr    $0x16,%eax
  801a7e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a85:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801a8a:	f6 c1 01             	test   $0x1,%cl
  801a8d:	74 1d                	je     801aac <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801a8f:	c1 ea 0c             	shr    $0xc,%edx
  801a92:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a99:	f6 c2 01             	test   $0x1,%dl
  801a9c:	74 0e                	je     801aac <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a9e:	c1 ea 0c             	shr    $0xc,%edx
  801aa1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801aa8:	ef 
  801aa9:	0f b7 c0             	movzwl %ax,%eax
}
  801aac:	5d                   	pop    %ebp
  801aad:	c3                   	ret    
  801aae:	66 90                	xchg   %ax,%ax

00801ab0 <__udivdi3>:
  801ab0:	55                   	push   %ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 1c             	sub    $0x1c,%esp
  801ab7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801abb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801abf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ac3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ac7:	85 d2                	test   %edx,%edx
  801ac9:	75 35                	jne    801b00 <__udivdi3+0x50>
  801acb:	39 f3                	cmp    %esi,%ebx
  801acd:	0f 87 bd 00 00 00    	ja     801b90 <__udivdi3+0xe0>
  801ad3:	85 db                	test   %ebx,%ebx
  801ad5:	89 d9                	mov    %ebx,%ecx
  801ad7:	75 0b                	jne    801ae4 <__udivdi3+0x34>
  801ad9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ade:	31 d2                	xor    %edx,%edx
  801ae0:	f7 f3                	div    %ebx
  801ae2:	89 c1                	mov    %eax,%ecx
  801ae4:	31 d2                	xor    %edx,%edx
  801ae6:	89 f0                	mov    %esi,%eax
  801ae8:	f7 f1                	div    %ecx
  801aea:	89 c6                	mov    %eax,%esi
  801aec:	89 e8                	mov    %ebp,%eax
  801aee:	89 f7                	mov    %esi,%edi
  801af0:	f7 f1                	div    %ecx
  801af2:	89 fa                	mov    %edi,%edx
  801af4:	83 c4 1c             	add    $0x1c,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
  801afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801b00:	39 f2                	cmp    %esi,%edx
  801b02:	77 7c                	ja     801b80 <__udivdi3+0xd0>
  801b04:	0f bd fa             	bsr    %edx,%edi
  801b07:	83 f7 1f             	xor    $0x1f,%edi
  801b0a:	0f 84 98 00 00 00    	je     801ba8 <__udivdi3+0xf8>
  801b10:	89 f9                	mov    %edi,%ecx
  801b12:	b8 20 00 00 00       	mov    $0x20,%eax
  801b17:	29 f8                	sub    %edi,%eax
  801b19:	d3 e2                	shl    %cl,%edx
  801b1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b1f:	89 c1                	mov    %eax,%ecx
  801b21:	89 da                	mov    %ebx,%edx
  801b23:	d3 ea                	shr    %cl,%edx
  801b25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801b29:	09 d1                	or     %edx,%ecx
  801b2b:	89 f2                	mov    %esi,%edx
  801b2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b31:	89 f9                	mov    %edi,%ecx
  801b33:	d3 e3                	shl    %cl,%ebx
  801b35:	89 c1                	mov    %eax,%ecx
  801b37:	d3 ea                	shr    %cl,%edx
  801b39:	89 f9                	mov    %edi,%ecx
  801b3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b3f:	d3 e6                	shl    %cl,%esi
  801b41:	89 eb                	mov    %ebp,%ebx
  801b43:	89 c1                	mov    %eax,%ecx
  801b45:	d3 eb                	shr    %cl,%ebx
  801b47:	09 de                	or     %ebx,%esi
  801b49:	89 f0                	mov    %esi,%eax
  801b4b:	f7 74 24 08          	divl   0x8(%esp)
  801b4f:	89 d6                	mov    %edx,%esi
  801b51:	89 c3                	mov    %eax,%ebx
  801b53:	f7 64 24 0c          	mull   0xc(%esp)
  801b57:	39 d6                	cmp    %edx,%esi
  801b59:	72 0c                	jb     801b67 <__udivdi3+0xb7>
  801b5b:	89 f9                	mov    %edi,%ecx
  801b5d:	d3 e5                	shl    %cl,%ebp
  801b5f:	39 c5                	cmp    %eax,%ebp
  801b61:	73 5d                	jae    801bc0 <__udivdi3+0x110>
  801b63:	39 d6                	cmp    %edx,%esi
  801b65:	75 59                	jne    801bc0 <__udivdi3+0x110>
  801b67:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b6a:	31 ff                	xor    %edi,%edi
  801b6c:	89 fa                	mov    %edi,%edx
  801b6e:	83 c4 1c             	add    $0x1c,%esp
  801b71:	5b                   	pop    %ebx
  801b72:	5e                   	pop    %esi
  801b73:	5f                   	pop    %edi
  801b74:	5d                   	pop    %ebp
  801b75:	c3                   	ret    
  801b76:	8d 76 00             	lea    0x0(%esi),%esi
  801b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801b80:	31 ff                	xor    %edi,%edi
  801b82:	31 c0                	xor    %eax,%eax
  801b84:	89 fa                	mov    %edi,%edx
  801b86:	83 c4 1c             	add    $0x1c,%esp
  801b89:	5b                   	pop    %ebx
  801b8a:	5e                   	pop    %esi
  801b8b:	5f                   	pop    %edi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	31 ff                	xor    %edi,%edi
  801b92:	89 e8                	mov    %ebp,%eax
  801b94:	89 f2                	mov    %esi,%edx
  801b96:	f7 f3                	div    %ebx
  801b98:	89 fa                	mov    %edi,%edx
  801b9a:	83 c4 1c             	add    $0x1c,%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5f                   	pop    %edi
  801ba0:	5d                   	pop    %ebp
  801ba1:	c3                   	ret    
  801ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ba8:	39 f2                	cmp    %esi,%edx
  801baa:	72 06                	jb     801bb2 <__udivdi3+0x102>
  801bac:	31 c0                	xor    %eax,%eax
  801bae:	39 eb                	cmp    %ebp,%ebx
  801bb0:	77 d2                	ja     801b84 <__udivdi3+0xd4>
  801bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb7:	eb cb                	jmp    801b84 <__udivdi3+0xd4>
  801bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	31 ff                	xor    %edi,%edi
  801bc4:	eb be                	jmp    801b84 <__udivdi3+0xd4>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	66 90                	xchg   %ax,%ax
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	66 90                	xchg   %ax,%ax
  801bce:	66 90                	xchg   %ax,%ax

00801bd0 <__umoddi3>:
  801bd0:	55                   	push   %ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 1c             	sub    $0x1c,%esp
  801bd7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801bdb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801bdf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801be3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801be7:	85 ed                	test   %ebp,%ebp
  801be9:	89 f0                	mov    %esi,%eax
  801beb:	89 da                	mov    %ebx,%edx
  801bed:	75 19                	jne    801c08 <__umoddi3+0x38>
  801bef:	39 df                	cmp    %ebx,%edi
  801bf1:	0f 86 b1 00 00 00    	jbe    801ca8 <__umoddi3+0xd8>
  801bf7:	f7 f7                	div    %edi
  801bf9:	89 d0                	mov    %edx,%eax
  801bfb:	31 d2                	xor    %edx,%edx
  801bfd:	83 c4 1c             	add    $0x1c,%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5f                   	pop    %edi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    
  801c05:	8d 76 00             	lea    0x0(%esi),%esi
  801c08:	39 dd                	cmp    %ebx,%ebp
  801c0a:	77 f1                	ja     801bfd <__umoddi3+0x2d>
  801c0c:	0f bd cd             	bsr    %ebp,%ecx
  801c0f:	83 f1 1f             	xor    $0x1f,%ecx
  801c12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c16:	0f 84 b4 00 00 00    	je     801cd0 <__umoddi3+0x100>
  801c1c:	b8 20 00 00 00       	mov    $0x20,%eax
  801c21:	89 c2                	mov    %eax,%edx
  801c23:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c27:	29 c2                	sub    %eax,%edx
  801c29:	89 c1                	mov    %eax,%ecx
  801c2b:	89 f8                	mov    %edi,%eax
  801c2d:	d3 e5                	shl    %cl,%ebp
  801c2f:	89 d1                	mov    %edx,%ecx
  801c31:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c35:	d3 e8                	shr    %cl,%eax
  801c37:	09 c5                	or     %eax,%ebp
  801c39:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c3d:	89 c1                	mov    %eax,%ecx
  801c3f:	d3 e7                	shl    %cl,%edi
  801c41:	89 d1                	mov    %edx,%ecx
  801c43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c47:	89 df                	mov    %ebx,%edi
  801c49:	d3 ef                	shr    %cl,%edi
  801c4b:	89 c1                	mov    %eax,%ecx
  801c4d:	89 f0                	mov    %esi,%eax
  801c4f:	d3 e3                	shl    %cl,%ebx
  801c51:	89 d1                	mov    %edx,%ecx
  801c53:	89 fa                	mov    %edi,%edx
  801c55:	d3 e8                	shr    %cl,%eax
  801c57:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801c5c:	09 d8                	or     %ebx,%eax
  801c5e:	f7 f5                	div    %ebp
  801c60:	d3 e6                	shl    %cl,%esi
  801c62:	89 d1                	mov    %edx,%ecx
  801c64:	f7 64 24 08          	mull   0x8(%esp)
  801c68:	39 d1                	cmp    %edx,%ecx
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	89 d7                	mov    %edx,%edi
  801c6e:	72 06                	jb     801c76 <__umoddi3+0xa6>
  801c70:	75 0e                	jne    801c80 <__umoddi3+0xb0>
  801c72:	39 c6                	cmp    %eax,%esi
  801c74:	73 0a                	jae    801c80 <__umoddi3+0xb0>
  801c76:	2b 44 24 08          	sub    0x8(%esp),%eax
  801c7a:	19 ea                	sbb    %ebp,%edx
  801c7c:	89 d7                	mov    %edx,%edi
  801c7e:	89 c3                	mov    %eax,%ebx
  801c80:	89 ca                	mov    %ecx,%edx
  801c82:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801c87:	29 de                	sub    %ebx,%esi
  801c89:	19 fa                	sbb    %edi,%edx
  801c8b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	d3 e0                	shl    %cl,%eax
  801c93:	89 d9                	mov    %ebx,%ecx
  801c95:	d3 ee                	shr    %cl,%esi
  801c97:	d3 ea                	shr    %cl,%edx
  801c99:	09 f0                	or     %esi,%eax
  801c9b:	83 c4 1c             	add    $0x1c,%esp
  801c9e:	5b                   	pop    %ebx
  801c9f:	5e                   	pop    %esi
  801ca0:	5f                   	pop    %edi
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    
  801ca3:	90                   	nop
  801ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ca8:	85 ff                	test   %edi,%edi
  801caa:	89 f9                	mov    %edi,%ecx
  801cac:	75 0b                	jne    801cb9 <__umoddi3+0xe9>
  801cae:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb3:	31 d2                	xor    %edx,%edx
  801cb5:	f7 f7                	div    %edi
  801cb7:	89 c1                	mov    %eax,%ecx
  801cb9:	89 d8                	mov    %ebx,%eax
  801cbb:	31 d2                	xor    %edx,%edx
  801cbd:	f7 f1                	div    %ecx
  801cbf:	89 f0                	mov    %esi,%eax
  801cc1:	f7 f1                	div    %ecx
  801cc3:	e9 31 ff ff ff       	jmp    801bf9 <__umoddi3+0x29>
  801cc8:	90                   	nop
  801cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cd0:	39 dd                	cmp    %ebx,%ebp
  801cd2:	72 08                	jb     801cdc <__umoddi3+0x10c>
  801cd4:	39 f7                	cmp    %esi,%edi
  801cd6:	0f 87 21 ff ff ff    	ja     801bfd <__umoddi3+0x2d>
  801cdc:	89 da                	mov    %ebx,%edx
  801cde:	89 f0                	mov    %esi,%eax
  801ce0:	29 f8                	sub    %edi,%eax
  801ce2:	19 ea                	sbb    %ebp,%edx
  801ce4:	e9 14 ff ff ff       	jmp    801bfd <__umoddi3+0x2d>
