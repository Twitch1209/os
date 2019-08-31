
obj/user/badsegment.debug：     文件格式 elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 ce 00 00 00       	call   80011c <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x2d>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008a:	e8 92 04 00 00       	call   800521 <close_all>
	sys_env_destroy(0);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	6a 00                	push   $0x0
  800094:	e8 42 00 00 00       	call   8000db <sys_env_destroy>
}
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	57                   	push   %edi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	89 c7                	mov    %eax,%edi
  8000b3:	89 c6                	mov    %eax,%esi
  8000b5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    

008000bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bc:	55                   	push   %ebp
  8000bd:	89 e5                	mov    %esp,%ebp
  8000bf:	57                   	push   %edi
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	89 d3                	mov    %edx,%ebx
  8000d0:	89 d7                	mov    %edx,%edi
  8000d2:	89 d6                	mov    %edx,%esi
  8000d4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f1:	89 cb                	mov    %ecx,%ebx
  8000f3:	89 cf                	mov    %ecx,%edi
  8000f5:	89 ce                	mov    %ecx,%esi
  8000f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	7f 08                	jg     800105 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5f                   	pop    %edi
  800103:	5d                   	pop    %ebp
  800104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	50                   	push   %eax
  800109:	6a 03                	push   $0x3
  80010b:	68 0a 1d 80 00       	push   $0x801d0a
  800110:	6a 23                	push   $0x23
  800112:	68 27 1d 80 00       	push   $0x801d27
  800117:	e8 ea 0e 00 00       	call   801006 <_panic>

0080011c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	57                   	push   %edi
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
	asm volatile("int %1\n"
  800122:	ba 00 00 00 00       	mov    $0x0,%edx
  800127:	b8 02 00 00 00       	mov    $0x2,%eax
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	89 d3                	mov    %edx,%ebx
  800130:	89 d7                	mov    %edx,%edi
  800132:	89 d6                	mov    %edx,%esi
  800134:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5f                   	pop    %edi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <sys_yield>:

void
sys_yield(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	57                   	push   %edi
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	asm volatile("int %1\n"
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	89 d3                	mov    %edx,%ebx
  80014f:	89 d7                	mov    %edx,%edi
  800151:	89 d6                	mov    %edx,%esi
  800153:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
  800160:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800163:	be 00 00 00 00       	mov    $0x0,%esi
  800168:	8b 55 08             	mov    0x8(%ebp),%edx
  80016b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016e:	b8 04 00 00 00       	mov    $0x4,%eax
  800173:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800176:	89 f7                	mov    %esi,%edi
  800178:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017a:	85 c0                	test   %eax,%eax
  80017c:	7f 08                	jg     800186 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800181:	5b                   	pop    %ebx
  800182:	5e                   	pop    %esi
  800183:	5f                   	pop    %edi
  800184:	5d                   	pop    %ebp
  800185:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	6a 04                	push   $0x4
  80018c:	68 0a 1d 80 00       	push   $0x801d0a
  800191:	6a 23                	push   $0x23
  800193:	68 27 1d 80 00       	push   $0x801d27
  800198:	e8 69 0e 00 00       	call   801006 <_panic>

0080019d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	57                   	push   %edi
  8001a1:	56                   	push   %esi
  8001a2:	53                   	push   %ebx
  8001a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001bc:	85 c0                	test   %eax,%eax
  8001be:	7f 08                	jg     8001c8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c3:	5b                   	pop    %ebx
  8001c4:	5e                   	pop    %esi
  8001c5:	5f                   	pop    %edi
  8001c6:	5d                   	pop    %ebp
  8001c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	50                   	push   %eax
  8001cc:	6a 05                	push   $0x5
  8001ce:	68 0a 1d 80 00       	push   $0x801d0a
  8001d3:	6a 23                	push   $0x23
  8001d5:	68 27 1d 80 00       	push   $0x801d27
  8001da:	e8 27 0e 00 00       	call   801006 <_panic>

008001df <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	57                   	push   %edi
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f3:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f8:	89 df                	mov    %ebx,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fe:	85 c0                	test   %eax,%eax
  800200:	7f 08                	jg     80020a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800202:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800205:	5b                   	pop    %ebx
  800206:	5e                   	pop    %esi
  800207:	5f                   	pop    %edi
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	50                   	push   %eax
  80020e:	6a 06                	push   $0x6
  800210:	68 0a 1d 80 00       	push   $0x801d0a
  800215:	6a 23                	push   $0x23
  800217:	68 27 1d 80 00       	push   $0x801d27
  80021c:	e8 e5 0d 00 00       	call   801006 <_panic>

00800221 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022f:	8b 55 08             	mov    0x8(%ebp),%edx
  800232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800235:	b8 08 00 00 00       	mov    $0x8,%eax
  80023a:	89 df                	mov    %ebx,%edi
  80023c:	89 de                	mov    %ebx,%esi
  80023e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800240:	85 c0                	test   %eax,%eax
  800242:	7f 08                	jg     80024c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	6a 08                	push   $0x8
  800252:	68 0a 1d 80 00       	push   $0x801d0a
  800257:	6a 23                	push   $0x23
  800259:	68 27 1d 80 00       	push   $0x801d27
  80025e:	e8 a3 0d 00 00       	call   801006 <_panic>

00800263 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	57                   	push   %edi
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800271:	8b 55 08             	mov    0x8(%ebp),%edx
  800274:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800277:	b8 09 00 00 00       	mov    $0x9,%eax
  80027c:	89 df                	mov    %ebx,%edi
  80027e:	89 de                	mov    %ebx,%esi
  800280:	cd 30                	int    $0x30
	if(check && ret > 0)
  800282:	85 c0                	test   %eax,%eax
  800284:	7f 08                	jg     80028e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	6a 09                	push   $0x9
  800294:	68 0a 1d 80 00       	push   $0x801d0a
  800299:	6a 23                	push   $0x23
  80029b:	68 27 1d 80 00       	push   $0x801d27
  8002a0:	e8 61 0d 00 00       	call   801006 <_panic>

008002a5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	57                   	push   %edi
  8002a9:	56                   	push   %esi
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002be:	89 df                	mov    %ebx,%edi
  8002c0:	89 de                	mov    %ebx,%esi
  8002c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	7f 08                	jg     8002d0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cb:	5b                   	pop    %ebx
  8002cc:	5e                   	pop    %esi
  8002cd:	5f                   	pop    %edi
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	50                   	push   %eax
  8002d4:	6a 0a                	push   $0xa
  8002d6:	68 0a 1d 80 00       	push   $0x801d0a
  8002db:	6a 23                	push   $0x23
  8002dd:	68 27 1d 80 00       	push   $0x801d27
  8002e2:	e8 1f 0d 00 00       	call   801006 <_panic>

008002e7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f8:	be 00 00 00 00       	mov    $0x0,%esi
  8002fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800300:	8b 7d 14             	mov    0x14(%ebp),%edi
  800303:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800305:	5b                   	pop    %ebx
  800306:	5e                   	pop    %esi
  800307:	5f                   	pop    %edi
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	57                   	push   %edi
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800313:	b9 00 00 00 00       	mov    $0x0,%ecx
  800318:	8b 55 08             	mov    0x8(%ebp),%edx
  80031b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800320:	89 cb                	mov    %ecx,%ebx
  800322:	89 cf                	mov    %ecx,%edi
  800324:	89 ce                	mov    %ecx,%esi
  800326:	cd 30                	int    $0x30
	if(check && ret > 0)
  800328:	85 c0                	test   %eax,%eax
  80032a:	7f 08                	jg     800334 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80032c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032f:	5b                   	pop    %ebx
  800330:	5e                   	pop    %esi
  800331:	5f                   	pop    %edi
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	50                   	push   %eax
  800338:	6a 0d                	push   $0xd
  80033a:	68 0a 1d 80 00       	push   $0x801d0a
  80033f:	6a 23                	push   $0x23
  800341:	68 27 1d 80 00       	push   $0x801d27
  800346:	e8 bb 0c 00 00       	call   801006 <_panic>

0080034b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	05 00 00 00 30       	add    $0x30000000,%eax
  800356:	c1 e8 0c             	shr    $0xc,%eax
}
  800359:	5d                   	pop    %ebp
  80035a:	c3                   	ret    

0080035b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800366:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80036b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800370:	5d                   	pop    %ebp
  800371:	c3                   	ret    

00800372 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800378:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80037d:	89 c2                	mov    %eax,%edx
  80037f:	c1 ea 16             	shr    $0x16,%edx
  800382:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800389:	f6 c2 01             	test   $0x1,%dl
  80038c:	74 2a                	je     8003b8 <fd_alloc+0x46>
  80038e:	89 c2                	mov    %eax,%edx
  800390:	c1 ea 0c             	shr    $0xc,%edx
  800393:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80039a:	f6 c2 01             	test   $0x1,%dl
  80039d:	74 19                	je     8003b8 <fd_alloc+0x46>
  80039f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003a4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003a9:	75 d2                	jne    80037d <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003ab:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003b1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003b6:	eb 07                	jmp    8003bf <fd_alloc+0x4d>
			*fd_store = fd;
  8003b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003bf:	5d                   	pop    %ebp
  8003c0:	c3                   	ret    

008003c1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003c1:	55                   	push   %ebp
  8003c2:	89 e5                	mov    %esp,%ebp
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003c7:	83 f8 1f             	cmp    $0x1f,%eax
  8003ca:	77 36                	ja     800402 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003cc:	c1 e0 0c             	shl    $0xc,%eax
  8003cf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	c1 ea 16             	shr    $0x16,%edx
  8003d9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003e0:	f6 c2 01             	test   $0x1,%dl
  8003e3:	74 24                	je     800409 <fd_lookup+0x48>
  8003e5:	89 c2                	mov    %eax,%edx
  8003e7:	c1 ea 0c             	shr    $0xc,%edx
  8003ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003f1:	f6 c2 01             	test   $0x1,%dl
  8003f4:	74 1a                	je     800410 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f9:	89 02                	mov    %eax,(%edx)
	return 0;
  8003fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    
		return -E_INVAL;
  800402:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800407:	eb f7                	jmp    800400 <fd_lookup+0x3f>
		return -E_INVAL;
  800409:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80040e:	eb f0                	jmp    800400 <fd_lookup+0x3f>
  800410:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800415:	eb e9                	jmp    800400 <fd_lookup+0x3f>

00800417 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800420:	ba b4 1d 80 00       	mov    $0x801db4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800425:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80042a:	39 08                	cmp    %ecx,(%eax)
  80042c:	74 33                	je     800461 <dev_lookup+0x4a>
  80042e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800431:	8b 02                	mov    (%edx),%eax
  800433:	85 c0                	test   %eax,%eax
  800435:	75 f3                	jne    80042a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800437:	a1 04 40 80 00       	mov    0x804004,%eax
  80043c:	8b 40 48             	mov    0x48(%eax),%eax
  80043f:	83 ec 04             	sub    $0x4,%esp
  800442:	51                   	push   %ecx
  800443:	50                   	push   %eax
  800444:	68 38 1d 80 00       	push   $0x801d38
  800449:	e8 93 0c 00 00       	call   8010e1 <cprintf>
	*dev = 0;
  80044e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800457:	83 c4 10             	add    $0x10,%esp
  80045a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80045f:	c9                   	leave  
  800460:	c3                   	ret    
			*dev = devtab[i];
  800461:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800464:	89 01                	mov    %eax,(%ecx)
			return 0;
  800466:	b8 00 00 00 00       	mov    $0x0,%eax
  80046b:	eb f2                	jmp    80045f <dev_lookup+0x48>

0080046d <fd_close>:
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	57                   	push   %edi
  800471:	56                   	push   %esi
  800472:	53                   	push   %ebx
  800473:	83 ec 1c             	sub    $0x1c,%esp
  800476:	8b 75 08             	mov    0x8(%ebp),%esi
  800479:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80047c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80047f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800480:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800486:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800489:	50                   	push   %eax
  80048a:	e8 32 ff ff ff       	call   8003c1 <fd_lookup>
  80048f:	89 c3                	mov    %eax,%ebx
  800491:	83 c4 08             	add    $0x8,%esp
  800494:	85 c0                	test   %eax,%eax
  800496:	78 05                	js     80049d <fd_close+0x30>
	    || fd != fd2)
  800498:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80049b:	74 16                	je     8004b3 <fd_close+0x46>
		return (must_exist ? r : 0);
  80049d:	89 f8                	mov    %edi,%eax
  80049f:	84 c0                	test   %al,%al
  8004a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a6:	0f 44 d8             	cmove  %eax,%ebx
}
  8004a9:	89 d8                	mov    %ebx,%eax
  8004ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ae:	5b                   	pop    %ebx
  8004af:	5e                   	pop    %esi
  8004b0:	5f                   	pop    %edi
  8004b1:	5d                   	pop    %ebp
  8004b2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	ff 36                	pushl  (%esi)
  8004bc:	e8 56 ff ff ff       	call   800417 <dev_lookup>
  8004c1:	89 c3                	mov    %eax,%ebx
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	85 c0                	test   %eax,%eax
  8004c8:	78 15                	js     8004df <fd_close+0x72>
		if (dev->dev_close)
  8004ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004cd:	8b 40 10             	mov    0x10(%eax),%eax
  8004d0:	85 c0                	test   %eax,%eax
  8004d2:	74 1b                	je     8004ef <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	56                   	push   %esi
  8004d8:	ff d0                	call   *%eax
  8004da:	89 c3                	mov    %eax,%ebx
  8004dc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	56                   	push   %esi
  8004e3:	6a 00                	push   $0x0
  8004e5:	e8 f5 fc ff ff       	call   8001df <sys_page_unmap>
	return r;
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	eb ba                	jmp    8004a9 <fd_close+0x3c>
			r = 0;
  8004ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004f4:	eb e9                	jmp    8004df <fd_close+0x72>

008004f6 <close>:

int
close(int fdnum)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004ff:	50                   	push   %eax
  800500:	ff 75 08             	pushl  0x8(%ebp)
  800503:	e8 b9 fe ff ff       	call   8003c1 <fd_lookup>
  800508:	83 c4 08             	add    $0x8,%esp
  80050b:	85 c0                	test   %eax,%eax
  80050d:	78 10                	js     80051f <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	6a 01                	push   $0x1
  800514:	ff 75 f4             	pushl  -0xc(%ebp)
  800517:	e8 51 ff ff ff       	call   80046d <fd_close>
  80051c:	83 c4 10             	add    $0x10,%esp
}
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <close_all>:

void
close_all(void)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	53                   	push   %ebx
  800525:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800528:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	53                   	push   %ebx
  800531:	e8 c0 ff ff ff       	call   8004f6 <close>
	for (i = 0; i < MAXFD; i++)
  800536:	83 c3 01             	add    $0x1,%ebx
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	83 fb 20             	cmp    $0x20,%ebx
  80053f:	75 ec                	jne    80052d <close_all+0xc>
}
  800541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800544:	c9                   	leave  
  800545:	c3                   	ret    

00800546 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	57                   	push   %edi
  80054a:	56                   	push   %esi
  80054b:	53                   	push   %ebx
  80054c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80054f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800552:	50                   	push   %eax
  800553:	ff 75 08             	pushl  0x8(%ebp)
  800556:	e8 66 fe ff ff       	call   8003c1 <fd_lookup>
  80055b:	89 c3                	mov    %eax,%ebx
  80055d:	83 c4 08             	add    $0x8,%esp
  800560:	85 c0                	test   %eax,%eax
  800562:	0f 88 81 00 00 00    	js     8005e9 <dup+0xa3>
		return r;
	close(newfdnum);
  800568:	83 ec 0c             	sub    $0xc,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	e8 83 ff ff ff       	call   8004f6 <close>

	newfd = INDEX2FD(newfdnum);
  800573:	8b 75 0c             	mov    0xc(%ebp),%esi
  800576:	c1 e6 0c             	shl    $0xc,%esi
  800579:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80057f:	83 c4 04             	add    $0x4,%esp
  800582:	ff 75 e4             	pushl  -0x1c(%ebp)
  800585:	e8 d1 fd ff ff       	call   80035b <fd2data>
  80058a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80058c:	89 34 24             	mov    %esi,(%esp)
  80058f:	e8 c7 fd ff ff       	call   80035b <fd2data>
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800599:	89 d8                	mov    %ebx,%eax
  80059b:	c1 e8 16             	shr    $0x16,%eax
  80059e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005a5:	a8 01                	test   $0x1,%al
  8005a7:	74 11                	je     8005ba <dup+0x74>
  8005a9:	89 d8                	mov    %ebx,%eax
  8005ab:	c1 e8 0c             	shr    $0xc,%eax
  8005ae:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005b5:	f6 c2 01             	test   $0x1,%dl
  8005b8:	75 39                	jne    8005f3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005bd:	89 d0                	mov    %edx,%eax
  8005bf:	c1 e8 0c             	shr    $0xc,%eax
  8005c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005c9:	83 ec 0c             	sub    $0xc,%esp
  8005cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8005d1:	50                   	push   %eax
  8005d2:	56                   	push   %esi
  8005d3:	6a 00                	push   $0x0
  8005d5:	52                   	push   %edx
  8005d6:	6a 00                	push   $0x0
  8005d8:	e8 c0 fb ff ff       	call   80019d <sys_page_map>
  8005dd:	89 c3                	mov    %eax,%ebx
  8005df:	83 c4 20             	add    $0x20,%esp
  8005e2:	85 c0                	test   %eax,%eax
  8005e4:	78 31                	js     800617 <dup+0xd1>
		goto err;

	return newfdnum;
  8005e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005e9:	89 d8                	mov    %ebx,%eax
  8005eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ee:	5b                   	pop    %ebx
  8005ef:	5e                   	pop    %esi
  8005f0:	5f                   	pop    %edi
  8005f1:	5d                   	pop    %ebp
  8005f2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	25 07 0e 00 00       	and    $0xe07,%eax
  800602:	50                   	push   %eax
  800603:	57                   	push   %edi
  800604:	6a 00                	push   $0x0
  800606:	53                   	push   %ebx
  800607:	6a 00                	push   $0x0
  800609:	e8 8f fb ff ff       	call   80019d <sys_page_map>
  80060e:	89 c3                	mov    %eax,%ebx
  800610:	83 c4 20             	add    $0x20,%esp
  800613:	85 c0                	test   %eax,%eax
  800615:	79 a3                	jns    8005ba <dup+0x74>
	sys_page_unmap(0, newfd);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	56                   	push   %esi
  80061b:	6a 00                	push   $0x0
  80061d:	e8 bd fb ff ff       	call   8001df <sys_page_unmap>
	sys_page_unmap(0, nva);
  800622:	83 c4 08             	add    $0x8,%esp
  800625:	57                   	push   %edi
  800626:	6a 00                	push   $0x0
  800628:	e8 b2 fb ff ff       	call   8001df <sys_page_unmap>
	return r;
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb b7                	jmp    8005e9 <dup+0xa3>

00800632 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	53                   	push   %ebx
  800636:	83 ec 14             	sub    $0x14,%esp
  800639:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80063c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80063f:	50                   	push   %eax
  800640:	53                   	push   %ebx
  800641:	e8 7b fd ff ff       	call   8003c1 <fd_lookup>
  800646:	83 c4 08             	add    $0x8,%esp
  800649:	85 c0                	test   %eax,%eax
  80064b:	78 3f                	js     80068c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800653:	50                   	push   %eax
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	ff 30                	pushl  (%eax)
  800659:	e8 b9 fd ff ff       	call   800417 <dev_lookup>
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	85 c0                	test   %eax,%eax
  800663:	78 27                	js     80068c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800668:	8b 42 08             	mov    0x8(%edx),%eax
  80066b:	83 e0 03             	and    $0x3,%eax
  80066e:	83 f8 01             	cmp    $0x1,%eax
  800671:	74 1e                	je     800691 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800676:	8b 40 08             	mov    0x8(%eax),%eax
  800679:	85 c0                	test   %eax,%eax
  80067b:	74 35                	je     8006b2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	ff 75 10             	pushl  0x10(%ebp)
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	52                   	push   %edx
  800687:	ff d0                	call   *%eax
  800689:	83 c4 10             	add    $0x10,%esp
}
  80068c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80068f:	c9                   	leave  
  800690:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800691:	a1 04 40 80 00       	mov    0x804004,%eax
  800696:	8b 40 48             	mov    0x48(%eax),%eax
  800699:	83 ec 04             	sub    $0x4,%esp
  80069c:	53                   	push   %ebx
  80069d:	50                   	push   %eax
  80069e:	68 79 1d 80 00       	push   $0x801d79
  8006a3:	e8 39 0a 00 00       	call   8010e1 <cprintf>
		return -E_INVAL;
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006b0:	eb da                	jmp    80068c <read+0x5a>
		return -E_NOT_SUPP;
  8006b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006b7:	eb d3                	jmp    80068c <read+0x5a>

008006b9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006b9:	55                   	push   %ebp
  8006ba:	89 e5                	mov    %esp,%ebp
  8006bc:	57                   	push   %edi
  8006bd:	56                   	push   %esi
  8006be:	53                   	push   %ebx
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006c5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cd:	39 f3                	cmp    %esi,%ebx
  8006cf:	73 25                	jae    8006f6 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006d1:	83 ec 04             	sub    $0x4,%esp
  8006d4:	89 f0                	mov    %esi,%eax
  8006d6:	29 d8                	sub    %ebx,%eax
  8006d8:	50                   	push   %eax
  8006d9:	89 d8                	mov    %ebx,%eax
  8006db:	03 45 0c             	add    0xc(%ebp),%eax
  8006de:	50                   	push   %eax
  8006df:	57                   	push   %edi
  8006e0:	e8 4d ff ff ff       	call   800632 <read>
		if (m < 0)
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	85 c0                	test   %eax,%eax
  8006ea:	78 08                	js     8006f4 <readn+0x3b>
			return m;
		if (m == 0)
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	74 06                	je     8006f6 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8006f0:	01 c3                	add    %eax,%ebx
  8006f2:	eb d9                	jmp    8006cd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006f6:	89 d8                	mov    %ebx,%eax
  8006f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fb:	5b                   	pop    %ebx
  8006fc:	5e                   	pop    %esi
  8006fd:	5f                   	pop    %edi
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	53                   	push   %ebx
  800704:	83 ec 14             	sub    $0x14,%esp
  800707:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80070a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80070d:	50                   	push   %eax
  80070e:	53                   	push   %ebx
  80070f:	e8 ad fc ff ff       	call   8003c1 <fd_lookup>
  800714:	83 c4 08             	add    $0x8,%esp
  800717:	85 c0                	test   %eax,%eax
  800719:	78 3a                	js     800755 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800721:	50                   	push   %eax
  800722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800725:	ff 30                	pushl  (%eax)
  800727:	e8 eb fc ff ff       	call   800417 <dev_lookup>
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	85 c0                	test   %eax,%eax
  800731:	78 22                	js     800755 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800736:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80073a:	74 1e                	je     80075a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80073c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073f:	8b 52 0c             	mov    0xc(%edx),%edx
  800742:	85 d2                	test   %edx,%edx
  800744:	74 35                	je     80077b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800746:	83 ec 04             	sub    $0x4,%esp
  800749:	ff 75 10             	pushl  0x10(%ebp)
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	50                   	push   %eax
  800750:	ff d2                	call   *%edx
  800752:	83 c4 10             	add    $0x10,%esp
}
  800755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800758:	c9                   	leave  
  800759:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80075a:	a1 04 40 80 00       	mov    0x804004,%eax
  80075f:	8b 40 48             	mov    0x48(%eax),%eax
  800762:	83 ec 04             	sub    $0x4,%esp
  800765:	53                   	push   %ebx
  800766:	50                   	push   %eax
  800767:	68 95 1d 80 00       	push   $0x801d95
  80076c:	e8 70 09 00 00       	call   8010e1 <cprintf>
		return -E_INVAL;
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800779:	eb da                	jmp    800755 <write+0x55>
		return -E_NOT_SUPP;
  80077b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800780:	eb d3                	jmp    800755 <write+0x55>

00800782 <seek>:

int
seek(int fdnum, off_t offset)
{
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800788:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80078b:	50                   	push   %eax
  80078c:	ff 75 08             	pushl  0x8(%ebp)
  80078f:	e8 2d fc ff ff       	call   8003c1 <fd_lookup>
  800794:	83 c4 08             	add    $0x8,%esp
  800797:	85 c0                	test   %eax,%eax
  800799:	78 0e                	js     8007a9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80079b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80079e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8007a1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	83 ec 14             	sub    $0x14,%esp
  8007b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b8:	50                   	push   %eax
  8007b9:	53                   	push   %ebx
  8007ba:	e8 02 fc ff ff       	call   8003c1 <fd_lookup>
  8007bf:	83 c4 08             	add    $0x8,%esp
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	78 37                	js     8007fd <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007cc:	50                   	push   %eax
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d0:	ff 30                	pushl  (%eax)
  8007d2:	e8 40 fc ff ff       	call   800417 <dev_lookup>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	78 1f                	js     8007fd <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007e5:	74 1b                	je     800802 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ea:	8b 52 18             	mov    0x18(%edx),%edx
  8007ed:	85 d2                	test   %edx,%edx
  8007ef:	74 32                	je     800823 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	ff d2                	call   *%edx
  8007fa:	83 c4 10             	add    $0x10,%esp
}
  8007fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800800:	c9                   	leave  
  800801:	c3                   	ret    
			thisenv->env_id, fdnum);
  800802:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800807:	8b 40 48             	mov    0x48(%eax),%eax
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	53                   	push   %ebx
  80080e:	50                   	push   %eax
  80080f:	68 58 1d 80 00       	push   $0x801d58
  800814:	e8 c8 08 00 00       	call   8010e1 <cprintf>
		return -E_INVAL;
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800821:	eb da                	jmp    8007fd <ftruncate+0x52>
		return -E_NOT_SUPP;
  800823:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800828:	eb d3                	jmp    8007fd <ftruncate+0x52>

0080082a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	53                   	push   %ebx
  80082e:	83 ec 14             	sub    $0x14,%esp
  800831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800834:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800837:	50                   	push   %eax
  800838:	ff 75 08             	pushl  0x8(%ebp)
  80083b:	e8 81 fb ff ff       	call   8003c1 <fd_lookup>
  800840:	83 c4 08             	add    $0x8,%esp
  800843:	85 c0                	test   %eax,%eax
  800845:	78 4b                	js     800892 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084d:	50                   	push   %eax
  80084e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800851:	ff 30                	pushl  (%eax)
  800853:	e8 bf fb ff ff       	call   800417 <dev_lookup>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	85 c0                	test   %eax,%eax
  80085d:	78 33                	js     800892 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80085f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800862:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800866:	74 2f                	je     800897 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800868:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80086b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800872:	00 00 00 
	stat->st_isdir = 0;
  800875:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80087c:	00 00 00 
	stat->st_dev = dev;
  80087f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	53                   	push   %ebx
  800889:	ff 75 f0             	pushl  -0x10(%ebp)
  80088c:	ff 50 14             	call   *0x14(%eax)
  80088f:	83 c4 10             	add    $0x10,%esp
}
  800892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800895:	c9                   	leave  
  800896:	c3                   	ret    
		return -E_NOT_SUPP;
  800897:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80089c:	eb f4                	jmp    800892 <fstat+0x68>

0080089e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	56                   	push   %esi
  8008a2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	6a 00                	push   $0x0
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	e8 e7 01 00 00       	call   800a97 <open>
  8008b0:	89 c3                	mov    %eax,%ebx
  8008b2:	83 c4 10             	add    $0x10,%esp
  8008b5:	85 c0                	test   %eax,%eax
  8008b7:	78 1b                	js     8008d4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	50                   	push   %eax
  8008c0:	e8 65 ff ff ff       	call   80082a <fstat>
  8008c5:	89 c6                	mov    %eax,%esi
	close(fd);
  8008c7:	89 1c 24             	mov    %ebx,(%esp)
  8008ca:	e8 27 fc ff ff       	call   8004f6 <close>
	return r;
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	89 f3                	mov    %esi,%ebx
}
  8008d4:	89 d8                	mov    %ebx,%eax
  8008d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d9:	5b                   	pop    %ebx
  8008da:	5e                   	pop    %esi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	56                   	push   %esi
  8008e1:	53                   	push   %ebx
  8008e2:	89 c6                	mov    %eax,%esi
  8008e4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008e6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008ed:	74 27                	je     800916 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008ef:	6a 07                	push   $0x7
  8008f1:	68 00 50 80 00       	push   $0x805000
  8008f6:	56                   	push   %esi
  8008f7:	ff 35 00 40 80 00    	pushl  0x804000
  8008fd:	e8 1d 11 00 00       	call   801a1f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800902:	83 c4 0c             	add    $0xc,%esp
  800905:	6a 00                	push   $0x0
  800907:	53                   	push   %ebx
  800908:	6a 00                	push   $0x0
  80090a:	e8 f9 10 00 00       	call   801a08 <ipc_recv>
}
  80090f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800916:	83 ec 0c             	sub    $0xc,%esp
  800919:	6a 01                	push   $0x1
  80091b:	e8 16 11 00 00       	call   801a36 <ipc_find_env>
  800920:	a3 00 40 80 00       	mov    %eax,0x804000
  800925:	83 c4 10             	add    $0x10,%esp
  800928:	eb c5                	jmp    8008ef <fsipc+0x12>

0080092a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 40 0c             	mov    0xc(%eax),%eax
  800936:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80093b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
  800948:	b8 02 00 00 00       	mov    $0x2,%eax
  80094d:	e8 8b ff ff ff       	call   8008dd <fsipc>
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <devfile_flush>:
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 40 0c             	mov    0xc(%eax),%eax
  800960:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800965:	ba 00 00 00 00       	mov    $0x0,%edx
  80096a:	b8 06 00 00 00       	mov    $0x6,%eax
  80096f:	e8 69 ff ff ff       	call   8008dd <fsipc>
}
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <devfile_stat>:
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	53                   	push   %ebx
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 40 0c             	mov    0xc(%eax),%eax
  800986:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80098b:	ba 00 00 00 00       	mov    $0x0,%edx
  800990:	b8 05 00 00 00       	mov    $0x5,%eax
  800995:	e8 43 ff ff ff       	call   8008dd <fsipc>
  80099a:	85 c0                	test   %eax,%eax
  80099c:	78 2c                	js     8009ca <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	68 00 50 80 00       	push   $0x805000
  8009a6:	53                   	push   %ebx
  8009a7:	e8 1f 0d 00 00       	call   8016cb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009ac:	a1 80 50 80 00       	mov    0x805080,%eax
  8009b1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009b7:	a1 84 50 80 00       	mov    0x805084,%eax
  8009bc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009c2:	83 c4 10             	add    $0x10,%esp
  8009c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009cd:	c9                   	leave  
  8009ce:	c3                   	ret    

008009cf <devfile_write>:
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	83 ec 0c             	sub    $0xc,%esp
  8009d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d8:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8009dd:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8009e2:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e8:	8b 52 0c             	mov    0xc(%edx),%edx
  8009eb:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8009f1:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8009f6:	50                   	push   %eax
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	68 08 50 80 00       	push   $0x805008
  8009ff:	e8 55 0e 00 00       	call   801859 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a04:	ba 00 00 00 00       	mov    $0x0,%edx
  800a09:	b8 04 00 00 00       	mov    $0x4,%eax
  800a0e:	e8 ca fe ff ff       	call   8008dd <fsipc>
}
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <devfile_read>:
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 40 0c             	mov    0xc(%eax),%eax
  800a23:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a28:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a33:	b8 03 00 00 00       	mov    $0x3,%eax
  800a38:	e8 a0 fe ff ff       	call   8008dd <fsipc>
  800a3d:	89 c3                	mov    %eax,%ebx
  800a3f:	85 c0                	test   %eax,%eax
  800a41:	78 1f                	js     800a62 <devfile_read+0x4d>
	assert(r <= n);
  800a43:	39 f0                	cmp    %esi,%eax
  800a45:	77 24                	ja     800a6b <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a47:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a4c:	7f 33                	jg     800a81 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a4e:	83 ec 04             	sub    $0x4,%esp
  800a51:	50                   	push   %eax
  800a52:	68 00 50 80 00       	push   $0x805000
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	e8 fa 0d 00 00       	call   801859 <memmove>
	return r;
  800a5f:	83 c4 10             	add    $0x10,%esp
}
  800a62:	89 d8                	mov    %ebx,%eax
  800a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a67:	5b                   	pop    %ebx
  800a68:	5e                   	pop    %esi
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    
	assert(r <= n);
  800a6b:	68 c4 1d 80 00       	push   $0x801dc4
  800a70:	68 cb 1d 80 00       	push   $0x801dcb
  800a75:	6a 7c                	push   $0x7c
  800a77:	68 e0 1d 80 00       	push   $0x801de0
  800a7c:	e8 85 05 00 00       	call   801006 <_panic>
	assert(r <= PGSIZE);
  800a81:	68 eb 1d 80 00       	push   $0x801deb
  800a86:	68 cb 1d 80 00       	push   $0x801dcb
  800a8b:	6a 7d                	push   $0x7d
  800a8d:	68 e0 1d 80 00       	push   $0x801de0
  800a92:	e8 6f 05 00 00       	call   801006 <_panic>

00800a97 <open>:
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	83 ec 1c             	sub    $0x1c,%esp
  800a9f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800aa2:	56                   	push   %esi
  800aa3:	e8 ec 0b 00 00       	call   801694 <strlen>
  800aa8:	83 c4 10             	add    $0x10,%esp
  800aab:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ab0:	7f 6c                	jg     800b1e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ab8:	50                   	push   %eax
  800ab9:	e8 b4 f8 ff ff       	call   800372 <fd_alloc>
  800abe:	89 c3                	mov    %eax,%ebx
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	85 c0                	test   %eax,%eax
  800ac5:	78 3c                	js     800b03 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	56                   	push   %esi
  800acb:	68 00 50 80 00       	push   $0x805000
  800ad0:	e8 f6 0b 00 00       	call   8016cb <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae0:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae5:	e8 f3 fd ff ff       	call   8008dd <fsipc>
  800aea:	89 c3                	mov    %eax,%ebx
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	85 c0                	test   %eax,%eax
  800af1:	78 19                	js     800b0c <open+0x75>
	return fd2num(fd);
  800af3:	83 ec 0c             	sub    $0xc,%esp
  800af6:	ff 75 f4             	pushl  -0xc(%ebp)
  800af9:	e8 4d f8 ff ff       	call   80034b <fd2num>
  800afe:	89 c3                	mov    %eax,%ebx
  800b00:	83 c4 10             	add    $0x10,%esp
}
  800b03:	89 d8                	mov    %ebx,%eax
  800b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    
		fd_close(fd, 0);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	6a 00                	push   $0x0
  800b11:	ff 75 f4             	pushl  -0xc(%ebp)
  800b14:	e8 54 f9 ff ff       	call   80046d <fd_close>
		return r;
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb e5                	jmp    800b03 <open+0x6c>
		return -E_BAD_PATH;
  800b1e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b23:	eb de                	jmp    800b03 <open+0x6c>

00800b25 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b30:	b8 08 00 00 00       	mov    $0x8,%eax
  800b35:	e8 a3 fd ff ff       	call   8008dd <fsipc>
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
  800b41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	ff 75 08             	pushl  0x8(%ebp)
  800b4a:	e8 0c f8 ff ff       	call   80035b <fd2data>
  800b4f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b51:	83 c4 08             	add    $0x8,%esp
  800b54:	68 f7 1d 80 00       	push   $0x801df7
  800b59:	53                   	push   %ebx
  800b5a:	e8 6c 0b 00 00       	call   8016cb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b5f:	8b 46 04             	mov    0x4(%esi),%eax
  800b62:	2b 06                	sub    (%esi),%eax
  800b64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b6a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b71:	00 00 00 
	stat->st_dev = &devpipe;
  800b74:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b7b:	30 80 00 
	return 0;
}
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	53                   	push   %ebx
  800b8e:	83 ec 0c             	sub    $0xc,%esp
  800b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b94:	53                   	push   %ebx
  800b95:	6a 00                	push   $0x0
  800b97:	e8 43 f6 ff ff       	call   8001df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b9c:	89 1c 24             	mov    %ebx,(%esp)
  800b9f:	e8 b7 f7 ff ff       	call   80035b <fd2data>
  800ba4:	83 c4 08             	add    $0x8,%esp
  800ba7:	50                   	push   %eax
  800ba8:	6a 00                	push   $0x0
  800baa:	e8 30 f6 ff ff       	call   8001df <sys_page_unmap>
}
  800baf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <_pipeisclosed>:
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
  800bba:	83 ec 1c             	sub    $0x1c,%esp
  800bbd:	89 c7                	mov    %eax,%edi
  800bbf:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800bc1:	a1 04 40 80 00       	mov    0x804004,%eax
  800bc6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800bc9:	83 ec 0c             	sub    $0xc,%esp
  800bcc:	57                   	push   %edi
  800bcd:	e8 9d 0e 00 00       	call   801a6f <pageref>
  800bd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bd5:	89 34 24             	mov    %esi,(%esp)
  800bd8:	e8 92 0e 00 00       	call   801a6f <pageref>
		nn = thisenv->env_runs;
  800bdd:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800be3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800be6:	83 c4 10             	add    $0x10,%esp
  800be9:	39 cb                	cmp    %ecx,%ebx
  800beb:	74 1b                	je     800c08 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800bed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800bf0:	75 cf                	jne    800bc1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bf2:	8b 42 58             	mov    0x58(%edx),%eax
  800bf5:	6a 01                	push   $0x1
  800bf7:	50                   	push   %eax
  800bf8:	53                   	push   %ebx
  800bf9:	68 fe 1d 80 00       	push   $0x801dfe
  800bfe:	e8 de 04 00 00       	call   8010e1 <cprintf>
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	eb b9                	jmp    800bc1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c08:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c0b:	0f 94 c0             	sete   %al
  800c0e:	0f b6 c0             	movzbl %al,%eax
}
  800c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <devpipe_write>:
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	83 ec 28             	sub    $0x28,%esp
  800c22:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c25:	56                   	push   %esi
  800c26:	e8 30 f7 ff ff       	call   80035b <fd2data>
  800c2b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	bf 00 00 00 00       	mov    $0x0,%edi
  800c35:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c38:	74 4f                	je     800c89 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c3a:	8b 43 04             	mov    0x4(%ebx),%eax
  800c3d:	8b 0b                	mov    (%ebx),%ecx
  800c3f:	8d 51 20             	lea    0x20(%ecx),%edx
  800c42:	39 d0                	cmp    %edx,%eax
  800c44:	72 14                	jb     800c5a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800c46:	89 da                	mov    %ebx,%edx
  800c48:	89 f0                	mov    %esi,%eax
  800c4a:	e8 65 ff ff ff       	call   800bb4 <_pipeisclosed>
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 3a                	jne    800c8d <devpipe_write+0x74>
			sys_yield();
  800c53:	e8 e3 f4 ff ff       	call   80013b <sys_yield>
  800c58:	eb e0                	jmp    800c3a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c61:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	c1 fa 1f             	sar    $0x1f,%edx
  800c69:	89 d1                	mov    %edx,%ecx
  800c6b:	c1 e9 1b             	shr    $0x1b,%ecx
  800c6e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c71:	83 e2 1f             	and    $0x1f,%edx
  800c74:	29 ca                	sub    %ecx,%edx
  800c76:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c7a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c7e:	83 c0 01             	add    $0x1,%eax
  800c81:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800c84:	83 c7 01             	add    $0x1,%edi
  800c87:	eb ac                	jmp    800c35 <devpipe_write+0x1c>
	return i;
  800c89:	89 f8                	mov    %edi,%eax
  800c8b:	eb 05                	jmp    800c92 <devpipe_write+0x79>
				return 0;
  800c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <devpipe_read>:
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	57                   	push   %edi
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	83 ec 18             	sub    $0x18,%esp
  800ca3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800ca6:	57                   	push   %edi
  800ca7:	e8 af f6 ff ff       	call   80035b <fd2data>
  800cac:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	be 00 00 00 00       	mov    $0x0,%esi
  800cb6:	3b 75 10             	cmp    0x10(%ebp),%esi
  800cb9:	74 47                	je     800d02 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800cbb:	8b 03                	mov    (%ebx),%eax
  800cbd:	3b 43 04             	cmp    0x4(%ebx),%eax
  800cc0:	75 22                	jne    800ce4 <devpipe_read+0x4a>
			if (i > 0)
  800cc2:	85 f6                	test   %esi,%esi
  800cc4:	75 14                	jne    800cda <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800cc6:	89 da                	mov    %ebx,%edx
  800cc8:	89 f8                	mov    %edi,%eax
  800cca:	e8 e5 fe ff ff       	call   800bb4 <_pipeisclosed>
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	75 33                	jne    800d06 <devpipe_read+0x6c>
			sys_yield();
  800cd3:	e8 63 f4 ff ff       	call   80013b <sys_yield>
  800cd8:	eb e1                	jmp    800cbb <devpipe_read+0x21>
				return i;
  800cda:	89 f0                	mov    %esi,%eax
}
  800cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ce4:	99                   	cltd   
  800ce5:	c1 ea 1b             	shr    $0x1b,%edx
  800ce8:	01 d0                	add    %edx,%eax
  800cea:	83 e0 1f             	and    $0x1f,%eax
  800ced:	29 d0                	sub    %edx,%eax
  800cef:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800cf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800cfa:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800cfd:	83 c6 01             	add    $0x1,%esi
  800d00:	eb b4                	jmp    800cb6 <devpipe_read+0x1c>
	return i;
  800d02:	89 f0                	mov    %esi,%eax
  800d04:	eb d6                	jmp    800cdc <devpipe_read+0x42>
				return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb cf                	jmp    800cdc <devpipe_read+0x42>

00800d0d <pipe>:
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d18:	50                   	push   %eax
  800d19:	e8 54 f6 ff ff       	call   800372 <fd_alloc>
  800d1e:	89 c3                	mov    %eax,%ebx
  800d20:	83 c4 10             	add    $0x10,%esp
  800d23:	85 c0                	test   %eax,%eax
  800d25:	78 5b                	js     800d82 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d27:	83 ec 04             	sub    $0x4,%esp
  800d2a:	68 07 04 00 00       	push   $0x407
  800d2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d32:	6a 00                	push   $0x0
  800d34:	e8 21 f4 ff ff       	call   80015a <sys_page_alloc>
  800d39:	89 c3                	mov    %eax,%ebx
  800d3b:	83 c4 10             	add    $0x10,%esp
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	78 40                	js     800d82 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d48:	50                   	push   %eax
  800d49:	e8 24 f6 ff ff       	call   800372 <fd_alloc>
  800d4e:	89 c3                	mov    %eax,%ebx
  800d50:	83 c4 10             	add    $0x10,%esp
  800d53:	85 c0                	test   %eax,%eax
  800d55:	78 1b                	js     800d72 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 07 04 00 00       	push   $0x407
  800d5f:	ff 75 f0             	pushl  -0x10(%ebp)
  800d62:	6a 00                	push   $0x0
  800d64:	e8 f1 f3 ff ff       	call   80015a <sys_page_alloc>
  800d69:	89 c3                	mov    %eax,%ebx
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	79 19                	jns    800d8b <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	6a 00                	push   $0x0
  800d7a:	e8 60 f4 ff ff       	call   8001df <sys_page_unmap>
  800d7f:	83 c4 10             	add    $0x10,%esp
}
  800d82:	89 d8                	mov    %ebx,%eax
  800d84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    
	va = fd2data(fd0);
  800d8b:	83 ec 0c             	sub    $0xc,%esp
  800d8e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d91:	e8 c5 f5 ff ff       	call   80035b <fd2data>
  800d96:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d98:	83 c4 0c             	add    $0xc,%esp
  800d9b:	68 07 04 00 00       	push   $0x407
  800da0:	50                   	push   %eax
  800da1:	6a 00                	push   $0x0
  800da3:	e8 b2 f3 ff ff       	call   80015a <sys_page_alloc>
  800da8:	89 c3                	mov    %eax,%ebx
  800daa:	83 c4 10             	add    $0x10,%esp
  800dad:	85 c0                	test   %eax,%eax
  800daf:	0f 88 8c 00 00 00    	js     800e41 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	ff 75 f0             	pushl  -0x10(%ebp)
  800dbb:	e8 9b f5 ff ff       	call   80035b <fd2data>
  800dc0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800dc7:	50                   	push   %eax
  800dc8:	6a 00                	push   $0x0
  800dca:	56                   	push   %esi
  800dcb:	6a 00                	push   $0x0
  800dcd:	e8 cb f3 ff ff       	call   80019d <sys_page_map>
  800dd2:	89 c3                	mov    %eax,%ebx
  800dd4:	83 c4 20             	add    $0x20,%esp
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	78 58                	js     800e33 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dde:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800de4:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800df9:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfe:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0b:	e8 3b f5 ff ff       	call   80034b <fd2num>
  800e10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e13:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e15:	83 c4 04             	add    $0x4,%esp
  800e18:	ff 75 f0             	pushl  -0x10(%ebp)
  800e1b:	e8 2b f5 ff ff       	call   80034b <fd2num>
  800e20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e23:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e26:	83 c4 10             	add    $0x10,%esp
  800e29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2e:	e9 4f ff ff ff       	jmp    800d82 <pipe+0x75>
	sys_page_unmap(0, va);
  800e33:	83 ec 08             	sub    $0x8,%esp
  800e36:	56                   	push   %esi
  800e37:	6a 00                	push   $0x0
  800e39:	e8 a1 f3 ff ff       	call   8001df <sys_page_unmap>
  800e3e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 f0             	pushl  -0x10(%ebp)
  800e47:	6a 00                	push   $0x0
  800e49:	e8 91 f3 ff ff       	call   8001df <sys_page_unmap>
  800e4e:	83 c4 10             	add    $0x10,%esp
  800e51:	e9 1c ff ff ff       	jmp    800d72 <pipe+0x65>

00800e56 <pipeisclosed>:
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e5f:	50                   	push   %eax
  800e60:	ff 75 08             	pushl  0x8(%ebp)
  800e63:	e8 59 f5 ff ff       	call   8003c1 <fd_lookup>
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	78 18                	js     800e87 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800e6f:	83 ec 0c             	sub    $0xc,%esp
  800e72:	ff 75 f4             	pushl  -0xc(%ebp)
  800e75:	e8 e1 f4 ff ff       	call   80035b <fd2data>
	return _pipeisclosed(fd, p);
  800e7a:	89 c2                	mov    %eax,%edx
  800e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e7f:	e8 30 fd ff ff       	call   800bb4 <_pipeisclosed>
  800e84:	83 c4 10             	add    $0x10,%esp
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e99:	68 16 1e 80 00       	push   $0x801e16
  800e9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ea1:	e8 25 08 00 00       	call   8016cb <strcpy>
	return 0;
}
  800ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <devcons_write>:
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800eb9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800ebe:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800ec4:	eb 2f                	jmp    800ef5 <devcons_write+0x48>
		m = n - tot;
  800ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec9:	29 f3                	sub    %esi,%ebx
  800ecb:	83 fb 7f             	cmp    $0x7f,%ebx
  800ece:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800ed3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800ed6:	83 ec 04             	sub    $0x4,%esp
  800ed9:	53                   	push   %ebx
  800eda:	89 f0                	mov    %esi,%eax
  800edc:	03 45 0c             	add    0xc(%ebp),%eax
  800edf:	50                   	push   %eax
  800ee0:	57                   	push   %edi
  800ee1:	e8 73 09 00 00       	call   801859 <memmove>
		sys_cputs(buf, m);
  800ee6:	83 c4 08             	add    $0x8,%esp
  800ee9:	53                   	push   %ebx
  800eea:	57                   	push   %edi
  800eeb:	e8 ae f1 ff ff       	call   80009e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800ef0:	01 de                	add    %ebx,%esi
  800ef2:	83 c4 10             	add    $0x10,%esp
  800ef5:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ef8:	72 cc                	jb     800ec6 <devcons_write+0x19>
}
  800efa:	89 f0                	mov    %esi,%eax
  800efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <devcons_read>:
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 08             	sub    $0x8,%esp
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f13:	75 07                	jne    800f1c <devcons_read+0x18>
}
  800f15:	c9                   	leave  
  800f16:	c3                   	ret    
		sys_yield();
  800f17:	e8 1f f2 ff ff       	call   80013b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800f1c:	e8 9b f1 ff ff       	call   8000bc <sys_cgetc>
  800f21:	85 c0                	test   %eax,%eax
  800f23:	74 f2                	je     800f17 <devcons_read+0x13>
	if (c < 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	78 ec                	js     800f15 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  800f29:	83 f8 04             	cmp    $0x4,%eax
  800f2c:	74 0c                	je     800f3a <devcons_read+0x36>
	*(char*)vbuf = c;
  800f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f31:	88 02                	mov    %al,(%edx)
	return 1;
  800f33:	b8 01 00 00 00       	mov    $0x1,%eax
  800f38:	eb db                	jmp    800f15 <devcons_read+0x11>
		return 0;
  800f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3f:	eb d4                	jmp    800f15 <devcons_read+0x11>

00800f41 <cputchar>:
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800f4d:	6a 01                	push   $0x1
  800f4f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f52:	50                   	push   %eax
  800f53:	e8 46 f1 ff ff       	call   80009e <sys_cputs>
}
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	c9                   	leave  
  800f5c:	c3                   	ret    

00800f5d <getchar>:
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800f63:	6a 01                	push   $0x1
  800f65:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f68:	50                   	push   %eax
  800f69:	6a 00                	push   $0x0
  800f6b:	e8 c2 f6 ff ff       	call   800632 <read>
	if (r < 0)
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	85 c0                	test   %eax,%eax
  800f75:	78 08                	js     800f7f <getchar+0x22>
	if (r < 1)
  800f77:	85 c0                	test   %eax,%eax
  800f79:	7e 06                	jle    800f81 <getchar+0x24>
	return c;
  800f7b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    
		return -E_EOF;
  800f81:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800f86:	eb f7                	jmp    800f7f <getchar+0x22>

00800f88 <iscons>:
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f91:	50                   	push   %eax
  800f92:	ff 75 08             	pushl  0x8(%ebp)
  800f95:	e8 27 f4 ff ff       	call   8003c1 <fd_lookup>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	78 11                	js     800fb2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800faa:	39 10                	cmp    %edx,(%eax)
  800fac:	0f 94 c0             	sete   %al
  800faf:	0f b6 c0             	movzbl %al,%eax
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <opencons>:
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800fba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fbd:	50                   	push   %eax
  800fbe:	e8 af f3 ff ff       	call   800372 <fd_alloc>
  800fc3:	83 c4 10             	add    $0x10,%esp
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	78 3a                	js     801004 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fca:	83 ec 04             	sub    $0x4,%esp
  800fcd:	68 07 04 00 00       	push   $0x407
  800fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd5:	6a 00                	push   $0x0
  800fd7:	e8 7e f1 ff ff       	call   80015a <sys_page_alloc>
  800fdc:	83 c4 10             	add    $0x10,%esp
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	78 21                	js     801004 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	50                   	push   %eax
  800ffc:	e8 4a f3 ff ff       	call   80034b <fd2num>
  801001:	83 c4 10             	add    $0x10,%esp
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80100b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80100e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801014:	e8 03 f1 ff ff       	call   80011c <sys_getenvid>
  801019:	83 ec 0c             	sub    $0xc,%esp
  80101c:	ff 75 0c             	pushl  0xc(%ebp)
  80101f:	ff 75 08             	pushl  0x8(%ebp)
  801022:	56                   	push   %esi
  801023:	50                   	push   %eax
  801024:	68 24 1e 80 00       	push   $0x801e24
  801029:	e8 b3 00 00 00       	call   8010e1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80102e:	83 c4 18             	add    $0x18,%esp
  801031:	53                   	push   %ebx
  801032:	ff 75 10             	pushl  0x10(%ebp)
  801035:	e8 56 00 00 00       	call   801090 <vcprintf>
	cprintf("\n");
  80103a:	c7 04 24 0f 1e 80 00 	movl   $0x801e0f,(%esp)
  801041:	e8 9b 00 00 00       	call   8010e1 <cprintf>
  801046:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801049:	cc                   	int3   
  80104a:	eb fd                	jmp    801049 <_panic+0x43>

0080104c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	53                   	push   %ebx
  801050:	83 ec 04             	sub    $0x4,%esp
  801053:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801056:	8b 13                	mov    (%ebx),%edx
  801058:	8d 42 01             	lea    0x1(%edx),%eax
  80105b:	89 03                	mov    %eax,(%ebx)
  80105d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801060:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801064:	3d ff 00 00 00       	cmp    $0xff,%eax
  801069:	74 09                	je     801074 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80106b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80106f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801072:	c9                   	leave  
  801073:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	68 ff 00 00 00       	push   $0xff
  80107c:	8d 43 08             	lea    0x8(%ebx),%eax
  80107f:	50                   	push   %eax
  801080:	e8 19 f0 ff ff       	call   80009e <sys_cputs>
		b->idx = 0;
  801085:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80108b:	83 c4 10             	add    $0x10,%esp
  80108e:	eb db                	jmp    80106b <putch+0x1f>

00801090 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801099:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8010a0:	00 00 00 
	b.cnt = 0;
  8010a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8010aa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	ff 75 08             	pushl  0x8(%ebp)
  8010b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8010b9:	50                   	push   %eax
  8010ba:	68 4c 10 80 00       	push   $0x80104c
  8010bf:	e8 1a 01 00 00       	call   8011de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8010c4:	83 c4 08             	add    $0x8,%esp
  8010c7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8010cd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8010d3:	50                   	push   %eax
  8010d4:	e8 c5 ef ff ff       	call   80009e <sys_cputs>

	return b.cnt;
}
  8010d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010df:	c9                   	leave  
  8010e0:	c3                   	ret    

008010e1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010e7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010ea:	50                   	push   %eax
  8010eb:	ff 75 08             	pushl  0x8(%ebp)
  8010ee:	e8 9d ff ff ff       	call   801090 <vcprintf>
	va_end(ap);

	return cnt;
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
  8010fb:	83 ec 1c             	sub    $0x1c,%esp
  8010fe:	89 c7                	mov    %eax,%edi
  801100:	89 d6                	mov    %edx,%esi
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8b 55 0c             	mov    0xc(%ebp),%edx
  801108:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80110b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80110e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801111:	bb 00 00 00 00       	mov    $0x0,%ebx
  801116:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801119:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80111c:	39 d3                	cmp    %edx,%ebx
  80111e:	72 05                	jb     801125 <printnum+0x30>
  801120:	39 45 10             	cmp    %eax,0x10(%ebp)
  801123:	77 7a                	ja     80119f <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801125:	83 ec 0c             	sub    $0xc,%esp
  801128:	ff 75 18             	pushl  0x18(%ebp)
  80112b:	8b 45 14             	mov    0x14(%ebp),%eax
  80112e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801131:	53                   	push   %ebx
  801132:	ff 75 10             	pushl  0x10(%ebp)
  801135:	83 ec 08             	sub    $0x8,%esp
  801138:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113b:	ff 75 e0             	pushl  -0x20(%ebp)
  80113e:	ff 75 dc             	pushl  -0x24(%ebp)
  801141:	ff 75 d8             	pushl  -0x28(%ebp)
  801144:	e8 67 09 00 00       	call   801ab0 <__udivdi3>
  801149:	83 c4 18             	add    $0x18,%esp
  80114c:	52                   	push   %edx
  80114d:	50                   	push   %eax
  80114e:	89 f2                	mov    %esi,%edx
  801150:	89 f8                	mov    %edi,%eax
  801152:	e8 9e ff ff ff       	call   8010f5 <printnum>
  801157:	83 c4 20             	add    $0x20,%esp
  80115a:	eb 13                	jmp    80116f <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	56                   	push   %esi
  801160:	ff 75 18             	pushl  0x18(%ebp)
  801163:	ff d7                	call   *%edi
  801165:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801168:	83 eb 01             	sub    $0x1,%ebx
  80116b:	85 db                	test   %ebx,%ebx
  80116d:	7f ed                	jg     80115c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	56                   	push   %esi
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	ff 75 e4             	pushl  -0x1c(%ebp)
  801179:	ff 75 e0             	pushl  -0x20(%ebp)
  80117c:	ff 75 dc             	pushl  -0x24(%ebp)
  80117f:	ff 75 d8             	pushl  -0x28(%ebp)
  801182:	e8 49 0a 00 00       	call   801bd0 <__umoddi3>
  801187:	83 c4 14             	add    $0x14,%esp
  80118a:	0f be 80 47 1e 80 00 	movsbl 0x801e47(%eax),%eax
  801191:	50                   	push   %eax
  801192:	ff d7                	call   *%edi
}
  801194:	83 c4 10             	add    $0x10,%esp
  801197:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119a:	5b                   	pop    %ebx
  80119b:	5e                   	pop    %esi
  80119c:	5f                   	pop    %edi
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    
  80119f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011a2:	eb c4                	jmp    801168 <printnum+0x73>

008011a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011aa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011ae:	8b 10                	mov    (%eax),%edx
  8011b0:	3b 50 04             	cmp    0x4(%eax),%edx
  8011b3:	73 0a                	jae    8011bf <sprintputch+0x1b>
		*b->buf++ = ch;
  8011b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b8:	89 08                	mov    %ecx,(%eax)
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	88 02                	mov    %al,(%edx)
}
  8011bf:	5d                   	pop    %ebp
  8011c0:	c3                   	ret    

008011c1 <printfmt>:
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8011c7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8011ca:	50                   	push   %eax
  8011cb:	ff 75 10             	pushl  0x10(%ebp)
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	e8 05 00 00 00       	call   8011de <vprintfmt>
}
  8011d9:	83 c4 10             	add    $0x10,%esp
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <vprintfmt>:
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	57                   	push   %edi
  8011e2:	56                   	push   %esi
  8011e3:	53                   	push   %ebx
  8011e4:	83 ec 2c             	sub    $0x2c,%esp
  8011e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011ed:	8b 7d 10             	mov    0x10(%ebp),%edi
  8011f0:	e9 8c 03 00 00       	jmp    801581 <vprintfmt+0x3a3>
		padc = ' ';
  8011f5:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8011f9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801200:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801207:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80120e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801213:	8d 47 01             	lea    0x1(%edi),%eax
  801216:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801219:	0f b6 17             	movzbl (%edi),%edx
  80121c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80121f:	3c 55                	cmp    $0x55,%al
  801221:	0f 87 dd 03 00 00    	ja     801604 <vprintfmt+0x426>
  801227:	0f b6 c0             	movzbl %al,%eax
  80122a:	ff 24 85 80 1f 80 00 	jmp    *0x801f80(,%eax,4)
  801231:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801234:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801238:	eb d9                	jmp    801213 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80123a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80123d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801241:	eb d0                	jmp    801213 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801243:	0f b6 d2             	movzbl %dl,%edx
  801246:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801249:	b8 00 00 00 00       	mov    $0x0,%eax
  80124e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801251:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801254:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801258:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80125b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80125e:	83 f9 09             	cmp    $0x9,%ecx
  801261:	77 55                	ja     8012b8 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801263:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801266:	eb e9                	jmp    801251 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801268:	8b 45 14             	mov    0x14(%ebp),%eax
  80126b:	8b 00                	mov    (%eax),%eax
  80126d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801270:	8b 45 14             	mov    0x14(%ebp),%eax
  801273:	8d 40 04             	lea    0x4(%eax),%eax
  801276:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801279:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80127c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801280:	79 91                	jns    801213 <vprintfmt+0x35>
				width = precision, precision = -1;
  801282:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801285:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801288:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80128f:	eb 82                	jmp    801213 <vprintfmt+0x35>
  801291:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801294:	85 c0                	test   %eax,%eax
  801296:	ba 00 00 00 00       	mov    $0x0,%edx
  80129b:	0f 49 d0             	cmovns %eax,%edx
  80129e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8012a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012a4:	e9 6a ff ff ff       	jmp    801213 <vprintfmt+0x35>
  8012a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8012ac:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012b3:	e9 5b ff ff ff       	jmp    801213 <vprintfmt+0x35>
  8012b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8012bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8012be:	eb bc                	jmp    80127c <vprintfmt+0x9e>
			lflag++;
  8012c0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8012c6:	e9 48 ff ff ff       	jmp    801213 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8012cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ce:	8d 78 04             	lea    0x4(%eax),%edi
  8012d1:	83 ec 08             	sub    $0x8,%esp
  8012d4:	53                   	push   %ebx
  8012d5:	ff 30                	pushl  (%eax)
  8012d7:	ff d6                	call   *%esi
			break;
  8012d9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8012dc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8012df:	e9 9a 02 00 00       	jmp    80157e <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8d 78 04             	lea    0x4(%eax),%edi
  8012ea:	8b 00                	mov    (%eax),%eax
  8012ec:	99                   	cltd   
  8012ed:	31 d0                	xor    %edx,%eax
  8012ef:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012f1:	83 f8 0f             	cmp    $0xf,%eax
  8012f4:	7f 23                	jg     801319 <vprintfmt+0x13b>
  8012f6:	8b 14 85 e0 20 80 00 	mov    0x8020e0(,%eax,4),%edx
  8012fd:	85 d2                	test   %edx,%edx
  8012ff:	74 18                	je     801319 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801301:	52                   	push   %edx
  801302:	68 dd 1d 80 00       	push   $0x801ddd
  801307:	53                   	push   %ebx
  801308:	56                   	push   %esi
  801309:	e8 b3 fe ff ff       	call   8011c1 <printfmt>
  80130e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801311:	89 7d 14             	mov    %edi,0x14(%ebp)
  801314:	e9 65 02 00 00       	jmp    80157e <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  801319:	50                   	push   %eax
  80131a:	68 5f 1e 80 00       	push   $0x801e5f
  80131f:	53                   	push   %ebx
  801320:	56                   	push   %esi
  801321:	e8 9b fe ff ff       	call   8011c1 <printfmt>
  801326:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801329:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80132c:	e9 4d 02 00 00       	jmp    80157e <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	83 c0 04             	add    $0x4,%eax
  801337:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80133a:	8b 45 14             	mov    0x14(%ebp),%eax
  80133d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80133f:	85 ff                	test   %edi,%edi
  801341:	b8 58 1e 80 00       	mov    $0x801e58,%eax
  801346:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801349:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80134d:	0f 8e bd 00 00 00    	jle    801410 <vprintfmt+0x232>
  801353:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801357:	75 0e                	jne    801367 <vprintfmt+0x189>
  801359:	89 75 08             	mov    %esi,0x8(%ebp)
  80135c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80135f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801362:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801365:	eb 6d                	jmp    8013d4 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	ff 75 d0             	pushl  -0x30(%ebp)
  80136d:	57                   	push   %edi
  80136e:	e8 39 03 00 00       	call   8016ac <strnlen>
  801373:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801376:	29 c1                	sub    %eax,%ecx
  801378:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80137b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80137e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801382:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801385:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801388:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80138a:	eb 0f                	jmp    80139b <vprintfmt+0x1bd>
					putch(padc, putdat);
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	53                   	push   %ebx
  801390:	ff 75 e0             	pushl  -0x20(%ebp)
  801393:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801395:	83 ef 01             	sub    $0x1,%edi
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 ff                	test   %edi,%edi
  80139d:	7f ed                	jg     80138c <vprintfmt+0x1ae>
  80139f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013a2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8013a5:	85 c9                	test   %ecx,%ecx
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ac:	0f 49 c1             	cmovns %ecx,%eax
  8013af:	29 c1                	sub    %eax,%ecx
  8013b1:	89 75 08             	mov    %esi,0x8(%ebp)
  8013b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8013b7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8013ba:	89 cb                	mov    %ecx,%ebx
  8013bc:	eb 16                	jmp    8013d4 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8013be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013c2:	75 31                	jne    8013f5 <vprintfmt+0x217>
					putch(ch, putdat);
  8013c4:	83 ec 08             	sub    $0x8,%esp
  8013c7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ca:	50                   	push   %eax
  8013cb:	ff 55 08             	call   *0x8(%ebp)
  8013ce:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d1:	83 eb 01             	sub    $0x1,%ebx
  8013d4:	83 c7 01             	add    $0x1,%edi
  8013d7:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8013db:	0f be c2             	movsbl %dl,%eax
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	74 59                	je     80143b <vprintfmt+0x25d>
  8013e2:	85 f6                	test   %esi,%esi
  8013e4:	78 d8                	js     8013be <vprintfmt+0x1e0>
  8013e6:	83 ee 01             	sub    $0x1,%esi
  8013e9:	79 d3                	jns    8013be <vprintfmt+0x1e0>
  8013eb:	89 df                	mov    %ebx,%edi
  8013ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8013f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8013f3:	eb 37                	jmp    80142c <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8013f5:	0f be d2             	movsbl %dl,%edx
  8013f8:	83 ea 20             	sub    $0x20,%edx
  8013fb:	83 fa 5e             	cmp    $0x5e,%edx
  8013fe:	76 c4                	jbe    8013c4 <vprintfmt+0x1e6>
					putch('?', putdat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	6a 3f                	push   $0x3f
  801408:	ff 55 08             	call   *0x8(%ebp)
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	eb c1                	jmp    8013d1 <vprintfmt+0x1f3>
  801410:	89 75 08             	mov    %esi,0x8(%ebp)
  801413:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801416:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801419:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80141c:	eb b6                	jmp    8013d4 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	53                   	push   %ebx
  801422:	6a 20                	push   $0x20
  801424:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801426:	83 ef 01             	sub    $0x1,%edi
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	85 ff                	test   %edi,%edi
  80142e:	7f ee                	jg     80141e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801430:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801433:	89 45 14             	mov    %eax,0x14(%ebp)
  801436:	e9 43 01 00 00       	jmp    80157e <vprintfmt+0x3a0>
  80143b:	89 df                	mov    %ebx,%edi
  80143d:	8b 75 08             	mov    0x8(%ebp),%esi
  801440:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801443:	eb e7                	jmp    80142c <vprintfmt+0x24e>
	if (lflag >= 2)
  801445:	83 f9 01             	cmp    $0x1,%ecx
  801448:	7e 3f                	jle    801489 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80144a:	8b 45 14             	mov    0x14(%ebp),%eax
  80144d:	8b 50 04             	mov    0x4(%eax),%edx
  801450:	8b 00                	mov    (%eax),%eax
  801452:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801455:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801458:	8b 45 14             	mov    0x14(%ebp),%eax
  80145b:	8d 40 08             	lea    0x8(%eax),%eax
  80145e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801461:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801465:	79 5c                	jns    8014c3 <vprintfmt+0x2e5>
				putch('-', putdat);
  801467:	83 ec 08             	sub    $0x8,%esp
  80146a:	53                   	push   %ebx
  80146b:	6a 2d                	push   $0x2d
  80146d:	ff d6                	call   *%esi
				num = -(long long) num;
  80146f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801472:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801475:	f7 da                	neg    %edx
  801477:	83 d1 00             	adc    $0x0,%ecx
  80147a:	f7 d9                	neg    %ecx
  80147c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80147f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801484:	e9 db 00 00 00       	jmp    801564 <vprintfmt+0x386>
	else if (lflag)
  801489:	85 c9                	test   %ecx,%ecx
  80148b:	75 1b                	jne    8014a8 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80148d:	8b 45 14             	mov    0x14(%ebp),%eax
  801490:	8b 00                	mov    (%eax),%eax
  801492:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801495:	89 c1                	mov    %eax,%ecx
  801497:	c1 f9 1f             	sar    $0x1f,%ecx
  80149a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80149d:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a0:	8d 40 04             	lea    0x4(%eax),%eax
  8014a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8014a6:	eb b9                	jmp    801461 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8014a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ab:	8b 00                	mov    (%eax),%eax
  8014ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014b0:	89 c1                	mov    %eax,%ecx
  8014b2:	c1 f9 1f             	sar    $0x1f,%ecx
  8014b5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8014b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bb:	8d 40 04             	lea    0x4(%eax),%eax
  8014be:	89 45 14             	mov    %eax,0x14(%ebp)
  8014c1:	eb 9e                	jmp    801461 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8014c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014c6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8014c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014ce:	e9 91 00 00 00       	jmp    801564 <vprintfmt+0x386>
	if (lflag >= 2)
  8014d3:	83 f9 01             	cmp    $0x1,%ecx
  8014d6:	7e 15                	jle    8014ed <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8014d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014db:	8b 10                	mov    (%eax),%edx
  8014dd:	8b 48 04             	mov    0x4(%eax),%ecx
  8014e0:	8d 40 08             	lea    0x8(%eax),%eax
  8014e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8014e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014eb:	eb 77                	jmp    801564 <vprintfmt+0x386>
	else if (lflag)
  8014ed:	85 c9                	test   %ecx,%ecx
  8014ef:	75 17                	jne    801508 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8014f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f4:	8b 10                	mov    (%eax),%edx
  8014f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014fb:	8d 40 04             	lea    0x4(%eax),%eax
  8014fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801501:	b8 0a 00 00 00       	mov    $0xa,%eax
  801506:	eb 5c                	jmp    801564 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  801508:	8b 45 14             	mov    0x14(%ebp),%eax
  80150b:	8b 10                	mov    (%eax),%edx
  80150d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801512:	8d 40 04             	lea    0x4(%eax),%eax
  801515:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801518:	b8 0a 00 00 00       	mov    $0xa,%eax
  80151d:	eb 45                	jmp    801564 <vprintfmt+0x386>
			putch('X', putdat);
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	53                   	push   %ebx
  801523:	6a 58                	push   $0x58
  801525:	ff d6                	call   *%esi
			putch('X', putdat);
  801527:	83 c4 08             	add    $0x8,%esp
  80152a:	53                   	push   %ebx
  80152b:	6a 58                	push   $0x58
  80152d:	ff d6                	call   *%esi
			putch('X', putdat);
  80152f:	83 c4 08             	add    $0x8,%esp
  801532:	53                   	push   %ebx
  801533:	6a 58                	push   $0x58
  801535:	ff d6                	call   *%esi
			break;
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	eb 42                	jmp    80157e <vprintfmt+0x3a0>
			putch('0', putdat);
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	53                   	push   %ebx
  801540:	6a 30                	push   $0x30
  801542:	ff d6                	call   *%esi
			putch('x', putdat);
  801544:	83 c4 08             	add    $0x8,%esp
  801547:	53                   	push   %ebx
  801548:	6a 78                	push   $0x78
  80154a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80154c:	8b 45 14             	mov    0x14(%ebp),%eax
  80154f:	8b 10                	mov    (%eax),%edx
  801551:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801556:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801559:	8d 40 04             	lea    0x4(%eax),%eax
  80155c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80155f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801564:	83 ec 0c             	sub    $0xc,%esp
  801567:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80156b:	57                   	push   %edi
  80156c:	ff 75 e0             	pushl  -0x20(%ebp)
  80156f:	50                   	push   %eax
  801570:	51                   	push   %ecx
  801571:	52                   	push   %edx
  801572:	89 da                	mov    %ebx,%edx
  801574:	89 f0                	mov    %esi,%eax
  801576:	e8 7a fb ff ff       	call   8010f5 <printnum>
			break;
  80157b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80157e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801581:	83 c7 01             	add    $0x1,%edi
  801584:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801588:	83 f8 25             	cmp    $0x25,%eax
  80158b:	0f 84 64 fc ff ff    	je     8011f5 <vprintfmt+0x17>
			if (ch == '\0')
  801591:	85 c0                	test   %eax,%eax
  801593:	0f 84 8b 00 00 00    	je     801624 <vprintfmt+0x446>
			putch(ch, putdat);
  801599:	83 ec 08             	sub    $0x8,%esp
  80159c:	53                   	push   %ebx
  80159d:	50                   	push   %eax
  80159e:	ff d6                	call   *%esi
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	eb dc                	jmp    801581 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8015a5:	83 f9 01             	cmp    $0x1,%ecx
  8015a8:	7e 15                	jle    8015bf <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	8b 10                	mov    (%eax),%edx
  8015af:	8b 48 04             	mov    0x4(%eax),%ecx
  8015b2:	8d 40 08             	lea    0x8(%eax),%eax
  8015b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015b8:	b8 10 00 00 00       	mov    $0x10,%eax
  8015bd:	eb a5                	jmp    801564 <vprintfmt+0x386>
	else if (lflag)
  8015bf:	85 c9                	test   %ecx,%ecx
  8015c1:	75 17                	jne    8015da <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8015c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c6:	8b 10                	mov    (%eax),%edx
  8015c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015cd:	8d 40 04             	lea    0x4(%eax),%eax
  8015d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015d3:	b8 10 00 00 00       	mov    $0x10,%eax
  8015d8:	eb 8a                	jmp    801564 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8015da:	8b 45 14             	mov    0x14(%ebp),%eax
  8015dd:	8b 10                	mov    (%eax),%edx
  8015df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015e4:	8d 40 04             	lea    0x4(%eax),%eax
  8015e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015ea:	b8 10 00 00 00       	mov    $0x10,%eax
  8015ef:	e9 70 ff ff ff       	jmp    801564 <vprintfmt+0x386>
			putch(ch, putdat);
  8015f4:	83 ec 08             	sub    $0x8,%esp
  8015f7:	53                   	push   %ebx
  8015f8:	6a 25                	push   $0x25
  8015fa:	ff d6                	call   *%esi
			break;
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	e9 7a ff ff ff       	jmp    80157e <vprintfmt+0x3a0>
			putch('%', putdat);
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	53                   	push   %ebx
  801608:	6a 25                	push   $0x25
  80160a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	89 f8                	mov    %edi,%eax
  801611:	eb 03                	jmp    801616 <vprintfmt+0x438>
  801613:	83 e8 01             	sub    $0x1,%eax
  801616:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80161a:	75 f7                	jne    801613 <vprintfmt+0x435>
  80161c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80161f:	e9 5a ff ff ff       	jmp    80157e <vprintfmt+0x3a0>
}
  801624:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801627:	5b                   	pop    %ebx
  801628:	5e                   	pop    %esi
  801629:	5f                   	pop    %edi
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 18             	sub    $0x18,%esp
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801638:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80163b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80163f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801642:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801649:	85 c0                	test   %eax,%eax
  80164b:	74 26                	je     801673 <vsnprintf+0x47>
  80164d:	85 d2                	test   %edx,%edx
  80164f:	7e 22                	jle    801673 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801651:	ff 75 14             	pushl  0x14(%ebp)
  801654:	ff 75 10             	pushl  0x10(%ebp)
  801657:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80165a:	50                   	push   %eax
  80165b:	68 a4 11 80 00       	push   $0x8011a4
  801660:	e8 79 fb ff ff       	call   8011de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801665:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801668:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80166b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166e:	83 c4 10             	add    $0x10,%esp
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    
		return -E_INVAL;
  801673:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801678:	eb f7                	jmp    801671 <vsnprintf+0x45>

0080167a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801680:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801683:	50                   	push   %eax
  801684:	ff 75 10             	pushl  0x10(%ebp)
  801687:	ff 75 0c             	pushl  0xc(%ebp)
  80168a:	ff 75 08             	pushl  0x8(%ebp)
  80168d:	e8 9a ff ff ff       	call   80162c <vsnprintf>
	va_end(ap);

	return rc;
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80169a:	b8 00 00 00 00       	mov    $0x0,%eax
  80169f:	eb 03                	jmp    8016a4 <strlen+0x10>
		n++;
  8016a1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8016a4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016a8:	75 f7                	jne    8016a1 <strlen+0xd>
	return n;
}
  8016aa:	5d                   	pop    %ebp
  8016ab:	c3                   	ret    

008016ac <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ba:	eb 03                	jmp    8016bf <strnlen+0x13>
		n++;
  8016bc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016bf:	39 d0                	cmp    %edx,%eax
  8016c1:	74 06                	je     8016c9 <strnlen+0x1d>
  8016c3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016c7:	75 f3                	jne    8016bc <strnlen+0x10>
	return n;
}
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	53                   	push   %ebx
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016d5:	89 c2                	mov    %eax,%edx
  8016d7:	83 c1 01             	add    $0x1,%ecx
  8016da:	83 c2 01             	add    $0x1,%edx
  8016dd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8016e1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8016e4:	84 db                	test   %bl,%bl
  8016e6:	75 ef                	jne    8016d7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8016e8:	5b                   	pop    %ebx
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	53                   	push   %ebx
  8016ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8016f2:	53                   	push   %ebx
  8016f3:	e8 9c ff ff ff       	call   801694 <strlen>
  8016f8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	01 d8                	add    %ebx,%eax
  801700:	50                   	push   %eax
  801701:	e8 c5 ff ff ff       	call   8016cb <strcpy>
	return dst;
}
  801706:	89 d8                	mov    %ebx,%eax
  801708:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	56                   	push   %esi
  801711:	53                   	push   %ebx
  801712:	8b 75 08             	mov    0x8(%ebp),%esi
  801715:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801718:	89 f3                	mov    %esi,%ebx
  80171a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80171d:	89 f2                	mov    %esi,%edx
  80171f:	eb 0f                	jmp    801730 <strncpy+0x23>
		*dst++ = *src;
  801721:	83 c2 01             	add    $0x1,%edx
  801724:	0f b6 01             	movzbl (%ecx),%eax
  801727:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80172a:	80 39 01             	cmpb   $0x1,(%ecx)
  80172d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801730:	39 da                	cmp    %ebx,%edx
  801732:	75 ed                	jne    801721 <strncpy+0x14>
	}
	return ret;
}
  801734:	89 f0                	mov    %esi,%eax
  801736:	5b                   	pop    %ebx
  801737:	5e                   	pop    %esi
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    

0080173a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	8b 75 08             	mov    0x8(%ebp),%esi
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801748:	89 f0                	mov    %esi,%eax
  80174a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80174e:	85 c9                	test   %ecx,%ecx
  801750:	75 0b                	jne    80175d <strlcpy+0x23>
  801752:	eb 17                	jmp    80176b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801754:	83 c2 01             	add    $0x1,%edx
  801757:	83 c0 01             	add    $0x1,%eax
  80175a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80175d:	39 d8                	cmp    %ebx,%eax
  80175f:	74 07                	je     801768 <strlcpy+0x2e>
  801761:	0f b6 0a             	movzbl (%edx),%ecx
  801764:	84 c9                	test   %cl,%cl
  801766:	75 ec                	jne    801754 <strlcpy+0x1a>
		*dst = '\0';
  801768:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80176b:	29 f0                	sub    %esi,%eax
}
  80176d:	5b                   	pop    %ebx
  80176e:	5e                   	pop    %esi
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    

00801771 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801777:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80177a:	eb 06                	jmp    801782 <strcmp+0x11>
		p++, q++;
  80177c:	83 c1 01             	add    $0x1,%ecx
  80177f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  801782:	0f b6 01             	movzbl (%ecx),%eax
  801785:	84 c0                	test   %al,%al
  801787:	74 04                	je     80178d <strcmp+0x1c>
  801789:	3a 02                	cmp    (%edx),%al
  80178b:	74 ef                	je     80177c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178d:	0f b6 c0             	movzbl %al,%eax
  801790:	0f b6 12             	movzbl (%edx),%edx
  801793:	29 d0                	sub    %edx,%eax
}
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	53                   	push   %ebx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a1:	89 c3                	mov    %eax,%ebx
  8017a3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017a6:	eb 06                	jmp    8017ae <strncmp+0x17>
		n--, p++, q++;
  8017a8:	83 c0 01             	add    $0x1,%eax
  8017ab:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017ae:	39 d8                	cmp    %ebx,%eax
  8017b0:	74 16                	je     8017c8 <strncmp+0x31>
  8017b2:	0f b6 08             	movzbl (%eax),%ecx
  8017b5:	84 c9                	test   %cl,%cl
  8017b7:	74 04                	je     8017bd <strncmp+0x26>
  8017b9:	3a 0a                	cmp    (%edx),%cl
  8017bb:	74 eb                	je     8017a8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017bd:	0f b6 00             	movzbl (%eax),%eax
  8017c0:	0f b6 12             	movzbl (%edx),%edx
  8017c3:	29 d0                	sub    %edx,%eax
}
  8017c5:	5b                   	pop    %ebx
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    
		return 0;
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cd:	eb f6                	jmp    8017c5 <strncmp+0x2e>

008017cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8017d9:	0f b6 10             	movzbl (%eax),%edx
  8017dc:	84 d2                	test   %dl,%dl
  8017de:	74 09                	je     8017e9 <strchr+0x1a>
		if (*s == c)
  8017e0:	38 ca                	cmp    %cl,%dl
  8017e2:	74 0a                	je     8017ee <strchr+0x1f>
	for (; *s; s++)
  8017e4:	83 c0 01             	add    $0x1,%eax
  8017e7:	eb f0                	jmp    8017d9 <strchr+0xa>
			return (char *) s;
	return 0;
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8017fa:	eb 03                	jmp    8017ff <strfind+0xf>
  8017fc:	83 c0 01             	add    $0x1,%eax
  8017ff:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801802:	38 ca                	cmp    %cl,%dl
  801804:	74 04                	je     80180a <strfind+0x1a>
  801806:	84 d2                	test   %dl,%dl
  801808:	75 f2                	jne    8017fc <strfind+0xc>
			break;
	return (char *) s;
}
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    

0080180c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	57                   	push   %edi
  801810:	56                   	push   %esi
  801811:	53                   	push   %ebx
  801812:	8b 7d 08             	mov    0x8(%ebp),%edi
  801815:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801818:	85 c9                	test   %ecx,%ecx
  80181a:	74 13                	je     80182f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80181c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801822:	75 05                	jne    801829 <memset+0x1d>
  801824:	f6 c1 03             	test   $0x3,%cl
  801827:	74 0d                	je     801836 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182c:	fc                   	cld    
  80182d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80182f:	89 f8                	mov    %edi,%eax
  801831:	5b                   	pop    %ebx
  801832:	5e                   	pop    %esi
  801833:	5f                   	pop    %edi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    
		c &= 0xFF;
  801836:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80183a:	89 d3                	mov    %edx,%ebx
  80183c:	c1 e3 08             	shl    $0x8,%ebx
  80183f:	89 d0                	mov    %edx,%eax
  801841:	c1 e0 18             	shl    $0x18,%eax
  801844:	89 d6                	mov    %edx,%esi
  801846:	c1 e6 10             	shl    $0x10,%esi
  801849:	09 f0                	or     %esi,%eax
  80184b:	09 c2                	or     %eax,%edx
  80184d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80184f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801852:	89 d0                	mov    %edx,%eax
  801854:	fc                   	cld    
  801855:	f3 ab                	rep stos %eax,%es:(%edi)
  801857:	eb d6                	jmp    80182f <memset+0x23>

00801859 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	57                   	push   %edi
  80185d:	56                   	push   %esi
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	8b 75 0c             	mov    0xc(%ebp),%esi
  801864:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801867:	39 c6                	cmp    %eax,%esi
  801869:	73 35                	jae    8018a0 <memmove+0x47>
  80186b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80186e:	39 c2                	cmp    %eax,%edx
  801870:	76 2e                	jbe    8018a0 <memmove+0x47>
		s += n;
		d += n;
  801872:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801875:	89 d6                	mov    %edx,%esi
  801877:	09 fe                	or     %edi,%esi
  801879:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80187f:	74 0c                	je     80188d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801881:	83 ef 01             	sub    $0x1,%edi
  801884:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801887:	fd                   	std    
  801888:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80188a:	fc                   	cld    
  80188b:	eb 21                	jmp    8018ae <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80188d:	f6 c1 03             	test   $0x3,%cl
  801890:	75 ef                	jne    801881 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801892:	83 ef 04             	sub    $0x4,%edi
  801895:	8d 72 fc             	lea    -0x4(%edx),%esi
  801898:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80189b:	fd                   	std    
  80189c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80189e:	eb ea                	jmp    80188a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018a0:	89 f2                	mov    %esi,%edx
  8018a2:	09 c2                	or     %eax,%edx
  8018a4:	f6 c2 03             	test   $0x3,%dl
  8018a7:	74 09                	je     8018b2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018a9:	89 c7                	mov    %eax,%edi
  8018ab:	fc                   	cld    
  8018ac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018ae:	5e                   	pop    %esi
  8018af:	5f                   	pop    %edi
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018b2:	f6 c1 03             	test   $0x3,%cl
  8018b5:	75 f2                	jne    8018a9 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018b7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018ba:	89 c7                	mov    %eax,%edi
  8018bc:	fc                   	cld    
  8018bd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018bf:	eb ed                	jmp    8018ae <memmove+0x55>

008018c1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8018c4:	ff 75 10             	pushl  0x10(%ebp)
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	ff 75 08             	pushl  0x8(%ebp)
  8018cd:	e8 87 ff ff ff       	call   801859 <memmove>
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	89 c6                	mov    %eax,%esi
  8018e1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018e4:	39 f0                	cmp    %esi,%eax
  8018e6:	74 1c                	je     801904 <memcmp+0x30>
		if (*s1 != *s2)
  8018e8:	0f b6 08             	movzbl (%eax),%ecx
  8018eb:	0f b6 1a             	movzbl (%edx),%ebx
  8018ee:	38 d9                	cmp    %bl,%cl
  8018f0:	75 08                	jne    8018fa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8018f2:	83 c0 01             	add    $0x1,%eax
  8018f5:	83 c2 01             	add    $0x1,%edx
  8018f8:	eb ea                	jmp    8018e4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8018fa:	0f b6 c1             	movzbl %cl,%eax
  8018fd:	0f b6 db             	movzbl %bl,%ebx
  801900:	29 d8                	sub    %ebx,%eax
  801902:	eb 05                	jmp    801909 <memcmp+0x35>
	}

	return 0;
  801904:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801909:	5b                   	pop    %ebx
  80190a:	5e                   	pop    %esi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    

0080190d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801916:	89 c2                	mov    %eax,%edx
  801918:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80191b:	39 d0                	cmp    %edx,%eax
  80191d:	73 09                	jae    801928 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191f:	38 08                	cmp    %cl,(%eax)
  801921:	74 05                	je     801928 <memfind+0x1b>
	for (; s < ends; s++)
  801923:	83 c0 01             	add    $0x1,%eax
  801926:	eb f3                	jmp    80191b <memfind+0xe>
			break;
	return (void *) s;
}
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	57                   	push   %edi
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
  801930:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801933:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	eb 03                	jmp    80193b <strtol+0x11>
		s++;
  801938:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80193b:	0f b6 01             	movzbl (%ecx),%eax
  80193e:	3c 20                	cmp    $0x20,%al
  801940:	74 f6                	je     801938 <strtol+0xe>
  801942:	3c 09                	cmp    $0x9,%al
  801944:	74 f2                	je     801938 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801946:	3c 2b                	cmp    $0x2b,%al
  801948:	74 2e                	je     801978 <strtol+0x4e>
	int neg = 0;
  80194a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80194f:	3c 2d                	cmp    $0x2d,%al
  801951:	74 2f                	je     801982 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801953:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801959:	75 05                	jne    801960 <strtol+0x36>
  80195b:	80 39 30             	cmpb   $0x30,(%ecx)
  80195e:	74 2c                	je     80198c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801960:	85 db                	test   %ebx,%ebx
  801962:	75 0a                	jne    80196e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801964:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801969:	80 39 30             	cmpb   $0x30,(%ecx)
  80196c:	74 28                	je     801996 <strtol+0x6c>
		base = 10;
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
  801973:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801976:	eb 50                	jmp    8019c8 <strtol+0x9e>
		s++;
  801978:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80197b:	bf 00 00 00 00       	mov    $0x0,%edi
  801980:	eb d1                	jmp    801953 <strtol+0x29>
		s++, neg = 1;
  801982:	83 c1 01             	add    $0x1,%ecx
  801985:	bf 01 00 00 00       	mov    $0x1,%edi
  80198a:	eb c7                	jmp    801953 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801990:	74 0e                	je     8019a0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801992:	85 db                	test   %ebx,%ebx
  801994:	75 d8                	jne    80196e <strtol+0x44>
		s++, base = 8;
  801996:	83 c1 01             	add    $0x1,%ecx
  801999:	bb 08 00 00 00       	mov    $0x8,%ebx
  80199e:	eb ce                	jmp    80196e <strtol+0x44>
		s += 2, base = 16;
  8019a0:	83 c1 02             	add    $0x2,%ecx
  8019a3:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019a8:	eb c4                	jmp    80196e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8019aa:	8d 72 9f             	lea    -0x61(%edx),%esi
  8019ad:	89 f3                	mov    %esi,%ebx
  8019af:	80 fb 19             	cmp    $0x19,%bl
  8019b2:	77 29                	ja     8019dd <strtol+0xb3>
			dig = *s - 'a' + 10;
  8019b4:	0f be d2             	movsbl %dl,%edx
  8019b7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019ba:	3b 55 10             	cmp    0x10(%ebp),%edx
  8019bd:	7d 30                	jge    8019ef <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8019bf:	83 c1 01             	add    $0x1,%ecx
  8019c2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8019c8:	0f b6 11             	movzbl (%ecx),%edx
  8019cb:	8d 72 d0             	lea    -0x30(%edx),%esi
  8019ce:	89 f3                	mov    %esi,%ebx
  8019d0:	80 fb 09             	cmp    $0x9,%bl
  8019d3:	77 d5                	ja     8019aa <strtol+0x80>
			dig = *s - '0';
  8019d5:	0f be d2             	movsbl %dl,%edx
  8019d8:	83 ea 30             	sub    $0x30,%edx
  8019db:	eb dd                	jmp    8019ba <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8019dd:	8d 72 bf             	lea    -0x41(%edx),%esi
  8019e0:	89 f3                	mov    %esi,%ebx
  8019e2:	80 fb 19             	cmp    $0x19,%bl
  8019e5:	77 08                	ja     8019ef <strtol+0xc5>
			dig = *s - 'A' + 10;
  8019e7:	0f be d2             	movsbl %dl,%edx
  8019ea:	83 ea 37             	sub    $0x37,%edx
  8019ed:	eb cb                	jmp    8019ba <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  8019ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019f3:	74 05                	je     8019fa <strtol+0xd0>
		*endptr = (char *) s;
  8019f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019f8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8019fa:	89 c2                	mov    %eax,%edx
  8019fc:	f7 da                	neg    %edx
  8019fe:	85 ff                	test   %edi,%edi
  801a00:	0f 45 c2             	cmovne %edx,%eax
}
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    

00801a08 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801a0e:	68 40 21 80 00       	push   $0x802140
  801a13:	6a 1a                	push   $0x1a
  801a15:	68 59 21 80 00       	push   $0x802159
  801a1a:	e8 e7 f5 ff ff       	call   801006 <_panic>

00801a1f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801a25:	68 63 21 80 00       	push   $0x802163
  801a2a:	6a 2a                	push   $0x2a
  801a2c:	68 59 21 80 00       	push   $0x802159
  801a31:	e8 d0 f5 ff ff       	call   801006 <_panic>

00801a36 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a3c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a41:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a44:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a4a:	8b 52 50             	mov    0x50(%edx),%edx
  801a4d:	39 ca                	cmp    %ecx,%edx
  801a4f:	74 11                	je     801a62 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801a51:	83 c0 01             	add    $0x1,%eax
  801a54:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a59:	75 e6                	jne    801a41 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a60:	eb 0b                	jmp    801a6d <ipc_find_env+0x37>
			return envs[i].env_id;
  801a62:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a65:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a6a:	8b 40 48             	mov    0x48(%eax),%eax
}
  801a6d:	5d                   	pop    %ebp
  801a6e:	c3                   	ret    

00801a6f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a75:	89 d0                	mov    %edx,%eax
  801a77:	c1 e8 16             	shr    $0x16,%eax
  801a7a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a81:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801a86:	f6 c1 01             	test   $0x1,%cl
  801a89:	74 1d                	je     801aa8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801a8b:	c1 ea 0c             	shr    $0xc,%edx
  801a8e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a95:	f6 c2 01             	test   $0x1,%dl
  801a98:	74 0e                	je     801aa8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a9a:	c1 ea 0c             	shr    $0xc,%edx
  801a9d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801aa4:	ef 
  801aa5:	0f b7 c0             	movzwl %ax,%eax
}
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	66 90                	xchg   %ax,%ax
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
