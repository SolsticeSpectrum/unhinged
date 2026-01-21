; ModuleID = 'runtime/rt.ll'
source_filename = "runtime/rt.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.UhValue = type { i32, double, ptr, ptr, ptr }
%struct.UhDictEntry = type { ptr, %struct.UhValue }
%struct.re_pattern_buffer = type { ptr, i64, i64, i64, ptr, ptr, i64, i8 }
%struct.tm = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, ptr }
%struct.stat = type { i64, i64, i64, i32, i32, i32, i32, i64, i64, i64, i64, %struct.timespec, %struct.timespec, %struct.timespec, [3 x i64] }
%struct.timespec = type { i64, i64 }
%struct.UhCurlBuf = type { ptr, i64, i64 }
%struct.UhRoute = type { ptr, ptr }
%struct.sockaddr_in = type { i16, i16, %struct.in_addr, [8 x i8] }
%struct.in_addr = type { i32 }
%struct.UhDbConn = type { ptr, ptr }
%struct.UhMutex = type { ptr, %union.pthread_mutex_t }
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { ptr, ptr }
%struct.UhSha1 = type { [5 x i32], i64, [64 x i8], i64 }
%struct.addrinfo = type { i32, i32, i32, i32, i32, ptr, ptr, ptr }
%struct.UhUpload = type { ptr, i64, i64 }
%struct.UhSha256 = type { [8 x i32], i64, [64 x i8], i64 }
%struct.UhAesCtx = type { [240 x i8], [16 x i8] }

@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"rb\00", align 1
@.str.2 = private unnamed_addr constant [3 x i8] c"wb\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"path\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"mode\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"ab\00", align 1
@.str.7 = private unnamed_addr constant [9 x i8] c"net/http\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"websocket\00", align 1
@.str.9 = private unnamed_addr constant [7 x i8] c"crypto\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"smtp\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.12 = private unnamed_addr constant [5 x i8] c"null\00", align 1
@.str.14 = private unnamed_addr constant [6 x i8] c"float\00", align 1
@.str.16 = private unnamed_addr constant [6 x i8] c"array\00", align 1
@.str.17 = private unnamed_addr constant [5 x i8] c"dict\00", align 1
@.str.19 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.20 = private unnamed_addr constant [18 x i8] c"%Y-%m-%d %H:%M:%S\00", align 1
@stdout = external local_unnamed_addr global ptr, align 8
@.str.21 = private unnamed_addr constant [3 x i8] c"%g\00", align 1
@g_args = internal global %struct.UhValue zeroinitializer, align 8
@g_env = internal unnamed_addr global ptr null, align 8
@.str.22 = private unnamed_addr constant [5 x i8] c"args\00", align 1
@environ = external local_unnamed_addr global ptr, align 8
@.str.25 = private unnamed_addr constant [13 x i8] c"/src/main.uh\00", align 1
@.str.26 = private unnamed_addr constant [4 x i8] c"GET\00", align 1
@.str.27 = private unnamed_addr constant [4 x i8] c"url\00", align 1
@.str.28 = private unnamed_addr constant [7 x i8] c"method\00", align 1
@.str.29 = private unnamed_addr constant [8 x i8] c"headers\00", align 1
@.str.30 = private unnamed_addr constant [5 x i8] c"body\00", align 1
@.str.31 = private unnamed_addr constant [7 x i8] c"%s: %s\00", align 1
@.str.32 = private unnamed_addr constant [7 x i8] c"status\00", align 1
@.str.33 = private unnamed_addr constant [6 x i8] c":8080\00", align 1
@.str.34 = private unnamed_addr constant [5 x i8] c"\0D\0A\0D\0A\00", align 1
@.str.35 = private unnamed_addr constant [3 x i8] c"\0D\0A\00", align 1
@.str.36 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.37 = private unnamed_addr constant [10 x i8] c"Not found\00", align 1
@.str.38 = private unnamed_addr constant [17 x i8] c"application/json\00", align 1
@.str.39 = private unnamed_addr constant [13 x i8] c"Content-Type\00", align 1
@.str.40 = private unnamed_addr constant [78 x i8] c"HTTP/1.1 %ld OK\0D\0AContent-Type: %s\0D\0AContent-Length: %zu\0D\0AConnection: close\0D\0A\0D\0A\00", align 1
@.str.41 = private unnamed_addr constant [9 x i8] c"database\00", align 1
@.str.42 = private unnamed_addr constant [9 x i8] c":memory:\00", align 1
@g_db = internal unnamed_addr global ptr null, align 8
@g_db_len = internal unnamed_addr global i64 0, align 8
@.str.43 = private unnamed_addr constant [8 x i8] c"__db_id\00", align 1
@.str.44 = private unnamed_addr constant [6 x i8] c"BEGIN\00", align 1
@.str.45 = private unnamed_addr constant [7 x i8] c"COMMIT\00", align 1
@g_threads = internal unnamed_addr global ptr null, align 8
@g_thread_len = internal unnamed_addr global i64 0, align 8
@.str.46 = private unnamed_addr constant [12 x i8] c"__thread_id\00", align 1
@.str.47 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.48 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@.str.49 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@.str.50 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.51 = private unnamed_addr constant [8 x i8] c"handler\00", align 1
@.str.52 = private unnamed_addr constant [7 x i8] c"__smtp\00", align 1
@.str.53 = private unnamed_addr constant [8 x i8] c"__ws_fd\00", align 1
@.str.54 = private unnamed_addr constant [13 x i8] c"/dev/urandom\00", align 1
@uh_curl_init_once.inited = internal unnamed_addr global i1 false, align 4
@g_route_len = internal unnamed_addr global i64 0, align 8
@g_route_cap = internal unnamed_addr global i64 0, align 8
@g_routes = internal unnamed_addr global ptr null, align 8
@g_mutex_len = internal unnamed_addr global i64 0, align 8
@g_mutexes = internal unnamed_addr global ptr null, align 8
@.str.61 = private unnamed_addr constant [6 x i8] c"ws://\00", align 1
@.str.62 = private unnamed_addr constant [7 x i8] c"wss://\00", align 1
@.str.63 = private unnamed_addr constant [124 x i8] c"GET %s HTTP/1.1\0D\0AHost: %s:%d\0D\0AUpgrade: websocket\0D\0AConnection: Upgrade\0D\0ASec-WebSocket-Key: %s\0D\0ASec-WebSocket-Version: 13\0D\0A\0D\0A\00", align 1
@.str.64 = private unnamed_addr constant [6 x i8] c" 101 \00", align 1
@.str.65 = private unnamed_addr constant [22 x i8] c"Sec-WebSocket-Accept:\00", align 1
@uh_base64_encode.tbl = internal unnamed_addr constant [65 x i8] c"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\00", align 16
@.str.66 = private unnamed_addr constant [37 x i8] c"258EAFA5-E914-47DA-95CA-C5AB0DC85B11\00", align 1
@.str.67 = private unnamed_addr constant [5 x i8] c"%s%s\00", align 1
@.str.68 = private unnamed_addr constant [19 x i8] c"Sec-WebSocket-Key:\00", align 1
@.str.69 = private unnamed_addr constant [104 x i8] c"HTTP/1.1 101 Switching Protocols\0D\0AUpgrade: websocket\0D\0AConnection: Upgrade\0D\0ASec-WebSocket-Accept: %s\0D\0A\0D\0A\00", align 1
@.str.70 = private unnamed_addr constant [9 x i8] c"username\00", align 1
@.str.71 = private unnamed_addr constant [9 x i8] c"password\00", align 1
@.str.72 = private unnamed_addr constant [4 x i8] c"tls\00", align 1
@.str.73 = private unnamed_addr constant [9 x i8] c"starttls\00", align 1
@.str.74 = private unnamed_addr constant [9 x i8] c"insecure\00", align 1
@.str.75 = private unnamed_addr constant [5 x i8] c"from\00", align 1
@.str.76 = private unnamed_addr constant [8 x i8] c"subject\00", align 1
@.str.77 = private unnamed_addr constant [5 x i8] c"html\00", align 1
@.str.80 = private unnamed_addr constant [6 x i8] c"smtps\00", align 1
@.str.81 = private unnamed_addr constant [11 x i8] c"%s://%s:%d\00", align 1
@.str.82 = private unnamed_addr constant [7 x i8] c"From: \00", align 1
@.str.83 = private unnamed_addr constant [5 x i8] c"To: \00", align 1
@.str.84 = private unnamed_addr constant [3 x i8] c", \00", align 1
@.str.85 = private unnamed_addr constant [5 x i8] c"Cc: \00", align 1
@.str.86 = private unnamed_addr constant [10 x i8] c"Subject: \00", align 1
@.str.87 = private unnamed_addr constant [15 x i8] c"uh-boundary-42\00", align 1
@.str.88 = private unnamed_addr constant [20 x i8] c"MIME-Version: 1.0\0D\0A\00", align 1
@.str.89 = private unnamed_addr constant [48 x i8] c"Content-Type: multipart/alternative; boundary=\22\00", align 1
@.str.90 = private unnamed_addr constant [6 x i8] c"\22\0D\0A\0D\0A\00", align 1
@.str.91 = private unnamed_addr constant [3 x i8] c"--\00", align 1
@.str.92 = private unnamed_addr constant [46 x i8] c"\0D\0AContent-Type: text/plain; charset=utf-8\0D\0A\0D\0A\00", align 1
@.str.93 = private unnamed_addr constant [5 x i8] c"\0D\0A--\00", align 1
@.str.94 = private unnamed_addr constant [45 x i8] c"\0D\0AContent-Type: text/html; charset=utf-8\0D\0A\0D\0A\00", align 1
@.str.95 = private unnamed_addr constant [5 x i8] c"--\0D\0A\00", align 1
@.str.96 = private unnamed_addr constant [43 x i8] c"Content-Type: text/html; charset=utf-8\0D\0A\0D\0A\00", align 1
@uh_sha256_transform.k = internal unnamed_addr constant [64 x i32] [i32 1116352408, i32 1899447441, i32 -1245643825, i32 -373957723, i32 961987163, i32 1508970993, i32 -1841331548, i32 -1424204075, i32 -670586216, i32 310598401, i32 607225278, i32 1426881987, i32 1925078388, i32 -2132889090, i32 -1680079193, i32 -1046744716, i32 -459576895, i32 -272742522, i32 264347078, i32 604807628, i32 770255983, i32 1249150122, i32 1555081692, i32 1996064986, i32 -1740746414, i32 -1473132947, i32 -1341970488, i32 -1084653625, i32 -958395405, i32 -710438585, i32 113926993, i32 338241895, i32 666307205, i32 773529912, i32 1294757372, i32 1396182291, i32 1695183700, i32 1986661051, i32 -2117940946, i32 -1838011259, i32 -1564481375, i32 -1474664885, i32 -1035236496, i32 -949202525, i32 -778901479, i32 -694614492, i32 -200395387, i32 275423344, i32 430227734, i32 506948616, i32 659060556, i32 883997877, i32 958139571, i32 1322822218, i32 1537002063, i32 1747873779, i32 1955562222, i32 2024104815, i32 -2067236844, i32 -1933114872, i32 -1866530822, i32 -1538233109, i32 -1090935817, i32 -965641998], align 16
@uh_aes_sbox = internal unnamed_addr constant [256 x i8] c"c|w{\F2ko\C50\01g+\FE\D7\ABv\CA\82\C9}\FAYG\F0\AD\D4\A2\AF\9C\A4r\C0\B7\FD\93&6?\F7\CC4\A5\E5\F1q\D81\15\04\C7#\C3\18\96\05\9A\07\12\80\E2\EB'\B2u\09\83,\1A\1BnZ\A0R;\D6\B3)\E3/\84S\D1\00\ED \FC\B1[j\CB\BE9JLX\CF\D0\EF\AA\FBCM3\85E\F9\02\7FP<\9F\A8Q\A3@\8F\92\9D8\F5\BC\B6\DA!\10\FF\F3\D2\CD\0C\13\EC_\97D\17\C4\A7~=d]\19s`\81O\DC\22*\90\88F\EE\B8\14\DE^\0B\DB\E02:\0AI\06$\\\C2\D3\ACb\91\95\E4y\E7\C87m\8D\D5N\A9lV\F4\EAez\AE\08\BAx%.\1C\A6\B4\C6\E8\DDt\1FK\BD\8B\8Ap>\B5fH\03\F6\0Ea5W\B9\86\C1\1D\9E\E1\F8\98\11i\D9\8E\94\9B\1E\87\E9\CEU(\DF\8C\A1\89\0D\BF\E6BhA\99-\0F\B0T\BB\16", align 16
@uh_aes_rcon = internal unnamed_addr constant [11 x i8] c"\00\01\02\04\08\10 @\80\1B6", align 1
@.str.97 = private unnamed_addr constant [4 x i8] c"%2x\00", align 1
@uh_aes_rsbox = internal unnamed_addr constant [256 x i8] c"R\09j\D506\A58\BF@\A3\9E\81\F3\D7\FB|\E39\82\9B/\FF\874\8ECD\C4\DE\E9\CBT{\942\A6\C2#=\EEL\95\0BB\FA\C3N\08.\A1f(\D9$\B2v[\A2Im\8B\D1%r\F8\F6d\86h\98\16\D4\A4\\\CC]e\B6\92lpHP\FD\ED\B9\DA^\15FW\A7\8D\9D\84\90\D8\AB\00\8C\BC\D3\0A\F7\E4X\05\B8\B3E\06\D0,\1E\8F\CA?\0F\02\C1\AF\BD\03\01\13\8Ak:\91\11AOg\DC\EA\97\F2\CF\CE\F0\B4\E6s\96\ACt\22\E7\AD5\85\E2\F97\E8\1Cu\DFnG\F1\1Aq\1D)\C5\89o\B7b\0E\AA\18\BE\1B\FCV>K\C6\D2y \9A\DB\C0\FEx\CDZ\F4\1F\DD\A83\88\07\C71\B1\12\10Y'\80\EC_`Q\7F\A9\19\B5J\0D-\E5z\9F\93\C9\9C\EF\A0\E0;M\AE*\F5\B0\C8\EB\BB<\83S\99a\17+\04~\BAw\D6&\E1i\14cU!\0C}", align 16
@.str.98 = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.99 = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.str.101 = private unnamed_addr constant [3 x i8] c"\\\\\00", align 1
@.str.102 = private unnamed_addr constant [3 x i8] c"\\\22\00", align 1
@.str.103 = private unnamed_addr constant [3 x i8] c"\\n\00", align 1
@.str.104 = private unnamed_addr constant [3 x i8] c"\\r\00", align 1
@.str.105 = private unnamed_addr constant [3 x i8] c"\\t\00", align 1

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(argmem: write) uwtable
define dso_local void @uh_env_init(ptr noundef writeonly captures(none) initializes((0, 16)) %0, ptr noundef %1) local_unnamed_addr #0 {
  store ptr %1, ptr %0, align 8, !tbaa !5
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store ptr null, ptr %3, align 8, !tbaa !12
  ret void
}

; Function Attrs: nofree norecurse nounwind sspstrong memory(readwrite, inaccessiblemem: none) uwtable
define dso_local void @uh_env_get(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly captures(address_is_null) %1, ptr noundef readonly captures(none) %2) local_unnamed_addr #1 {
  %4 = icmp eq ptr %1, null
  br i1 %4, label %24, label %5

5:                                                ; preds = %3, %19
  %6 = phi ptr [ %20, %19 ], [ %1, %3 ]
  %7 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %8 = load ptr, ptr %7, align 8, !tbaa !13
  %9 = icmp eq ptr %8, null
  br i1 %9, label %19, label %10

10:                                               ; preds = %5, %15
  %11 = phi ptr [ %17, %15 ], [ %8, %5 ]
  %12 = load ptr, ptr %11, align 8, !tbaa !14
  %13 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %12, ptr noundef nonnull readonly dereferenceable(1) %2) #33
  %14 = icmp eq i32 %13, 0
  br i1 %14, label %22, label %15

15:                                               ; preds = %10
  %16 = getelementptr inbounds nuw i8, ptr %11, i64 48
  %17 = load ptr, ptr %16, align 8, !tbaa !13
  %18 = icmp eq ptr %17, null
  br i1 %18, label %19, label %10, !llvm.loop !22

19:                                               ; preds = %15, %5
  %20 = load ptr, ptr %6, align 8, !tbaa !5
  %21 = icmp eq ptr %20, null
  br i1 %21, label %24, label %5, !llvm.loop !24

22:                                               ; preds = %10
  %23 = getelementptr inbounds nuw i8, ptr %11, i64 8
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %23, i64 40, i1 false), !tbaa.struct !25
  br label %26

24:                                               ; preds = %19, %3
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !32
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %25, i8 0, i64 32, i1 false)
  br label %26

26:                                               ; preds = %22, %24
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #2

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(argmem: write) uwtable
define dso_local void @uh_num(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, double noundef %1) local_unnamed_addr #0 {
  store i32 0, ptr %0, align 8, !tbaa !31
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %1, ptr %3, align 8, !tbaa !35
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %4, i8 0, i64 24, i1 false)
  ret void
}

; Function Attrs: nofree nounwind sspstrong uwtable
define dso_local void @uh_env_set(ptr noundef captures(none) %0, ptr noundef readonly captures(address_is_null) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #4 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %5 = load ptr, ptr %4, align 8, !tbaa !13
  %6 = icmp eq ptr %5, null
  br i1 %6, label %20, label %7

7:                                                ; preds = %3, %12
  %8 = phi ptr [ %14, %12 ], [ %5, %3 ]
  %9 = load ptr, ptr %8, align 8, !tbaa !14
  %10 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull readonly dereferenceable(1) %1) #33
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %18, label %12

12:                                               ; preds = %7
  %13 = getelementptr inbounds nuw i8, ptr %8, i64 48
  %14 = load ptr, ptr %13, align 8, !tbaa !13
  %15 = icmp eq ptr %14, null
  br i1 %15, label %16, label %7, !llvm.loop !22

16:                                               ; preds = %12
  %17 = tail call noalias dereferenceable_or_null(56) ptr @malloc(i64 noundef 56) #34
  br label %23

18:                                               ; preds = %7
  %19 = getelementptr inbounds nuw i8, ptr %8, i64 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %19, ptr noundef nonnull align 8 dereferenceable(40) %2, i64 40, i1 false), !tbaa.struct !25
  br label %35

20:                                               ; preds = %3
  %21 = tail call noalias dereferenceable_or_null(56) ptr @malloc(i64 noundef 56) #34
  %22 = icmp eq ptr %1, null
  br i1 %22, label %30, label %23

23:                                               ; preds = %16, %20
  %24 = phi ptr [ %17, %16 ], [ %21, %20 ]
  %25 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %1) #33
  %26 = add i64 %25, 1
  %27 = tail call noalias ptr @malloc(i64 noundef %26) #34
  %28 = icmp eq ptr %27, null
  br i1 %28, label %30, label %29

29:                                               ; preds = %23
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %27, ptr nonnull readonly align 1 %1, i64 %26, i1 false)
  br label %30

30:                                               ; preds = %20, %23, %29
  %31 = phi ptr [ %21, %20 ], [ %24, %29 ], [ %24, %23 ]
  %32 = phi ptr [ null, %20 ], [ %27, %29 ], [ null, %23 ]
  store ptr %32, ptr %31, align 8, !tbaa !14
  %33 = getelementptr inbounds nuw i8, ptr %31, i64 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %33, ptr noundef nonnull align 8 dereferenceable(40) %2, i64 40, i1 false), !tbaa.struct !25
  %34 = getelementptr inbounds nuw i8, ptr %31, i64 48
  store ptr %5, ptr %34, align 8, !tbaa !36
  store ptr %31, ptr %4, align 8, !tbaa !12
  br label %35

35:                                               ; preds = %30, %18
  ret void
}

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #5

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(argmem: write) uwtable
define dso_local void @uh_stack_init(ptr noundef writeonly captures(none) initializes((0, 24)) %0) local_unnamed_addr #0 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %0, i8 0, i64 24, i1 false)
  ret void
}

; Function Attrs: mustprogress nounwind sspstrong willreturn uwtable
define dso_local void @uh_stack_push(ptr noundef captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #6 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load i64, ptr %3, align 8, !tbaa !37
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %6 = load i64, ptr %5, align 8, !tbaa !41
  %7 = icmp eq i64 %4, %6
  %8 = load ptr, ptr %0, align 8, !tbaa !42
  br i1 %7, label %9, label %16

9:                                                ; preds = %2
  %10 = icmp eq i64 %4, 0
  %11 = shl i64 %4, 1
  %12 = select i1 %10, i64 16, i64 %11
  %13 = mul i64 %12, 40
  %14 = tail call ptr @realloc(ptr noundef %8, i64 noundef %13) #35
  store ptr %14, ptr %0, align 8, !tbaa !42
  store i64 %12, ptr %5, align 8, !tbaa !41
  %15 = load i64, ptr %3, align 8, !tbaa !37
  br label %16

16:                                               ; preds = %9, %2
  %17 = phi i64 [ %15, %9 ], [ %4, %2 ]
  %18 = phi ptr [ %14, %9 ], [ %8, %2 ]
  %19 = add i64 %17, 1
  store i64 %19, ptr %3, align 8, !tbaa !37
  %20 = getelementptr inbounds nuw %struct.UhValue, ptr %18, i64 %17
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %20, ptr noundef nonnull align 8 dereferenceable(40) %1, i64 40, i1 false), !tbaa.struct !25
  ret void
}

; Function Attrs: mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias noundef ptr @realloc(ptr allocptr noundef captures(none), i64 noundef) local_unnamed_addr #7

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(readwrite, inaccessiblemem: none) uwtable
define dso_local void @uh_stack_pop(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef captures(none) %1) local_unnamed_addr #8 {
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %4 = load i64, ptr %3, align 8, !tbaa !37
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %2
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !43
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %7, i8 0, i64 32, i1 false)
  br label %12

8:                                                ; preds = %2
  %9 = load ptr, ptr %1, align 8, !tbaa !42
  %10 = add i64 %4, -1
  store i64 %10, ptr %3, align 8, !tbaa !37
  %11 = getelementptr inbounds nuw %struct.UhValue, ptr %9, i64 %10
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %11, i64 40, i1 false), !tbaa.struct !25
  br label %12

12:                                               ; preds = %8, %6
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(argmem: write) uwtable
define dso_local void @uh_stack_clear(ptr noundef writeonly captures(none) initializes((8, 16)) %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i64 0, ptr %2, align 8, !tbaa !37
  ret void
}

; Function Attrs: mustprogress nofree nounwind sspstrong willreturn uwtable
define dso_local void @uh_str(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly captures(address_is_null) %1) local_unnamed_addr #9 {
  store i32 1, ptr %0, align 8, !tbaa !31
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %3, align 8, !tbaa !35
  %4 = icmp eq ptr %1, null
  br i1 %4, label %11, label %5

5:                                                ; preds = %2
  %6 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %1) #33
  %7 = add i64 %6, 1
  %8 = tail call noalias ptr @malloc(i64 noundef %7) #34
  %9 = icmp eq ptr %8, null
  br i1 %9, label %11, label %10

10:                                               ; preds = %5
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %8, ptr nonnull readonly align 1 %1, i64 %7, i1 false)
  br label %11

11:                                               ; preds = %2, %5, %10
  %12 = phi ptr [ null, %2 ], [ %8, %10 ], [ null, %5 ]
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %12, ptr %13, align 8, !tbaa !46
  %14 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %14, i8 0, i64 16, i1 false)
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(argmem: write) uwtable
define dso_local void @uh_null(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0) local_unnamed_addr #0 {
  store i32 4, ptr %0, align 8, !tbaa !31
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %2, i8 0, i64 32, i1 false)
  ret void
}

; Function Attrs: mustprogress nofree nounwind sspstrong willreturn memory(argmem: write, inaccessiblemem: readwrite) uwtable
define dso_local void @uh_arr_new(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0) local_unnamed_addr #10 {
  store i32 2, ptr %0, align 8, !tbaa !31
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %2, i8 0, i64 16, i1 false)
  store ptr %3, ptr %4, align 8, !tbaa !47
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %5, align 8, !tbaa !48
  ret void
}

; Function Attrs: mustprogress nounwind sspstrong willreturn uwtable
define dso_local void @uh_arr_push(ptr noundef readonly captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #6 {
  %3 = icmp eq ptr %0, null
  br i1 %3, label %30, label %4

4:                                                ; preds = %2
  %5 = load i32, ptr %0, align 8, !tbaa !31
  %6 = icmp eq i32 %5, 2
  br i1 %6, label %7, label %30

7:                                                ; preds = %4
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %9 = load ptr, ptr %8, align 8, !tbaa !47
  %10 = icmp eq ptr %9, null
  br i1 %10, label %30, label %11

11:                                               ; preds = %7
  %12 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !49
  %14 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %15 = load i64, ptr %14, align 8, !tbaa !51
  %16 = icmp eq i64 %13, %15
  %17 = load ptr, ptr %9, align 8, !tbaa !52
  br i1 %16, label %18, label %25

18:                                               ; preds = %11
  %19 = icmp eq i64 %13, 0
  %20 = shl i64 %13, 1
  %21 = select i1 %19, i64 8, i64 %20
  %22 = mul i64 %21, 40
  %23 = tail call ptr @realloc(ptr noundef %17, i64 noundef %22) #35
  store ptr %23, ptr %9, align 8, !tbaa !52
  store i64 %21, ptr %14, align 8, !tbaa !51
  %24 = load i64, ptr %12, align 8, !tbaa !49
  br label %25

25:                                               ; preds = %18, %11
  %26 = phi i64 [ %24, %18 ], [ %13, %11 ]
  %27 = phi ptr [ %23, %18 ], [ %17, %11 ]
  %28 = add i64 %26, 1
  store i64 %28, ptr %12, align 8, !tbaa !49
  %29 = getelementptr inbounds nuw %struct.UhValue, ptr %27, i64 %26
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %29, ptr noundef nonnull align 8 dereferenceable(40) %1, i64 40, i1 false), !tbaa.struct !25
  br label %30

30:                                               ; preds = %2, %4, %7, %25
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(readwrite, inaccessiblemem: none) uwtable
define dso_local void @uh_arr_get(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, i64 noundef %2) local_unnamed_addr #8 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 2
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %7 = load ptr, ptr %6, align 8
  %8 = icmp eq ptr %7, null
  %9 = select i1 %5, i1 true, i1 %8
  br i1 %9, label %10, label %12

10:                                               ; preds = %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !53
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %11, i8 0, i64 32, i1 false), !alias.scope !53
  br label %27

12:                                               ; preds = %3
  %13 = icmp slt i64 %2, 0
  %14 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %15 = load i64, ptr %14, align 8, !tbaa !49
  br i1 %13, label %16, label %19

16:                                               ; preds = %12
  %17 = add nsw i64 %15, %2
  %18 = icmp slt i64 %17, 0
  br i1 %18, label %22, label %19

19:                                               ; preds = %12, %16
  %20 = phi i64 [ %17, %16 ], [ %2, %12 ]
  %21 = icmp ult i64 %20, %15
  br i1 %21, label %24, label %22

22:                                               ; preds = %19, %16
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !56
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %23, i8 0, i64 32, i1 false), !alias.scope !56
  br label %27

24:                                               ; preds = %19
  %25 = load ptr, ptr %7, align 8, !tbaa !52
  %26 = getelementptr inbounds nuw %struct.UhValue, ptr %25, i64 %20
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %26, i64 40, i1 false), !tbaa.struct !25
  br label %27

27:                                               ; preds = %24, %22, %10
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(read, inaccessiblemem: none) uwtable
define dso_local i64 @uh_arr_len(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0) local_unnamed_addr #11 {
  %2 = load i32, ptr %0, align 8, !tbaa !31
  %3 = icmp ne i32 %2, 2
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %5 = load ptr, ptr %4, align 8
  %6 = icmp eq ptr %5, null
  %7 = select i1 %3, i1 true, i1 %6
  br i1 %7, label %11, label %8

8:                                                ; preds = %1
  %9 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %10 = load i64, ptr %9, align 8, !tbaa !49
  br label %11

11:                                               ; preds = %1, %8
  %12 = phi i64 [ %10, %8 ], [ 0, %1 ]
  ret i64 %12
}

; Function Attrs: mustprogress nofree nounwind sspstrong willreturn memory(argmem: write, inaccessiblemem: readwrite) uwtable
define dso_local void @uh_dict_new(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0) local_unnamed_addr #10 {
  store i32 3, ptr %0, align 8, !tbaa !31
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 32
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false)
  store ptr %3, ptr %4, align 8, !tbaa !48
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_dict_get(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 3
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %7 = load ptr, ptr %6, align 8
  %8 = icmp eq ptr %7, null
  %9 = select i1 %5, i1 true, i1 %8
  br i1 %9, label %10, label %12

10:                                               ; preds = %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !59
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %11, i8 0, i64 32, i1 false), !alias.scope !59
  br label %45

12:                                               ; preds = %3
  %13 = load i32, ptr %2, align 8
  %14 = icmp eq i32 %13, 1
  br i1 %14, label %15, label %24

15:                                               ; preds = %12
  %16 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %17 = load ptr, ptr %16, align 8
  %18 = icmp eq ptr %17, null
  %19 = select i1 %18, ptr @.str, ptr %17
  %20 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %19) #33
  %21 = add i64 %20, 1
  %22 = tail call noalias ptr @malloc(i64 noundef %21) #34
  %23 = icmp eq ptr %22, null
  br i1 %23, label %24, label %26

24:                                               ; preds = %12, %15
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !62
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %25, i8 0, i64 32, i1 false), !alias.scope !62
  br label %45

26:                                               ; preds = %15
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %22, ptr nonnull readonly align 1 %19, i64 %21, i1 false)
  %27 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %28 = load i64, ptr %27, align 8, !tbaa !65
  %29 = icmp eq i64 %28, 0
  br i1 %29, label %41, label %30

30:                                               ; preds = %26
  %31 = load ptr, ptr %7, align 8, !tbaa !68
  br label %35

32:                                               ; preds = %35
  %33 = add nuw i64 %36, 1
  %34 = icmp eq i64 %33, %28
  br i1 %34, label %41, label %35, !llvm.loop !69

35:                                               ; preds = %32, %30
  %36 = phi i64 [ 0, %30 ], [ %33, %32 ]
  %37 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %31, i64 %36
  %38 = load ptr, ptr %37, align 8, !tbaa !70
  %39 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %38, ptr noundef nonnull readonly dereferenceable(1) %22) #33
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %43, label %32

41:                                               ; preds = %32, %26
  tail call void @free(ptr noundef nonnull %22) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !72
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %42, i8 0, i64 32, i1 false), !alias.scope !72
  br label %45

43:                                               ; preds = %35
  tail call void @free(ptr noundef nonnull %22) #36
  %44 = getelementptr inbounds nuw i8, ptr %37, i64 8
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %44, i64 40, i1 false), !tbaa.struct !25
  br label %45

45:                                               ; preds = %24, %43, %41, %10
  ret void
}

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #13

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_dict_set(ptr noundef readonly captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = icmp eq ptr %0, null
  br i1 %4, label %57, label %5

5:                                                ; preds = %3
  %6 = load i32, ptr %0, align 8, !tbaa !31
  %7 = icmp eq i32 %6, 3
  br i1 %7, label %8, label %57

8:                                                ; preds = %5
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %10 = load ptr, ptr %9, align 8, !tbaa !48
  %11 = icmp ne ptr %10, null
  %12 = load i32, ptr %1, align 8
  %13 = icmp eq i32 %12, 1
  %14 = select i1 %11, i1 %13, i1 false
  br i1 %14, label %15, label %57

15:                                               ; preds = %8
  %16 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %17 = load ptr, ptr %16, align 8
  %18 = icmp eq ptr %17, null
  %19 = select i1 %18, ptr @.str, ptr %17
  %20 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %19) #33
  %21 = add i64 %20, 1
  %22 = tail call noalias ptr @malloc(i64 noundef %21) #34
  %23 = icmp eq ptr %22, null
  br i1 %23, label %57, label %24

24:                                               ; preds = %15
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %22, ptr nonnull readonly align 1 %19, i64 %21, i1 false)
  %25 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %26 = load i64, ptr %25, align 8, !tbaa !65
  %27 = icmp eq i64 %26, 0
  %28 = load ptr, ptr %10, align 8, !tbaa !68
  br i1 %27, label %40, label %32

29:                                               ; preds = %32
  %30 = add nuw i64 %33, 1
  %31 = icmp eq i64 %30, %26
  br i1 %31, label %40, label %32, !llvm.loop !69

32:                                               ; preds = %24, %29
  %33 = phi i64 [ %30, %29 ], [ 0, %24 ]
  %34 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %28, i64 %33
  %35 = load ptr, ptr %34, align 8, !tbaa !70
  %36 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %35, ptr noundef nonnull readonly dereferenceable(1) %22) #33
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %38, label %29

38:                                               ; preds = %32
  %39 = getelementptr inbounds nuw i8, ptr %34, i64 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %39, ptr noundef nonnull align 8 dereferenceable(40) %2, i64 40, i1 false), !tbaa.struct !25
  tail call void @free(ptr noundef nonnull %22) #36
  br label %57

40:                                               ; preds = %29, %24
  %41 = getelementptr inbounds nuw i8, ptr %10, i64 16
  %42 = load i64, ptr %41, align 8, !tbaa !75
  %43 = icmp eq i64 %26, %42
  br i1 %43, label %44, label %50

44:                                               ; preds = %40
  %45 = shl i64 %26, 1
  %46 = select i1 %27, i64 8, i64 %45
  %47 = mul i64 %46, 48
  %48 = tail call ptr @realloc(ptr noundef %28, i64 noundef %47) #35
  store ptr %48, ptr %10, align 8, !tbaa !68
  store i64 %46, ptr %41, align 8, !tbaa !75
  %49 = load i64, ptr %25, align 8, !tbaa !65
  br label %50

50:                                               ; preds = %44, %40
  %51 = phi i64 [ %49, %44 ], [ %26, %40 ]
  %52 = phi ptr [ %48, %44 ], [ %28, %40 ]
  %53 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %52, i64 %51
  store ptr %22, ptr %53, align 8, !tbaa !70
  %54 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %52, i64 %51, i32 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %54, ptr noundef nonnull align 8 dereferenceable(40) %2, i64 40, i1 false), !tbaa.struct !25
  %55 = load i64, ptr %25, align 8, !tbaa !65
  %56 = add i64 %55, 1
  store i64 %56, ptr %25, align 8, !tbaa !65
  br label %57

57:                                               ; preds = %15, %50, %38, %3, %5, %8
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind sspstrong memory(read, argmem: readwrite, inaccessiblemem: none) uwtable
define dso_local void @uh_len(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #14 {
  %3 = load i32, ptr %1, align 8, !tbaa !31
  %4 = icmp eq i32 %3, 1
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %6 = load ptr, ptr %5, align 8
  %7 = icmp ne ptr %6, null
  %8 = select i1 %4, i1 %7, i1 false
  br i1 %8, label %9, label %41

9:                                                ; preds = %2
  %10 = load i8, ptr %6, align 1, !tbaa !76
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %37, label %12

12:                                               ; preds = %9, %28
  %13 = phi i8 [ %33, %28 ], [ %10, %9 ]
  %14 = phi i64 [ %30, %28 ], [ 0, %9 ]
  %15 = phi i64 [ %31, %28 ], [ 0, %9 ]
  %16 = zext i8 %13 to i32
  %17 = icmp sgt i8 %13, -1
  br i1 %17, label %28, label %18

18:                                               ; preds = %12
  %19 = and i32 %16, 224
  %20 = icmp eq i32 %19, 192
  br i1 %20, label %28, label %21

21:                                               ; preds = %18
  %22 = and i32 %16, 240
  %23 = icmp eq i32 %22, 224
  br i1 %23, label %28, label %24

24:                                               ; preds = %21
  %25 = and i32 %16, 248
  %26 = icmp eq i32 %25, 240
  %27 = select i1 %26, i64 4, i64 1
  br label %28

28:                                               ; preds = %24, %21, %18, %12
  %29 = phi i64 [ 1, %12 ], [ 2, %18 ], [ 3, %21 ], [ %27, %24 ]
  %30 = add i64 %29, %14
  %31 = add i64 %15, 1
  %32 = getelementptr inbounds nuw i8, ptr %6, i64 %30
  %33 = load i8, ptr %32, align 1, !tbaa !76
  %34 = icmp eq i8 %33, 0
  br i1 %34, label %35, label %12, !llvm.loop !77

35:                                               ; preds = %28
  %36 = uitofp i64 %31 to double
  br label %37

37:                                               ; preds = %35, %9
  %38 = phi double [ 0.000000e+00, %9 ], [ %36, %35 ]
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !78
  %39 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %38, ptr %39, align 8, !tbaa !35, !alias.scope !78
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %40, i8 0, i64 24, i1 false), !alias.scope !78
  br label %67

41:                                               ; preds = %2
  %42 = icmp eq i32 %3, 2
  %43 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %44 = load ptr, ptr %43, align 8
  %45 = icmp ne ptr %44, null
  %46 = select i1 %42, i1 %45, i1 false
  br i1 %46, label %47, label %53

47:                                               ; preds = %41
  %48 = getelementptr inbounds nuw i8, ptr %44, i64 8
  %49 = load i64, ptr %48, align 8, !tbaa !49
  %50 = uitofp i64 %49 to double
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !81
  %51 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %50, ptr %51, align 8, !tbaa !35, !alias.scope !81
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %52, i8 0, i64 24, i1 false), !alias.scope !81
  br label %67

53:                                               ; preds = %41
  %54 = icmp eq i32 %3, 3
  %55 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %56 = load ptr, ptr %55, align 8
  %57 = icmp ne ptr %56, null
  %58 = select i1 %54, i1 %57, i1 false
  br i1 %58, label %59, label %65

59:                                               ; preds = %53
  %60 = getelementptr inbounds nuw i8, ptr %56, i64 8
  %61 = load i64, ptr %60, align 8, !tbaa !65
  %62 = uitofp i64 %61 to double
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !84
  %63 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %62, ptr %63, align 8, !tbaa !35, !alias.scope !84
  %64 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %64, i8 0, i64 24, i1 false), !alias.scope !84
  br label %67

65:                                               ; preds = %53
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !87
  %66 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %66, i8 0, i64 32, i1 false)
  br label %67

67:                                               ; preds = %65, %59, %47, %37
  ret void
}

; Function Attrs: mustprogress nounwind sspstrong willreturn uwtable
define dso_local void @uh_append(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #6 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 2
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %7 = load ptr, ptr %6, align 8
  %8 = icmp eq ptr %7, null
  %9 = select i1 %5, i1 true, i1 %8
  br i1 %9, label %29, label %10

10:                                               ; preds = %3
  %11 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %12 = load i64, ptr %11, align 8, !tbaa !49
  %13 = getelementptr inbounds nuw i8, ptr %7, i64 16
  %14 = load i64, ptr %13, align 8, !tbaa !51
  %15 = icmp eq i64 %12, %14
  %16 = load ptr, ptr %7, align 8, !tbaa !52
  br i1 %15, label %17, label %24

17:                                               ; preds = %10
  %18 = icmp eq i64 %12, 0
  %19 = shl i64 %12, 1
  %20 = select i1 %18, i64 8, i64 %19
  %21 = mul i64 %20, 40
  %22 = tail call ptr @realloc(ptr noundef %16, i64 noundef %21) #35
  store ptr %22, ptr %7, align 8, !tbaa !52
  store i64 %20, ptr %13, align 8, !tbaa !51
  %23 = load i64, ptr %11, align 8, !tbaa !49
  br label %24

24:                                               ; preds = %10, %17
  %25 = phi i64 [ %23, %17 ], [ %12, %10 ]
  %26 = phi ptr [ %22, %17 ], [ %16, %10 ]
  %27 = add i64 %25, 1
  store i64 %27, ptr %11, align 8, !tbaa !49
  %28 = getelementptr inbounds nuw %struct.UhValue, ptr %26, i64 %25
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %28, ptr noundef nonnull align 8 dereferenceable(40) %2, i64 40, i1 false)
  br label %29

29:                                               ; preds = %3, %24
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %1, i64 40, i1 false)
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_split(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca [2 x i8], align 1
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !90
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %6 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %5, i8 0, i64 16, i1 false), !alias.scope !90
  store ptr %6, ptr %7, align 8, !tbaa !47, !alias.scope !90
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %8, align 8, !tbaa !48, !alias.scope !90
  %9 = icmp eq ptr %6, null
  %10 = load i32, ptr %1, align 8, !tbaa !31
  %11 = icmp ne i32 %10, 1
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %13 = load ptr, ptr %12, align 8
  %14 = icmp eq ptr %13, null
  %15 = select i1 %11, i1 true, i1 %14
  %16 = or i1 %9, %15
  br i1 %16, label %141, label %17

17:                                               ; preds = %3
  %18 = load i32, ptr %2, align 8, !tbaa !31
  %19 = icmp eq i32 %18, 1
  %20 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %21 = load ptr, ptr %20, align 8
  %22 = icmp ne ptr %21, null
  %23 = select i1 %19, i1 %22, i1 false
  %24 = select i1 %23, ptr %21, ptr @.str
  %25 = load i8, ptr %24, align 1, !tbaa !76
  %26 = icmp eq i8 %25, 0
  br i1 %26, label %27, label %65

27:                                               ; preds = %17
  %28 = load i8, ptr %13, align 1, !tbaa !76
  %29 = icmp eq i8 %28, 0
  br i1 %29, label %141, label %30

30:                                               ; preds = %27
  %31 = getelementptr inbounds nuw i8, ptr %4, i64 1
  %32 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %33 = getelementptr inbounds nuw i8, ptr %6, i64 16
  br label %34

34:                                               ; preds = %30, %54
  %35 = phi i8 [ %28, %30 ], [ %63, %54 ]
  %36 = phi ptr [ %13, %30 ], [ %62, %54 ]
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %4) #36
  store i8 %35, ptr %4, align 1, !tbaa !76
  store i8 0, ptr %31, align 1, !tbaa !76
  %37 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %4) #33, !noalias !93
  %38 = add i64 %37, 1
  %39 = tail call noalias ptr @malloc(i64 noundef %38) #34
  %40 = icmp eq ptr %39, null
  br i1 %40, label %42, label %41

41:                                               ; preds = %34
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %39, ptr nonnull readonly align 1 %4, i64 %38, i1 false), !noalias !93
  br label %42

42:                                               ; preds = %41, %34
  %43 = load i64, ptr %32, align 8, !tbaa !49
  %44 = load i64, ptr %33, align 8, !tbaa !51
  %45 = icmp eq i64 %43, %44
  %46 = load ptr, ptr %6, align 8, !tbaa !52
  br i1 %45, label %47, label %54

47:                                               ; preds = %42
  %48 = icmp eq i64 %43, 0
  %49 = shl i64 %43, 1
  %50 = select i1 %48, i64 8, i64 %49
  %51 = mul i64 %50, 40
  %52 = tail call ptr @realloc(ptr noundef %46, i64 noundef %51) #35
  store ptr %52, ptr %6, align 8, !tbaa !52
  store i64 %50, ptr %33, align 8, !tbaa !51
  %53 = load i64, ptr %32, align 8, !tbaa !49
  br label %54

54:                                               ; preds = %42, %47
  %55 = phi i64 [ %53, %47 ], [ %43, %42 ]
  %56 = phi ptr [ %52, %47 ], [ %46, %42 ]
  %57 = add i64 %55, 1
  store i64 %57, ptr %32, align 8, !tbaa !49
  %58 = getelementptr inbounds nuw %struct.UhValue, ptr %56, i64 %55
  store i32 1, ptr %58, align 8, !tbaa !26
  %59 = getelementptr inbounds nuw i8, ptr %58, i64 8
  store double 0.000000e+00, ptr %59, align 8, !tbaa !27
  %60 = getelementptr inbounds nuw i8, ptr %58, i64 16
  store ptr %39, ptr %60, align 8, !tbaa !28
  %61 = getelementptr inbounds nuw i8, ptr %58, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %61, i8 0, i64 16, i1 false)
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %4) #36
  %62 = getelementptr inbounds nuw i8, ptr %36, i64 1
  %63 = load i8, ptr %62, align 1, !tbaa !76
  %64 = icmp eq i8 %63, 0
  br i1 %64, label %141, label %34, !llvm.loop !96

65:                                               ; preds = %17
  %66 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %24) #33
  %67 = tail call ptr @strstr(ptr noundef nonnull dereferenceable(1) %13, ptr noundef nonnull dereferenceable(1) %24) #33
  %68 = icmp eq ptr %67, null
  br i1 %68, label %112, label %69

69:                                               ; preds = %65
  %70 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %71 = getelementptr inbounds nuw i8, ptr %6, i64 16
  br label %72

72:                                               ; preds = %69, %108
  %73 = phi ptr [ %67, %69 ], [ %110, %108 ]
  %74 = phi ptr [ %13, %69 ], [ %109, %108 ]
  %75 = ptrtoint ptr %73 to i64
  %76 = ptrtoint ptr %74 to i64
  %77 = sub i64 %75, %76
  %78 = add i64 %77, 1
  %79 = tail call noalias ptr @malloc(i64 noundef %78) #34
  %80 = icmp eq ptr %79, null
  br i1 %80, label %108, label %81

81:                                               ; preds = %72
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %79, ptr nonnull align 1 %74, i64 %77, i1 false)
  %82 = getelementptr inbounds nuw i8, ptr %79, i64 %77
  store i8 0, ptr %82, align 1, !tbaa !76
  %83 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %79) #33, !noalias !97
  %84 = add i64 %83, 1
  %85 = tail call noalias ptr @malloc(i64 noundef %84) #34
  %86 = icmp eq ptr %85, null
  br i1 %86, label %88, label %87

87:                                               ; preds = %81
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %85, ptr nonnull readonly align 1 %79, i64 %84, i1 false), !noalias !97
  br label %88

88:                                               ; preds = %87, %81
  %89 = load i64, ptr %70, align 8, !tbaa !49
  %90 = load i64, ptr %71, align 8, !tbaa !51
  %91 = icmp eq i64 %89, %90
  %92 = load ptr, ptr %6, align 8, !tbaa !52
  br i1 %91, label %93, label %100

93:                                               ; preds = %88
  %94 = icmp eq i64 %89, 0
  %95 = shl i64 %89, 1
  %96 = select i1 %94, i64 8, i64 %95
  %97 = mul i64 %96, 40
  %98 = tail call ptr @realloc(ptr noundef %92, i64 noundef %97) #35
  store ptr %98, ptr %6, align 8, !tbaa !52
  store i64 %96, ptr %71, align 8, !tbaa !51
  %99 = load i64, ptr %70, align 8, !tbaa !49
  br label %100

100:                                              ; preds = %88, %93
  %101 = phi i64 [ %99, %93 ], [ %89, %88 ]
  %102 = phi ptr [ %98, %93 ], [ %92, %88 ]
  %103 = add i64 %101, 1
  store i64 %103, ptr %70, align 8, !tbaa !49
  %104 = getelementptr inbounds nuw %struct.UhValue, ptr %102, i64 %101
  store i32 1, ptr %104, align 8, !tbaa !26
  %105 = getelementptr inbounds nuw i8, ptr %104, i64 8
  store double 0.000000e+00, ptr %105, align 8, !tbaa !27
  %106 = getelementptr inbounds nuw i8, ptr %104, i64 16
  store ptr %85, ptr %106, align 8, !tbaa !28
  %107 = getelementptr inbounds nuw i8, ptr %104, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %107, i8 0, i64 16, i1 false)
  tail call void @free(ptr noundef nonnull %79) #36
  br label %108

108:                                              ; preds = %100, %72
  %109 = getelementptr inbounds nuw i8, ptr %73, i64 %66
  %110 = tail call ptr @strstr(ptr noundef nonnull dereferenceable(1) %109, ptr noundef nonnull dereferenceable(1) %24) #33
  %111 = icmp eq ptr %110, null
  br i1 %111, label %112, label %72, !llvm.loop !100

112:                                              ; preds = %108, %65
  %113 = phi ptr [ %13, %65 ], [ %109, %108 ]
  %114 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %113) #33, !noalias !101
  %115 = add i64 %114, 1
  %116 = tail call noalias ptr @malloc(i64 noundef %115) #34
  %117 = icmp eq ptr %116, null
  br i1 %117, label %119, label %118

118:                                              ; preds = %112
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %116, ptr nonnull readonly align 1 %113, i64 %115, i1 false), !noalias !101
  br label %119

119:                                              ; preds = %118, %112
  %120 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %121 = load i64, ptr %120, align 8, !tbaa !49
  %122 = getelementptr inbounds nuw i8, ptr %6, i64 16
  %123 = load i64, ptr %122, align 8, !tbaa !51
  %124 = icmp eq i64 %121, %123
  %125 = load ptr, ptr %6, align 8, !tbaa !52
  br i1 %124, label %126, label %133

126:                                              ; preds = %119
  %127 = icmp eq i64 %121, 0
  %128 = shl i64 %121, 1
  %129 = select i1 %127, i64 8, i64 %128
  %130 = mul i64 %129, 40
  %131 = tail call ptr @realloc(ptr noundef %125, i64 noundef %130) #35
  store ptr %131, ptr %6, align 8, !tbaa !52
  store i64 %129, ptr %122, align 8, !tbaa !51
  %132 = load i64, ptr %120, align 8, !tbaa !49
  br label %133

133:                                              ; preds = %119, %126
  %134 = phi i64 [ %132, %126 ], [ %121, %119 ]
  %135 = phi ptr [ %131, %126 ], [ %125, %119 ]
  %136 = add i64 %134, 1
  store i64 %136, ptr %120, align 8, !tbaa !49
  %137 = getelementptr inbounds nuw %struct.UhValue, ptr %135, i64 %134
  store i32 1, ptr %137, align 8, !tbaa !26
  %138 = getelementptr inbounds nuw i8, ptr %137, i64 8
  store double 0.000000e+00, ptr %138, align 8, !tbaa !27
  %139 = getelementptr inbounds nuw i8, ptr %137, i64 16
  store ptr %116, ptr %139, align 8, !tbaa !28
  %140 = getelementptr inbounds nuw i8, ptr %137, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %140, i8 0, i64 16, i1 false)
  br label %141

141:                                              ; preds = %54, %27, %133, %3
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr noundef captures(none)) local_unnamed_addr #15

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @strstr(ptr noundef, ptr noundef captures(none)) local_unnamed_addr #15

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_join(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 2
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %7 = load ptr, ptr %6, align 8
  %8 = icmp eq ptr %7, null
  %9 = select i1 %5, i1 true, i1 %8
  br i1 %9, label %10, label %18

10:                                               ; preds = %3
  tail call void @llvm.experimental.noalias.scope.decl(metadata !104)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !104
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %11, align 8, !tbaa !35, !alias.scope !104
  %12 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %13 = icmp eq ptr %12, null
  br i1 %13, label %15, label %14

14:                                               ; preds = %10
  store i8 0, ptr %12, align 1, !noalias !104
  br label %15

15:                                               ; preds = %10, %14
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %12, ptr %16, align 8, !tbaa !46, !alias.scope !104
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %17, i8 0, i64 16, i1 false), !alias.scope !104
  br label %108

18:                                               ; preds = %3
  %19 = load i32, ptr %2, align 8, !tbaa !31
  %20 = icmp eq i32 %19, 1
  %21 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %22 = load ptr, ptr %21, align 8
  %23 = icmp ne ptr %22, null
  %24 = select i1 %20, i1 %23, i1 false
  %25 = select i1 %24, ptr %22, ptr @.str
  %26 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %27 = load i64, ptr %26, align 8, !tbaa !49
  %28 = icmp eq i64 %27, 0
  br i1 %28, label %96, label %31

29:                                               ; preds = %89
  %30 = icmp eq ptr %92, null
  br i1 %30, label %96, label %104

31:                                               ; preds = %18, %89
  %32 = phi ptr [ %91, %89 ], [ %7, %18 ]
  %33 = phi i64 [ %61, %89 ], [ 0, %18 ]
  %34 = phi i64 [ %94, %89 ], [ 0, %18 ]
  %35 = phi i64 [ %93, %89 ], [ 0, %18 ]
  %36 = phi ptr [ %92, %89 ], [ null, %18 ]
  %37 = load ptr, ptr %32, align 8, !tbaa !52
  %38 = getelementptr inbounds nuw %struct.UhValue, ptr %37, i64 %33
  %39 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef byval(%struct.UhValue) align 8 %38)
  %40 = icmp eq ptr %39, null
  %41 = select i1 %40, ptr @.str, ptr %39
  %42 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %41) #33
  %43 = add i64 %42, 1
  %44 = add i64 %43, %35
  %45 = icmp ugt i64 %44, %34
  br i1 %45, label %46, label %56

46:                                               ; preds = %31
  %47 = icmp eq i64 %34, 0
  %48 = shl i64 %34, 1
  %49 = select i1 %47, i64 64, i64 %48
  br label %50

50:                                               ; preds = %50, %46
  %51 = phi i64 [ %49, %46 ], [ %53, %50 ]
  %52 = icmp ult i64 %51, %44
  %53 = shl i64 %51, 1
  br i1 %52, label %50, label %54, !llvm.loop !107

54:                                               ; preds = %50
  %55 = tail call ptr @realloc(ptr noundef %36, i64 noundef %51) #35
  br label %56

56:                                               ; preds = %31, %54
  %57 = phi ptr [ %55, %54 ], [ %36, %31 ]
  %58 = phi i64 [ %51, %54 ], [ %34, %31 ]
  %59 = getelementptr inbounds nuw i8, ptr %57, i64 %35
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %59, ptr nonnull readonly align 1 %41, i64 %43, i1 false)
  %60 = add i64 %42, %35
  tail call void @free(ptr noundef %39) #36
  %61 = add nuw i64 %33, 1
  %62 = load ptr, ptr %6, align 8, !tbaa !47
  %63 = getelementptr inbounds nuw i8, ptr %62, i64 8
  %64 = load i64, ptr %63, align 8, !tbaa !49
  %65 = icmp ult i64 %61, %64
  br i1 %65, label %66, label %89

66:                                               ; preds = %56
  %67 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %25) #33
  %68 = add i64 %67, 1
  %69 = add i64 %68, %60
  %70 = icmp ugt i64 %69, %58
  br i1 %70, label %71, label %81

71:                                               ; preds = %66
  %72 = icmp eq i64 %58, 0
  %73 = shl i64 %58, 1
  %74 = select i1 %72, i64 64, i64 %73
  br label %75

75:                                               ; preds = %75, %71
  %76 = phi i64 [ %74, %71 ], [ %78, %75 ]
  %77 = icmp ult i64 %76, %69
  %78 = shl i64 %76, 1
  br i1 %77, label %75, label %79, !llvm.loop !107

79:                                               ; preds = %75
  %80 = tail call ptr @realloc(ptr noundef %57, i64 noundef %76) #35
  br label %81

81:                                               ; preds = %66, %79
  %82 = phi ptr [ %80, %79 ], [ %57, %66 ]
  %83 = phi i64 [ %76, %79 ], [ %58, %66 ]
  %84 = getelementptr inbounds nuw i8, ptr %82, i64 %60
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %84, ptr nonnull readonly align 1 %25, i64 %68, i1 false)
  %85 = add i64 %67, %60
  %86 = load ptr, ptr %6, align 8, !tbaa !47
  %87 = getelementptr inbounds nuw i8, ptr %86, i64 8
  %88 = load i64, ptr %87, align 8, !tbaa !49
  br label %89

89:                                               ; preds = %81, %56
  %90 = phi i64 [ %88, %81 ], [ %64, %56 ]
  %91 = phi ptr [ %86, %81 ], [ %62, %56 ]
  %92 = phi ptr [ %82, %81 ], [ %57, %56 ]
  %93 = phi i64 [ %85, %81 ], [ %60, %56 ]
  %94 = phi i64 [ %83, %81 ], [ %58, %56 ]
  %95 = icmp ult i64 %61, %90
  br i1 %95, label %31, label %29, !llvm.loop !108

96:                                               ; preds = %18, %29
  tail call void @llvm.experimental.noalias.scope.decl(metadata !109)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !109
  %97 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %97, align 8, !tbaa !35, !alias.scope !109
  %98 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %99 = icmp eq ptr %98, null
  br i1 %99, label %101, label %100

100:                                              ; preds = %96
  store i8 0, ptr %98, align 1, !noalias !109
  br label %101

101:                                              ; preds = %96, %100
  %102 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %98, ptr %102, align 8, !tbaa !46, !alias.scope !109
  %103 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %103, i8 0, i64 16, i1 false), !alias.scope !109
  br label %108

104:                                              ; preds = %29
  store i32 1, ptr %0, align 8, !tbaa !31
  %105 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %105, align 8, !tbaa !35
  %106 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %92, ptr %106, align 8, !tbaa !46
  %107 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %107, i8 0, i64 16, i1 false)
  br label %108

108:                                              ; preds = %101, %104, %15
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define internal fastcc noalias ptr @uh_value_to_cstr(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0) unnamed_addr #12 {
  %2 = alloca [64 x i8], align 16
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %2) #36
  %3 = load i32, ptr %0, align 8, !tbaa !31
  switch i32 %3, label %23 [
    i32 1, label %4
    i32 0, label %14
  ]

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %6 = load ptr, ptr %5, align 8, !tbaa !46
  %7 = icmp eq ptr %6, null
  %8 = select i1 %7, ptr @.str, ptr %6
  %9 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %8) #33
  %10 = add i64 %9, 1
  %11 = tail call noalias ptr @malloc(i64 noundef %10) #34
  %12 = icmp eq ptr %11, null
  br i1 %12, label %253, label %13

13:                                               ; preds = %4
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %11, ptr nonnull readonly align 1 %8, i64 %10, i1 false)
  br label %253

14:                                               ; preds = %1
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %16 = load double, ptr %15, align 8, !tbaa !35
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %2, i64 noundef 64, ptr noundef nonnull @.str.21, double noundef %16) #36
  %18 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %2) #33
  %19 = add i64 %18, 1
  %20 = tail call noalias ptr @malloc(i64 noundef %19) #34
  %21 = icmp eq ptr %20, null
  br i1 %21, label %253, label %22

22:                                               ; preds = %14
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %20, ptr nonnull readonly align 16 %2, i64 %19, i1 false)
  br label %253

23:                                               ; preds = %1
  %24 = icmp eq i32 %3, 2
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %26 = load ptr, ptr %25, align 8
  %27 = icmp ne ptr %26, null
  %28 = select i1 %24, i1 %27, i1 false
  br i1 %28, label %29, label %116

29:                                               ; preds = %23
  %30 = tail call dereferenceable_or_null(64) ptr @malloc(i64 64)
  store i16 91, ptr %30, align 1
  %31 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %32 = load i64, ptr %31, align 8, !tbaa !49
  %33 = icmp eq i64 %32, 0
  br i1 %33, label %34, label %53

34:                                               ; preds = %109, %29
  %35 = phi ptr [ %30, %29 ], [ %112, %109 ]
  %36 = phi i64 [ 1, %29 ], [ %113, %109 ]
  %37 = phi i64 [ 64, %29 ], [ %114, %109 ]
  %38 = add i64 %36, 2
  %39 = icmp ugt i64 %38, %37
  br i1 %39, label %40, label %50

40:                                               ; preds = %34
  %41 = icmp eq i64 %37, 0
  %42 = shl i64 %37, 1
  %43 = select i1 %41, i64 64, i64 %42
  br label %44

44:                                               ; preds = %44, %40
  %45 = phi i64 [ %43, %40 ], [ %47, %44 ]
  %46 = icmp ult i64 %45, %38
  %47 = shl i64 %45, 1
  br i1 %46, label %44, label %48, !llvm.loop !107

48:                                               ; preds = %44
  %49 = tail call ptr @realloc(ptr noundef %35, i64 noundef %45) #35
  br label %50

50:                                               ; preds = %34, %48
  %51 = phi ptr [ %49, %48 ], [ %35, %34 ]
  %52 = getelementptr inbounds nuw i8, ptr %51, i64 %36
  store i16 93, ptr %52, align 1
  br label %253

53:                                               ; preds = %29, %109
  %54 = phi ptr [ %111, %109 ], [ %26, %29 ]
  %55 = phi i64 [ %83, %109 ], [ 0, %29 ]
  %56 = phi i64 [ %114, %109 ], [ 64, %29 ]
  %57 = phi i64 [ %113, %109 ], [ 1, %29 ]
  %58 = phi ptr [ %112, %109 ], [ %30, %29 ]
  %59 = load ptr, ptr %54, align 8, !tbaa !52
  %60 = getelementptr inbounds nuw %struct.UhValue, ptr %59, i64 %55
  %61 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef byval(%struct.UhValue) align 8 %60)
  %62 = icmp eq ptr %61, null
  %63 = select i1 %62, ptr @.str, ptr %61
  %64 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %63) #33
  %65 = add i64 %64, 1
  %66 = add i64 %65, %57
  %67 = icmp ugt i64 %66, %56
  br i1 %67, label %68, label %78

68:                                               ; preds = %53
  %69 = icmp eq i64 %56, 0
  %70 = shl i64 %56, 1
  %71 = select i1 %69, i64 64, i64 %70
  br label %72

72:                                               ; preds = %72, %68
  %73 = phi i64 [ %71, %68 ], [ %75, %72 ]
  %74 = icmp ult i64 %73, %66
  %75 = shl i64 %73, 1
  br i1 %74, label %72, label %76, !llvm.loop !107

76:                                               ; preds = %72
  %77 = tail call ptr @realloc(ptr noundef %58, i64 noundef %73) #35
  br label %78

78:                                               ; preds = %53, %76
  %79 = phi ptr [ %77, %76 ], [ %58, %53 ]
  %80 = phi i64 [ %73, %76 ], [ %56, %53 ]
  %81 = getelementptr inbounds nuw i8, ptr %79, i64 %57
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %81, ptr nonnull readonly align 1 %63, i64 %65, i1 false)
  %82 = add i64 %64, %57
  tail call void @free(ptr noundef %61) #36
  %83 = add nuw i64 %55, 1
  %84 = load ptr, ptr %25, align 8, !tbaa !47
  %85 = getelementptr inbounds nuw i8, ptr %84, i64 8
  %86 = load i64, ptr %85, align 8, !tbaa !49
  %87 = icmp ult i64 %83, %86
  br i1 %87, label %88, label %109

88:                                               ; preds = %78
  %89 = add i64 %82, 2
  %90 = icmp ugt i64 %89, %80
  br i1 %90, label %91, label %101

91:                                               ; preds = %88
  %92 = icmp eq i64 %80, 0
  %93 = shl i64 %80, 1
  %94 = select i1 %92, i64 64, i64 %93
  br label %95

95:                                               ; preds = %95, %91
  %96 = phi i64 [ %94, %91 ], [ %98, %95 ]
  %97 = icmp ult i64 %96, %89
  %98 = shl i64 %96, 1
  br i1 %97, label %95, label %99, !llvm.loop !107

99:                                               ; preds = %95
  %100 = tail call ptr @realloc(ptr noundef %79, i64 noundef %96) #35
  br label %101

101:                                              ; preds = %88, %99
  %102 = phi ptr [ %100, %99 ], [ %79, %88 ]
  %103 = phi i64 [ %96, %99 ], [ %80, %88 ]
  %104 = getelementptr inbounds nuw i8, ptr %102, i64 %82
  store i16 32, ptr %104, align 1
  %105 = add i64 %82, 1
  %106 = load ptr, ptr %25, align 8, !tbaa !47
  %107 = getelementptr inbounds nuw i8, ptr %106, i64 8
  %108 = load i64, ptr %107, align 8, !tbaa !49
  br label %109

109:                                              ; preds = %101, %78
  %110 = phi i64 [ %108, %101 ], [ %86, %78 ]
  %111 = phi ptr [ %106, %101 ], [ %84, %78 ]
  %112 = phi ptr [ %102, %101 ], [ %79, %78 ]
  %113 = phi i64 [ %105, %101 ], [ %82, %78 ]
  %114 = phi i64 [ %103, %101 ], [ %80, %78 ]
  %115 = icmp ult i64 %83, %110
  br i1 %115, label %53, label %34, !llvm.loop !112

116:                                              ; preds = %23
  %117 = icmp eq i32 %3, 3
  %118 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %119 = load ptr, ptr %118, align 8
  %120 = icmp ne ptr %119, null
  %121 = select i1 %117, i1 %120, i1 false
  br i1 %121, label %122, label %249

122:                                              ; preds = %116
  %123 = tail call dereferenceable_or_null(64) ptr @malloc(i64 64)
  store i16 123, ptr %123, align 1
  %124 = getelementptr inbounds nuw i8, ptr %119, i64 8
  %125 = load i64, ptr %124, align 8, !tbaa !65
  %126 = icmp eq i64 %125, 0
  br i1 %126, label %127, label %146

127:                                              ; preds = %242, %122
  %128 = phi ptr [ %123, %122 ], [ %245, %242 ]
  %129 = phi i64 [ 1, %122 ], [ %246, %242 ]
  %130 = phi i64 [ 64, %122 ], [ %247, %242 ]
  %131 = add i64 %129, 2
  %132 = icmp ugt i64 %131, %130
  br i1 %132, label %133, label %143

133:                                              ; preds = %127
  %134 = icmp eq i64 %130, 0
  %135 = shl i64 %130, 1
  %136 = select i1 %134, i64 64, i64 %135
  br label %137

137:                                              ; preds = %137, %133
  %138 = phi i64 [ %136, %133 ], [ %140, %137 ]
  %139 = icmp ult i64 %138, %131
  %140 = shl i64 %138, 1
  br i1 %139, label %137, label %141, !llvm.loop !107

141:                                              ; preds = %137
  %142 = tail call ptr @realloc(ptr noundef %128, i64 noundef %138) #35
  br label %143

143:                                              ; preds = %127, %141
  %144 = phi ptr [ %142, %141 ], [ %128, %127 ]
  %145 = getelementptr inbounds nuw i8, ptr %144, i64 %129
  store i16 125, ptr %145, align 1
  br label %253

146:                                              ; preds = %122, %242
  %147 = phi ptr [ %244, %242 ], [ %119, %122 ]
  %148 = phi i64 [ %216, %242 ], [ 0, %122 ]
  %149 = phi i64 [ %247, %242 ], [ 64, %122 ]
  %150 = phi i64 [ %246, %242 ], [ 1, %122 ]
  %151 = phi ptr [ %245, %242 ], [ %123, %122 ]
  %152 = load ptr, ptr %147, align 8, !tbaa !68
  %153 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %152, i64 %148
  %154 = load ptr, ptr %153, align 8, !tbaa !70
  %155 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %154) #33
  %156 = add i64 %155, 1
  %157 = add i64 %156, %150
  %158 = icmp ugt i64 %157, %149
  br i1 %158, label %159, label %169

159:                                              ; preds = %146
  %160 = icmp eq i64 %149, 0
  %161 = shl i64 %149, 1
  %162 = select i1 %160, i64 64, i64 %161
  br label %163

163:                                              ; preds = %163, %159
  %164 = phi i64 [ %162, %159 ], [ %166, %163 ]
  %165 = icmp ult i64 %164, %157
  %166 = shl i64 %164, 1
  br i1 %165, label %163, label %167, !llvm.loop !107

167:                                              ; preds = %163
  %168 = tail call ptr @realloc(ptr noundef %151, i64 noundef %164) #35
  br label %169

169:                                              ; preds = %146, %167
  %170 = phi ptr [ %168, %167 ], [ %151, %146 ]
  %171 = phi i64 [ %164, %167 ], [ %149, %146 ]
  %172 = getelementptr inbounds nuw i8, ptr %170, i64 %150
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %172, ptr nonnull readonly align 1 %154, i64 %156, i1 false)
  %173 = add i64 %155, %150
  %174 = add i64 %173, 2
  %175 = icmp ugt i64 %174, %171
  br i1 %175, label %176, label %186

176:                                              ; preds = %169
  %177 = icmp eq i64 %171, 0
  %178 = shl i64 %171, 1
  %179 = select i1 %177, i64 64, i64 %178
  br label %180

180:                                              ; preds = %180, %176
  %181 = phi i64 [ %179, %176 ], [ %183, %180 ]
  %182 = icmp ult i64 %181, %174
  %183 = shl i64 %181, 1
  br i1 %182, label %180, label %184, !llvm.loop !107

184:                                              ; preds = %180
  %185 = tail call ptr @realloc(ptr noundef %170, i64 noundef %181) #35
  br label %186

186:                                              ; preds = %169, %184
  %187 = phi ptr [ %185, %184 ], [ %170, %169 ]
  %188 = phi i64 [ %181, %184 ], [ %171, %169 ]
  %189 = getelementptr inbounds nuw i8, ptr %187, i64 %173
  store i16 58, ptr %189, align 1
  %190 = add i64 %173, 1
  %191 = load ptr, ptr %118, align 8, !tbaa !48
  %192 = load ptr, ptr %191, align 8, !tbaa !68
  %193 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %192, i64 %148, i32 1
  %194 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %193)
  %195 = icmp eq ptr %194, null
  %196 = select i1 %195, ptr @.str, ptr %194
  %197 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %196) #33
  %198 = add i64 %197, 1
  %199 = add i64 %198, %190
  %200 = icmp ugt i64 %199, %188
  br i1 %200, label %201, label %211

201:                                              ; preds = %186
  %202 = icmp eq i64 %188, 0
  %203 = shl i64 %188, 1
  %204 = select i1 %202, i64 64, i64 %203
  br label %205

205:                                              ; preds = %205, %201
  %206 = phi i64 [ %204, %201 ], [ %208, %205 ]
  %207 = icmp ult i64 %206, %199
  %208 = shl i64 %206, 1
  br i1 %207, label %205, label %209, !llvm.loop !107

209:                                              ; preds = %205
  %210 = tail call ptr @realloc(ptr noundef nonnull %187, i64 noundef %206) #35
  br label %211

211:                                              ; preds = %186, %209
  %212 = phi ptr [ %210, %209 ], [ %187, %186 ]
  %213 = phi i64 [ %206, %209 ], [ %188, %186 ]
  %214 = getelementptr inbounds nuw i8, ptr %212, i64 %190
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %214, ptr nonnull readonly align 1 %196, i64 %198, i1 false)
  %215 = add i64 %197, %190
  tail call void @free(ptr noundef %194) #36
  %216 = add nuw i64 %148, 1
  %217 = load ptr, ptr %118, align 8, !tbaa !48
  %218 = getelementptr inbounds nuw i8, ptr %217, i64 8
  %219 = load i64, ptr %218, align 8, !tbaa !65
  %220 = icmp ult i64 %216, %219
  br i1 %220, label %221, label %242

221:                                              ; preds = %211
  %222 = add i64 %215, 2
  %223 = icmp ugt i64 %222, %213
  br i1 %223, label %224, label %234

224:                                              ; preds = %221
  %225 = icmp eq i64 %213, 0
  %226 = shl i64 %213, 1
  %227 = select i1 %225, i64 64, i64 %226
  br label %228

228:                                              ; preds = %228, %224
  %229 = phi i64 [ %227, %224 ], [ %231, %228 ]
  %230 = icmp ult i64 %229, %222
  %231 = shl i64 %229, 1
  br i1 %230, label %228, label %232, !llvm.loop !107

232:                                              ; preds = %228
  %233 = tail call ptr @realloc(ptr noundef %212, i64 noundef %229) #35
  br label %234

234:                                              ; preds = %221, %232
  %235 = phi ptr [ %233, %232 ], [ %212, %221 ]
  %236 = phi i64 [ %229, %232 ], [ %213, %221 ]
  %237 = getelementptr inbounds nuw i8, ptr %235, i64 %215
  store i16 44, ptr %237, align 1
  %238 = add i64 %215, 1
  %239 = load ptr, ptr %118, align 8, !tbaa !48
  %240 = getelementptr inbounds nuw i8, ptr %239, i64 8
  %241 = load i64, ptr %240, align 8, !tbaa !65
  br label %242

242:                                              ; preds = %234, %211
  %243 = phi i64 [ %241, %234 ], [ %219, %211 ]
  %244 = phi ptr [ %239, %234 ], [ %217, %211 ]
  %245 = phi ptr [ %235, %234 ], [ %212, %211 ]
  %246 = phi i64 [ %238, %234 ], [ %215, %211 ]
  %247 = phi i64 [ %236, %234 ], [ %213, %211 ]
  %248 = icmp ult i64 %216, %243
  br i1 %248, label %146, label %127, !llvm.loop !113

249:                                              ; preds = %116
  %250 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %251 = icmp eq ptr %250, null
  br i1 %251, label %253, label %252

252:                                              ; preds = %249
  store i8 0, ptr %250, align 1
  br label %253

253:                                              ; preds = %252, %249, %22, %14, %13, %4, %143, %50
  %254 = phi ptr [ %51, %50 ], [ %144, %143 ], [ %11, %13 ], [ null, %4 ], [ %20, %22 ], [ null, %14 ], [ %250, %252 ], [ null, %249 ]
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %2) #36
  ret ptr %254
}

; Function Attrs: nofree nounwind sspstrong uwtable
define dso_local void @uh_substr(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %3) local_unnamed_addr #4 {
  %5 = load i32, ptr %1, align 8, !tbaa !31
  %6 = icmp ne i32 %5, 1
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %8 = load ptr, ptr %7, align 8
  %9 = icmp eq ptr %8, null
  %10 = select i1 %6, i1 true, i1 %9
  br i1 %10, label %11, label %19

11:                                               ; preds = %4
  tail call void @llvm.experimental.noalias.scope.decl(metadata !114)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !114
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %12, align 8, !tbaa !35, !alias.scope !114
  %13 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %14 = icmp eq ptr %13, null
  br i1 %14, label %16, label %15

15:                                               ; preds = %11
  store i8 0, ptr %13, align 1, !noalias !114
  br label %16

16:                                               ; preds = %11, %15
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %13, ptr %17, align 8, !tbaa !46, !alias.scope !114
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %18, i8 0, i64 16, i1 false), !alias.scope !114
  br label %201

19:                                               ; preds = %4
  %20 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %21 = load double, ptr %20, align 8, !tbaa !35
  %22 = fptosi double %21 to i64
  %23 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %24 = load double, ptr %23, align 8, !tbaa !35
  %25 = fptosi double %24 to i64
  %26 = load i8, ptr %8, align 1, !tbaa !76
  %27 = icmp eq i8 %26, 0
  br i1 %27, label %51, label %28

28:                                               ; preds = %19, %44
  %29 = phi i8 [ %49, %44 ], [ %26, %19 ]
  %30 = phi i64 [ %46, %44 ], [ 0, %19 ]
  %31 = phi i64 [ %47, %44 ], [ 0, %19 ]
  %32 = zext i8 %29 to i32
  %33 = icmp sgt i8 %29, -1
  br i1 %33, label %44, label %34

34:                                               ; preds = %28
  %35 = and i32 %32, 224
  %36 = icmp eq i32 %35, 192
  br i1 %36, label %44, label %37

37:                                               ; preds = %34
  %38 = and i32 %32, 240
  %39 = icmp eq i32 %38, 224
  br i1 %39, label %44, label %40

40:                                               ; preds = %37
  %41 = and i32 %32, 248
  %42 = icmp eq i32 %41, 240
  %43 = select i1 %42, i64 4, i64 1
  br label %44

44:                                               ; preds = %40, %37, %34, %28
  %45 = phi i64 [ 1, %28 ], [ 2, %34 ], [ 3, %37 ], [ %43, %40 ]
  %46 = add i64 %45, %30
  %47 = add i64 %31, 1
  %48 = getelementptr inbounds nuw i8, ptr %8, i64 %46
  %49 = load i8, ptr %48, align 1, !tbaa !76
  %50 = icmp eq i8 %49, 0
  br i1 %50, label %51, label %28, !llvm.loop !77

51:                                               ; preds = %44, %19
  %52 = phi i64 [ 0, %19 ], [ %47, %44 ]
  %53 = icmp slt i64 %22, 0
  %54 = select i1 %53, i64 %52, i64 0
  %55 = add nsw i64 %54, %22
  %56 = tail call i64 @llvm.smax.i64(i64 %55, i64 0)
  %57 = icmp ugt i64 %56, %52
  br i1 %57, label %58, label %66

58:                                               ; preds = %51
  tail call void @llvm.experimental.noalias.scope.decl(metadata !117)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !117
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %59, align 8, !tbaa !35, !alias.scope !117
  %60 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %61 = icmp eq ptr %60, null
  br i1 %61, label %63, label %62

62:                                               ; preds = %58
  store i8 0, ptr %60, align 1, !noalias !117
  br label %63

63:                                               ; preds = %58, %62
  %64 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %60, ptr %64, align 8, !tbaa !46, !alias.scope !117
  %65 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %65, i8 0, i64 16, i1 false), !alias.scope !117
  br label %201

66:                                               ; preds = %51
  %67 = icmp slt i64 %25, 0
  %68 = add nuw nsw i64 %56, %25
  %69 = icmp ugt i64 %68, %52
  %70 = select i1 %67, i1 true, i1 %69
  %71 = sub nuw i64 %52, %56
  %72 = select i1 %70, i64 %71, i64 %25
  br i1 %27, label %98, label %73

73:                                               ; preds = %66, %91
  %74 = phi i8 [ %96, %91 ], [ %26, %66 ]
  %75 = phi i64 [ %94, %91 ], [ 0, %66 ]
  %76 = phi i64 [ %93, %91 ], [ 0, %66 ]
  %77 = icmp eq i64 %75, %56
  br i1 %77, label %103, label %78

78:                                               ; preds = %73
  %79 = zext i8 %74 to i32
  %80 = icmp sgt i8 %74, -1
  br i1 %80, label %91, label %81

81:                                               ; preds = %78
  %82 = and i32 %79, 224
  %83 = icmp eq i32 %82, 192
  br i1 %83, label %91, label %84

84:                                               ; preds = %81
  %85 = and i32 %79, 240
  %86 = icmp eq i32 %85, 224
  br i1 %86, label %91, label %87

87:                                               ; preds = %84
  %88 = and i32 %79, 248
  %89 = icmp eq i32 %88, 240
  %90 = select i1 %89, i64 4, i64 1
  br label %91

91:                                               ; preds = %87, %84, %81, %78
  %92 = phi i64 [ 1, %78 ], [ 2, %81 ], [ 3, %84 ], [ %90, %87 ]
  %93 = add i64 %92, %76
  %94 = add nuw nsw i64 %75, 1
  %95 = getelementptr inbounds nuw i8, ptr %8, i64 %93
  %96 = load i8, ptr %95, align 1, !tbaa !76
  %97 = icmp eq i8 %96, 0
  br i1 %97, label %98, label %73, !llvm.loop !120

98:                                               ; preds = %91, %66
  %99 = phi i64 [ 0, %66 ], [ %93, %91 ]
  %100 = phi i64 [ 0, %66 ], [ %94, %91 ]
  %101 = icmp eq i64 %100, %56
  %102 = select i1 %101, i64 %99, i64 -1
  br label %103

103:                                              ; preds = %73, %98
  %104 = phi i64 [ %102, %98 ], [ %76, %73 ]
  %105 = add nsw i64 %72, %56
  %106 = icmp slt i64 %105, 0
  br i1 %106, label %107, label %135

107:                                              ; preds = %103
  br i1 %27, label %131, label %108

108:                                              ; preds = %107, %124
  %109 = phi i8 [ %129, %124 ], [ %26, %107 ]
  %110 = phi i64 [ %126, %124 ], [ 0, %107 ]
  %111 = phi i64 [ %127, %124 ], [ 0, %107 ]
  %112 = zext i8 %109 to i32
  %113 = icmp sgt i8 %109, -1
  br i1 %113, label %124, label %114

114:                                              ; preds = %108
  %115 = and i32 %112, 224
  %116 = icmp eq i32 %115, 192
  br i1 %116, label %124, label %117

117:                                              ; preds = %114
  %118 = and i32 %112, 240
  %119 = icmp eq i32 %118, 224
  br i1 %119, label %124, label %120

120:                                              ; preds = %117
  %121 = and i32 %112, 248
  %122 = icmp eq i32 %121, 240
  %123 = select i1 %122, i64 4, i64 1
  br label %124

124:                                              ; preds = %120, %117, %114, %108
  %125 = phi i64 [ 1, %108 ], [ 2, %114 ], [ 3, %117 ], [ %123, %120 ]
  %126 = add i64 %125, %110
  %127 = add i64 %111, 1
  %128 = getelementptr inbounds nuw i8, ptr %8, i64 %126
  %129 = load i8, ptr %128, align 1, !tbaa !76
  %130 = icmp eq i8 %129, 0
  br i1 %130, label %131, label %108, !llvm.loop !77

131:                                              ; preds = %124, %107
  %132 = phi i64 [ 0, %107 ], [ %127, %124 ]
  %133 = add nsw i64 %132, %105
  %134 = icmp slt i64 %133, 0
  br i1 %134, label %174, label %135

135:                                              ; preds = %131, %103
  %136 = phi i64 [ %133, %131 ], [ %105, %103 ]
  br i1 %27, label %162, label %137

137:                                              ; preds = %135, %155
  %138 = phi i8 [ %160, %155 ], [ %26, %135 ]
  %139 = phi i64 [ %158, %155 ], [ 0, %135 ]
  %140 = phi i64 [ %157, %155 ], [ 0, %135 ]
  %141 = icmp eq i64 %139, %136
  br i1 %141, label %167, label %142

142:                                              ; preds = %137
  %143 = zext i8 %138 to i32
  %144 = icmp sgt i8 %138, -1
  br i1 %144, label %155, label %145

145:                                              ; preds = %142
  %146 = and i32 %143, 224
  %147 = icmp eq i32 %146, 192
  br i1 %147, label %155, label %148

148:                                              ; preds = %145
  %149 = and i32 %143, 240
  %150 = icmp eq i32 %149, 224
  br i1 %150, label %155, label %151

151:                                              ; preds = %148
  %152 = and i32 %143, 248
  %153 = icmp eq i32 %152, 240
  %154 = select i1 %153, i64 4, i64 1
  br label %155

155:                                              ; preds = %151, %148, %145, %142
  %156 = phi i64 [ 1, %142 ], [ 2, %145 ], [ 3, %148 ], [ %154, %151 ]
  %157 = add i64 %156, %140
  %158 = add nuw nsw i64 %139, 1
  %159 = getelementptr inbounds nuw i8, ptr %8, i64 %157
  %160 = load i8, ptr %159, align 1, !tbaa !76
  %161 = icmp eq i8 %160, 0
  br i1 %161, label %162, label %137, !llvm.loop !120

162:                                              ; preds = %155, %135
  %163 = phi i64 [ 0, %135 ], [ %157, %155 ]
  %164 = phi i64 [ 0, %135 ], [ %158, %155 ]
  %165 = icmp eq i64 %164, %136
  %166 = select i1 %165, i64 %163, i64 -1
  br label %167

167:                                              ; preds = %137, %162
  %168 = phi i64 [ %166, %162 ], [ %140, %137 ]
  %169 = icmp eq i64 %104, -1
  %170 = icmp eq i64 %168, -1
  %171 = select i1 %169, i1 true, i1 %170
  %172 = icmp ult i64 %168, %104
  %173 = select i1 %171, i1 true, i1 %172
  br i1 %173, label %174, label %182

174:                                              ; preds = %131, %167
  tail call void @llvm.experimental.noalias.scope.decl(metadata !121)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !121
  %175 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %175, align 8, !tbaa !35, !alias.scope !121
  %176 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %177 = icmp eq ptr %176, null
  br i1 %177, label %179, label %178

178:                                              ; preds = %174
  store i8 0, ptr %176, align 1, !noalias !121
  br label %179

179:                                              ; preds = %174, %178
  %180 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %176, ptr %180, align 8, !tbaa !46, !alias.scope !121
  %181 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %181, i8 0, i64 16, i1 false), !alias.scope !121
  br label %201

182:                                              ; preds = %167
  %183 = sub nuw i64 %168, %104
  %184 = add nuw i64 %183, 1
  %185 = tail call noalias ptr @malloc(i64 noundef %184) #34
  %186 = icmp eq ptr %185, null
  br i1 %186, label %187, label %195

187:                                              ; preds = %182
  tail call void @llvm.experimental.noalias.scope.decl(metadata !124)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !124
  %188 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %188, align 8, !tbaa !35, !alias.scope !124
  %189 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %190 = icmp eq ptr %189, null
  br i1 %190, label %192, label %191

191:                                              ; preds = %187
  store i8 0, ptr %189, align 1, !noalias !124
  br label %192

192:                                              ; preds = %187, %191
  %193 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %189, ptr %193, align 8, !tbaa !46, !alias.scope !124
  %194 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %194, i8 0, i64 16, i1 false), !alias.scope !124
  br label %201

195:                                              ; preds = %182
  %196 = getelementptr inbounds nuw i8, ptr %8, i64 %104
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %185, ptr nonnull align 1 %196, i64 %183, i1 false)
  %197 = getelementptr inbounds nuw i8, ptr %185, i64 %183
  store i8 0, ptr %197, align 1, !tbaa !76
  store i32 1, ptr %0, align 8, !tbaa !31
  %198 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %198, align 8, !tbaa !35
  %199 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %185, ptr %199, align 8, !tbaa !46
  %200 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %200, i8 0, i64 16, i1 false)
  br label %201

201:                                              ; preds = %63, %192, %195, %179, %16
  ret void
}

; Function Attrs: nofree nounwind sspstrong uwtable
define dso_local void @uh_char_at(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #4 {
  %4 = alloca [5 x i8], align 1
  %5 = load i32, ptr %1, align 8, !tbaa !31
  %6 = icmp ne i32 %5, 1
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %8 = load ptr, ptr %7, align 8
  %9 = icmp eq ptr %8, null
  %10 = select i1 %6, i1 true, i1 %9
  br i1 %10, label %11, label %19

11:                                               ; preds = %3
  tail call void @llvm.experimental.noalias.scope.decl(metadata !127)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !127
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %12, align 8, !tbaa !35, !alias.scope !127
  %13 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %14 = icmp eq ptr %13, null
  br i1 %14, label %16, label %15

15:                                               ; preds = %11
  store i8 0, ptr %13, align 1, !noalias !127
  br label %16

16:                                               ; preds = %11, %15
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %13, ptr %17, align 8, !tbaa !46, !alias.scope !127
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %18, i8 0, i64 16, i1 false), !alias.scope !127
  br label %128

19:                                               ; preds = %3
  %20 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %21 = load double, ptr %20, align 8, !tbaa !35
  %22 = fptosi double %21 to i64
  %23 = load i8, ptr %8, align 1, !tbaa !76
  %24 = icmp eq i8 %23, 0
  br i1 %24, label %55, label %25

25:                                               ; preds = %19, %41
  %26 = phi i8 [ %46, %41 ], [ %23, %19 ]
  %27 = phi i64 [ %43, %41 ], [ 0, %19 ]
  %28 = phi i64 [ %44, %41 ], [ 0, %19 ]
  %29 = zext i8 %26 to i32
  %30 = icmp sgt i8 %26, -1
  br i1 %30, label %41, label %31

31:                                               ; preds = %25
  %32 = and i32 %29, 224
  %33 = icmp eq i32 %32, 192
  br i1 %33, label %41, label %34

34:                                               ; preds = %31
  %35 = and i32 %29, 240
  %36 = icmp eq i32 %35, 224
  br i1 %36, label %41, label %37

37:                                               ; preds = %34
  %38 = and i32 %29, 248
  %39 = icmp eq i32 %38, 240
  %40 = select i1 %39, i64 4, i64 1
  br label %41

41:                                               ; preds = %37, %34, %31, %25
  %42 = phi i64 [ 1, %25 ], [ 2, %31 ], [ 3, %34 ], [ %40, %37 ]
  %43 = add i64 %42, %27
  %44 = add i64 %28, 1
  %45 = getelementptr inbounds nuw i8, ptr %8, i64 %43
  %46 = load i8, ptr %45, align 1, !tbaa !76
  %47 = icmp eq i8 %46, 0
  br i1 %47, label %48, label %25, !llvm.loop !77

48:                                               ; preds = %41
  %49 = icmp slt i64 %22, 0
  %50 = select i1 %49, i64 %44, i64 0
  %51 = add nsw i64 %50, %22
  %52 = icmp sgt i64 %51, -1
  %53 = icmp ult i64 %51, %44
  %54 = select i1 %52, i1 %53, i1 false
  br i1 %54, label %63, label %55

55:                                               ; preds = %19, %48
  tail call void @llvm.experimental.noalias.scope.decl(metadata !130)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !130
  %56 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %56, align 8, !tbaa !35, !alias.scope !130
  %57 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %58 = icmp eq ptr %57, null
  br i1 %58, label %60, label %59

59:                                               ; preds = %55
  store i8 0, ptr %57, align 1, !noalias !130
  br label %60

60:                                               ; preds = %55, %59
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %57, ptr %61, align 8, !tbaa !46, !alias.scope !130
  %62 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %62, i8 0, i64 16, i1 false), !alias.scope !130
  br label %128

63:                                               ; preds = %48, %81
  %64 = phi i8 [ %86, %81 ], [ %23, %48 ]
  %65 = phi i64 [ %84, %81 ], [ 0, %48 ]
  %66 = phi i64 [ %83, %81 ], [ 0, %48 ]
  %67 = icmp eq i64 %65, %51
  br i1 %67, label %90, label %68

68:                                               ; preds = %63
  %69 = zext i8 %64 to i32
  %70 = icmp sgt i8 %64, -1
  br i1 %70, label %81, label %71

71:                                               ; preds = %68
  %72 = and i32 %69, 224
  %73 = icmp eq i32 %72, 192
  br i1 %73, label %81, label %74

74:                                               ; preds = %71
  %75 = and i32 %69, 240
  %76 = icmp eq i32 %75, 224
  br i1 %76, label %81, label %77

77:                                               ; preds = %74
  %78 = and i32 %69, 248
  %79 = icmp eq i32 %78, 240
  %80 = select i1 %79, i64 4, i64 1
  br label %81

81:                                               ; preds = %77, %74, %71, %68
  %82 = phi i64 [ 1, %68 ], [ 2, %71 ], [ 3, %74 ], [ %80, %77 ]
  %83 = add i64 %82, %66
  %84 = add nuw nsw i64 %65, 1
  %85 = getelementptr inbounds nuw i8, ptr %8, i64 %83
  %86 = load i8, ptr %85, align 1, !tbaa !76
  %87 = icmp eq i8 %86, 0
  br i1 %87, label %88, label %63, !llvm.loop !120

88:                                               ; preds = %81
  %89 = icmp eq i64 %84, %51
  br i1 %89, label %90, label %93

90:                                               ; preds = %63, %88
  %91 = phi i64 [ %83, %88 ], [ %66, %63 ]
  %92 = icmp eq i64 %91, -1
  br i1 %92, label %93, label %101

93:                                               ; preds = %88, %90
  tail call void @llvm.experimental.noalias.scope.decl(metadata !133)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !133
  %94 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %94, align 8, !tbaa !35, !alias.scope !133
  %95 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %96 = icmp eq ptr %95, null
  br i1 %96, label %98, label %97

97:                                               ; preds = %93
  store i8 0, ptr %95, align 1, !noalias !133
  br label %98

98:                                               ; preds = %93, %97
  %99 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %95, ptr %99, align 8, !tbaa !46, !alias.scope !133
  %100 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %100, i8 0, i64 16, i1 false), !alias.scope !133
  br label %128

101:                                              ; preds = %90
  %102 = getelementptr inbounds nuw i8, ptr %8, i64 %91
  %103 = load i8, ptr %102, align 1, !tbaa !76
  %104 = zext i8 %103 to i32
  %105 = icmp sgt i8 %103, -1
  br i1 %105, label %116, label %106

106:                                              ; preds = %101
  %107 = and i32 %104, 224
  %108 = icmp eq i32 %107, 192
  br i1 %108, label %116, label %109

109:                                              ; preds = %106
  %110 = and i32 %104, 240
  %111 = icmp eq i32 %110, 224
  br i1 %111, label %116, label %112

112:                                              ; preds = %109
  %113 = and i32 %104, 248
  %114 = icmp eq i32 %113, 240
  %115 = select i1 %114, i64 4, i64 1
  br label %116

116:                                              ; preds = %101, %106, %109, %112
  %117 = phi i64 [ 1, %101 ], [ 2, %106 ], [ 3, %109 ], [ %115, %112 ]
  call void @llvm.lifetime.start.p0(i64 5, ptr nonnull %4) #36
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(1) %4, ptr noundef nonnull align 1 dereferenceable(1) %102, i64 %117, i1 false)
  %118 = getelementptr inbounds nuw [5 x i8], ptr %4, i64 0, i64 %117
  store i8 0, ptr %118, align 1, !tbaa !76
  tail call void @llvm.experimental.noalias.scope.decl(metadata !136)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !136
  %119 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %119, align 8, !tbaa !35, !alias.scope !136
  %120 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %4) #33, !noalias !136
  %121 = add i64 %120, 1
  %122 = tail call noalias ptr @malloc(i64 noundef %121) #34
  %123 = icmp eq ptr %122, null
  br i1 %123, label %125, label %124

124:                                              ; preds = %116
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %122, ptr nonnull readonly align 1 %4, i64 %121, i1 false), !noalias !136
  br label %125

125:                                              ; preds = %116, %124
  %126 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %122, ptr %126, align 8, !tbaa !46, !alias.scope !136
  %127 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %127, i8 0, i64 16, i1 false), !alias.scope !136
  call void @llvm.lifetime.end.p0(i64 5, ptr nonnull %4) #36
  br label %128

128:                                              ; preds = %60, %125, %98, %16
  ret void
}

; Function Attrs: nofree nounwind sspstrong uwtable
define dso_local void @uh_read_file(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #4 {
  %3 = load i32, ptr %1, align 8, !tbaa !31
  %4 = icmp ne i32 %3, 1
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %6 = load ptr, ptr %5, align 8
  %7 = icmp eq ptr %6, null
  %8 = select i1 %4, i1 true, i1 %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !139)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !139
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %10, align 8, !tbaa !35, !alias.scope !139
  %11 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %12 = icmp eq ptr %11, null
  br i1 %12, label %14, label %13

13:                                               ; preds = %9
  store i8 0, ptr %11, align 1, !noalias !139
  br label %14

14:                                               ; preds = %9, %13
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %11, ptr %15, align 8, !tbaa !46, !alias.scope !139
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %16, i8 0, i64 16, i1 false), !alias.scope !139
  br label %62

17:                                               ; preds = %2
  %18 = tail call noalias ptr @fopen(ptr noundef nonnull %6, ptr noundef nonnull @.str.1)
  %19 = icmp eq ptr %18, null
  br i1 %19, label %20, label %28

20:                                               ; preds = %17
  tail call void @llvm.experimental.noalias.scope.decl(metadata !142)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !142
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %21, align 8, !tbaa !35, !alias.scope !142
  %22 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %23 = icmp eq ptr %22, null
  br i1 %23, label %25, label %24

24:                                               ; preds = %20
  store i8 0, ptr %22, align 1, !noalias !142
  br label %25

25:                                               ; preds = %20, %24
  %26 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %22, ptr %26, align 8, !tbaa !46, !alias.scope !142
  %27 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %27, i8 0, i64 16, i1 false), !alias.scope !142
  br label %62

28:                                               ; preds = %17
  %29 = tail call i32 @fseek(ptr noundef nonnull %18, i64 noundef 0, i32 noundef 2)
  %30 = tail call i64 @ftell(ptr noundef nonnull %18)
  %31 = tail call i32 @fseek(ptr noundef nonnull %18, i64 noundef 0, i32 noundef 0)
  %32 = icmp slt i64 %30, 0
  br i1 %32, label %33, label %42

33:                                               ; preds = %28
  %34 = tail call i32 @fclose(ptr noundef nonnull %18)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !145)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !145
  %35 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %35, align 8, !tbaa !35, !alias.scope !145
  %36 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %37 = icmp eq ptr %36, null
  br i1 %37, label %39, label %38

38:                                               ; preds = %33
  store i8 0, ptr %36, align 1, !noalias !145
  br label %39

39:                                               ; preds = %33, %38
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %36, ptr %40, align 8, !tbaa !46, !alias.scope !145
  %41 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %41, i8 0, i64 16, i1 false), !alias.scope !145
  br label %62

42:                                               ; preds = %28
  %43 = add nuw i64 %30, 1
  %44 = tail call noalias ptr @malloc(i64 noundef %43) #34
  %45 = icmp eq ptr %44, null
  br i1 %45, label %46, label %55

46:                                               ; preds = %42
  %47 = tail call i32 @fclose(ptr noundef nonnull %18)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !148)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !148
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %48, align 8, !tbaa !35, !alias.scope !148
  %49 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %50 = icmp eq ptr %49, null
  br i1 %50, label %52, label %51

51:                                               ; preds = %46
  store i8 0, ptr %49, align 1, !noalias !148
  br label %52

52:                                               ; preds = %46, %51
  %53 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %49, ptr %53, align 8, !tbaa !46, !alias.scope !148
  %54 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %54, i8 0, i64 16, i1 false), !alias.scope !148
  br label %62

55:                                               ; preds = %42
  %56 = tail call i64 @fread(ptr noundef nonnull %44, i64 noundef 1, i64 noundef %30, ptr noundef nonnull %18)
  %57 = getelementptr inbounds nuw i8, ptr %44, i64 %56
  store i8 0, ptr %57, align 1, !tbaa !76
  %58 = tail call i32 @fclose(ptr noundef nonnull %18)
  store i32 1, ptr %0, align 8, !tbaa !31
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %59, align 8, !tbaa !35
  %60 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %44, ptr %60, align 8, !tbaa !46
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %61, i8 0, i64 16, i1 false)
  br label %62

62:                                               ; preds = %25, %52, %55, %39, %14
  ret void
}

; Function Attrs: nofree nounwind
declare noalias noundef ptr @fopen(ptr noundef readonly captures(none), ptr noundef readonly captures(none)) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef i32 @fseek(ptr noundef captures(none), i64 noundef, i32 noundef) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef i64 @ftell(ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef i32 @fclose(ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef i64 @fread(ptr noundef writeonly captures(none), i64 noundef, i64 noundef, ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_write_file(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 1
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %7 = load ptr, ptr %6, align 8
  %8 = icmp eq ptr %7, null
  %9 = select i1 %5, i1 true, i1 %8
  br i1 %9, label %10, label %12

10:                                               ; preds = %3
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !151
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %11, i8 0, i64 32, i1 false)
  br label %36

12:                                               ; preds = %3
  %13 = load i32, ptr %2, align 8, !tbaa !31
  %14 = icmp eq i32 %13, 1
  %15 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %16 = load ptr, ptr %15, align 8
  %17 = icmp ne ptr %16, null
  %18 = select i1 %14, i1 %17, i1 false
  br i1 %18, label %23, label %19

19:                                               ; preds = %12
  %20 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  %21 = icmp eq ptr %20, null
  %22 = select i1 %21, ptr @.str, ptr %20
  br label %23

23:                                               ; preds = %12, %19
  %24 = phi ptr [ %20, %19 ], [ null, %12 ]
  %25 = phi ptr [ %22, %19 ], [ %16, %12 ]
  %26 = tail call noalias ptr @fopen(ptr noundef nonnull %7, ptr noundef nonnull @.str.2)
  %27 = icmp eq ptr %26, null
  br i1 %27, label %28, label %30

28:                                               ; preds = %23
  tail call void @free(ptr noundef %24) #36
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !154
  %29 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %29, i8 0, i64 32, i1 false)
  br label %36

30:                                               ; preds = %23
  %31 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %25) #33
  %32 = tail call i64 @fwrite(ptr noundef nonnull %25, i64 noundef 1, i64 noundef %31, ptr noundef nonnull %26)
  %33 = tail call i32 @fclose(ptr noundef nonnull %26)
  tail call void @free(ptr noundef %24) #36
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !157
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 1.000000e+00, ptr %34, align 8, !tbaa !35, !alias.scope !157
  %35 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %35, i8 0, i64 24, i1 false), !alias.scope !157
  br label %36

36:                                               ; preds = %28, %30, %10
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(ptr noundef readonly captures(none), i64 noundef, i64 noundef, ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_file_open(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = load i32, ptr %1, align 8, !tbaa !31
  %7 = icmp ne i32 %6, 1
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %9 = load ptr, ptr %8, align 8
  %10 = icmp eq ptr %9, null
  %11 = select i1 %7, i1 true, i1 %10
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 8
  br i1 %11, label %13, label %14

13:                                               ; preds = %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !160
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %12, i8 0, i64 32, i1 false), !alias.scope !160
  br label %38

14:                                               ; preds = %3
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !163
  %15 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 32
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %12, i8 0, i64 24, i1 false), !alias.scope !163
  store ptr %15, ptr %16, align 8, !tbaa !48, !alias.scope !163
  tail call void @llvm.experimental.noalias.scope.decl(metadata !166)
  store i32 1, ptr %4, align 8, !tbaa !31, !alias.scope !166
  %17 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store double 0.000000e+00, ptr %17, align 8, !tbaa !35, !alias.scope !166
  %18 = tail call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %19 = icmp eq ptr %18, null
  br i1 %19, label %21, label %20

20:                                               ; preds = %14
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %18, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !noalias !166
  br label %21

21:                                               ; preds = %14, %20
  %22 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store ptr %18, ptr %22, align 8, !tbaa !46, !alias.scope !166
  %23 = getelementptr inbounds nuw i8, ptr %4, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %23, i8 0, i64 16, i1 false), !alias.scope !166
  tail call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %4, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %24 = load i32, ptr %2, align 8, !tbaa !31
  %25 = icmp eq i32 %24, 1
  %26 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %27 = load ptr, ptr %26, align 8
  %28 = icmp ne ptr %27, null
  %29 = select i1 %25, i1 %28, i1 false
  br i1 %29, label %30, label %38

30:                                               ; preds = %21
  tail call void @llvm.experimental.noalias.scope.decl(metadata !169)
  store i32 1, ptr %5, align 8, !tbaa !31, !alias.scope !169
  %31 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store double 0.000000e+00, ptr %31, align 8, !tbaa !35, !alias.scope !169
  %32 = tail call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %33 = icmp eq ptr %32, null
  br i1 %33, label %35, label %34

34:                                               ; preds = %30
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %32, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.4, i64 5, i1 false), !noalias !169
  br label %35

35:                                               ; preds = %30, %34
  %36 = getelementptr inbounds nuw i8, ptr %5, i64 16
  store ptr %32, ptr %36, align 8, !tbaa !46, !alias.scope !169
  %37 = getelementptr inbounds nuw i8, ptr %5, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %37, i8 0, i64 16, i1 false), !alias.scope !169
  tail call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %5, ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  br label %38

38:                                               ; preds = %21, %35, %13
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_file_read(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  %4 = tail call fastcc ptr @uh_file_path(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %5 = icmp eq ptr %4, null
  br i1 %5, label %6, label %14

6:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !172)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !172
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %7, align 8, !tbaa !35, !alias.scope !172
  %8 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %9 = icmp eq ptr %8, null
  br i1 %9, label %11, label %10

10:                                               ; preds = %6
  store i8 0, ptr %8, align 1, !noalias !172
  br label %11

11:                                               ; preds = %6, %10
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %8, ptr %12, align 8, !tbaa !46, !alias.scope !172
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %13, i8 0, i64 16, i1 false), !alias.scope !172
  br label %24

14:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !175)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !175
  %15 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store double 0.000000e+00, ptr %15, align 8, !tbaa !35, !alias.scope !175
  %16 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %4) #33, !noalias !175
  %17 = add i64 %16, 1
  %18 = tail call noalias ptr @malloc(i64 noundef %17) #34
  %19 = icmp eq ptr %18, null
  br i1 %19, label %21, label %20

20:                                               ; preds = %14
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %18, ptr nonnull readonly align 1 %4, i64 %17, i1 false), !noalias !175
  br label %21

21:                                               ; preds = %14, %20
  %22 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store ptr %18, ptr %22, align 8, !tbaa !46, !alias.scope !175
  %23 = getelementptr inbounds nuw i8, ptr %3, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %23, i8 0, i64 16, i1 false), !alias.scope !175
  tail call void @uh_read_file(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %3)
  br label %24

24:                                               ; preds = %21, %11
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define internal fastcc ptr @uh_file_path(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0) unnamed_addr #12 {
  %2 = load i32, ptr %0, align 8, !tbaa !31
  %3 = icmp eq i32 %2, 3
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %5 = load ptr, ptr %4, align 8
  %6 = icmp ne ptr %5, null
  %7 = select i1 %3, i1 %6, i1 false
  br i1 %7, label %8, label %42

8:                                                ; preds = %1
  %9 = tail call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %10 = icmp eq ptr %9, null
  br i1 %10, label %12, label %11

11:                                               ; preds = %8
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %9, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !noalias !178
  br label %12

12:                                               ; preds = %8, %11
  %13 = phi ptr [ @.str, %8 ], [ %9, %11 ]
  %14 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %13) #33, !noalias !181
  %15 = add i64 %14, 1
  %16 = tail call noalias ptr @malloc(i64 noundef %15) #34
  %17 = icmp eq ptr %16, null
  br i1 %17, label %42, label %18

18:                                               ; preds = %12
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %16, ptr nonnull readonly align 1 %13, i64 %15, i1 false), !noalias !181
  %19 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %20 = load i64, ptr %19, align 8, !tbaa !65, !noalias !181
  %21 = icmp eq i64 %20, 0
  br i1 %21, label %33, label %22

22:                                               ; preds = %18
  %23 = load ptr, ptr %5, align 8, !tbaa !68, !noalias !181
  br label %27

24:                                               ; preds = %27
  %25 = add nuw i64 %28, 1
  %26 = icmp eq i64 %25, %20
  br i1 %26, label %33, label %27, !llvm.loop !69

27:                                               ; preds = %24, %22
  %28 = phi i64 [ 0, %22 ], [ %25, %24 ]
  %29 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %23, i64 %28
  %30 = load ptr, ptr %29, align 8, !tbaa !70, !noalias !181
  %31 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %30, ptr noundef nonnull readonly dereferenceable(1) %16) #33, !noalias !181
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %34, label %24

33:                                               ; preds = %24, %18
  tail call void @free(ptr noundef nonnull %16) #36, !noalias !181
  br label %42

34:                                               ; preds = %27
  tail call void @free(ptr noundef nonnull %16) #36, !noalias !181
  %35 = getelementptr inbounds nuw i8, ptr %29, i64 8
  %36 = load i32, ptr %35, align 8, !tbaa !26
  %37 = getelementptr inbounds nuw i8, ptr %29, i64 24
  %38 = load ptr, ptr %37, align 8, !tbaa !28
  %39 = icmp ne i32 %36, 1
  %40 = icmp eq ptr %38, null
  %41 = select i1 %39, i1 true, i1 %40
  br i1 %41, label %42, label %47

42:                                               ; preds = %33, %12, %34, %1
  %43 = icmp eq i32 %2, 1
  %44 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %45 = load ptr, ptr %44, align 8
  %46 = select i1 %43, ptr %45, ptr null
  br label %47

47:                                               ; preds = %34, %42
  %48 = phi ptr [ %38, %34 ], [ %46, %42 ]
  ret ptr %48
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_file_readall(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  tail call void @llvm.experimental.noalias.scope.decl(metadata !184)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  %4 = tail call fastcc ptr @uh_file_path(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %5 = icmp eq ptr %4, null
  br i1 %5, label %6, label %14

6:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !187)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !190
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %7, align 8, !tbaa !35, !alias.scope !190
  %8 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %9 = icmp eq ptr %8, null
  br i1 %9, label %11, label %10

10:                                               ; preds = %6
  store i8 0, ptr %8, align 1, !noalias !190
  br label %11

11:                                               ; preds = %10, %6
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %8, ptr %12, align 8, !tbaa !46, !alias.scope !190
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %13, i8 0, i64 16, i1 false), !alias.scope !190
  br label %24

14:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !191)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !191, !noalias !184
  %15 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store double 0.000000e+00, ptr %15, align 8, !tbaa !35, !alias.scope !191, !noalias !184
  %16 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %4) #33, !noalias !194
  %17 = add i64 %16, 1
  %18 = tail call noalias ptr @malloc(i64 noundef %17) #34
  %19 = icmp eq ptr %18, null
  br i1 %19, label %21, label %20

20:                                               ; preds = %14
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %18, ptr nonnull readonly align 1 %4, i64 %17, i1 false), !noalias !194
  br label %21

21:                                               ; preds = %20, %14
  %22 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store ptr %18, ptr %22, align 8, !tbaa !46, !alias.scope !191, !noalias !184
  %23 = getelementptr inbounds nuw i8, ptr %3, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %23, i8 0, i64 16, i1 false), !alias.scope !191, !noalias !184
  tail call void @uh_read_file(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %3)
  br label %24

24:                                               ; preds = %11, %21
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_file_readlines(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !195)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  %6 = tail call fastcc ptr @uh_file_path(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %7 = icmp eq ptr %6, null
  br i1 %7, label %8, label %16

8:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !198)
  store i32 1, ptr %4, align 8, !tbaa !31, !alias.scope !201
  %9 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store double 0.000000e+00, ptr %9, align 8, !tbaa !35, !alias.scope !201
  %10 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %11 = icmp eq ptr %10, null
  br i1 %11, label %13, label %12

12:                                               ; preds = %8
  store i8 0, ptr %10, align 1, !noalias !201
  br label %13

13:                                               ; preds = %12, %8
  %14 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store ptr %10, ptr %14, align 8, !tbaa !46, !alias.scope !201
  %15 = getelementptr inbounds nuw i8, ptr %4, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %15, i8 0, i64 16, i1 false), !alias.scope !201
  br label %26

16:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !202)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !202, !noalias !195
  %17 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store double 0.000000e+00, ptr %17, align 8, !tbaa !35, !alias.scope !202, !noalias !195
  %18 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %6) #33, !noalias !205
  %19 = add i64 %18, 1
  %20 = tail call noalias ptr @malloc(i64 noundef %19) #34
  %21 = icmp eq ptr %20, null
  br i1 %21, label %23, label %22

22:                                               ; preds = %16
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %20, ptr nonnull readonly align 1 %6, i64 %19, i1 false), !noalias !205
  br label %23

23:                                               ; preds = %22, %16
  %24 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store ptr %20, ptr %24, align 8, !tbaa !46, !alias.scope !202, !noalias !195
  %25 = getelementptr inbounds nuw i8, ptr %3, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %25, i8 0, i64 16, i1 false), !alias.scope !202, !noalias !195
  call void @uh_read_file(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %4, ptr noundef nonnull byval(%struct.UhValue) align 8 %3)
  br label %26

26:                                               ; preds = %13, %23
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !206)
  store i32 1, ptr %5, align 8, !tbaa !31, !alias.scope !206
  %27 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store double 0.000000e+00, ptr %27, align 8, !tbaa !35, !alias.scope !206
  %28 = tail call noalias dereferenceable_or_null(2) ptr @malloc(i64 noundef 2) #34
  %29 = icmp eq ptr %28, null
  br i1 %29, label %31, label %30

30:                                               ; preds = %26
  store i16 10, ptr %28, align 1, !noalias !206
  br label %31

31:                                               ; preds = %26, %30
  %32 = getelementptr inbounds nuw i8, ptr %5, i64 16
  store ptr %28, ptr %32, align 8, !tbaa !46, !alias.scope !206
  %33 = getelementptr inbounds nuw i8, ptr %5, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %33, i8 0, i64 16, i1 false), !alias.scope !206
  tail call void @uh_split(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %4, ptr noundef nonnull byval(%struct.UhValue) align 8 %5)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4) #36
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_file_write(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.UhValue, align 8
  %5 = tail call fastcc ptr @uh_file_path(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %6 = icmp eq ptr %5, null
  br i1 %6, label %7, label %9

7:                                                ; preds = %3
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !209
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %8, i8 0, i64 32, i1 false)
  br label %87

9:                                                ; preds = %3
  %10 = load i32, ptr %1, align 8
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %12 = load ptr, ptr %11, align 8
  %13 = icmp eq i32 %10, 3
  %14 = icmp ne ptr %12, null
  %15 = select i1 %13, i1 %14, i1 false
  br i1 %15, label %16, label %77

16:                                               ; preds = %9
  %17 = tail call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %18 = icmp eq ptr %17, null
  br i1 %18, label %20, label %19

19:                                               ; preds = %16
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %17, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.4, i64 5, i1 false), !noalias !212
  br label %20

20:                                               ; preds = %19, %16
  %21 = phi ptr [ @.str, %16 ], [ %17, %19 ]
  %22 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %21) #33, !noalias !215
  %23 = add i64 %22, 1
  %24 = tail call noalias ptr @malloc(i64 noundef %23) #34
  %25 = icmp eq ptr %24, null
  br i1 %25, label %77, label %26

26:                                               ; preds = %20
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %24, ptr nonnull readonly align 1 %21, i64 %23, i1 false), !noalias !215
  %27 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %28 = load i64, ptr %27, align 8, !tbaa !65, !noalias !215
  %29 = icmp eq i64 %28, 0
  br i1 %29, label %41, label %30

30:                                               ; preds = %26
  %31 = load ptr, ptr %12, align 8, !tbaa !68, !noalias !215
  br label %35

32:                                               ; preds = %35
  %33 = add nuw i64 %36, 1
  %34 = icmp eq i64 %33, %28
  br i1 %34, label %41, label %35, !llvm.loop !69

35:                                               ; preds = %32, %30
  %36 = phi i64 [ 0, %30 ], [ %33, %32 ]
  %37 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %31, i64 %36
  %38 = load ptr, ptr %37, align 8, !tbaa !70, !noalias !215
  %39 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %38, ptr noundef nonnull readonly dereferenceable(1) %24) #33, !noalias !215
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %42, label %32

41:                                               ; preds = %32, %26
  tail call void @free(ptr noundef nonnull %24) #36, !noalias !215
  br label %77

42:                                               ; preds = %35
  tail call void @free(ptr noundef nonnull %24) #36, !noalias !215
  %43 = getelementptr inbounds nuw i8, ptr %37, i64 8
  %44 = load i32, ptr %43, align 8, !tbaa !26
  %45 = getelementptr inbounds nuw i8, ptr %37, i64 24
  %46 = load ptr, ptr %45, align 8, !tbaa !28
  %47 = icmp ne i32 %44, 1
  %48 = icmp eq ptr %46, null
  %49 = select i1 %47, i1 true, i1 %48
  br i1 %49, label %77, label %50

50:                                               ; preds = %42
  %51 = load i8, ptr %46, align 1, !tbaa !76
  %52 = icmp eq i8 %51, 97
  br i1 %52, label %53, label %77

53:                                               ; preds = %50
  %54 = load i32, ptr %2, align 8, !tbaa !31
  %55 = icmp eq i32 %54, 1
  %56 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %57 = load ptr, ptr %56, align 8
  %58 = icmp ne ptr %57, null
  %59 = select i1 %55, i1 %58, i1 false
  br i1 %59, label %64, label %60

60:                                               ; preds = %53
  %61 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  %62 = icmp eq ptr %61, null
  %63 = select i1 %62, ptr @.str, ptr %61
  br label %64

64:                                               ; preds = %53, %60
  %65 = phi ptr [ %63, %60 ], [ %57, %53 ]
  %66 = phi ptr [ %61, %60 ], [ null, %53 ]
  %67 = tail call noalias ptr @fopen(ptr noundef nonnull %5, ptr noundef nonnull @.str.6)
  %68 = icmp eq ptr %67, null
  br i1 %68, label %69, label %71

69:                                               ; preds = %64
  tail call void @free(ptr noundef %66) #36
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !218
  %70 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %70, i8 0, i64 32, i1 false)
  br label %87

71:                                               ; preds = %64
  %72 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %65) #33
  %73 = tail call i64 @fwrite(ptr noundef nonnull %65, i64 noundef 1, i64 noundef %72, ptr noundef nonnull %67)
  %74 = tail call i32 @fclose(ptr noundef nonnull %67)
  tail call void @free(ptr noundef %66) #36
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !221
  %75 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 1.000000e+00, ptr %75, align 8, !tbaa !35, !alias.scope !221
  %76 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %76, i8 0, i64 24, i1 false), !alias.scope !221
  br label %87

77:                                               ; preds = %42, %41, %20, %9, %50
  tail call void @llvm.experimental.noalias.scope.decl(metadata !224)
  store i32 1, ptr %4, align 8, !tbaa !31, !alias.scope !224
  %78 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store double 0.000000e+00, ptr %78, align 8, !tbaa !35, !alias.scope !224
  %79 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %5) #33, !noalias !224
  %80 = add i64 %79, 1
  %81 = tail call noalias ptr @malloc(i64 noundef %80) #34
  %82 = icmp eq ptr %81, null
  br i1 %82, label %84, label %83

83:                                               ; preds = %77
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %81, ptr nonnull readonly align 1 %5, i64 %80, i1 false), !noalias !224
  br label %84

84:                                               ; preds = %77, %83
  %85 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store ptr %81, ptr %85, align 8, !tbaa !46, !alias.scope !224
  %86 = getelementptr inbounds nuw i8, ptr %4, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %86, i8 0, i64 16, i1 false), !alias.scope !224
  tail call void @uh_write_file(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %4, ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  br label %87

87:                                               ; preds = %84, %71, %69, %7
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(argmem: write) uwtable
define dso_local void @uh_file_close(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readnone byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #0 {
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !227
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %3, i8 0, i64 32, i1 false), !alias.scope !227
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_syscall(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca [256 x i8], align 16
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 1
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %7 = load ptr, ptr %6, align 8
  %8 = icmp eq ptr %7, null
  %9 = select i1 %5, i1 true, i1 %8
  br i1 %9, label %10, label %18

10:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !230)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !230
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %11, align 8, !tbaa !35, !alias.scope !230
  %12 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %13 = icmp eq ptr %12, null
  br i1 %13, label %15, label %14

14:                                               ; preds = %10
  store i8 0, ptr %12, align 1, !noalias !230
  br label %15

15:                                               ; preds = %10, %14
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %12, ptr %16, align 8, !tbaa !46, !alias.scope !230
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %17, i8 0, i64 16, i1 false), !alias.scope !230
  br label %82

18:                                               ; preds = %2
  %19 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %7, ptr noundef nonnull dereferenceable(9) @.str.7) #33
  %20 = icmp eq i32 %19, 0
  br i1 %20, label %30, label %21

21:                                               ; preds = %18
  %22 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %7, ptr noundef nonnull dereferenceable(10) @.str.8) #33
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %30, label %24

24:                                               ; preds = %21
  %25 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %7, ptr noundef nonnull dereferenceable(7) @.str.9) #33
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %30, label %27

27:                                               ; preds = %24
  %28 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %7, ptr noundef nonnull dereferenceable(5) @.str.10) #33
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %30, label %32

30:                                               ; preds = %27, %24, %21, %18
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !233
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %31, i8 0, i64 32, i1 false), !alias.scope !233
  br label %82

32:                                               ; preds = %27
  %33 = tail call noalias ptr @popen(ptr noundef nonnull %7, ptr noundef nonnull @.str.11)
  %34 = icmp eq ptr %33, null
  br i1 %34, label %35, label %43

35:                                               ; preds = %32
  tail call void @llvm.experimental.noalias.scope.decl(metadata !236)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !236
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %36, align 8, !tbaa !35, !alias.scope !236
  %37 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %38 = icmp eq ptr %37, null
  br i1 %38, label %40, label %39

39:                                               ; preds = %35
  store i8 0, ptr %37, align 1, !noalias !236
  br label %40

40:                                               ; preds = %35, %39
  %41 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %37, ptr %41, align 8, !tbaa !46, !alias.scope !236
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %42, i8 0, i64 16, i1 false), !alias.scope !236
  br label %82

43:                                               ; preds = %32
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #36
  %44 = call ptr @fgets(ptr noundef nonnull %3, i32 noundef 256, ptr noundef nonnull %33)
  %45 = icmp eq ptr %44, null
  br i1 %45, label %46, label %48

46:                                               ; preds = %43
  %47 = call i32 @pclose(ptr noundef nonnull %33)
  br label %76

48:                                               ; preds = %43, %66
  %49 = phi i64 [ %68, %66 ], [ 0, %43 ]
  %50 = phi i64 [ %70, %66 ], [ 0, %43 ]
  %51 = phi ptr [ %67, %66 ], [ null, %43 ]
  %52 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %3) #33
  %53 = add i64 %52, 1
  %54 = add i64 %53, %50
  %55 = icmp ugt i64 %54, %49
  br i1 %55, label %56, label %66

56:                                               ; preds = %48
  %57 = icmp eq i64 %49, 0
  %58 = shl i64 %49, 1
  %59 = select i1 %57, i64 64, i64 %58
  br label %60

60:                                               ; preds = %60, %56
  %61 = phi i64 [ %59, %56 ], [ %63, %60 ]
  %62 = icmp ult i64 %61, %54
  %63 = shl i64 %61, 1
  br i1 %62, label %60, label %64, !llvm.loop !107

64:                                               ; preds = %60
  %65 = call ptr @realloc(ptr noundef %51, i64 noundef %61) #35
  br label %66

66:                                               ; preds = %48, %64
  %67 = phi ptr [ %65, %64 ], [ %51, %48 ]
  %68 = phi i64 [ %61, %64 ], [ %49, %48 ]
  %69 = getelementptr inbounds nuw i8, ptr %67, i64 %50
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %69, ptr nonnull readonly align 16 %3, i64 %53, i1 false)
  %70 = add i64 %52, %50
  %71 = call ptr @fgets(ptr noundef nonnull %3, i32 noundef 256, ptr noundef nonnull %33)
  %72 = icmp eq ptr %71, null
  br i1 %72, label %73, label %48, !llvm.loop !239

73:                                               ; preds = %66
  %74 = call i32 @pclose(ptr noundef nonnull %33)
  %75 = icmp eq ptr %67, null
  br i1 %75, label %76, label %77

76:                                               ; preds = %46, %73
  call void @uh_str(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull @.str)
  br label %81

77:                                               ; preds = %73
  store i32 1, ptr %0, align 8, !tbaa !31
  %78 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %78, align 8, !tbaa !35
  %79 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %67, ptr %79, align 8, !tbaa !46
  %80 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %80, i8 0, i64 16, i1 false)
  br label %81

81:                                               ; preds = %77, %76
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #36
  br label %82

82:                                               ; preds = %40, %81, %30, %15
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @strcmp(ptr noundef captures(none), ptr noundef captures(none)) local_unnamed_addr #15

; Function Attrs: nofree nounwind
declare noalias noundef ptr @popen(ptr noundef readonly captures(none), ptr noundef readonly captures(none)) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef ptr @fgets(ptr noundef writeonly, i32 noundef, ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef i32 @pclose(ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_concat(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = load i32, ptr %1, align 8, !tbaa !31
  %7 = icmp eq i32 %6, 2
  %8 = load i32, ptr %2, align 8
  %9 = icmp eq i32 %8, 2
  %10 = select i1 %7, i1 %9, i1 false
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %12 = load ptr, ptr %11, align 8
  %13 = icmp ne ptr %12, null
  %14 = select i1 %10, i1 %13, i1 false
  %15 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %16 = load ptr, ptr %15, align 8
  %17 = icmp ne ptr %16, null
  %18 = select i1 %14, i1 %17, i1 false
  br i1 %18, label %19, label %90

19:                                               ; preds = %3
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !240
  %20 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %21 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %22 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %20, i8 0, i64 16, i1 false), !alias.scope !240
  store ptr %21, ptr %22, align 8, !tbaa !47, !alias.scope !240
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %23, align 8, !tbaa !48, !alias.scope !240
  %24 = icmp eq ptr %21, null
  br i1 %24, label %125, label %25

25:                                               ; preds = %19
  %26 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %27 = load i64, ptr %26, align 8, !tbaa !49
  %28 = icmp eq i64 %27, 0
  br i1 %28, label %32, label %29

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %21, i64 8
  %31 = getelementptr inbounds nuw i8, ptr %21, i64 16
  br label %42

32:                                               ; preds = %57, %25
  %33 = phi ptr [ null, %25 ], [ %58, %57 ]
  %34 = phi i64 [ 0, %25 ], [ %59, %57 ]
  %35 = phi i64 [ 0, %25 ], [ %61, %57 ]
  %36 = getelementptr inbounds nuw i8, ptr %16, i64 8
  %37 = load i64, ptr %36, align 8, !tbaa !49
  %38 = icmp eq i64 %37, 0
  br i1 %38, label %125, label %39

39:                                               ; preds = %32
  %40 = getelementptr inbounds nuw i8, ptr %21, i64 8
  %41 = getelementptr inbounds nuw i8, ptr %21, i64 16
  br label %66

42:                                               ; preds = %29, %57
  %43 = phi ptr [ null, %29 ], [ %58, %57 ]
  %44 = phi i64 [ 0, %29 ], [ %59, %57 ]
  %45 = phi i64 [ 0, %29 ], [ %61, %57 ]
  %46 = phi i64 [ 0, %29 ], [ %63, %57 ]
  %47 = load ptr, ptr %12, align 8, !tbaa !52
  %48 = getelementptr inbounds nuw %struct.UhValue, ptr %47, i64 %46
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %5, ptr noundef nonnull align 8 dereferenceable(40) %48, i64 40, i1 false)
  %49 = icmp eq i64 %45, %44
  br i1 %49, label %50, label %57

50:                                               ; preds = %42
  %51 = icmp eq i64 %44, 0
  %52 = shl i64 %44, 1
  %53 = select i1 %51, i64 8, i64 %52
  %54 = mul i64 %53, 40
  %55 = tail call ptr @realloc(ptr noundef %43, i64 noundef %54) #35
  store ptr %55, ptr %21, align 8, !tbaa !52
  store i64 %53, ptr %31, align 8, !tbaa !51
  %56 = load i64, ptr %30, align 8, !tbaa !49
  br label %57

57:                                               ; preds = %42, %50
  %58 = phi ptr [ %55, %50 ], [ %43, %42 ]
  %59 = phi i64 [ %53, %50 ], [ %44, %42 ]
  %60 = phi i64 [ %56, %50 ], [ %45, %42 ]
  %61 = add i64 %60, 1
  store i64 %61, ptr %30, align 8, !tbaa !49
  %62 = getelementptr inbounds nuw %struct.UhValue, ptr %58, i64 %60
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %62, ptr noundef nonnull readonly align 8 dereferenceable(40) %5, i64 40, i1 false), !tbaa.struct !25
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5)
  %63 = add nuw i64 %46, 1
  %64 = load i64, ptr %26, align 8, !tbaa !49
  %65 = icmp ult i64 %63, %64
  br i1 %65, label %42, label %32, !llvm.loop !243

66:                                               ; preds = %39, %81
  %67 = phi ptr [ %33, %39 ], [ %82, %81 ]
  %68 = phi i64 [ %34, %39 ], [ %83, %81 ]
  %69 = phi i64 [ %35, %39 ], [ %85, %81 ]
  %70 = phi i64 [ 0, %39 ], [ %87, %81 ]
  %71 = load ptr, ptr %16, align 8, !tbaa !52
  %72 = getelementptr inbounds nuw %struct.UhValue, ptr %71, i64 %70
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %4, ptr noundef nonnull align 8 dereferenceable(40) %72, i64 40, i1 false)
  %73 = icmp eq i64 %69, %68
  br i1 %73, label %74, label %81

74:                                               ; preds = %66
  %75 = icmp eq i64 %68, 0
  %76 = shl i64 %68, 1
  %77 = select i1 %75, i64 8, i64 %76
  %78 = mul i64 %77, 40
  %79 = tail call ptr @realloc(ptr noundef %67, i64 noundef %78) #35
  store ptr %79, ptr %21, align 8, !tbaa !52
  store i64 %77, ptr %41, align 8, !tbaa !51
  %80 = load i64, ptr %40, align 8, !tbaa !49
  br label %81

81:                                               ; preds = %66, %74
  %82 = phi ptr [ %79, %74 ], [ %67, %66 ]
  %83 = phi i64 [ %77, %74 ], [ %68, %66 ]
  %84 = phi i64 [ %80, %74 ], [ %69, %66 ]
  %85 = add i64 %84, 1
  store i64 %85, ptr %40, align 8, !tbaa !49
  %86 = getelementptr inbounds nuw %struct.UhValue, ptr %82, i64 %84
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %86, ptr noundef nonnull readonly align 8 dereferenceable(40) %4, i64 40, i1 false), !tbaa.struct !25
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  %87 = add nuw i64 %70, 1
  %88 = load i64, ptr %36, align 8, !tbaa !49
  %89 = icmp ult i64 %87, %88
  br i1 %89, label %66, label %125, !llvm.loop !244

90:                                               ; preds = %3
  %91 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %92 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  %93 = icmp eq ptr %91, null
  br i1 %93, label %96, label %94

94:                                               ; preds = %90
  %95 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %91) #33
  br label %96

96:                                               ; preds = %90, %94
  %97 = phi i64 [ %95, %94 ], [ 0, %90 ]
  %98 = icmp eq ptr %92, null
  br i1 %98, label %101, label %99

99:                                               ; preds = %96
  %100 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %92) #33
  br label %101

101:                                              ; preds = %96, %99
  %102 = phi i64 [ %100, %99 ], [ 0, %96 ]
  %103 = add i64 %102, %97
  %104 = add i64 %103, 1
  %105 = tail call noalias ptr @malloc(i64 noundef %104) #34
  %106 = icmp eq ptr %105, null
  br i1 %106, label %107, label %115

107:                                              ; preds = %101
  tail call void @free(ptr noundef %91) #36
  tail call void @free(ptr noundef %92) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !245)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !245
  %108 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %108, align 8, !tbaa !35, !alias.scope !245
  %109 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %110 = icmp eq ptr %109, null
  br i1 %110, label %112, label %111

111:                                              ; preds = %107
  store i8 0, ptr %109, align 1, !noalias !245
  br label %112

112:                                              ; preds = %107, %111
  %113 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %109, ptr %113, align 8, !tbaa !46, !alias.scope !245
  %114 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %114, i8 0, i64 16, i1 false), !alias.scope !245
  br label %125

115:                                              ; preds = %101
  br i1 %93, label %117, label %116

116:                                              ; preds = %115
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %105, ptr nonnull align 1 %91, i64 %97, i1 false)
  br label %117

117:                                              ; preds = %116, %115
  br i1 %98, label %120, label %118

118:                                              ; preds = %117
  %119 = getelementptr inbounds nuw i8, ptr %105, i64 %97
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %119, ptr nonnull align 1 %92, i64 %102, i1 false)
  br label %120

120:                                              ; preds = %118, %117
  %121 = getelementptr inbounds nuw i8, ptr %105, i64 %103
  store i8 0, ptr %121, align 1, !tbaa !76
  tail call void @free(ptr noundef %91) #36
  tail call void @free(ptr noundef %92) #36
  store i32 1, ptr %0, align 8, !tbaa !31
  %122 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %122, align 8, !tbaa !35
  %123 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %105, ptr %123, align 8, !tbaa !46
  %124 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %124, i8 0, i64 16, i1 false)
  br label %125

125:                                              ; preds = %81, %32, %112, %120, %19
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_add(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 0
  %6 = load i32, ptr %2, align 8
  %7 = icmp eq i32 %6, 0
  %8 = select i1 %5, i1 %7, i1 false
  br i1 %8, label %9, label %17

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %11 = load double, ptr %10, align 8, !tbaa !35
  %12 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %13 = load double, ptr %12, align 8, !tbaa !35
  %14 = fadd double %11, %13
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !248
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %14, ptr %15, align 8, !tbaa !35, !alias.scope !248
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %16, i8 0, i64 24, i1 false), !alias.scope !248
  br label %24

17:                                               ; preds = %3
  %18 = icmp eq i32 %4, 2
  %19 = icmp eq i32 %6, 2
  %20 = select i1 %18, i1 true, i1 %19
  br i1 %20, label %21, label %22

21:                                               ; preds = %17
  tail call fastcc void @uh_arr_binop(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %2, i8 noundef signext 43)
  br label %24

22:                                               ; preds = %17
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !251
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %23, i8 0, i64 32, i1 false)
  br label %24

24:                                               ; preds = %22, %21, %9
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define internal fastcc void @uh_arr_binop(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2, i8 noundef signext range(i8 42, 48) %3) unnamed_addr #12 {
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !254
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %6 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %5, i8 0, i64 16, i1 false), !alias.scope !254
  store ptr %6, ptr %7, align 8, !tbaa !47, !alias.scope !254
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %8, align 8, !tbaa !48, !alias.scope !254
  %9 = icmp eq ptr %6, null
  br i1 %9, label %176, label %10

10:                                               ; preds = %4
  %11 = load i32, ptr %1, align 8, !tbaa !31
  %12 = icmp eq i32 %11, 2
  %13 = load i32, ptr %2, align 8
  %14 = icmp eq i32 %13, 2
  %15 = select i1 %12, i1 %14, i1 false
  %16 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %17 = load ptr, ptr %16, align 8
  %18 = icmp ne ptr %17, null
  %19 = select i1 %15, i1 %18, i1 false
  %20 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %21 = load ptr, ptr %20, align 8
  %22 = icmp ne ptr %21, null
  %23 = select i1 %19, i1 %22, i1 false
  br i1 %23, label %24, label %74

24:                                               ; preds = %10
  %25 = getelementptr inbounds nuw i8, ptr %17, i64 8
  %26 = load i64, ptr %25, align 8, !tbaa !49
  %27 = getelementptr inbounds nuw i8, ptr %21, i64 8
  %28 = load i64, ptr %27, align 8, !tbaa !49
  %29 = tail call i64 @llvm.umin.i64(i64 %26, i64 %28)
  %30 = icmp eq i64 %29, 0
  br i1 %30, label %176, label %31

31:                                               ; preds = %24
  %32 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %33 = getelementptr inbounds nuw i8, ptr %6, i64 16
  br label %34

34:                                               ; preds = %31, %65
  %35 = phi i64 [ 0, %31 ], [ %72, %65 ]
  %36 = load ptr, ptr %17, align 8, !tbaa !52
  %37 = getelementptr inbounds nuw %struct.UhValue, ptr %36, i64 %35, i32 1
  %38 = load double, ptr %37, align 8, !tbaa !27
  %39 = load ptr, ptr %21, align 8, !tbaa !52
  %40 = getelementptr inbounds nuw %struct.UhValue, ptr %39, i64 %35, i32 1
  %41 = load double, ptr %40, align 8, !tbaa !27
  switch i8 %3, label %52 [
    i8 43, label %42
    i8 45, label %44
    i8 42, label %46
    i8 47, label %48
  ]

42:                                               ; preds = %34
  %43 = fadd double %38, %41
  br label %52

44:                                               ; preds = %34
  %45 = fsub double %38, %41
  br label %52

46:                                               ; preds = %34
  %47 = fmul double %38, %41
  br label %52

48:                                               ; preds = %34
  %49 = fcmp oeq double %41, 0.000000e+00
  %50 = fdiv double %38, %41
  %51 = select i1 %49, double 0.000000e+00, double %50
  br label %52

52:                                               ; preds = %42, %46, %48, %44, %34
  %53 = phi double [ %43, %42 ], [ %45, %44 ], [ %47, %46 ], [ %51, %48 ], [ 0.000000e+00, %34 ]
  %54 = load i64, ptr %32, align 8, !tbaa !49
  %55 = load i64, ptr %33, align 8, !tbaa !51
  %56 = icmp eq i64 %54, %55
  %57 = load ptr, ptr %6, align 8, !tbaa !52
  br i1 %56, label %58, label %65

58:                                               ; preds = %52
  %59 = icmp eq i64 %54, 0
  %60 = shl i64 %54, 1
  %61 = select i1 %59, i64 8, i64 %60
  %62 = mul i64 %61, 40
  %63 = tail call ptr @realloc(ptr noundef %57, i64 noundef %62) #35
  store ptr %63, ptr %6, align 8, !tbaa !52
  store i64 %61, ptr %33, align 8, !tbaa !51
  %64 = load i64, ptr %32, align 8, !tbaa !49
  br label %65

65:                                               ; preds = %52, %58
  %66 = phi i64 [ %64, %58 ], [ %54, %52 ]
  %67 = phi ptr [ %63, %58 ], [ %57, %52 ]
  %68 = add i64 %66, 1
  store i64 %68, ptr %32, align 8, !tbaa !49
  %69 = getelementptr inbounds nuw %struct.UhValue, ptr %67, i64 %66
  store i32 0, ptr %69, align 8, !tbaa !26
  %70 = getelementptr inbounds nuw i8, ptr %69, i64 8
  store double %53, ptr %70, align 8, !tbaa !27
  %71 = getelementptr inbounds nuw i8, ptr %69, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %71, i8 0, i64 24, i1 false)
  %72 = add nuw i64 %35, 1
  %73 = icmp eq i64 %72, %29
  br i1 %73, label %176, label %34, !llvm.loop !257

74:                                               ; preds = %10
  %75 = select i1 %12, i1 %18, i1 false
  %76 = icmp eq i32 %13, 0
  %77 = select i1 %75, i1 %76, i1 false
  br i1 %77, label %78, label %125

78:                                               ; preds = %74
  %79 = getelementptr inbounds nuw i8, ptr %17, i64 8
  %80 = load i64, ptr %79, align 8, !tbaa !49
  %81 = icmp eq i64 %80, 0
  br i1 %81, label %176, label %82

82:                                               ; preds = %78
  %83 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %84 = load double, ptr %83, align 8, !tbaa !35
  %85 = fcmp oeq double %84, 0.000000e+00
  %86 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %87 = getelementptr inbounds nuw i8, ptr %6, i64 16
  br label %88

88:                                               ; preds = %82, %115
  %89 = phi i64 [ 0, %82 ], [ %122, %115 ]
  %90 = load ptr, ptr %17, align 8, !tbaa !52
  %91 = getelementptr inbounds nuw %struct.UhValue, ptr %90, i64 %89, i32 1
  %92 = load double, ptr %91, align 8, !tbaa !35
  switch i8 %3, label %102 [
    i8 43, label %93
    i8 45, label %95
    i8 42, label %97
    i8 47, label %99
  ]

93:                                               ; preds = %88
  %94 = fadd double %92, %84
  br label %102

95:                                               ; preds = %88
  %96 = fsub double %92, %84
  br label %102

97:                                               ; preds = %88
  %98 = fmul double %92, %84
  br label %102

99:                                               ; preds = %88
  %100 = fdiv double %92, %84
  %101 = select i1 %85, double 0.000000e+00, double %100
  br label %102

102:                                              ; preds = %93, %97, %99, %95, %88
  %103 = phi double [ %94, %93 ], [ %96, %95 ], [ %98, %97 ], [ %101, %99 ], [ 0.000000e+00, %88 ]
  %104 = load i64, ptr %86, align 8, !tbaa !49
  %105 = load i64, ptr %87, align 8, !tbaa !51
  %106 = icmp eq i64 %104, %105
  %107 = load ptr, ptr %6, align 8, !tbaa !52
  br i1 %106, label %108, label %115

108:                                              ; preds = %102
  %109 = icmp eq i64 %104, 0
  %110 = shl i64 %104, 1
  %111 = select i1 %109, i64 8, i64 %110
  %112 = mul i64 %111, 40
  %113 = tail call ptr @realloc(ptr noundef %107, i64 noundef %112) #35
  store ptr %113, ptr %6, align 8, !tbaa !52
  store i64 %111, ptr %87, align 8, !tbaa !51
  %114 = load i64, ptr %86, align 8, !tbaa !49
  br label %115

115:                                              ; preds = %102, %108
  %116 = phi i64 [ %114, %108 ], [ %104, %102 ]
  %117 = phi ptr [ %113, %108 ], [ %107, %102 ]
  %118 = add i64 %116, 1
  store i64 %118, ptr %86, align 8, !tbaa !49
  %119 = getelementptr inbounds nuw %struct.UhValue, ptr %117, i64 %116
  store i32 0, ptr %119, align 8, !tbaa !26
  %120 = getelementptr inbounds nuw i8, ptr %119, i64 8
  store double %103, ptr %120, align 8, !tbaa !27
  %121 = getelementptr inbounds nuw i8, ptr %119, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %121, i8 0, i64 24, i1 false)
  %122 = add nuw i64 %89, 1
  %123 = load i64, ptr %79, align 8, !tbaa !49
  %124 = icmp ult i64 %122, %123
  br i1 %124, label %88, label %176, !llvm.loop !258

125:                                              ; preds = %74
  %126 = icmp eq i32 %11, 0
  %127 = select i1 %126, i1 %14, i1 false
  %128 = select i1 %127, i1 %22, i1 false
  br i1 %128, label %129, label %176

129:                                              ; preds = %125
  %130 = getelementptr inbounds nuw i8, ptr %21, i64 8
  %131 = load i64, ptr %130, align 8, !tbaa !49
  %132 = icmp eq i64 %131, 0
  br i1 %132, label %176, label %133

133:                                              ; preds = %129
  %134 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %135 = load double, ptr %134, align 8, !tbaa !35
  %136 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %137 = getelementptr inbounds nuw i8, ptr %6, i64 16
  br label %138

138:                                              ; preds = %133, %166
  %139 = phi i64 [ 0, %133 ], [ %173, %166 ]
  %140 = load ptr, ptr %21, align 8, !tbaa !52
  %141 = getelementptr inbounds nuw %struct.UhValue, ptr %140, i64 %139, i32 1
  %142 = load double, ptr %141, align 8, !tbaa !35
  switch i8 %3, label %153 [
    i8 43, label %143
    i8 45, label %145
    i8 42, label %147
    i8 47, label %149
  ]

143:                                              ; preds = %138
  %144 = fadd double %135, %142
  br label %153

145:                                              ; preds = %138
  %146 = fsub double %135, %142
  br label %153

147:                                              ; preds = %138
  %148 = fmul double %135, %142
  br label %153

149:                                              ; preds = %138
  %150 = fcmp oeq double %142, 0.000000e+00
  %151 = fdiv double %135, %142
  %152 = select i1 %150, double 0.000000e+00, double %151
  br label %153

153:                                              ; preds = %143, %147, %149, %145, %138
  %154 = phi double [ %144, %143 ], [ %146, %145 ], [ %148, %147 ], [ %152, %149 ], [ 0.000000e+00, %138 ]
  %155 = load i64, ptr %136, align 8, !tbaa !49
  %156 = load i64, ptr %137, align 8, !tbaa !51
  %157 = icmp eq i64 %155, %156
  %158 = load ptr, ptr %6, align 8, !tbaa !52
  br i1 %157, label %159, label %166

159:                                              ; preds = %153
  %160 = icmp eq i64 %155, 0
  %161 = shl i64 %155, 1
  %162 = select i1 %160, i64 8, i64 %161
  %163 = mul i64 %162, 40
  %164 = tail call ptr @realloc(ptr noundef %158, i64 noundef %163) #35
  store ptr %164, ptr %6, align 8, !tbaa !52
  store i64 %162, ptr %137, align 8, !tbaa !51
  %165 = load i64, ptr %136, align 8, !tbaa !49
  br label %166

166:                                              ; preds = %153, %159
  %167 = phi i64 [ %165, %159 ], [ %155, %153 ]
  %168 = phi ptr [ %164, %159 ], [ %158, %153 ]
  %169 = add i64 %167, 1
  store i64 %169, ptr %136, align 8, !tbaa !49
  %170 = getelementptr inbounds nuw %struct.UhValue, ptr %168, i64 %167
  store i32 0, ptr %170, align 8, !tbaa !26
  %171 = getelementptr inbounds nuw i8, ptr %170, i64 8
  store double %154, ptr %171, align 8, !tbaa !27
  %172 = getelementptr inbounds nuw i8, ptr %170, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %172, i8 0, i64 24, i1 false)
  %173 = add nuw i64 %139, 1
  %174 = load i64, ptr %130, align 8, !tbaa !49
  %175 = icmp ult i64 %173, %174
  br i1 %175, label %138, label %176, !llvm.loop !259

176:                                              ; preds = %166, %115, %65, %129, %78, %24, %125, %4
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_sub(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 0
  %6 = load i32, ptr %2, align 8
  %7 = icmp eq i32 %6, 0
  %8 = select i1 %5, i1 %7, i1 false
  br i1 %8, label %9, label %17

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %11 = load double, ptr %10, align 8, !tbaa !35
  %12 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %13 = load double, ptr %12, align 8, !tbaa !35
  %14 = fsub double %11, %13
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !260
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %14, ptr %15, align 8, !tbaa !35, !alias.scope !260
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %16, i8 0, i64 24, i1 false), !alias.scope !260
  br label %24

17:                                               ; preds = %3
  %18 = icmp eq i32 %4, 2
  %19 = icmp eq i32 %6, 2
  %20 = select i1 %18, i1 true, i1 %19
  br i1 %20, label %21, label %22

21:                                               ; preds = %17
  tail call fastcc void @uh_arr_binop(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %2, i8 noundef signext 45)
  br label %24

22:                                               ; preds = %17
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !263
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %23, i8 0, i64 32, i1 false)
  br label %24

24:                                               ; preds = %22, %21, %9
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_mul(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 0
  %6 = load i32, ptr %2, align 8
  %7 = icmp eq i32 %6, 0
  %8 = select i1 %5, i1 %7, i1 false
  br i1 %8, label %9, label %17

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %11 = load double, ptr %10, align 8, !tbaa !35
  %12 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %13 = load double, ptr %12, align 8, !tbaa !35
  %14 = fmul double %11, %13
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !266
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %14, ptr %15, align 8, !tbaa !35, !alias.scope !266
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %16, i8 0, i64 24, i1 false), !alias.scope !266
  br label %24

17:                                               ; preds = %3
  %18 = icmp eq i32 %4, 2
  %19 = icmp eq i32 %6, 2
  %20 = select i1 %18, i1 true, i1 %19
  br i1 %20, label %21, label %22

21:                                               ; preds = %17
  tail call fastcc void @uh_arr_binop(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %2, i8 noundef signext 42)
  br label %24

22:                                               ; preds = %17
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !269
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %23, i8 0, i64 32, i1 false)
  br label %24

24:                                               ; preds = %22, %21, %9
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_div(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 0
  %6 = load i32, ptr %2, align 8
  %7 = icmp eq i32 %6, 0
  %8 = select i1 %5, i1 %7, i1 false
  br i1 %8, label %9, label %19

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %11 = load double, ptr %10, align 8, !tbaa !35
  %12 = fcmp oeq double %11, 0.000000e+00
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %14 = load double, ptr %13, align 8
  %15 = fdiv double %14, %11
  %16 = select i1 %12, double 0.000000e+00, double %15
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !272
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %16, ptr %17, align 8, !tbaa !35, !alias.scope !272
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %18, i8 0, i64 24, i1 false), !alias.scope !272
  br label %26

19:                                               ; preds = %3
  %20 = icmp eq i32 %4, 2
  %21 = icmp eq i32 %6, 2
  %22 = select i1 %20, i1 true, i1 %21
  br i1 %22, label %23, label %24

23:                                               ; preds = %19
  tail call fastcc void @uh_arr_binop(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %2, i8 noundef signext 47)
  br label %26

24:                                               ; preds = %19
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !275
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %25, i8 0, i64 32, i1 false)
  br label %26

26:                                               ; preds = %24, %23, %9
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_stringify(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  store i32 1, ptr %0, align 8, !tbaa !31
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %4, align 8, !tbaa !35
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %3, ptr %5, align 8, !tbaa !46
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %6, i8 0, i64 16, i1 false)
  ret void
}

; Function Attrs: mustprogress nofree nounwind sspstrong willreturn uwtable
define dso_local void @uh_type(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #9 {
  %3 = load i32, ptr %1, align 8, !tbaa !31
  switch i32 %3, label %40 [
    i32 4, label %4
    i32 0, label %9
    i32 1, label %25
    i32 2, label %30
    i32 3, label %35
  ]

4:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !278)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !278
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %5, align 8, !tbaa !35, !alias.scope !278
  %6 = tail call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %7 = icmp eq ptr %6, null
  br i1 %7, label %45, label %8

8:                                                ; preds = %4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %6, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.12, i64 5, i1 false), !noalias !278
  br label %45

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %11 = load double, ptr %10, align 8, !tbaa !35
  %12 = tail call double @llvm.floor.f64(double %11)
  %13 = fsub double %11, %12
  %14 = tail call double @llvm.fabs.f64(double %13)
  %15 = fcmp olt double %14, 1.000000e-09
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 8
  br i1 %15, label %17, label %21

17:                                               ; preds = %9
  tail call void @llvm.experimental.noalias.scope.decl(metadata !281)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !281
  store double 0.000000e+00, ptr %16, align 8, !tbaa !35, !alias.scope !281
  %18 = tail call noalias dereferenceable_or_null(4) ptr @malloc(i64 noundef 4) #34
  %19 = icmp eq ptr %18, null
  br i1 %19, label %45, label %20

20:                                               ; preds = %17
  store i32 7630441, ptr %18, align 1, !noalias !281
  br label %45

21:                                               ; preds = %9
  tail call void @llvm.experimental.noalias.scope.decl(metadata !284)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !284
  store double 0.000000e+00, ptr %16, align 8, !tbaa !35, !alias.scope !284
  %22 = tail call noalias dereferenceable_or_null(6) ptr @malloc(i64 noundef 6) #34
  %23 = icmp eq ptr %22, null
  br i1 %23, label %45, label %24

24:                                               ; preds = %21
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %22, ptr noundef nonnull readonly align 1 dereferenceable(6) @.str.14, i64 6, i1 false), !noalias !284
  br label %45

25:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !287)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !287
  %26 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %26, align 8, !tbaa !35, !alias.scope !287
  %27 = tail call noalias dereferenceable_or_null(4) ptr @malloc(i64 noundef 4) #34
  %28 = icmp eq ptr %27, null
  br i1 %28, label %45, label %29

29:                                               ; preds = %25
  store i32 7500915, ptr %27, align 1, !noalias !287
  br label %45

30:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !290)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !290
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %31, align 8, !tbaa !35, !alias.scope !290
  %32 = tail call noalias dereferenceable_or_null(6) ptr @malloc(i64 noundef 6) #34
  %33 = icmp eq ptr %32, null
  br i1 %33, label %45, label %34

34:                                               ; preds = %30
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %32, ptr noundef nonnull readonly align 1 dereferenceable(6) @.str.16, i64 6, i1 false), !noalias !290
  br label %45

35:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !293)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !293
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %36, align 8, !tbaa !35, !alias.scope !293
  %37 = tail call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %38 = icmp eq ptr %37, null
  br i1 %38, label %45, label %39

39:                                               ; preds = %35
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %37, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.17, i64 5, i1 false), !noalias !293
  br label %45

40:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !296)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !296
  %41 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %41, align 8, !tbaa !35, !alias.scope !296
  %42 = tail call noalias dereferenceable_or_null(8) ptr @malloc(i64 noundef 8) #34
  %43 = icmp eq ptr %42, null
  br i1 %43, label %45, label %44

44:                                               ; preds = %40
  store i64 31093567915781749, ptr %42, align 1, !noalias !296
  br label %45

45:                                               ; preds = %44, %40, %39, %35, %34, %30, %29, %25, %24, %21, %20, %17, %8, %4
  %46 = phi ptr [ %6, %4 ], [ %6, %8 ], [ %18, %17 ], [ %18, %20 ], [ %22, %21 ], [ %22, %24 ], [ %27, %25 ], [ %27, %29 ], [ %32, %30 ], [ %32, %34 ], [ %37, %35 ], [ %37, %39 ], [ %42, %40 ], [ %42, %44 ]
  %47 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %46, ptr %47, align 8, !tbaa !46
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %48, i8 0, i64 16, i1 false)
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.floor.f64(double) #17

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fabs.f64(double) #17

; Function Attrs: mustprogress nofree norecurse nounwind sspstrong willreturn uwtable
define dso_local void @uh_int(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #18 {
  %3 = alloca ptr, align 8
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %13

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %8 = load double, ptr %7, align 8, !tbaa !35
  %9 = fptosi double %8 to i64
  %10 = sitofp i64 %9 to double
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !299
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %10, ptr %11, align 8, !tbaa !35, !alias.scope !299
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %12, i8 0, i64 24, i1 false), !alias.scope !299
  br label %26

13:                                               ; preds = %2
  %14 = icmp eq i32 %4, 1
  %15 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %16 = load ptr, ptr %15, align 8
  %17 = icmp ne ptr %16, null
  %18 = select i1 %14, i1 %17, i1 false
  br i1 %18, label %19, label %24

19:                                               ; preds = %13
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #36
  store ptr null, ptr %3, align 8, !tbaa !28
  %20 = call i64 @strtol(ptr noundef nonnull %16, ptr noundef nonnull %3, i32 noundef 10) #36
  %21 = sitofp i64 %20 to double
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !302
  %22 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %21, ptr %22, align 8, !tbaa !35, !alias.scope !302
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %23, i8 0, i64 24, i1 false), !alias.scope !302
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #36
  br label %26

24:                                               ; preds = %13
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !305
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %25, i8 0, i64 32, i1 false)
  br label %26

26:                                               ; preds = %24, %19, %6
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn
declare i64 @strtol(ptr noundef readonly, ptr noundef captures(none), i32 noundef) local_unnamed_addr #19

; Function Attrs: mustprogress nofree norecurse nounwind sspstrong willreturn uwtable
define dso_local void @uh_float(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #18 {
  %3 = alloca ptr, align 8
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %2
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %1, i64 40, i1 false), !tbaa.struct !25
  br label %19

7:                                                ; preds = %2
  %8 = icmp eq i32 %4, 1
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %10 = load ptr, ptr %9, align 8
  %11 = icmp ne ptr %10, null
  %12 = select i1 %8, i1 %11, i1 false
  br i1 %12, label %13, label %17

13:                                               ; preds = %7
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #36
  store ptr null, ptr %3, align 8, !tbaa !28
  %14 = call double @strtod(ptr noundef nonnull %10, ptr noundef nonnull %3) #36
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !308
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %14, ptr %15, align 8, !tbaa !35, !alias.scope !308
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %16, i8 0, i64 24, i1 false), !alias.scope !308
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #36
  br label %19

17:                                               ; preds = %7
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !311
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %18, i8 0, i64 32, i1 false)
  br label %19

19:                                               ; preds = %17, %13, %6
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn
declare double @strtod(ptr noundef readonly, ptr noundef captures(none)) local_unnamed_addr #19

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_upper(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %1, align 8, !tbaa !31
  %4 = icmp ne i32 %3, 1
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %6 = load ptr, ptr %5, align 8
  %7 = icmp eq ptr %6, null
  %8 = select i1 %4, i1 true, i1 %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !314)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !314
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %10, align 8, !tbaa !35, !alias.scope !314
  %11 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %12 = icmp eq ptr %11, null
  br i1 %12, label %14, label %13

13:                                               ; preds = %9
  store i8 0, ptr %11, align 1, !noalias !314
  br label %14

14:                                               ; preds = %9, %13
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %11, ptr %15, align 8, !tbaa !46, !alias.scope !314
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %16, i8 0, i64 16, i1 false), !alias.scope !314
  br label %103

17:                                               ; preds = %2
  %18 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %6) #33
  %19 = add i64 %18, 1
  %20 = tail call noalias ptr @malloc(i64 noundef %19) #34
  %21 = icmp eq ptr %20, null
  br i1 %21, label %31, label %22

22:                                               ; preds = %17
  %23 = icmp eq i64 %18, 0
  br i1 %23, label %55, label %24

24:                                               ; preds = %22
  %25 = tail call ptr @__ctype_toupper_loc() #37
  %26 = load ptr, ptr %25, align 8, !tbaa !317
  %27 = and i64 %18, 3
  %28 = icmp ult i64 %18, 4
  br i1 %28, label %39, label %29

29:                                               ; preds = %24
  %30 = and i64 %18, -4
  br label %66

31:                                               ; preds = %17
  tail call void @llvm.experimental.noalias.scope.decl(metadata !319)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !319
  %32 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %32, align 8, !tbaa !35, !alias.scope !319
  %33 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %34 = icmp eq ptr %33, null
  br i1 %34, label %36, label %35

35:                                               ; preds = %31
  store i8 0, ptr %33, align 1, !noalias !319
  br label %36

36:                                               ; preds = %31, %35
  %37 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %33, ptr %37, align 8, !tbaa !46, !alias.scope !319
  %38 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %38, i8 0, i64 16, i1 false), !alias.scope !319
  br label %103

39:                                               ; preds = %66, %24
  %40 = phi i64 [ 0, %24 ], [ %100, %66 ]
  %41 = icmp eq i64 %27, 0
  br i1 %41, label %55, label %42

42:                                               ; preds = %39, %42
  %43 = phi i64 [ %52, %42 ], [ %40, %39 ]
  %44 = phi i64 [ %53, %42 ], [ 0, %39 ]
  %45 = getelementptr inbounds nuw i8, ptr %6, i64 %43
  %46 = load i8, ptr %45, align 1, !tbaa !76
  %47 = zext i8 %46 to i64
  %48 = getelementptr inbounds nuw i32, ptr %26, i64 %47
  %49 = load i32, ptr %48, align 4, !tbaa !26
  %50 = trunc i32 %49 to i8
  %51 = getelementptr inbounds nuw i8, ptr %20, i64 %43
  store i8 %50, ptr %51, align 1, !tbaa !76
  %52 = add nuw i64 %43, 1
  %53 = add i64 %44, 1
  %54 = icmp eq i64 %53, %27
  br i1 %54, label %55, label %42, !llvm.loop !322

55:                                               ; preds = %39, %42, %22
  %56 = getelementptr inbounds nuw i8, ptr %20, i64 %18
  store i8 0, ptr %56, align 1, !tbaa !76
  tail call void @llvm.experimental.noalias.scope.decl(metadata !324)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !324
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %57, align 8, !tbaa !35, !alias.scope !324
  %58 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %20) #33, !noalias !324
  %59 = add i64 %58, 1
  %60 = tail call noalias ptr @malloc(i64 noundef %59) #34
  %61 = icmp eq ptr %60, null
  br i1 %61, label %63, label %62

62:                                               ; preds = %55
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %60, ptr nonnull readonly align 1 %20, i64 %59, i1 false), !noalias !324
  br label %63

63:                                               ; preds = %55, %62
  %64 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %60, ptr %64, align 8, !tbaa !46, !alias.scope !324
  %65 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %65, i8 0, i64 16, i1 false), !alias.scope !324
  tail call void @free(ptr noundef nonnull %20) #36
  br label %103

66:                                               ; preds = %66, %29
  %67 = phi i64 [ 0, %29 ], [ %100, %66 ]
  %68 = phi i64 [ 0, %29 ], [ %101, %66 ]
  %69 = getelementptr inbounds nuw i8, ptr %6, i64 %67
  %70 = load i8, ptr %69, align 1, !tbaa !76
  %71 = zext i8 %70 to i64
  %72 = getelementptr inbounds nuw i32, ptr %26, i64 %71
  %73 = load i32, ptr %72, align 4, !tbaa !26
  %74 = trunc i32 %73 to i8
  %75 = getelementptr inbounds nuw i8, ptr %20, i64 %67
  store i8 %74, ptr %75, align 1, !tbaa !76
  %76 = or disjoint i64 %67, 1
  %77 = getelementptr inbounds nuw i8, ptr %6, i64 %76
  %78 = load i8, ptr %77, align 1, !tbaa !76
  %79 = zext i8 %78 to i64
  %80 = getelementptr inbounds nuw i32, ptr %26, i64 %79
  %81 = load i32, ptr %80, align 4, !tbaa !26
  %82 = trunc i32 %81 to i8
  %83 = getelementptr inbounds nuw i8, ptr %20, i64 %76
  store i8 %82, ptr %83, align 1, !tbaa !76
  %84 = or disjoint i64 %67, 2
  %85 = getelementptr inbounds nuw i8, ptr %6, i64 %84
  %86 = load i8, ptr %85, align 1, !tbaa !76
  %87 = zext i8 %86 to i64
  %88 = getelementptr inbounds nuw i32, ptr %26, i64 %87
  %89 = load i32, ptr %88, align 4, !tbaa !26
  %90 = trunc i32 %89 to i8
  %91 = getelementptr inbounds nuw i8, ptr %20, i64 %84
  store i8 %90, ptr %91, align 1, !tbaa !76
  %92 = or disjoint i64 %67, 3
  %93 = getelementptr inbounds nuw i8, ptr %6, i64 %92
  %94 = load i8, ptr %93, align 1, !tbaa !76
  %95 = zext i8 %94 to i64
  %96 = getelementptr inbounds nuw i32, ptr %26, i64 %95
  %97 = load i32, ptr %96, align 4, !tbaa !26
  %98 = trunc i32 %97 to i8
  %99 = getelementptr inbounds nuw i8, ptr %20, i64 %92
  store i8 %98, ptr %99, align 1, !tbaa !76
  %100 = add nuw i64 %67, 4
  %101 = add i64 %68, 4
  %102 = icmp eq i64 %101, %30
  br i1 %102, label %39, label %66, !llvm.loop !327

103:                                              ; preds = %36, %63, %14
  ret void
}

; Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
declare ptr @__ctype_toupper_loc() local_unnamed_addr #20

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_lower(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %1, align 8, !tbaa !31
  %4 = icmp ne i32 %3, 1
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %6 = load ptr, ptr %5, align 8
  %7 = icmp eq ptr %6, null
  %8 = select i1 %4, i1 true, i1 %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !328)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !328
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %10, align 8, !tbaa !35, !alias.scope !328
  %11 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %12 = icmp eq ptr %11, null
  br i1 %12, label %14, label %13

13:                                               ; preds = %9
  store i8 0, ptr %11, align 1, !noalias !328
  br label %14

14:                                               ; preds = %9, %13
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %11, ptr %15, align 8, !tbaa !46, !alias.scope !328
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %16, i8 0, i64 16, i1 false), !alias.scope !328
  br label %103

17:                                               ; preds = %2
  %18 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %6) #33
  %19 = add i64 %18, 1
  %20 = tail call noalias ptr @malloc(i64 noundef %19) #34
  %21 = icmp eq ptr %20, null
  br i1 %21, label %31, label %22

22:                                               ; preds = %17
  %23 = icmp eq i64 %18, 0
  br i1 %23, label %55, label %24

24:                                               ; preds = %22
  %25 = tail call ptr @__ctype_tolower_loc() #37
  %26 = load ptr, ptr %25, align 8, !tbaa !317
  %27 = and i64 %18, 3
  %28 = icmp ult i64 %18, 4
  br i1 %28, label %39, label %29

29:                                               ; preds = %24
  %30 = and i64 %18, -4
  br label %66

31:                                               ; preds = %17
  tail call void @llvm.experimental.noalias.scope.decl(metadata !331)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !331
  %32 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %32, align 8, !tbaa !35, !alias.scope !331
  %33 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %34 = icmp eq ptr %33, null
  br i1 %34, label %36, label %35

35:                                               ; preds = %31
  store i8 0, ptr %33, align 1, !noalias !331
  br label %36

36:                                               ; preds = %31, %35
  %37 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %33, ptr %37, align 8, !tbaa !46, !alias.scope !331
  %38 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %38, i8 0, i64 16, i1 false), !alias.scope !331
  br label %103

39:                                               ; preds = %66, %24
  %40 = phi i64 [ 0, %24 ], [ %100, %66 ]
  %41 = icmp eq i64 %27, 0
  br i1 %41, label %55, label %42

42:                                               ; preds = %39, %42
  %43 = phi i64 [ %52, %42 ], [ %40, %39 ]
  %44 = phi i64 [ %53, %42 ], [ 0, %39 ]
  %45 = getelementptr inbounds nuw i8, ptr %6, i64 %43
  %46 = load i8, ptr %45, align 1, !tbaa !76
  %47 = zext i8 %46 to i64
  %48 = getelementptr inbounds nuw i32, ptr %26, i64 %47
  %49 = load i32, ptr %48, align 4, !tbaa !26
  %50 = trunc i32 %49 to i8
  %51 = getelementptr inbounds nuw i8, ptr %20, i64 %43
  store i8 %50, ptr %51, align 1, !tbaa !76
  %52 = add nuw i64 %43, 1
  %53 = add i64 %44, 1
  %54 = icmp eq i64 %53, %27
  br i1 %54, label %55, label %42, !llvm.loop !334

55:                                               ; preds = %39, %42, %22
  %56 = getelementptr inbounds nuw i8, ptr %20, i64 %18
  store i8 0, ptr %56, align 1, !tbaa !76
  tail call void @llvm.experimental.noalias.scope.decl(metadata !335)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !335
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %57, align 8, !tbaa !35, !alias.scope !335
  %58 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %20) #33, !noalias !335
  %59 = add i64 %58, 1
  %60 = tail call noalias ptr @malloc(i64 noundef %59) #34
  %61 = icmp eq ptr %60, null
  br i1 %61, label %63, label %62

62:                                               ; preds = %55
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %60, ptr nonnull readonly align 1 %20, i64 %59, i1 false), !noalias !335
  br label %63

63:                                               ; preds = %55, %62
  %64 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %60, ptr %64, align 8, !tbaa !46, !alias.scope !335
  %65 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %65, i8 0, i64 16, i1 false), !alias.scope !335
  tail call void @free(ptr noundef nonnull %20) #36
  br label %103

66:                                               ; preds = %66, %29
  %67 = phi i64 [ 0, %29 ], [ %100, %66 ]
  %68 = phi i64 [ 0, %29 ], [ %101, %66 ]
  %69 = getelementptr inbounds nuw i8, ptr %6, i64 %67
  %70 = load i8, ptr %69, align 1, !tbaa !76
  %71 = zext i8 %70 to i64
  %72 = getelementptr inbounds nuw i32, ptr %26, i64 %71
  %73 = load i32, ptr %72, align 4, !tbaa !26
  %74 = trunc i32 %73 to i8
  %75 = getelementptr inbounds nuw i8, ptr %20, i64 %67
  store i8 %74, ptr %75, align 1, !tbaa !76
  %76 = or disjoint i64 %67, 1
  %77 = getelementptr inbounds nuw i8, ptr %6, i64 %76
  %78 = load i8, ptr %77, align 1, !tbaa !76
  %79 = zext i8 %78 to i64
  %80 = getelementptr inbounds nuw i32, ptr %26, i64 %79
  %81 = load i32, ptr %80, align 4, !tbaa !26
  %82 = trunc i32 %81 to i8
  %83 = getelementptr inbounds nuw i8, ptr %20, i64 %76
  store i8 %82, ptr %83, align 1, !tbaa !76
  %84 = or disjoint i64 %67, 2
  %85 = getelementptr inbounds nuw i8, ptr %6, i64 %84
  %86 = load i8, ptr %85, align 1, !tbaa !76
  %87 = zext i8 %86 to i64
  %88 = getelementptr inbounds nuw i32, ptr %26, i64 %87
  %89 = load i32, ptr %88, align 4, !tbaa !26
  %90 = trunc i32 %89 to i8
  %91 = getelementptr inbounds nuw i8, ptr %20, i64 %84
  store i8 %90, ptr %91, align 1, !tbaa !76
  %92 = or disjoint i64 %67, 3
  %93 = getelementptr inbounds nuw i8, ptr %6, i64 %92
  %94 = load i8, ptr %93, align 1, !tbaa !76
  %95 = zext i8 %94 to i64
  %96 = getelementptr inbounds nuw i32, ptr %26, i64 %95
  %97 = load i32, ptr %96, align 4, !tbaa !26
  %98 = trunc i32 %97 to i8
  %99 = getelementptr inbounds nuw i8, ptr %20, i64 %92
  store i8 %98, ptr %99, align 1, !tbaa !76
  %100 = add nuw i64 %67, 4
  %101 = add i64 %68, 4
  %102 = icmp eq i64 %101, %30
  br i1 %102, label %39, label %66, !llvm.loop !338

103:                                              ; preds = %36, %63, %14
  ret void
}

; Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
declare ptr @__ctype_tolower_loc() local_unnamed_addr #20

; Function Attrs: mustprogress nofree norecurse nounwind sspstrong willreturn memory(read, argmem: readwrite, inaccessiblemem: none) uwtable
define dso_local void @uh_index_of(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #21 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 1
  %6 = load i32, ptr %2, align 8
  %7 = icmp ne i32 %6, 1
  %8 = select i1 %5, i1 true, i1 %7
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %10 = load ptr, ptr %9, align 8
  %11 = icmp eq ptr %10, null
  %12 = select i1 %8, i1 true, i1 %11
  %13 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %14 = load ptr, ptr %13, align 8
  %15 = icmp eq ptr %14, null
  %16 = select i1 %12, i1 true, i1 %15
  br i1 %16, label %25, label %17

17:                                               ; preds = %3
  %18 = tail call ptr @strstr(ptr noundef nonnull dereferenceable(1) %10, ptr noundef nonnull dereferenceable(1) %14) #33
  %19 = icmp eq ptr %18, null
  br i1 %19, label %25, label %20

20:                                               ; preds = %17
  %21 = ptrtoint ptr %18 to i64
  %22 = ptrtoint ptr %10 to i64
  %23 = sub i64 %21, %22
  %24 = sitofp i64 %23 to double
  br label %25

25:                                               ; preds = %17, %3, %20
  %26 = phi double [ %24, %20 ], [ -1.000000e+00, %3 ], [ -1.000000e+00, %17 ]
  store i32 0, ptr %0, align 8, !tbaa !31
  %27 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %26, ptr %27, align 8, !tbaa !35
  %28 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %28, i8 0, i64 24, i1 false)
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind sspstrong willreturn memory(read, argmem: readwrite, inaccessiblemem: none) uwtable
define dso_local void @uh_starts_with(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #21 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 1
  %6 = load i32, ptr %2, align 8
  %7 = icmp ne i32 %6, 1
  %8 = select i1 %5, i1 true, i1 %7
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %10 = load ptr, ptr %9, align 8
  %11 = icmp eq ptr %10, null
  %12 = select i1 %8, i1 true, i1 %11
  %13 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %14 = load ptr, ptr %13, align 8
  %15 = icmp eq ptr %14, null
  %16 = select i1 %12, i1 true, i1 %15
  br i1 %16, label %17, label %19

17:                                               ; preds = %3
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !339
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %18, i8 0, i64 32, i1 false)
  br label %27

19:                                               ; preds = %3
  %20 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %14) #33
  %21 = tail call i32 @strncmp(ptr noundef nonnull %10, ptr noundef nonnull %14, i64 noundef %20) #33
  %22 = icmp eq i32 %21, 0
  store i32 0, ptr %0, align 8, !tbaa !31
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 8
  br i1 %22, label %24, label %26

24:                                               ; preds = %19
  store double 1.000000e+00, ptr %23, align 8, !tbaa !35, !alias.scope !342
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %25, i8 0, i64 24, i1 false), !alias.scope !342
  br label %27

26:                                               ; preds = %19
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %23, i8 0, i64 32, i1 false)
  br label %27

27:                                               ; preds = %24, %26, %17
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @strncmp(ptr noundef captures(none), ptr noundef captures(none), i64 noundef) local_unnamed_addr #15

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_match(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.re_pattern_buffer, align 8
  %5 = load i32, ptr %1, align 8, !tbaa !31
  %6 = icmp ne i32 %5, 1
  %7 = load i32, ptr %2, align 8
  %8 = icmp ne i32 %7, 1
  %9 = select i1 %6, i1 true, i1 %8
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %11 = load ptr, ptr %10, align 8
  %12 = icmp eq ptr %11, null
  %13 = select i1 %9, i1 true, i1 %12
  %14 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %15 = load ptr, ptr %14, align 8
  %16 = icmp eq ptr %15, null
  %17 = select i1 %13, i1 true, i1 %16
  br i1 %17, label %18, label %20

18:                                               ; preds = %3
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !345
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %19, i8 0, i64 32, i1 false)
  br label %31

20:                                               ; preds = %3
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %4) #36
  %21 = call i32 @regcomp(ptr noundef nonnull %4, ptr noundef nonnull %15, i32 noundef 9) #36
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %23, label %27

23:                                               ; preds = %20
  %24 = call i32 @regexec(ptr noundef nonnull %4, ptr noundef nonnull %11, i64 noundef 0, ptr noundef null, i32 noundef 0) #36
  call void @regfree(ptr noundef nonnull %4) #36
  %25 = icmp eq i32 %24, 0
  %26 = uitofp i1 %25 to double
  br label %27

27:                                               ; preds = %20, %23
  %28 = phi double [ %26, %23 ], [ 0.000000e+00, %20 ]
  %29 = getelementptr inbounds nuw i8, ptr %0, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %29, i8 0, i64 24, i1 false)
  store i32 0, ptr %0, align 8, !tbaa !31
  %30 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %28, ptr %30, align 8, !tbaa !35
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %4) #36
  br label %31

31:                                               ; preds = %27, %18
  ret void
}

declare i32 @regcomp(ptr noundef, ptr noundef, i32 noundef) local_unnamed_addr #22

declare i32 @regexec(ptr noundef, ptr noundef, i64 noundef, ptr noundef, i32 noundef) local_unnamed_addr #22

declare void @regfree(ptr noundef) local_unnamed_addr #22

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_chunk(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 32)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca [20 x i8], align 4
  %6 = alloca [20 x i8], align 4
  %7 = load i32, ptr %1, align 8, !tbaa !31
  %8 = icmp ne i32 %7, 2
  %9 = load i32, ptr %2, align 8
  %10 = icmp ne i32 %9, 0
  %11 = select i1 %8, i1 true, i1 %10
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %13 = load ptr, ptr %12, align 8
  %14 = icmp eq ptr %13, null
  %15 = select i1 %11, i1 true, i1 %14
  br i1 %15, label %16, label %20

16:                                               ; preds = %3
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !348
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %18 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %17, i8 0, i64 16, i1 false), !alias.scope !348
  store ptr %18, ptr %19, align 8, !tbaa !47, !alias.scope !348
  br label %126

20:                                               ; preds = %3
  %21 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %22 = load double, ptr %21, align 8, !tbaa !35
  %23 = fptosi double %22 to i64
  %24 = icmp slt i64 %23, 1
  store i32 2, ptr %0, align 8, !tbaa !31
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %26 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %27 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %25, i8 0, i64 16, i1 false)
  store ptr %26, ptr %27, align 8, !tbaa !47
  %28 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %28, align 8, !tbaa !48
  br i1 %24, label %129, label %29

29:                                               ; preds = %20
  %30 = icmp eq ptr %26, null
  %31 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %32 = getelementptr inbounds nuw i8, ptr %5, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %32, i8 0, i64 16, i1 false)
  %33 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %34 = load i64, ptr %33, align 8, !tbaa !49
  %35 = icmp eq i64 %34, 0
  br i1 %35, label %40, label %36

36:                                               ; preds = %29
  %37 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %38 = getelementptr inbounds nuw i8, ptr %26, i64 16
  %39 = getelementptr inbounds nuw i8, ptr %6, i64 4
  br label %43

40:                                               ; preds = %95, %29
  %41 = phi ptr [ %31, %29 ], [ %96, %95 ]
  %42 = icmp eq ptr %41, null
  br i1 %42, label %129, label %100

43:                                               ; preds = %36, %95
  %44 = phi i64 [ 0, %36 ], [ %97, %95 ]
  %45 = phi ptr [ %31, %36 ], [ %96, %95 ]
  %46 = load ptr, ptr %13, align 8, !tbaa !52
  %47 = getelementptr inbounds nuw %struct.UhValue, ptr %46, i64 %44
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %4, ptr noundef nonnull align 8 dereferenceable(40) %47, i64 40, i1 false)
  %48 = icmp eq ptr %45, null
  br i1 %48, label %68, label %49

49:                                               ; preds = %43
  %50 = getelementptr inbounds nuw i8, ptr %45, i64 8
  %51 = load i64, ptr %50, align 8, !tbaa !49
  %52 = getelementptr inbounds nuw i8, ptr %45, i64 16
  %53 = load i64, ptr %52, align 8, !tbaa !51
  %54 = icmp eq i64 %51, %53
  %55 = load ptr, ptr %45, align 8, !tbaa !52
  br i1 %54, label %56, label %63

56:                                               ; preds = %49
  %57 = icmp eq i64 %51, 0
  %58 = shl i64 %51, 1
  %59 = select i1 %57, i64 8, i64 %58
  %60 = mul i64 %59, 40
  %61 = tail call ptr @realloc(ptr noundef %55, i64 noundef %60) #35
  store ptr %61, ptr %45, align 8, !tbaa !52
  store i64 %59, ptr %52, align 8, !tbaa !51
  %62 = load i64, ptr %50, align 8, !tbaa !49
  br label %63

63:                                               ; preds = %56, %49
  %64 = phi i64 [ %62, %56 ], [ %51, %49 ]
  %65 = phi ptr [ %61, %56 ], [ %55, %49 ]
  %66 = add i64 %64, 1
  store i64 %66, ptr %50, align 8, !tbaa !49
  %67 = getelementptr inbounds nuw %struct.UhValue, ptr %65, i64 %64
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %67, ptr noundef nonnull readonly align 8 dereferenceable(40) %4, i64 40, i1 false), !tbaa.struct !25
  br label %68

68:                                               ; preds = %43, %63
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  %69 = getelementptr inbounds nuw i8, ptr %45, i64 8
  %70 = load i64, ptr %69, align 8, !tbaa !49
  %71 = icmp slt i64 %70, %23
  br i1 %71, label %95, label %72

72:                                               ; preds = %68
  br i1 %30, label %93, label %73

73:                                               ; preds = %72
  %74 = load i64, ptr %37, align 8, !tbaa !49
  %75 = load i64, ptr %38, align 8, !tbaa !51
  %76 = icmp eq i64 %74, %75
  %77 = load ptr, ptr %26, align 8, !tbaa !52
  br i1 %76, label %78, label %85

78:                                               ; preds = %73
  %79 = icmp eq i64 %74, 0
  %80 = shl i64 %74, 1
  %81 = select i1 %79, i64 8, i64 %80
  %82 = mul i64 %81, 40
  %83 = tail call ptr @realloc(ptr noundef %77, i64 noundef %82) #35
  store ptr %83, ptr %26, align 8, !tbaa !52
  store i64 %81, ptr %38, align 8, !tbaa !51
  %84 = load i64, ptr %37, align 8, !tbaa !49
  br label %85

85:                                               ; preds = %78, %73
  %86 = phi i64 [ %84, %78 ], [ %74, %73 ]
  %87 = phi ptr [ %83, %78 ], [ %77, %73 ]
  %88 = add i64 %86, 1
  store i64 %88, ptr %37, align 8, !tbaa !49
  %89 = getelementptr inbounds nuw %struct.UhValue, ptr %87, i64 %86
  store i32 2, ptr %89, align 8, !tbaa !26
  %90 = getelementptr inbounds nuw i8, ptr %89, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(20) %90, ptr noundef nonnull align 4 dereferenceable(20) %5, i64 20, i1 false)
  %91 = getelementptr inbounds nuw i8, ptr %89, i64 24
  store ptr %45, ptr %91, align 8, !tbaa !29
  %92 = getelementptr inbounds nuw i8, ptr %89, i64 32
  store ptr null, ptr %92, align 8, !tbaa !30
  br label %93

93:                                               ; preds = %72, %85
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %6)
  %94 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %39, i8 0, i64 16, i1 false), !alias.scope !351
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(20) %5, ptr noundef nonnull align 4 dereferenceable(20) %6, i64 20, i1 false)
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %6)
  br label %95

95:                                               ; preds = %68, %93
  %96 = phi ptr [ %45, %68 ], [ %94, %93 ]
  %97 = add nuw i64 %44, 1
  %98 = load i64, ptr %33, align 8, !tbaa !49
  %99 = icmp ult i64 %97, %98
  br i1 %99, label %43, label %40, !llvm.loop !354

100:                                              ; preds = %40
  %101 = getelementptr inbounds nuw i8, ptr %41, i64 8
  %102 = load i64, ptr %101, align 8, !tbaa !49
  %103 = icmp eq i64 %102, 0
  %104 = or i1 %103, %30
  br i1 %104, label %129, label %105

105:                                              ; preds = %100
  %106 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %107 = load i64, ptr %106, align 8, !tbaa !49
  %108 = getelementptr inbounds nuw i8, ptr %26, i64 16
  %109 = load i64, ptr %108, align 8, !tbaa !51
  %110 = icmp eq i64 %107, %109
  %111 = load ptr, ptr %26, align 8, !tbaa !52
  br i1 %110, label %112, label %119

112:                                              ; preds = %105
  %113 = icmp eq i64 %107, 0
  %114 = shl i64 %107, 1
  %115 = select i1 %113, i64 8, i64 %114
  %116 = mul i64 %115, 40
  %117 = tail call ptr @realloc(ptr noundef %111, i64 noundef %116) #35
  store ptr %117, ptr %26, align 8, !tbaa !52
  store i64 %115, ptr %108, align 8, !tbaa !51
  %118 = load i64, ptr %106, align 8, !tbaa !49
  br label %119

119:                                              ; preds = %112, %105
  %120 = phi i64 [ %118, %112 ], [ %107, %105 ]
  %121 = phi ptr [ %117, %112 ], [ %111, %105 ]
  %122 = add i64 %120, 1
  store i64 %122, ptr %106, align 8, !tbaa !49
  %123 = getelementptr inbounds nuw %struct.UhValue, ptr %121, i64 %120
  store i32 2, ptr %123, align 8, !tbaa !26
  %124 = getelementptr inbounds nuw i8, ptr %123, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(20) %124, ptr noundef nonnull align 4 dereferenceable(20) %5, i64 20, i1 false)
  %125 = getelementptr inbounds nuw i8, ptr %123, i64 24
  store ptr %41, ptr %125, align 8, !tbaa !29
  br label %126

126:                                              ; preds = %16, %119
  %127 = phi ptr [ %123, %119 ], [ %0, %16 ]
  %128 = getelementptr inbounds nuw i8, ptr %127, i64 32
  store ptr null, ptr %128, align 8, !tbaa !30
  br label %129

129:                                              ; preds = %100, %126, %40, %20
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_format(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !355
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %4, align 8, !tbaa !35, !alias.scope !355
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %3, ptr %5, align 8, !tbaa !46, !alias.scope !355
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %6, i8 0, i64 16, i1 false), !alias.scope !355
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_hex(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %1, align 8, !tbaa !31
  %4 = icmp ne i32 %3, 1
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %6 = load ptr, ptr %5, align 8
  %7 = icmp eq ptr %6, null
  %8 = select i1 %4, i1 true, i1 %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !358)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !358
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %10, align 8, !tbaa !35, !alias.scope !358
  %11 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %12 = icmp eq ptr %11, null
  br i1 %12, label %14, label %13

13:                                               ; preds = %9
  store i8 0, ptr %11, align 1, !noalias !358
  br label %14

14:                                               ; preds = %9, %13
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %11, ptr %15, align 8, !tbaa !46, !alias.scope !358
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %16, i8 0, i64 16, i1 false), !alias.scope !358
  br label %54

17:                                               ; preds = %2
  %18 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %6) #33
  %19 = shl i64 %18, 1
  %20 = or disjoint i64 %19, 1
  %21 = tail call noalias ptr @malloc(i64 noundef %20) #34
  %22 = icmp eq ptr %21, null
  br i1 %22, label %25, label %23

23:                                               ; preds = %17
  %24 = icmp eq i64 %18, 0
  br i1 %24, label %33, label %44

25:                                               ; preds = %17
  tail call void @llvm.experimental.noalias.scope.decl(metadata !361)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !361
  %26 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %26, align 8, !tbaa !35, !alias.scope !361
  %27 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %28 = icmp eq ptr %27, null
  br i1 %28, label %30, label %29

29:                                               ; preds = %25
  store i8 0, ptr %27, align 1, !noalias !361
  br label %30

30:                                               ; preds = %25, %29
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %27, ptr %31, align 8, !tbaa !46, !alias.scope !361
  %32 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %32, i8 0, i64 16, i1 false), !alias.scope !361
  br label %54

33:                                               ; preds = %44, %23
  %34 = getelementptr inbounds nuw i8, ptr %21, i64 %19
  store i8 0, ptr %34, align 1, !tbaa !76
  tail call void @llvm.experimental.noalias.scope.decl(metadata !364)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !364
  %35 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %35, align 8, !tbaa !35, !alias.scope !364
  %36 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %21) #33, !noalias !364
  %37 = add i64 %36, 1
  %38 = tail call noalias ptr @malloc(i64 noundef %37) #34
  %39 = icmp eq ptr %38, null
  br i1 %39, label %41, label %40

40:                                               ; preds = %33
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %38, ptr nonnull readonly align 1 %21, i64 %37, i1 false), !noalias !364
  br label %41

41:                                               ; preds = %33, %40
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %38, ptr %42, align 8, !tbaa !46, !alias.scope !364
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %43, i8 0, i64 16, i1 false), !alias.scope !364
  tail call void @free(ptr noundef nonnull %21) #36
  br label %54

44:                                               ; preds = %23, %44
  %45 = phi i64 [ %52, %44 ], [ 0, %23 ]
  %46 = getelementptr inbounds nuw i8, ptr %6, i64 %45
  %47 = load i8, ptr %46, align 1, !tbaa !76
  %48 = shl i64 %45, 1
  %49 = getelementptr inbounds nuw i8, ptr %21, i64 %48
  %50 = zext i8 %47 to i32
  %51 = tail call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %49, i64 noundef 3, ptr noundef nonnull @.str.19, i32 noundef %50) #36
  %52 = add nuw i64 %45, 1
  %53 = icmp eq i64 %52, %18
  br i1 %53, label %33, label %44, !llvm.loop !367

54:                                               ; preds = %30, %41, %14
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i32 @snprintf(ptr noalias noundef writeonly captures(none), i64 noundef, ptr noundef readonly captures(none), ...) local_unnamed_addr #16

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_time_now(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0) local_unnamed_addr #12 {
  %2 = alloca i64, align 8
  %3 = alloca %struct.tm, align 8
  %4 = alloca [32 x i8], align 16
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #36
  %5 = tail call i64 @time(ptr noundef null) #36
  store i64 %5, ptr %2, align 8, !tbaa !368
  call void @llvm.lifetime.start.p0(i64 56, ptr nonnull %3) #36
  %6 = call ptr @localtime_r(ptr noundef nonnull %2, ptr noundef nonnull %3) #36
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %4) #36
  %7 = call i64 @strftime(ptr noundef nonnull %4, i64 noundef 32, ptr noundef nonnull @.str.20, ptr noundef nonnull %3) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !369)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !369
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %8, align 8, !tbaa !35, !alias.scope !369
  %9 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %4) #33, !noalias !369
  %10 = add i64 %9, 1
  %11 = call noalias ptr @malloc(i64 noundef %10) #34
  %12 = icmp eq ptr %11, null
  br i1 %12, label %14, label %13

13:                                               ; preds = %1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %11, ptr nonnull readonly align 16 %4, i64 %10, i1 false), !noalias !369
  br label %14

14:                                               ; preds = %1, %13
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %11, ptr %15, align 8, !tbaa !46, !alias.scope !369
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %16, i8 0, i64 16, i1 false), !alias.scope !369
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %4) #36
  call void @llvm.lifetime.end.p0(i64 56, ptr nonnull %3) #36
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #36
  ret void
}

; Function Attrs: nounwind
declare i64 @time(ptr noundef) local_unnamed_addr #23

; Function Attrs: nounwind
declare ptr @localtime_r(ptr noundef, ptr noundef) local_unnamed_addr #23

; Function Attrs: nounwind
declare i64 @strftime(ptr noundef, i64 noundef, ptr noundef, ptr noundef) local_unnamed_addr #23

; Function Attrs: mustprogress nofree norecurse nounwind sspstrong willreturn memory(argmem: readwrite, errnomem: write) uwtable
define dso_local void @uh_pow(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #24 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 0
  %6 = load i32, ptr %2, align 8
  %7 = icmp eq i32 %6, 0
  %8 = select i1 %5, i1 %7, i1 false
  br i1 %8, label %9, label %15

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %11 = load double, ptr %10, align 8, !tbaa !35
  %12 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %13 = load double, ptr %12, align 8, !tbaa !35
  %14 = tail call double @pow(double noundef %11, double noundef %13) #36, !tbaa !26
  br label %15

15:                                               ; preds = %3, %9
  %16 = phi double [ %14, %9 ], [ 0.000000e+00, %3 ]
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %17, i8 0, i64 24, i1 false)
  store i32 0, ptr %0, align 8, !tbaa !31
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %16, ptr %18, align 8, !tbaa !35
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(errnomem: write)
declare double @pow(double noundef, double noundef) local_unnamed_addr #25

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_take(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = alloca %struct.UhValue, align 8
  %7 = alloca %struct.UhValue, align 8
  %8 = alloca %struct.UhValue, align 8
  %9 = alloca %struct.UhValue, align 8
  %10 = load i32, ptr %2, align 8, !tbaa !31
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %14, label %12

12:                                               ; preds = %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !372
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %13, i8 0, i64 32, i1 false), !alias.scope !372
  br label %151

14:                                               ; preds = %3
  %15 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %16 = load double, ptr %15, align 8, !tbaa !35
  %17 = fptosi double %16 to i64
  %18 = load i32, ptr %1, align 8, !tbaa !31
  switch i32 %18, label %69 [
    i32 1, label %19
    i32 2, label %71
  ]

19:                                               ; preds = %14
  %20 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %21 = load ptr, ptr %20, align 8, !tbaa !46
  %22 = icmp eq ptr %21, null
  %23 = select i1 %22, ptr @.str, ptr %21
  %24 = load i8, ptr %23, align 1, !tbaa !76
  %25 = icmp eq i8 %24, 0
  br i1 %25, label %49, label %26

26:                                               ; preds = %19, %42
  %27 = phi i8 [ %47, %42 ], [ %24, %19 ]
  %28 = phi i64 [ %44, %42 ], [ 0, %19 ]
  %29 = phi i64 [ %45, %42 ], [ 0, %19 ]
  %30 = zext i8 %27 to i32
  %31 = icmp sgt i8 %27, -1
  br i1 %31, label %42, label %32

32:                                               ; preds = %26
  %33 = and i32 %30, 224
  %34 = icmp eq i32 %33, 192
  br i1 %34, label %42, label %35

35:                                               ; preds = %32
  %36 = and i32 %30, 240
  %37 = icmp eq i32 %36, 224
  br i1 %37, label %42, label %38

38:                                               ; preds = %35
  %39 = and i32 %30, 248
  %40 = icmp eq i32 %39, 240
  %41 = select i1 %40, i64 4, i64 1
  br label %42

42:                                               ; preds = %38, %35, %32, %26
  %43 = phi i64 [ 1, %26 ], [ 2, %32 ], [ 3, %35 ], [ %41, %38 ]
  %44 = add i64 %43, %28
  %45 = add i64 %29, 1
  %46 = getelementptr inbounds nuw i8, ptr %23, i64 %44
  %47 = load i8, ptr %46, align 1, !tbaa !76
  %48 = icmp eq i8 %47, 0
  br i1 %48, label %49, label %26, !llvm.loop !77

49:                                               ; preds = %42, %19
  %50 = phi i64 [ 0, %19 ], [ %45, %42 ]
  %51 = icmp sgt i64 %17, -1
  br i1 %51, label %52, label %58

52:                                               ; preds = %49
  store i32 0, ptr %6, align 8, !tbaa !31, !alias.scope !375
  %53 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %54 = tail call noundef i64 @llvm.smin.i64(i64 range(i64 0, -9223372036854775808) %17, i64 %50)
  %55 = sitofp i64 %54 to double
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %53, i8 0, i64 32, i1 false)
  store i32 0, ptr %7, align 8, !tbaa !31, !alias.scope !378
  %56 = getelementptr inbounds nuw i8, ptr %7, i64 8
  store double %55, ptr %56, align 8, !tbaa !35, !alias.scope !378
  %57 = getelementptr inbounds nuw i8, ptr %7, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %57, i8 0, i64 24, i1 false), !alias.scope !378
  tail call void @uh_substr(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %6, ptr noundef nonnull byval(%struct.UhValue) align 8 %7)
  br label %151

58:                                               ; preds = %49
  %59 = sub nsw i64 0, %17
  %60 = add nsw i64 %50, %17
  %61 = tail call i64 @llvm.smax.i64(i64 %60, i64 0)
  %62 = uitofp nneg i64 %61 to double
  store i32 0, ptr %8, align 8, !tbaa !31, !alias.scope !381
  %63 = getelementptr inbounds nuw i8, ptr %8, i64 8
  store double %62, ptr %63, align 8, !tbaa !35, !alias.scope !381
  %64 = getelementptr inbounds nuw i8, ptr %8, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %64, i8 0, i64 24, i1 false), !alias.scope !381
  %65 = tail call noundef i64 @llvm.smin.i64(i64 range(i64 0, -9223372036854775808) %59, i64 %50)
  %66 = sitofp i64 %65 to double
  store i32 0, ptr %9, align 8, !tbaa !31, !alias.scope !384
  %67 = getelementptr inbounds nuw i8, ptr %9, i64 8
  store double %66, ptr %67, align 8, !tbaa !35, !alias.scope !384
  %68 = getelementptr inbounds nuw i8, ptr %9, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %68, i8 0, i64 24, i1 false), !alias.scope !384
  tail call void @uh_substr(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %8, ptr noundef nonnull byval(%struct.UhValue) align 8 %9)
  br label %151

69:                                               ; preds = %14
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !387
  %70 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %70, i8 0, i64 32, i1 false), !alias.scope !387
  br label %151

71:                                               ; preds = %14
  %72 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %73 = load ptr, ptr %72, align 8, !tbaa !47
  %74 = getelementptr inbounds nuw i8, ptr %73, i64 8
  %75 = load i64, ptr %74, align 8, !tbaa !49
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !390
  %76 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %77 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %78 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %76, i8 0, i64 16, i1 false), !alias.scope !390
  store ptr %77, ptr %78, align 8, !tbaa !47, !alias.scope !390
  %79 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %79, align 8, !tbaa !48, !alias.scope !390
  %80 = icmp eq ptr %77, null
  %81 = icmp sgt i64 %17, -1
  br i1 %81, label %82, label %116

82:                                               ; preds = %71
  %83 = tail call noundef i64 @llvm.smin.i64(i64 range(i64 0, -9223372036854775808) %17, i64 %75)
  %84 = icmp sgt i64 %83, 0
  br i1 %84, label %85, label %151

85:                                               ; preds = %82
  %86 = getelementptr inbounds nuw i8, ptr %77, i64 8
  %87 = getelementptr inbounds nuw i8, ptr %77, i64 16
  br label %88

88:                                               ; preds = %85, %110
  %89 = phi ptr [ null, %85 ], [ %111, %110 ]
  %90 = phi i64 [ 0, %85 ], [ %112, %110 ]
  %91 = phi i64 [ 0, %85 ], [ %113, %110 ]
  %92 = phi i64 [ 0, %85 ], [ %114, %110 ]
  %93 = load ptr, ptr %73, align 8, !tbaa !52
  %94 = getelementptr inbounds nuw %struct.UhValue, ptr %93, i64 %92
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %5, ptr noundef nonnull align 8 dereferenceable(40) %94, i64 40, i1 false)
  br i1 %80, label %110, label %95

95:                                               ; preds = %88
  %96 = icmp eq i64 %91, %90
  br i1 %96, label %97, label %104

97:                                               ; preds = %95
  %98 = icmp eq i64 %90, 0
  %99 = shl i64 %90, 1
  %100 = select i1 %98, i64 8, i64 %99
  %101 = mul i64 %100, 40
  %102 = tail call ptr @realloc(ptr noundef %89, i64 noundef %101) #35
  store ptr %102, ptr %77, align 8, !tbaa !52
  store i64 %100, ptr %87, align 8, !tbaa !51
  %103 = load i64, ptr %86, align 8, !tbaa !49
  br label %104

104:                                              ; preds = %97, %95
  %105 = phi ptr [ %102, %97 ], [ %89, %95 ]
  %106 = phi i64 [ %100, %97 ], [ %90, %95 ]
  %107 = phi i64 [ %103, %97 ], [ %91, %95 ]
  %108 = add i64 %107, 1
  store i64 %108, ptr %86, align 8, !tbaa !49
  %109 = getelementptr inbounds nuw %struct.UhValue, ptr %105, i64 %107
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %109, ptr noundef nonnull readonly align 8 dereferenceable(40) %5, i64 40, i1 false), !tbaa.struct !25
  br label %110

110:                                              ; preds = %88, %104
  %111 = phi ptr [ %89, %88 ], [ %105, %104 ]
  %112 = phi i64 [ %90, %88 ], [ %106, %104 ]
  %113 = phi i64 [ %91, %88 ], [ %108, %104 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5)
  %114 = add nuw nsw i64 %92, 1
  %115 = icmp eq i64 %114, %83
  br i1 %115, label %151, label %88, !llvm.loop !393

116:                                              ; preds = %71
  %117 = icmp sgt i64 %75, 0
  br i1 %117, label %118, label %151

118:                                              ; preds = %116
  %119 = add nsw i64 %75, %17
  %120 = tail call i64 @llvm.smax.i64(i64 %119, i64 0)
  %121 = getelementptr inbounds nuw i8, ptr %77, i64 8
  %122 = getelementptr inbounds nuw i8, ptr %77, i64 16
  br label %123

123:                                              ; preds = %118, %145
  %124 = phi ptr [ null, %118 ], [ %146, %145 ]
  %125 = phi i64 [ 0, %118 ], [ %147, %145 ]
  %126 = phi i64 [ 0, %118 ], [ %148, %145 ]
  %127 = phi i64 [ %120, %118 ], [ %149, %145 ]
  %128 = load ptr, ptr %73, align 8, !tbaa !52
  %129 = getelementptr inbounds nuw %struct.UhValue, ptr %128, i64 %127
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %4, ptr noundef nonnull align 8 dereferenceable(40) %129, i64 40, i1 false)
  br i1 %80, label %145, label %130

130:                                              ; preds = %123
  %131 = icmp eq i64 %126, %125
  br i1 %131, label %132, label %139

132:                                              ; preds = %130
  %133 = icmp eq i64 %125, 0
  %134 = shl i64 %125, 1
  %135 = select i1 %133, i64 8, i64 %134
  %136 = mul i64 %135, 40
  %137 = tail call ptr @realloc(ptr noundef %124, i64 noundef %136) #35
  store ptr %137, ptr %77, align 8, !tbaa !52
  store i64 %135, ptr %122, align 8, !tbaa !51
  %138 = load i64, ptr %121, align 8, !tbaa !49
  br label %139

139:                                              ; preds = %132, %130
  %140 = phi ptr [ %137, %132 ], [ %124, %130 ]
  %141 = phi i64 [ %135, %132 ], [ %125, %130 ]
  %142 = phi i64 [ %138, %132 ], [ %126, %130 ]
  %143 = add i64 %142, 1
  store i64 %143, ptr %121, align 8, !tbaa !49
  %144 = getelementptr inbounds nuw %struct.UhValue, ptr %140, i64 %142
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %144, ptr noundef nonnull readonly align 8 dereferenceable(40) %4, i64 40, i1 false), !tbaa.struct !25
  br label %145

145:                                              ; preds = %123, %139
  %146 = phi ptr [ %124, %123 ], [ %140, %139 ]
  %147 = phi i64 [ %125, %123 ], [ %141, %139 ]
  %148 = phi i64 [ %126, %123 ], [ %143, %139 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  %149 = add nuw nsw i64 %127, 1
  %150 = icmp slt i64 %149, %75
  br i1 %150, label %123, label %151, !llvm.loop !394

151:                                              ; preds = %145, %110, %116, %82, %69, %58, %52, %12
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_drop(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = alloca %struct.UhValue, align 8
  %7 = alloca %struct.UhValue, align 8
  %8 = alloca %struct.UhValue, align 8
  %9 = alloca %struct.UhValue, align 8
  %10 = load i32, ptr %2, align 8, !tbaa !31
  %11 = icmp eq i32 %10, 0
  br i1 %11, label %14, label %12

12:                                               ; preds = %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !395
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %13, i8 0, i64 32, i1 false), !alias.scope !395
  br label %148

14:                                               ; preds = %3
  %15 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %16 = load double, ptr %15, align 8, !tbaa !35
  %17 = fptosi double %16 to i64
  %18 = load i32, ptr %1, align 8, !tbaa !31
  switch i32 %18, label %68 [
    i32 1, label %19
    i32 2, label %70
  ]

19:                                               ; preds = %14
  %20 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %21 = load ptr, ptr %20, align 8, !tbaa !46
  %22 = icmp eq ptr %21, null
  %23 = select i1 %22, ptr @.str, ptr %21
  %24 = load i8, ptr %23, align 1, !tbaa !76
  %25 = icmp eq i8 %24, 0
  br i1 %25, label %49, label %26

26:                                               ; preds = %19, %42
  %27 = phi i8 [ %47, %42 ], [ %24, %19 ]
  %28 = phi i64 [ %44, %42 ], [ 0, %19 ]
  %29 = phi i64 [ %45, %42 ], [ 0, %19 ]
  %30 = zext i8 %27 to i32
  %31 = icmp sgt i8 %27, -1
  br i1 %31, label %42, label %32

32:                                               ; preds = %26
  %33 = and i32 %30, 224
  %34 = icmp eq i32 %33, 192
  br i1 %34, label %42, label %35

35:                                               ; preds = %32
  %36 = and i32 %30, 240
  %37 = icmp eq i32 %36, 224
  br i1 %37, label %42, label %38

38:                                               ; preds = %35
  %39 = and i32 %30, 248
  %40 = icmp eq i32 %39, 240
  %41 = select i1 %40, i64 4, i64 1
  br label %42

42:                                               ; preds = %38, %35, %32, %26
  %43 = phi i64 [ 1, %26 ], [ 2, %32 ], [ 3, %35 ], [ %41, %38 ]
  %44 = add i64 %43, %28
  %45 = add i64 %29, 1
  %46 = getelementptr inbounds nuw i8, ptr %23, i64 %44
  %47 = load i8, ptr %46, align 1, !tbaa !76
  %48 = icmp eq i8 %47, 0
  br i1 %48, label %49, label %26, !llvm.loop !77

49:                                               ; preds = %42, %19
  %50 = phi i64 [ 0, %19 ], [ %45, %42 ]
  %51 = icmp sgt i64 %17, -1
  br i1 %51, label %52, label %61

52:                                               ; preds = %49
  %53 = tail call noundef i64 @llvm.smin.i64(i64 range(i64 0, -9223372036854775808) %17, i64 %50)
  %54 = sitofp i64 %53 to double
  store i32 0, ptr %6, align 8, !tbaa !31, !alias.scope !398
  %55 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store double %54, ptr %55, align 8, !tbaa !35, !alias.scope !398
  %56 = getelementptr inbounds nuw i8, ptr %6, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %56, i8 0, i64 24, i1 false), !alias.scope !398
  %57 = sub nsw i64 %50, %53
  %58 = sitofp i64 %57 to double
  store i32 0, ptr %7, align 8, !tbaa !31, !alias.scope !401
  %59 = getelementptr inbounds nuw i8, ptr %7, i64 8
  store double %58, ptr %59, align 8, !tbaa !35, !alias.scope !401
  %60 = getelementptr inbounds nuw i8, ptr %7, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %60, i8 0, i64 24, i1 false), !alias.scope !401
  tail call void @uh_substr(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %6, ptr noundef nonnull byval(%struct.UhValue) align 8 %7)
  br label %148

61:                                               ; preds = %49
  %62 = add nsw i64 %50, %17
  %63 = tail call i64 @llvm.smax.i64(i64 %62, i64 0)
  store i32 0, ptr %8, align 8, !tbaa !31, !alias.scope !404
  %64 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %65 = uitofp nneg i64 %63 to double
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %64, i8 0, i64 32, i1 false)
  store i32 0, ptr %9, align 8, !tbaa !31, !alias.scope !407
  %66 = getelementptr inbounds nuw i8, ptr %9, i64 8
  store double %65, ptr %66, align 8, !tbaa !35, !alias.scope !407
  %67 = getelementptr inbounds nuw i8, ptr %9, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %67, i8 0, i64 24, i1 false), !alias.scope !407
  tail call void @uh_substr(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %8, ptr noundef nonnull byval(%struct.UhValue) align 8 %9)
  br label %148

68:                                               ; preds = %14
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !410
  %69 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %69, i8 0, i64 32, i1 false), !alias.scope !410
  br label %148

70:                                               ; preds = %14
  %71 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %72 = load ptr, ptr %71, align 8, !tbaa !47
  %73 = getelementptr inbounds nuw i8, ptr %72, i64 8
  %74 = load i64, ptr %73, align 8, !tbaa !49
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !413
  %75 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %76 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %77 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %75, i8 0, i64 16, i1 false), !alias.scope !413
  store ptr %76, ptr %77, align 8, !tbaa !47, !alias.scope !413
  %78 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %78, align 8, !tbaa !48, !alias.scope !413
  %79 = icmp eq ptr %76, null
  %80 = icmp sgt i64 %17, -1
  br i1 %80, label %81, label %114

81:                                               ; preds = %70
  %82 = icmp sgt i64 %74, %17
  br i1 %82, label %83, label %148

83:                                               ; preds = %81
  %84 = getelementptr inbounds nuw i8, ptr %76, i64 8
  %85 = getelementptr inbounds nuw i8, ptr %76, i64 16
  br label %86

86:                                               ; preds = %83, %108
  %87 = phi ptr [ null, %83 ], [ %109, %108 ]
  %88 = phi i64 [ 0, %83 ], [ %110, %108 ]
  %89 = phi i64 [ 0, %83 ], [ %111, %108 ]
  %90 = phi i64 [ %17, %83 ], [ %112, %108 ]
  %91 = load ptr, ptr %72, align 8, !tbaa !52
  %92 = getelementptr inbounds nuw %struct.UhValue, ptr %91, i64 %90
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %5, ptr noundef nonnull align 8 dereferenceable(40) %92, i64 40, i1 false)
  br i1 %79, label %108, label %93

93:                                               ; preds = %86
  %94 = icmp eq i64 %89, %88
  br i1 %94, label %95, label %102

95:                                               ; preds = %93
  %96 = icmp eq i64 %88, 0
  %97 = shl i64 %88, 1
  %98 = select i1 %96, i64 8, i64 %97
  %99 = mul i64 %98, 40
  %100 = tail call ptr @realloc(ptr noundef %87, i64 noundef %99) #35
  store ptr %100, ptr %76, align 8, !tbaa !52
  store i64 %98, ptr %85, align 8, !tbaa !51
  %101 = load i64, ptr %84, align 8, !tbaa !49
  br label %102

102:                                              ; preds = %95, %93
  %103 = phi ptr [ %100, %95 ], [ %87, %93 ]
  %104 = phi i64 [ %98, %95 ], [ %88, %93 ]
  %105 = phi i64 [ %101, %95 ], [ %89, %93 ]
  %106 = add i64 %105, 1
  store i64 %106, ptr %84, align 8, !tbaa !49
  %107 = getelementptr inbounds nuw %struct.UhValue, ptr %103, i64 %105
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %107, ptr noundef nonnull readonly align 8 dereferenceable(40) %5, i64 40, i1 false), !tbaa.struct !25
  br label %108

108:                                              ; preds = %86, %102
  %109 = phi ptr [ %87, %86 ], [ %103, %102 ]
  %110 = phi i64 [ %88, %86 ], [ %104, %102 ]
  %111 = phi i64 [ %89, %86 ], [ %106, %102 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5)
  %112 = add nuw nsw i64 %90, 1
  %113 = icmp eq i64 %112, %74
  br i1 %113, label %148, label %86, !llvm.loop !416

114:                                              ; preds = %70
  %115 = add nsw i64 %74, %17
  %116 = icmp sgt i64 %115, 0
  br i1 %116, label %117, label %148

117:                                              ; preds = %114
  %118 = getelementptr inbounds nuw i8, ptr %76, i64 8
  %119 = getelementptr inbounds nuw i8, ptr %76, i64 16
  br label %120

120:                                              ; preds = %117, %142
  %121 = phi ptr [ null, %117 ], [ %143, %142 ]
  %122 = phi i64 [ 0, %117 ], [ %144, %142 ]
  %123 = phi i64 [ 0, %117 ], [ %145, %142 ]
  %124 = phi i64 [ 0, %117 ], [ %146, %142 ]
  %125 = load ptr, ptr %72, align 8, !tbaa !52
  %126 = getelementptr inbounds nuw %struct.UhValue, ptr %125, i64 %124
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %4, ptr noundef nonnull align 8 dereferenceable(40) %126, i64 40, i1 false)
  br i1 %79, label %142, label %127

127:                                              ; preds = %120
  %128 = icmp eq i64 %123, %122
  br i1 %128, label %129, label %136

129:                                              ; preds = %127
  %130 = icmp eq i64 %122, 0
  %131 = shl i64 %122, 1
  %132 = select i1 %130, i64 8, i64 %131
  %133 = mul i64 %132, 40
  %134 = tail call ptr @realloc(ptr noundef %121, i64 noundef %133) #35
  store ptr %134, ptr %76, align 8, !tbaa !52
  store i64 %132, ptr %119, align 8, !tbaa !51
  %135 = load i64, ptr %118, align 8, !tbaa !49
  br label %136

136:                                              ; preds = %129, %127
  %137 = phi ptr [ %134, %129 ], [ %121, %127 ]
  %138 = phi i64 [ %132, %129 ], [ %122, %127 ]
  %139 = phi i64 [ %135, %129 ], [ %123, %127 ]
  %140 = add i64 %139, 1
  store i64 %140, ptr %118, align 8, !tbaa !49
  %141 = getelementptr inbounds nuw %struct.UhValue, ptr %137, i64 %139
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %141, ptr noundef nonnull readonly align 8 dereferenceable(40) %4, i64 40, i1 false), !tbaa.struct !25
  br label %142

142:                                              ; preds = %120, %136
  %143 = phi ptr [ %121, %120 ], [ %137, %136 ]
  %144 = phi i64 [ %122, %120 ], [ %138, %136 ]
  %145 = phi i64 [ %123, %120 ], [ %140, %136 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  %146 = add nuw nsw i64 %124, 1
  %147 = icmp eq i64 %146, %115
  br i1 %147, label %148, label %120, !llvm.loop !417

148:                                              ; preds = %142, %108, %114, %81, %68, %61, %52, %12
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_reverse(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  %4 = load i32, ptr %1, align 8, !tbaa !31
  switch i32 %4, label %182 [
    i32 2, label %5
    i32 1, label %47
  ]

5:                                                ; preds = %2
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !418
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %7 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %6, i8 0, i64 16, i1 false), !alias.scope !418
  store ptr %7, ptr %8, align 8, !tbaa !47, !alias.scope !418
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %9, align 8, !tbaa !48, !alias.scope !418
  %10 = icmp eq ptr %7, null
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %12 = load ptr, ptr %11, align 8, !tbaa !47
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %14 = load i64, ptr %13, align 8, !tbaa !49
  %15 = icmp sgt i64 %14, 0
  br i1 %15, label %16, label %184

16:                                               ; preds = %5
  %17 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %18 = getelementptr inbounds nuw i8, ptr %7, i64 16
  br label %19

19:                                               ; preds = %16, %42
  %20 = phi ptr [ null, %16 ], [ %43, %42 ]
  %21 = phi i64 [ 0, %16 ], [ %44, %42 ]
  %22 = phi i64 [ 0, %16 ], [ %45, %42 ]
  %23 = phi i64 [ %14, %16 ], [ %24, %42 ]
  %24 = add nsw i64 %23, -1
  %25 = load ptr, ptr %12, align 8, !tbaa !52
  %26 = getelementptr inbounds nuw %struct.UhValue, ptr %25, i64 %24
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %3, ptr noundef nonnull align 8 dereferenceable(40) %26, i64 40, i1 false)
  br i1 %10, label %42, label %27

27:                                               ; preds = %19
  %28 = icmp eq i64 %22, %21
  br i1 %28, label %29, label %36

29:                                               ; preds = %27
  %30 = icmp eq i64 %21, 0
  %31 = shl i64 %21, 1
  %32 = select i1 %30, i64 8, i64 %31
  %33 = mul i64 %32, 40
  %34 = tail call ptr @realloc(ptr noundef %20, i64 noundef %33) #35
  store ptr %34, ptr %7, align 8, !tbaa !52
  store i64 %32, ptr %18, align 8, !tbaa !51
  %35 = load i64, ptr %17, align 8, !tbaa !49
  br label %36

36:                                               ; preds = %29, %27
  %37 = phi ptr [ %34, %29 ], [ %20, %27 ]
  %38 = phi i64 [ %32, %29 ], [ %21, %27 ]
  %39 = phi i64 [ %35, %29 ], [ %22, %27 ]
  %40 = add i64 %39, 1
  store i64 %40, ptr %17, align 8, !tbaa !49
  %41 = getelementptr inbounds nuw %struct.UhValue, ptr %37, i64 %39
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %41, ptr noundef nonnull readonly align 8 dereferenceable(40) %3, i64 40, i1 false), !tbaa.struct !25
  br label %42

42:                                               ; preds = %19, %36
  %43 = phi ptr [ %20, %19 ], [ %37, %36 ]
  %44 = phi i64 [ %21, %19 ], [ %38, %36 ]
  %45 = phi i64 [ %22, %19 ], [ %40, %36 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  %46 = icmp samesign ugt i64 %23, 1
  br i1 %46, label %19, label %184, !llvm.loop !421

47:                                               ; preds = %2
  %48 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %49 = load ptr, ptr %48, align 8, !tbaa !46
  %50 = icmp eq ptr %49, null
  %51 = select i1 %50, ptr @.str, ptr %49
  %52 = load i8, ptr %51, align 1, !tbaa !76
  %53 = icmp eq i8 %52, 0
  br i1 %53, label %77, label %54

54:                                               ; preds = %47, %70
  %55 = phi i8 [ %75, %70 ], [ %52, %47 ]
  %56 = phi i64 [ %72, %70 ], [ 0, %47 ]
  %57 = phi i64 [ %73, %70 ], [ 0, %47 ]
  %58 = zext i8 %55 to i32
  %59 = icmp sgt i8 %55, -1
  br i1 %59, label %70, label %60

60:                                               ; preds = %54
  %61 = and i32 %58, 224
  %62 = icmp eq i32 %61, 192
  br i1 %62, label %70, label %63

63:                                               ; preds = %60
  %64 = and i32 %58, 240
  %65 = icmp eq i32 %64, 224
  br i1 %65, label %70, label %66

66:                                               ; preds = %63
  %67 = and i32 %58, 248
  %68 = icmp eq i32 %67, 240
  %69 = select i1 %68, i64 4, i64 1
  br label %70

70:                                               ; preds = %66, %63, %60, %54
  %71 = phi i64 [ 1, %54 ], [ 2, %60 ], [ 3, %63 ], [ %69, %66 ]
  %72 = add i64 %71, %56
  %73 = add i64 %57, 1
  %74 = getelementptr inbounds nuw i8, ptr %51, i64 %72
  %75 = load i8, ptr %74, align 1, !tbaa !76
  %76 = icmp eq i8 %75, 0
  br i1 %76, label %77, label %54, !llvm.loop !77

77:                                               ; preds = %70, %47
  %78 = phi i64 [ 0, %47 ], [ %73, %70 ]
  %79 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %51) #33
  %80 = add i64 %79, 1
  %81 = tail call noalias ptr @malloc(i64 noundef %80) #34
  %82 = icmp eq ptr %81, null
  br i1 %82, label %85, label %83

83:                                               ; preds = %77
  %84 = icmp sgt i64 %78, 0
  br i1 %84, label %93, label %170

85:                                               ; preds = %77
  tail call void @llvm.experimental.noalias.scope.decl(metadata !422)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !422
  %86 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %86, align 8, !tbaa !35, !alias.scope !422
  %87 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %88 = icmp eq ptr %87, null
  br i1 %88, label %90, label %89

89:                                               ; preds = %85
  store i8 0, ptr %87, align 1, !noalias !422
  br label %90

90:                                               ; preds = %85, %89
  %91 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %87, ptr %91, align 8, !tbaa !46, !alias.scope !422
  %92 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %92, i8 0, i64 16, i1 false), !alias.scope !422
  br label %184

93:                                               ; preds = %83, %162
  %94 = phi i64 [ %168, %162 ], [ 0, %83 ]
  %95 = phi i64 [ %96, %162 ], [ %78, %83 ]
  %96 = add nsw i64 %95, -1
  br i1 %53, label %122, label %97

97:                                               ; preds = %93, %115
  %98 = phi i8 [ %120, %115 ], [ %52, %93 ]
  %99 = phi i64 [ %118, %115 ], [ 0, %93 ]
  %100 = phi i64 [ %117, %115 ], [ 0, %93 ]
  %101 = icmp eq i64 %99, %96
  br i1 %101, label %127, label %102

102:                                              ; preds = %97
  %103 = zext i8 %98 to i32
  %104 = icmp sgt i8 %98, -1
  br i1 %104, label %115, label %105

105:                                              ; preds = %102
  %106 = and i32 %103, 224
  %107 = icmp eq i32 %106, 192
  br i1 %107, label %115, label %108

108:                                              ; preds = %105
  %109 = and i32 %103, 240
  %110 = icmp eq i32 %109, 224
  br i1 %110, label %115, label %111

111:                                              ; preds = %108
  %112 = and i32 %103, 248
  %113 = icmp eq i32 %112, 240
  %114 = select i1 %113, i64 4, i64 1
  br label %115

115:                                              ; preds = %111, %108, %105, %102
  %116 = phi i64 [ 1, %102 ], [ 2, %105 ], [ 3, %108 ], [ %114, %111 ]
  %117 = add i64 %116, %100
  %118 = add nuw nsw i64 %99, 1
  %119 = getelementptr inbounds nuw i8, ptr %51, i64 %117
  %120 = load i8, ptr %119, align 1, !tbaa !76
  %121 = icmp eq i8 %120, 0
  br i1 %121, label %122, label %97, !llvm.loop !120

122:                                              ; preds = %115, %93
  %123 = phi i64 [ 0, %93 ], [ %117, %115 ]
  %124 = phi i64 [ 0, %93 ], [ %118, %115 ]
  %125 = icmp eq i64 %124, %96
  %126 = select i1 %125, i64 %123, i64 -1
  br label %127

127:                                              ; preds = %97, %122
  %128 = phi i64 [ %126, %122 ], [ %100, %97 ]
  br i1 %53, label %154, label %129

129:                                              ; preds = %127, %147
  %130 = phi i8 [ %152, %147 ], [ %52, %127 ]
  %131 = phi i64 [ %150, %147 ], [ 0, %127 ]
  %132 = phi i64 [ %149, %147 ], [ 0, %127 ]
  %133 = icmp eq i64 %131, %95
  br i1 %133, label %159, label %134

134:                                              ; preds = %129
  %135 = zext i8 %130 to i32
  %136 = icmp sgt i8 %130, -1
  br i1 %136, label %147, label %137

137:                                              ; preds = %134
  %138 = and i32 %135, 224
  %139 = icmp eq i32 %138, 192
  br i1 %139, label %147, label %140

140:                                              ; preds = %137
  %141 = and i32 %135, 240
  %142 = icmp eq i32 %141, 224
  br i1 %142, label %147, label %143

143:                                              ; preds = %140
  %144 = and i32 %135, 248
  %145 = icmp eq i32 %144, 240
  %146 = select i1 %145, i64 4, i64 1
  br label %147

147:                                              ; preds = %143, %140, %137, %134
  %148 = phi i64 [ 1, %134 ], [ 2, %137 ], [ 3, %140 ], [ %146, %143 ]
  %149 = add i64 %148, %132
  %150 = add nuw nsw i64 %131, 1
  %151 = getelementptr inbounds nuw i8, ptr %51, i64 %149
  %152 = load i8, ptr %151, align 1, !tbaa !76
  %153 = icmp eq i8 %152, 0
  br i1 %153, label %154, label %129, !llvm.loop !120

154:                                              ; preds = %147, %127
  %155 = phi i64 [ 0, %127 ], [ %149, %147 ]
  %156 = phi i64 [ 0, %127 ], [ %150, %147 ]
  %157 = icmp eq i64 %156, %95
  %158 = select i1 %157, i64 %155, i64 -1
  br label %159

159:                                              ; preds = %129, %154
  %160 = phi i64 [ %158, %154 ], [ %132, %129 ]
  %161 = icmp eq i64 %128, -1
  br i1 %161, label %170, label %162

162:                                              ; preds = %159
  %163 = icmp eq i64 %160, -1
  %164 = select i1 %163, i64 %79, i64 %160
  %165 = sub i64 %164, %128
  %166 = getelementptr inbounds nuw i8, ptr %81, i64 %94
  %167 = getelementptr inbounds nuw i8, ptr %51, i64 %128
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %166, ptr nonnull align 1 %167, i64 %165, i1 false)
  %168 = add i64 %165, %94
  %169 = icmp sgt i64 %95, 1
  br i1 %169, label %93, label %170, !llvm.loop !425

170:                                              ; preds = %162, %159, %83
  %171 = phi i64 [ 0, %83 ], [ %94, %159 ], [ %168, %162 ]
  %172 = getelementptr inbounds nuw i8, ptr %81, i64 %171
  store i8 0, ptr %172, align 1, !tbaa !76
  tail call void @llvm.experimental.noalias.scope.decl(metadata !426)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !426
  %173 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %173, align 8, !tbaa !35, !alias.scope !426
  %174 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %81) #33, !noalias !426
  %175 = add i64 %174, 1
  %176 = tail call noalias ptr @malloc(i64 noundef %175) #34
  %177 = icmp eq ptr %176, null
  br i1 %177, label %179, label %178

178:                                              ; preds = %170
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %176, ptr nonnull readonly align 1 %81, i64 %175, i1 false), !noalias !426
  br label %179

179:                                              ; preds = %170, %178
  %180 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %176, ptr %180, align 8, !tbaa !46, !alias.scope !426
  %181 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %181, i8 0, i64 16, i1 false), !alias.scope !426
  tail call void @free(ptr noundef nonnull %81) #36
  br label %184

182:                                              ; preds = %2
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !429
  %183 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %183, i8 0, i64 32, i1 false), !alias.scope !429
  br label %184

184:                                              ; preds = %42, %5, %90, %179, %182
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_rotate(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = alloca %struct.UhValue, align 8
  %7 = alloca %struct.UhValue, align 8
  %8 = alloca %struct.UhValue, align 8
  %9 = alloca %struct.UhValue, align 8
  %10 = alloca %struct.UhValue, align 8
  %11 = alloca %struct.UhValue, align 8
  %12 = load i32, ptr %2, align 8, !tbaa !31
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %16, label %14

14:                                               ; preds = %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !432
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %15, i8 0, i64 32, i1 false), !alias.scope !432
  br label %163

16:                                               ; preds = %3
  %17 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %18 = load double, ptr %17, align 8, !tbaa !35
  %19 = fptosi double %18 to i64
  %20 = load i32, ptr %1, align 8, !tbaa !31
  switch i32 %20, label %76 [
    i32 1, label %21
    i32 2, label %78
  ]

21:                                               ; preds = %16
  %22 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %23 = load ptr, ptr %22, align 8, !tbaa !46
  %24 = icmp eq ptr %23, null
  %25 = select i1 %24, ptr @.str, ptr %23
  %26 = load i8, ptr %25, align 1, !tbaa !76
  %27 = icmp eq i8 %26, 0
  br i1 %27, label %53, label %28

28:                                               ; preds = %21, %44
  %29 = phi i8 [ %49, %44 ], [ %26, %21 ]
  %30 = phi i64 [ %46, %44 ], [ 0, %21 ]
  %31 = phi i64 [ %47, %44 ], [ 0, %21 ]
  %32 = zext i8 %29 to i32
  %33 = icmp sgt i8 %29, -1
  br i1 %33, label %44, label %34

34:                                               ; preds = %28
  %35 = and i32 %32, 224
  %36 = icmp eq i32 %35, 192
  br i1 %36, label %44, label %37

37:                                               ; preds = %34
  %38 = and i32 %32, 240
  %39 = icmp eq i32 %38, 224
  br i1 %39, label %44, label %40

40:                                               ; preds = %37
  %41 = and i32 %32, 248
  %42 = icmp eq i32 %41, 240
  %43 = select i1 %42, i64 4, i64 1
  br label %44

44:                                               ; preds = %40, %37, %34, %28
  %45 = phi i64 [ 1, %28 ], [ 2, %34 ], [ 3, %37 ], [ %43, %40 ]
  %46 = add i64 %45, %30
  %47 = add i64 %31, 1
  %48 = getelementptr inbounds nuw i8, ptr %25, i64 %46
  %49 = load i8, ptr %48, align 1, !tbaa !76
  %50 = icmp eq i8 %49, 0
  br i1 %50, label %51, label %28, !llvm.loop !77

51:                                               ; preds = %44
  %52 = icmp eq i64 %47, 0
  br i1 %52, label %53, label %61

53:                                               ; preds = %21, %51
  tail call void @llvm.experimental.noalias.scope.decl(metadata !435)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !435
  %54 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %54, align 8, !tbaa !35, !alias.scope !435
  %55 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %56 = icmp eq ptr %55, null
  br i1 %56, label %58, label %57

57:                                               ; preds = %53
  store i8 0, ptr %55, align 1, !noalias !435
  br label %58

58:                                               ; preds = %53, %57
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %55, ptr %59, align 8, !tbaa !46, !alias.scope !435
  %60 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %60, i8 0, i64 16, i1 false), !alias.scope !435
  br label %163

61:                                               ; preds = %51
  %62 = srem i64 %19, %47
  %63 = icmp slt i64 %62, 0
  %64 = select i1 %63, i64 %47, i64 0
  %65 = add nsw i64 %64, %62
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %6) #36
  %66 = sitofp i64 %65 to double
  store i32 0, ptr %7, align 8, !tbaa !31, !alias.scope !438
  %67 = getelementptr inbounds nuw i8, ptr %7, i64 8
  store double %66, ptr %67, align 8, !tbaa !35, !alias.scope !438
  %68 = getelementptr inbounds nuw i8, ptr %7, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %68, i8 0, i64 24, i1 false), !alias.scope !438
  %69 = sub nsw i64 %47, %65
  %70 = sitofp i64 %69 to double
  store i32 0, ptr %8, align 8, !tbaa !31, !alias.scope !441
  %71 = getelementptr inbounds nuw i8, ptr %8, i64 8
  store double %70, ptr %71, align 8, !tbaa !35, !alias.scope !441
  %72 = getelementptr inbounds nuw i8, ptr %8, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %72, i8 0, i64 24, i1 false), !alias.scope !441
  call void @uh_substr(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %6, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %7, ptr noundef nonnull byval(%struct.UhValue) align 8 %8)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %9) #36
  store i32 0, ptr %10, align 8, !tbaa !31, !alias.scope !444
  %73 = getelementptr inbounds nuw i8, ptr %10, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %73, i8 0, i64 32, i1 false)
  store i32 0, ptr %11, align 8, !tbaa !31, !alias.scope !447
  %74 = getelementptr inbounds nuw i8, ptr %11, i64 8
  store double %66, ptr %74, align 8, !tbaa !35, !alias.scope !447
  %75 = getelementptr inbounds nuw i8, ptr %11, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %75, i8 0, i64 24, i1 false), !alias.scope !447
  call void @uh_substr(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %9, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %10, ptr noundef nonnull byval(%struct.UhValue) align 8 %11)
  tail call void @uh_concat(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %6, ptr noundef nonnull byval(%struct.UhValue) align 8 %9)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %9) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %6) #36
  br label %163

76:                                               ; preds = %16
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !450
  %77 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %77, i8 0, i64 32, i1 false), !alias.scope !450
  br label %163

78:                                               ; preds = %16
  %79 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %80 = load ptr, ptr %79, align 8, !tbaa !47
  %81 = getelementptr inbounds nuw i8, ptr %80, i64 8
  %82 = load i64, ptr %81, align 8, !tbaa !49
  %83 = icmp eq i64 %82, 0
  br i1 %83, label %84, label %85

84:                                               ; preds = %78
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %1, i64 40, i1 false), !tbaa.struct !25
  br label %163

85:                                               ; preds = %78
  %86 = srem i64 %19, %82
  %87 = icmp slt i64 %86, 0
  %88 = select i1 %87, i64 %82, i64 0
  %89 = add nsw i64 %88, %86
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !453
  %90 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %91 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %92 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %90, i8 0, i64 16, i1 false), !alias.scope !453
  store ptr %91, ptr %92, align 8, !tbaa !47, !alias.scope !453
  %93 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %93, align 8, !tbaa !48, !alias.scope !453
  %94 = icmp eq ptr %91, null
  %95 = icmp slt i64 %89, %82
  br i1 %95, label %96, label %99

96:                                               ; preds = %85
  %97 = getelementptr inbounds nuw i8, ptr %91, i64 8
  %98 = getelementptr inbounds nuw i8, ptr %91, i64 16
  br label %107

99:                                               ; preds = %129, %85
  %100 = phi ptr [ null, %85 ], [ %130, %129 ]
  %101 = phi i64 [ 0, %85 ], [ %131, %129 ]
  %102 = phi i64 [ 0, %85 ], [ %132, %129 ]
  %103 = icmp sgt i64 %89, 0
  br i1 %103, label %104, label %163

104:                                              ; preds = %99
  %105 = getelementptr inbounds nuw i8, ptr %91, i64 8
  %106 = getelementptr inbounds nuw i8, ptr %91, i64 16
  br label %135

107:                                              ; preds = %96, %129
  %108 = phi ptr [ null, %96 ], [ %130, %129 ]
  %109 = phi i64 [ 0, %96 ], [ %131, %129 ]
  %110 = phi i64 [ 0, %96 ], [ %132, %129 ]
  %111 = phi i64 [ %89, %96 ], [ %133, %129 ]
  %112 = load ptr, ptr %80, align 8, !tbaa !52
  %113 = getelementptr inbounds %struct.UhValue, ptr %112, i64 %111
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %5, ptr noundef nonnull align 8 dereferenceable(40) %113, i64 40, i1 false)
  br i1 %94, label %129, label %114

114:                                              ; preds = %107
  %115 = icmp eq i64 %110, %109
  br i1 %115, label %116, label %123

116:                                              ; preds = %114
  %117 = icmp eq i64 %109, 0
  %118 = shl i64 %109, 1
  %119 = select i1 %117, i64 8, i64 %118
  %120 = mul i64 %119, 40
  %121 = tail call ptr @realloc(ptr noundef %108, i64 noundef %120) #35
  store ptr %121, ptr %91, align 8, !tbaa !52
  store i64 %119, ptr %98, align 8, !tbaa !51
  %122 = load i64, ptr %97, align 8, !tbaa !49
  br label %123

123:                                              ; preds = %116, %114
  %124 = phi ptr [ %121, %116 ], [ %108, %114 ]
  %125 = phi i64 [ %119, %116 ], [ %109, %114 ]
  %126 = phi i64 [ %122, %116 ], [ %110, %114 ]
  %127 = add i64 %126, 1
  store i64 %127, ptr %97, align 8, !tbaa !49
  %128 = getelementptr inbounds nuw %struct.UhValue, ptr %124, i64 %126
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %128, ptr noundef nonnull readonly align 8 dereferenceable(40) %5, i64 40, i1 false), !tbaa.struct !25
  br label %129

129:                                              ; preds = %107, %123
  %130 = phi ptr [ %108, %107 ], [ %124, %123 ]
  %131 = phi i64 [ %109, %107 ], [ %125, %123 ]
  %132 = phi i64 [ %110, %107 ], [ %127, %123 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5)
  %133 = add nsw i64 %111, 1
  %134 = icmp slt i64 %133, %82
  br i1 %134, label %107, label %99, !llvm.loop !456

135:                                              ; preds = %104, %157
  %136 = phi ptr [ %100, %104 ], [ %158, %157 ]
  %137 = phi i64 [ %101, %104 ], [ %159, %157 ]
  %138 = phi i64 [ %102, %104 ], [ %160, %157 ]
  %139 = phi i64 [ 0, %104 ], [ %161, %157 ]
  %140 = load ptr, ptr %80, align 8, !tbaa !52
  %141 = getelementptr inbounds nuw %struct.UhValue, ptr %140, i64 %139
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %4, ptr noundef nonnull align 8 dereferenceable(40) %141, i64 40, i1 false)
  br i1 %94, label %157, label %142

142:                                              ; preds = %135
  %143 = icmp eq i64 %138, %137
  br i1 %143, label %144, label %151

144:                                              ; preds = %142
  %145 = icmp eq i64 %137, 0
  %146 = shl i64 %137, 1
  %147 = select i1 %145, i64 8, i64 %146
  %148 = mul i64 %147, 40
  %149 = tail call ptr @realloc(ptr noundef %136, i64 noundef %148) #35
  store ptr %149, ptr %91, align 8, !tbaa !52
  store i64 %147, ptr %106, align 8, !tbaa !51
  %150 = load i64, ptr %105, align 8, !tbaa !49
  br label %151

151:                                              ; preds = %144, %142
  %152 = phi ptr [ %149, %144 ], [ %136, %142 ]
  %153 = phi i64 [ %147, %144 ], [ %137, %142 ]
  %154 = phi i64 [ %150, %144 ], [ %138, %142 ]
  %155 = add i64 %154, 1
  store i64 %155, ptr %105, align 8, !tbaa !49
  %156 = getelementptr inbounds nuw %struct.UhValue, ptr %152, i64 %154
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %156, ptr noundef nonnull readonly align 8 dereferenceable(40) %4, i64 40, i1 false), !tbaa.struct !25
  br label %157

157:                                              ; preds = %135, %151
  %158 = phi ptr [ %136, %135 ], [ %152, %151 ]
  %159 = phi i64 [ %137, %135 ], [ %153, %151 ]
  %160 = phi i64 [ %138, %135 ], [ %155, %151 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  %161 = add nuw nsw i64 %139, 1
  %162 = icmp eq i64 %161, %89
  br i1 %162, label %163, label %135, !llvm.loop !457

163:                                              ; preds = %157, %99, %76, %61, %58, %84, %14
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_reshape(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %3) local_unnamed_addr #12 {
  %5 = alloca [36 x i8], align 4
  %6 = alloca %struct.UhValue, align 8
  %7 = alloca [20 x i8], align 4
  %8 = alloca [36 x i8], align 4
  %9 = load i32, ptr %1, align 8, !tbaa !31
  %10 = icmp ne i32 %9, 2
  %11 = load i32, ptr %2, align 8
  %12 = icmp ne i32 %11, 0
  %13 = select i1 %10, i1 true, i1 %12
  %14 = load i32, ptr %3, align 8
  %15 = icmp ne i32 %14, 0
  %16 = select i1 %13, i1 true, i1 %15
  br i1 %16, label %17, label %19

17:                                               ; preds = %4
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !458
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %18, i8 0, i64 32, i1 false), !alias.scope !458
  br label %141

19:                                               ; preds = %4
  %20 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %21 = load double, ptr %20, align 8, !tbaa !35
  %22 = fptosi double %21 to i64
  %23 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %24 = load double, ptr %23, align 8, !tbaa !35
  %25 = fptosi double %24 to i64
  %26 = icmp slt i64 %22, 1
  %27 = icmp slt i64 %25, 1
  %28 = select i1 %26, i1 true, i1 %27
  store i32 2, ptr %0, align 8, !tbaa !31
  %29 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %30 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %29, i8 0, i64 16, i1 false)
  store ptr %30, ptr %31, align 8, !tbaa !47
  %32 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %32, align 8, !tbaa !48
  br i1 %28, label %141, label %33

33:                                               ; preds = %19
  %34 = icmp eq ptr %30, null
  %35 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %36 = load ptr, ptr %35, align 8
  %37 = getelementptr inbounds nuw i8, ptr %36, i64 8
  %38 = getelementptr inbounds nuw i8, ptr %30, i64 8
  %39 = getelementptr inbounds nuw i8, ptr %30, i64 16
  %40 = getelementptr inbounds nuw i8, ptr %7, i64 4
  %41 = getelementptr inbounds nuw i8, ptr %8, i64 4
  br label %42

42:                                               ; preds = %70, %33
  %43 = phi i64 [ 0, %33 ], [ %71, %70 ]
  %44 = phi i64 [ 0, %33 ], [ %138, %70 ]
  %45 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %40, i8 0, i64 16, i1 false)
  %46 = icmp eq ptr %45, null
  %47 = getelementptr inbounds nuw i8, ptr %45, i64 8
  %48 = getelementptr inbounds nuw i8, ptr %45, i64 16
  br label %73

49:                                               ; preds = %132
  br i1 %34, label %70, label %50

50:                                               ; preds = %49
  %51 = load i64, ptr %38, align 8, !tbaa !49
  %52 = load i64, ptr %39, align 8, !tbaa !51
  %53 = icmp eq i64 %51, %52
  %54 = load ptr, ptr %30, align 8, !tbaa !52
  br i1 %53, label %55, label %62

55:                                               ; preds = %50
  %56 = icmp eq i64 %51, 0
  %57 = shl i64 %51, 1
  %58 = select i1 %56, i64 8, i64 %57
  %59 = mul i64 %58, 40
  %60 = tail call ptr @realloc(ptr noundef %54, i64 noundef %59) #35
  store ptr %60, ptr %30, align 8, !tbaa !52
  store i64 %58, ptr %39, align 8, !tbaa !51
  %61 = load i64, ptr %38, align 8, !tbaa !49
  br label %62

62:                                               ; preds = %55, %50
  %63 = phi i64 [ %61, %55 ], [ %51, %50 ]
  %64 = phi ptr [ %60, %55 ], [ %54, %50 ]
  %65 = add i64 %63, 1
  store i64 %65, ptr %38, align 8, !tbaa !49
  %66 = getelementptr inbounds nuw %struct.UhValue, ptr %64, i64 %63
  store i32 2, ptr %66, align 8, !tbaa !26
  %67 = getelementptr inbounds nuw i8, ptr %66, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(20) %67, ptr noundef nonnull align 4 dereferenceable(20) %7, i64 20, i1 false)
  %68 = getelementptr inbounds nuw i8, ptr %66, i64 24
  store ptr %45, ptr %68, align 8, !tbaa !29
  %69 = getelementptr inbounds nuw i8, ptr %66, i64 32
  store ptr null, ptr %69, align 8, !tbaa !30
  br label %70

70:                                               ; preds = %49, %62
  %71 = add nuw nsw i64 %43, 1
  %72 = icmp eq i64 %71, %22
  br i1 %72, label %141, label %42, !llvm.loop !461

73:                                               ; preds = %42, %132
  %74 = phi ptr [ null, %42 ], [ %133, %132 ]
  %75 = phi i64 [ 0, %42 ], [ %134, %132 ]
  %76 = phi ptr [ null, %42 ], [ %135, %132 ]
  %77 = phi i64 [ 0, %42 ], [ %136, %132 ]
  %78 = phi i64 [ 0, %42 ], [ %137, %132 ]
  %79 = phi i64 [ 0, %42 ], [ %139, %132 ]
  %80 = phi i64 [ %44, %42 ], [ %138, %132 ]
  %81 = load i64, ptr %37, align 8, !tbaa !49
  %82 = icmp slt i64 %80, %81
  br i1 %82, label %83, label %107

83:                                               ; preds = %73
  %84 = load ptr, ptr %36, align 8, !tbaa !52
  %85 = getelementptr inbounds %struct.UhValue, ptr %84, i64 %80
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %6)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %6, ptr noundef nonnull align 8 dereferenceable(40) %85, i64 40, i1 false)
  br i1 %46, label %101, label %86

86:                                               ; preds = %83
  %87 = icmp eq i64 %78, %75
  br i1 %87, label %88, label %95

88:                                               ; preds = %86
  %89 = icmp eq i64 %75, 0
  %90 = shl i64 %75, 1
  %91 = select i1 %89, i64 8, i64 %90
  %92 = mul i64 %91, 40
  %93 = tail call ptr @realloc(ptr noundef %74, i64 noundef %92) #35
  store ptr %93, ptr %45, align 8, !tbaa !52
  store i64 %91, ptr %48, align 8, !tbaa !51
  %94 = load i64, ptr %47, align 8, !tbaa !49
  br label %95

95:                                               ; preds = %88, %86
  %96 = phi ptr [ %93, %88 ], [ %74, %86 ]
  %97 = phi i64 [ %91, %88 ], [ %75, %86 ]
  %98 = phi i64 [ %94, %88 ], [ %78, %86 ]
  %99 = add i64 %98, 1
  store i64 %99, ptr %47, align 8, !tbaa !49
  %100 = getelementptr inbounds nuw %struct.UhValue, ptr %96, i64 %98
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %100, ptr noundef nonnull readonly align 8 dereferenceable(40) %6, i64 40, i1 false), !tbaa.struct !25
  br label %101

101:                                              ; preds = %83, %95
  %102 = phi ptr [ %74, %83 ], [ %96, %95 ]
  %103 = phi i64 [ %75, %83 ], [ %97, %95 ]
  %104 = phi ptr [ %76, %83 ], [ %96, %95 ]
  %105 = phi i64 [ %77, %83 ], [ %97, %95 ]
  %106 = phi i64 [ %78, %83 ], [ %99, %95 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %6)
  br label %132

107:                                              ; preds = %73
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(32) %41, i8 0, i64 32, i1 false), !alias.scope !462
  call void @llvm.lifetime.start.p0(i64 36, ptr nonnull %5)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %5, ptr noundef nonnull align 4 dereferenceable(36) %8, i64 36, i1 false)
  br i1 %46, label %126, label %108

108:                                              ; preds = %107
  %109 = icmp eq i64 %78, %77
  br i1 %109, label %110, label %117

110:                                              ; preds = %108
  %111 = icmp eq i64 %77, 0
  %112 = shl i64 %77, 1
  %113 = select i1 %111, i64 8, i64 %112
  %114 = mul i64 %113, 40
  %115 = tail call ptr @realloc(ptr noundef %76, i64 noundef %114) #35
  store ptr %115, ptr %45, align 8, !tbaa !52
  store i64 %113, ptr %48, align 8, !tbaa !51
  %116 = load i64, ptr %47, align 8, !tbaa !49
  br label %117

117:                                              ; preds = %110, %108
  %118 = phi ptr [ %115, %110 ], [ %74, %108 ]
  %119 = phi i64 [ %113, %110 ], [ %75, %108 ]
  %120 = phi ptr [ %115, %110 ], [ %76, %108 ]
  %121 = phi i64 [ %113, %110 ], [ %77, %108 ]
  %122 = phi i64 [ %116, %110 ], [ %78, %108 ]
  %123 = add i64 %122, 1
  store i64 %123, ptr %47, align 8, !tbaa !49
  %124 = getelementptr inbounds nuw %struct.UhValue, ptr %120, i64 %122
  store i32 4, ptr %124, align 8, !tbaa !26
  %125 = getelementptr inbounds nuw i8, ptr %124, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %125, ptr noundef nonnull align 4 dereferenceable(36) %5, i64 36, i1 false), !tbaa.struct !465
  br label %126

126:                                              ; preds = %107, %117
  %127 = phi ptr [ %74, %107 ], [ %118, %117 ]
  %128 = phi i64 [ %75, %107 ], [ %119, %117 ]
  %129 = phi ptr [ %76, %107 ], [ %120, %117 ]
  %130 = phi i64 [ %77, %107 ], [ %121, %117 ]
  %131 = phi i64 [ %78, %107 ], [ %123, %117 ]
  call void @llvm.lifetime.end.p0(i64 36, ptr nonnull %5)
  br label %132

132:                                              ; preds = %126, %101
  %133 = phi ptr [ %127, %126 ], [ %102, %101 ]
  %134 = phi i64 [ %128, %126 ], [ %103, %101 ]
  %135 = phi ptr [ %129, %126 ], [ %104, %101 ]
  %136 = phi i64 [ %130, %126 ], [ %105, %101 ]
  %137 = phi i64 [ %131, %126 ], [ %106, %101 ]
  %138 = add nsw i64 %80, 1
  %139 = add nuw nsw i64 %79, 1
  %140 = icmp eq i64 %139, %25
  br i1 %140, label %49, label %73, !llvm.loop !466

141:                                              ; preds = %70, %19, %17
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_transpose(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca [36 x i8], align 4
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca [20 x i8], align 4
  %6 = alloca [36 x i8], align 4
  %7 = load i32, ptr %1, align 8, !tbaa !31
  %8 = icmp eq i32 %7, 2
  br i1 %8, label %11, label %9

9:                                                ; preds = %2
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !467
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %10, i8 0, i64 32, i1 false), !alias.scope !467
  br label %193

11:                                               ; preds = %2
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %13 = load ptr, ptr %12, align 8, !tbaa !47
  %14 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %15 = load i64, ptr %14, align 8, !tbaa !49
  %16 = icmp eq i64 %15, 0
  br i1 %16, label %25, label %17

17:                                               ; preds = %11
  %18 = icmp sgt i64 %15, 0
  br i1 %18, label %19, label %45

19:                                               ; preds = %17
  %20 = load ptr, ptr %13, align 8, !tbaa !52
  %21 = and i64 %15, 1
  %22 = icmp eq i64 %15, 1
  br i1 %22, label %30, label %23

23:                                               ; preds = %19
  %24 = and i64 %15, 9223372036854775806
  br label %58

25:                                               ; preds = %11
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !470
  %26 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %27 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %28 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %26, i8 0, i64 16, i1 false), !alias.scope !470
  store ptr %27, ptr %28, align 8, !tbaa !47, !alias.scope !470
  %29 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %29, align 8, !tbaa !48, !alias.scope !470
  br label %193

30:                                               ; preds = %83, %19
  %31 = phi i64 [ poison, %19 ], [ %84, %83 ]
  %32 = phi i64 [ 0, %19 ], [ %84, %83 ]
  %33 = phi i64 [ 0, %19 ], [ %85, %83 ]
  %34 = icmp eq i64 %21, 0
  br i1 %34, label %45, label %35

35:                                               ; preds = %30
  %36 = getelementptr inbounds nuw %struct.UhValue, ptr %20, i64 %33
  %37 = load i32, ptr %36, align 8, !tbaa !26
  %38 = icmp eq i32 %37, 2
  br i1 %38, label %39, label %45

39:                                               ; preds = %35
  %40 = getelementptr inbounds nuw i8, ptr %36, i64 24
  %41 = load ptr, ptr %40, align 8, !tbaa !29
  %42 = getelementptr inbounds nuw i8, ptr %41, i64 8
  %43 = load i64, ptr %42, align 8, !tbaa !49
  %44 = tail call i64 @llvm.smax.i64(i64 %43, i64 %32)
  br label %45

45:                                               ; preds = %30, %39, %35, %17
  %46 = phi i64 [ 0, %17 ], [ %31, %30 ], [ %32, %35 ], [ %44, %39 ]
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !473
  %47 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %48 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %49 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %47, i8 0, i64 16, i1 false), !alias.scope !473
  store ptr %48, ptr %49, align 8, !tbaa !47, !alias.scope !473
  %50 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %50, align 8, !tbaa !48, !alias.scope !473
  %51 = icmp eq ptr %48, null
  %52 = icmp sgt i64 %46, 0
  br i1 %52, label %53, label %193

53:                                               ; preds = %45
  %54 = getelementptr inbounds nuw i8, ptr %48, i64 8
  %55 = getelementptr inbounds nuw i8, ptr %48, i64 16
  %56 = getelementptr inbounds nuw i8, ptr %5, i64 4
  %57 = getelementptr inbounds nuw i8, ptr %6, i64 4
  br label %88

58:                                               ; preds = %83, %23
  %59 = phi i64 [ 0, %23 ], [ %84, %83 ]
  %60 = phi i64 [ 0, %23 ], [ %85, %83 ]
  %61 = phi i64 [ 0, %23 ], [ %86, %83 ]
  %62 = getelementptr inbounds nuw %struct.UhValue, ptr %20, i64 %60
  %63 = load i32, ptr %62, align 8, !tbaa !26
  %64 = icmp eq i32 %63, 2
  br i1 %64, label %65, label %71

65:                                               ; preds = %58
  %66 = getelementptr inbounds nuw i8, ptr %62, i64 24
  %67 = load ptr, ptr %66, align 8, !tbaa !29
  %68 = getelementptr inbounds nuw i8, ptr %67, i64 8
  %69 = load i64, ptr %68, align 8, !tbaa !49
  %70 = tail call i64 @llvm.smax.i64(i64 %69, i64 %59)
  br label %71

71:                                               ; preds = %65, %58
  %72 = phi i64 [ %59, %58 ], [ %70, %65 ]
  %73 = getelementptr inbounds nuw %struct.UhValue, ptr %20, i64 %60
  %74 = getelementptr inbounds nuw i8, ptr %73, i64 40
  %75 = load i32, ptr %74, align 8, !tbaa !26
  %76 = icmp eq i32 %75, 2
  br i1 %76, label %77, label %83

77:                                               ; preds = %71
  %78 = getelementptr inbounds nuw i8, ptr %73, i64 64
  %79 = load ptr, ptr %78, align 8, !tbaa !29
  %80 = getelementptr inbounds nuw i8, ptr %79, i64 8
  %81 = load i64, ptr %80, align 8, !tbaa !49
  %82 = tail call i64 @llvm.smax.i64(i64 %81, i64 %72)
  br label %83

83:                                               ; preds = %77, %71
  %84 = phi i64 [ %72, %71 ], [ %82, %77 ]
  %85 = add nuw nsw i64 %60, 2
  %86 = add i64 %61, 2
  %87 = icmp eq i64 %86, %24
  br i1 %87, label %30, label %58, !llvm.loop !476

88:                                               ; preds = %53, %116
  %89 = phi i64 [ 0, %53 ], [ %117, %116 ]
  %90 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %56, i8 0, i64 16, i1 false)
  %91 = icmp eq ptr %90, null
  br i1 %18, label %92, label %95

92:                                               ; preds = %88
  %93 = getelementptr inbounds nuw i8, ptr %90, i64 8
  %94 = getelementptr inbounds nuw i8, ptr %90, i64 16
  br label %119

95:                                               ; preds = %185, %88
  br i1 %51, label %116, label %96

96:                                               ; preds = %95
  %97 = load i64, ptr %54, align 8, !tbaa !49
  %98 = load i64, ptr %55, align 8, !tbaa !51
  %99 = icmp eq i64 %97, %98
  %100 = load ptr, ptr %48, align 8, !tbaa !52
  br i1 %99, label %101, label %108

101:                                              ; preds = %96
  %102 = icmp eq i64 %97, 0
  %103 = shl i64 %97, 1
  %104 = select i1 %102, i64 8, i64 %103
  %105 = mul i64 %104, 40
  %106 = tail call ptr @realloc(ptr noundef %100, i64 noundef %105) #35
  store ptr %106, ptr %48, align 8, !tbaa !52
  store i64 %104, ptr %55, align 8, !tbaa !51
  %107 = load i64, ptr %54, align 8, !tbaa !49
  br label %108

108:                                              ; preds = %101, %96
  %109 = phi i64 [ %107, %101 ], [ %97, %96 ]
  %110 = phi ptr [ %106, %101 ], [ %100, %96 ]
  %111 = add i64 %109, 1
  store i64 %111, ptr %54, align 8, !tbaa !49
  %112 = getelementptr inbounds nuw %struct.UhValue, ptr %110, i64 %109
  store i32 2, ptr %112, align 8, !tbaa !26
  %113 = getelementptr inbounds nuw i8, ptr %112, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(20) %113, ptr noundef nonnull align 4 dereferenceable(20) %5, i64 20, i1 false)
  %114 = getelementptr inbounds nuw i8, ptr %112, i64 24
  store ptr %90, ptr %114, align 8, !tbaa !29
  %115 = getelementptr inbounds nuw i8, ptr %112, i64 32
  store ptr null, ptr %115, align 8, !tbaa !30
  br label %116

116:                                              ; preds = %95, %108
  %117 = add nuw nsw i64 %89, 1
  %118 = icmp eq i64 %117, %46
  br i1 %118, label %193, label %88, !llvm.loop !477

119:                                              ; preds = %92, %185
  %120 = phi ptr [ null, %92 ], [ %186, %185 ]
  %121 = phi i64 [ 0, %92 ], [ %187, %185 ]
  %122 = phi ptr [ null, %92 ], [ %188, %185 ]
  %123 = phi i64 [ 0, %92 ], [ %189, %185 ]
  %124 = phi i64 [ 0, %92 ], [ %190, %185 ]
  %125 = phi i64 [ 0, %92 ], [ %191, %185 ]
  %126 = load ptr, ptr %13, align 8, !tbaa !52
  %127 = getelementptr inbounds nuw %struct.UhValue, ptr %126, i64 %125
  %128 = load i32, ptr %127, align 8, !tbaa !26
  %129 = getelementptr inbounds nuw i8, ptr %127, i64 24
  %130 = load ptr, ptr %129, align 8, !tbaa !29
  %131 = icmp eq i32 %128, 2
  br i1 %131, label %132, label %160

132:                                              ; preds = %119
  %133 = getelementptr inbounds nuw i8, ptr %130, i64 8
  %134 = load i64, ptr %133, align 8, !tbaa !49
  %135 = icmp slt i64 %89, %134
  br i1 %135, label %136, label %160

136:                                              ; preds = %132
  %137 = load ptr, ptr %130, align 8, !tbaa !52
  %138 = getelementptr inbounds nuw %struct.UhValue, ptr %137, i64 %89
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %4, ptr noundef nonnull align 8 dereferenceable(40) %138, i64 40, i1 false)
  br i1 %91, label %154, label %139

139:                                              ; preds = %136
  %140 = icmp eq i64 %124, %121
  br i1 %140, label %141, label %148

141:                                              ; preds = %139
  %142 = icmp eq i64 %121, 0
  %143 = shl i64 %121, 1
  %144 = select i1 %142, i64 8, i64 %143
  %145 = mul i64 %144, 40
  %146 = tail call ptr @realloc(ptr noundef %120, i64 noundef %145) #35
  store ptr %146, ptr %90, align 8, !tbaa !52
  store i64 %144, ptr %94, align 8, !tbaa !51
  %147 = load i64, ptr %93, align 8, !tbaa !49
  br label %148

148:                                              ; preds = %141, %139
  %149 = phi ptr [ %146, %141 ], [ %120, %139 ]
  %150 = phi i64 [ %144, %141 ], [ %121, %139 ]
  %151 = phi i64 [ %147, %141 ], [ %124, %139 ]
  %152 = add i64 %151, 1
  store i64 %152, ptr %93, align 8, !tbaa !49
  %153 = getelementptr inbounds nuw %struct.UhValue, ptr %149, i64 %151
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %153, ptr noundef nonnull readonly align 8 dereferenceable(40) %4, i64 40, i1 false), !tbaa.struct !25
  br label %154

154:                                              ; preds = %136, %148
  %155 = phi ptr [ %120, %136 ], [ %149, %148 ]
  %156 = phi i64 [ %121, %136 ], [ %150, %148 ]
  %157 = phi ptr [ %122, %136 ], [ %149, %148 ]
  %158 = phi i64 [ %123, %136 ], [ %150, %148 ]
  %159 = phi i64 [ %124, %136 ], [ %152, %148 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  br label %185

160:                                              ; preds = %119, %132
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(32) %57, i8 0, i64 32, i1 false), !alias.scope !478
  call void @llvm.lifetime.start.p0(i64 36, ptr nonnull %3)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %3, ptr noundef nonnull align 4 dereferenceable(36) %6, i64 36, i1 false)
  br i1 %91, label %179, label %161

161:                                              ; preds = %160
  %162 = icmp eq i64 %124, %123
  br i1 %162, label %163, label %170

163:                                              ; preds = %161
  %164 = icmp eq i64 %123, 0
  %165 = shl i64 %123, 1
  %166 = select i1 %164, i64 8, i64 %165
  %167 = mul i64 %166, 40
  %168 = tail call ptr @realloc(ptr noundef %122, i64 noundef %167) #35
  store ptr %168, ptr %90, align 8, !tbaa !52
  store i64 %166, ptr %94, align 8, !tbaa !51
  %169 = load i64, ptr %93, align 8, !tbaa !49
  br label %170

170:                                              ; preds = %163, %161
  %171 = phi ptr [ %168, %163 ], [ %120, %161 ]
  %172 = phi i64 [ %166, %163 ], [ %121, %161 ]
  %173 = phi ptr [ %168, %163 ], [ %122, %161 ]
  %174 = phi i64 [ %166, %163 ], [ %123, %161 ]
  %175 = phi i64 [ %169, %163 ], [ %124, %161 ]
  %176 = add i64 %175, 1
  store i64 %176, ptr %93, align 8, !tbaa !49
  %177 = getelementptr inbounds nuw %struct.UhValue, ptr %173, i64 %175
  store i32 4, ptr %177, align 8, !tbaa !26
  %178 = getelementptr inbounds nuw i8, ptr %177, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %178, ptr noundef nonnull align 4 dereferenceable(36) %3, i64 36, i1 false), !tbaa.struct !465
  br label %179

179:                                              ; preds = %160, %170
  %180 = phi ptr [ %120, %160 ], [ %171, %170 ]
  %181 = phi i64 [ %121, %160 ], [ %172, %170 ]
  %182 = phi ptr [ %122, %160 ], [ %173, %170 ]
  %183 = phi i64 [ %123, %160 ], [ %174, %170 ]
  %184 = phi i64 [ %124, %160 ], [ %176, %170 ]
  call void @llvm.lifetime.end.p0(i64 36, ptr nonnull %3)
  br label %185

185:                                              ; preds = %179, %154
  %186 = phi ptr [ %180, %179 ], [ %155, %154 ]
  %187 = phi i64 [ %181, %179 ], [ %156, %154 ]
  %188 = phi ptr [ %182, %179 ], [ %157, %154 ]
  %189 = phi i64 [ %183, %179 ], [ %158, %154 ]
  %190 = phi i64 [ %184, %179 ], [ %159, %154 ]
  %191 = add nuw nsw i64 %125, 1
  %192 = icmp eq i64 %191, %15
  br i1 %192, label %95, label %119, !llvm.loop !481

193:                                              ; preds = %116, %45, %25, %9
  ret void
}

; Function Attrs: nofree nounwind sspstrong memory(read, inaccessiblemem: none) uwtable
define dso_local range(i32 0, 2) i32 @uh_subset(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, i32 noundef %2) local_unnamed_addr #26 {
  %4 = load i32, ptr %0, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 2
  %6 = load i32, ptr %1, align 8
  %7 = icmp eq i32 %6, 2
  %8 = select i1 %5, i1 %7, i1 false
  br i1 %8, label %9, label %40

9:                                                ; preds = %3
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %11 = load ptr, ptr %10, align 8, !tbaa !47
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !49
  %14 = icmp eq i64 %13, 0
  br i1 %14, label %38, label %15

15:                                               ; preds = %9
  %16 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %17 = load ptr, ptr %16, align 8, !tbaa !47
  %18 = getelementptr inbounds nuw i8, ptr %17, i64 8
  %19 = load i64, ptr %18, align 8, !tbaa !49
  %20 = icmp eq i64 %19, 0
  br i1 %20, label %90, label %21

21:                                               ; preds = %15
  %22 = load ptr, ptr %11, align 8, !tbaa !52
  %23 = load ptr, ptr %17, align 8, !tbaa !52
  br label %24

24:                                               ; preds = %21, %35
  %25 = phi i64 [ 0, %21 ], [ %36, %35 ]
  %26 = getelementptr inbounds nuw %struct.UhValue, ptr %22, i64 %25
  br label %30

27:                                               ; preds = %30
  %28 = add nuw i64 %31, 1
  %29 = icmp eq i64 %28, %19
  br i1 %29, label %90, label %30, !llvm.loop !482

30:                                               ; preds = %24, %27
  %31 = phi i64 [ 0, %24 ], [ %28, %27 ]
  %32 = getelementptr inbounds nuw %struct.UhValue, ptr %23, i64 %31
  %33 = tail call i32 @uh_value_eq(ptr noundef byval(%struct.UhValue) align 8 %26, ptr noundef byval(%struct.UhValue) align 8 %32)
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %27, label %35

35:                                               ; preds = %30
  %36 = add nuw i64 %25, 1
  %37 = icmp eq i64 %36, %13
  br i1 %37, label %38, label %24, !llvm.loop !483

38:                                               ; preds = %35, %9
  %39 = icmp eq i32 %2, 0
  br i1 %39, label %90, label %81

40:                                               ; preds = %3
  %41 = icmp eq i32 %4, 3
  %42 = icmp eq i32 %6, 3
  %43 = select i1 %41, i1 %42, i1 false
  br i1 %43, label %44, label %90

44:                                               ; preds = %40
  %45 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %46 = load ptr, ptr %45, align 8, !tbaa !48
  %47 = getelementptr inbounds nuw i8, ptr %46, i64 8
  %48 = load i64, ptr %47, align 8, !tbaa !65
  %49 = icmp eq i64 %48, 0
  br i1 %49, label %79, label %50

50:                                               ; preds = %44
  %51 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %52 = load ptr, ptr %51, align 8, !tbaa !48
  %53 = freeze ptr %52
  %54 = load ptr, ptr %46, align 8, !tbaa !68
  %55 = icmp eq ptr %53, null
  %56 = getelementptr inbounds nuw i8, ptr %53, i64 8
  br i1 %55, label %90, label %57

57:                                               ; preds = %50, %76
  %58 = phi i64 [ %77, %76 ], [ 0, %50 ]
  %59 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %54, i64 %58
  %60 = load ptr, ptr %59, align 8, !tbaa !70
  %61 = icmp eq ptr %60, null
  br i1 %61, label %90, label %62

62:                                               ; preds = %57
  %63 = load i64, ptr %56, align 8, !tbaa !65
  %64 = icmp eq i64 %63, 0
  br i1 %64, label %90, label %65

65:                                               ; preds = %62
  %66 = load ptr, ptr %53, align 8, !tbaa !68
  br label %70

67:                                               ; preds = %70
  %68 = add nuw i64 %71, 1
  %69 = icmp eq i64 %68, %63
  br i1 %69, label %90, label %70, !llvm.loop !69

70:                                               ; preds = %67, %65
  %71 = phi i64 [ 0, %65 ], [ %68, %67 ]
  %72 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %66, i64 %71
  %73 = load ptr, ptr %72, align 8, !tbaa !70
  %74 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %73, ptr noundef nonnull readonly dereferenceable(1) %60) #33
  %75 = icmp eq i32 %74, 0
  br i1 %75, label %76, label %67

76:                                               ; preds = %70
  %77 = add nuw i64 %58, 1
  %78 = icmp eq i64 %77, %48
  br i1 %78, label %79, label %57, !llvm.loop !484

79:                                               ; preds = %76, %44
  %80 = icmp eq i32 %2, 0
  br i1 %80, label %90, label %81

81:                                               ; preds = %79, %38
  %82 = phi i64 [ 24, %38 ], [ 32, %79 ]
  %83 = phi i64 [ %13, %38 ], [ %48, %79 ]
  %84 = getelementptr inbounds nuw i8, ptr %1, i64 %82
  %85 = load ptr, ptr %84, align 8, !tbaa !485
  %86 = getelementptr inbounds nuw i8, ptr %85, i64 8
  %87 = load i64, ptr %86, align 8, !tbaa !368
  %88 = icmp ult i64 %83, %87
  %89 = zext i1 %88 to i32
  br label %90

90:                                               ; preds = %57, %62, %67, %27, %81, %50, %15, %40, %79, %38
  %91 = phi i32 [ 1, %38 ], [ 1, %79 ], [ 0, %40 ], [ 0, %15 ], [ 0, %50 ], [ %89, %81 ], [ 0, %27 ], [ 0, %67 ], [ 0, %62 ], [ 0, %57 ]
  ret i32 %91
}

; Function Attrs: nofree nounwind sspstrong memory(read, inaccessiblemem: none) uwtable
define dso_local range(i32 0, 2) i32 @uh_value_eq(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #26 {
  %3 = load i32, ptr %0, align 8, !tbaa !31
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %3, %4
  br i1 %5, label %6, label %100

6:                                                ; preds = %2
  switch i32 %3, label %94 [
    i32 4, label %100
    i32 1, label %7
    i32 2, label %20
    i32 3, label %50
  ]

7:                                                ; preds = %6
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %9 = load ptr, ptr %8, align 8, !tbaa !46
  %10 = icmp eq ptr %9, null
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %12 = load ptr, ptr %11, align 8
  %13 = icmp eq ptr %12, null
  %14 = select i1 %10, i1 true, i1 %13
  br i1 %14, label %15, label %17

15:                                               ; preds = %7
  %16 = icmp eq ptr %9, %12
  br label %100

17:                                               ; preds = %7
  %18 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(1) %12) #33
  %19 = icmp eq i32 %18, 0
  br label %100

20:                                               ; preds = %6
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %22 = load ptr, ptr %21, align 8, !tbaa !47
  %23 = icmp eq ptr %22, null
  %24 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %25 = load ptr, ptr %24, align 8
  %26 = icmp eq ptr %25, null
  %27 = select i1 %23, i1 true, i1 %26
  br i1 %27, label %28, label %30

28:                                               ; preds = %20
  %29 = icmp eq ptr %22, %25
  br label %100

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %22, i64 8
  %32 = load i64, ptr %31, align 8, !tbaa !49
  %33 = getelementptr inbounds nuw i8, ptr %25, i64 8
  %34 = load i64, ptr %33, align 8, !tbaa !49
  %35 = icmp eq i64 %32, %34
  br i1 %35, label %36, label %100

36:                                               ; preds = %30
  %37 = icmp eq i64 %32, 0
  br i1 %37, label %100, label %38

38:                                               ; preds = %36
  %39 = load ptr, ptr %22, align 8, !tbaa !52
  %40 = load ptr, ptr %25, align 8, !tbaa !52
  br label %41

41:                                               ; preds = %41, %38
  %42 = phi i64 [ 0, %38 ], [ %47, %41 ]
  %43 = getelementptr inbounds nuw %struct.UhValue, ptr %39, i64 %42
  %44 = getelementptr inbounds nuw %struct.UhValue, ptr %40, i64 %42
  %45 = tail call i32 @uh_value_eq(ptr noundef byval(%struct.UhValue) align 8 %43, ptr noundef byval(%struct.UhValue) align 8 %44)
  %46 = icmp ne i32 %45, 0
  %47 = add nuw i64 %42, 1
  %48 = icmp ne i64 %47, %32
  %49 = select i1 %46, i1 %48, i1 false
  br i1 %49, label %41, label %100, !llvm.loop !486

50:                                               ; preds = %6
  %51 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %52 = load ptr, ptr %51, align 8, !tbaa !48
  %53 = icmp eq ptr %52, null
  %54 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %55 = load ptr, ptr %54, align 8
  %56 = icmp eq ptr %55, null
  %57 = select i1 %53, i1 true, i1 %56
  br i1 %57, label %58, label %60

58:                                               ; preds = %50
  %59 = icmp eq ptr %52, %55
  br label %100

60:                                               ; preds = %50
  %61 = getelementptr inbounds nuw i8, ptr %52, i64 8
  %62 = load i64, ptr %61, align 8, !tbaa !65
  %63 = getelementptr inbounds nuw i8, ptr %55, i64 8
  %64 = load i64, ptr %63, align 8, !tbaa !65
  %65 = icmp eq i64 %62, %64
  br i1 %65, label %66, label %100

66:                                               ; preds = %60
  %67 = icmp eq i64 %62, 0
  br i1 %67, label %100, label %68

68:                                               ; preds = %66
  %69 = load ptr, ptr %52, align 8, !tbaa !68
  br label %73

70:                                               ; preds = %89
  %71 = add nuw i64 %74, 1
  %72 = icmp eq i64 %71, %62
  br i1 %72, label %100, label %73, !llvm.loop !487

73:                                               ; preds = %68, %70
  %74 = phi i64 [ 0, %68 ], [ %71, %70 ]
  %75 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %69, i64 %74
  %76 = load ptr, ptr %75, align 8, !tbaa !70
  %77 = icmp eq ptr %76, null
  br i1 %77, label %100, label %78

78:                                               ; preds = %73
  %79 = load ptr, ptr %55, align 8, !tbaa !68
  br label %83

80:                                               ; preds = %83
  %81 = add nuw i64 %84, 1
  %82 = icmp eq i64 %81, %62
  br i1 %82, label %100, label %83, !llvm.loop !69

83:                                               ; preds = %80, %78
  %84 = phi i64 [ 0, %78 ], [ %81, %80 ]
  %85 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %79, i64 %84
  %86 = load ptr, ptr %85, align 8, !tbaa !70
  %87 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %86, ptr noundef nonnull readonly dereferenceable(1) %76) #33
  %88 = icmp eq i32 %87, 0
  br i1 %88, label %89, label %80

89:                                               ; preds = %83
  %90 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %69, i64 %74, i32 1
  %91 = getelementptr inbounds nuw i8, ptr %85, i64 8
  %92 = tail call i32 @uh_value_eq(ptr noundef nonnull byval(%struct.UhValue) align 8 %90, ptr noundef nonnull byval(%struct.UhValue) align 8 %91)
  %93 = icmp eq i32 %92, 0
  br i1 %93, label %100, label %70

94:                                               ; preds = %6
  %95 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %96 = load double, ptr %95, align 8, !tbaa !35
  %97 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %98 = load double, ptr %97, align 8, !tbaa !35
  %99 = fcmp oeq double %96, %98
  br label %100

100:                                              ; preds = %73, %70, %89, %80, %41, %66, %36, %60, %6, %30, %2, %94, %58, %28, %17, %15
  %101 = phi i1 [ %16, %15 ], [ %19, %17 ], [ %29, %28 ], [ %59, %58 ], [ %99, %94 ], [ false, %2 ], [ true, %6 ], [ false, %30 ], [ false, %60 ], [ true, %36 ], [ true, %66 ], [ %46, %41 ], [ false, %80 ], [ false, %73 ], [ true, %70 ], [ false, %89 ]
  %102 = zext i1 %101 to i32
  ret i32 %102
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local range(i32 0, 2) i32 @uh_contains(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %0, align 8, !tbaa !31
  %4 = icmp eq i32 %3, 1
  br i1 %4, label %5, label %16

5:                                                ; preds = %2
  %6 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %8 = load ptr, ptr %7, align 8, !tbaa !46
  %9 = icmp ne ptr %8, null
  %10 = icmp ne ptr %6, null
  %11 = select i1 %9, i1 %10, i1 false
  br i1 %11, label %12, label %69

12:                                               ; preds = %5
  %13 = tail call ptr @strstr(ptr noundef nonnull dereferenceable(1) %8, ptr noundef nonnull dereferenceable(1) %6) #33
  %14 = icmp ne ptr %13, null
  %15 = zext i1 %14 to i32
  br label %69

16:                                               ; preds = %2
  %17 = icmp eq i32 %3, 2
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %19 = load ptr, ptr %18, align 8
  %20 = icmp ne ptr %19, null
  %21 = select i1 %17, i1 %20, i1 false
  br i1 %21, label %22, label %36

22:                                               ; preds = %16
  %23 = getelementptr inbounds nuw i8, ptr %19, i64 8
  %24 = load i64, ptr %23, align 8, !tbaa !49
  %25 = icmp eq i64 %24, 0
  br i1 %25, label %72, label %26

26:                                               ; preds = %22
  %27 = load ptr, ptr %19, align 8, !tbaa !52
  br label %31

28:                                               ; preds = %31
  %29 = add nuw i64 %32, 1
  %30 = icmp eq i64 %29, %24
  br i1 %30, label %72, label %31, !llvm.loop !488

31:                                               ; preds = %26, %28
  %32 = phi i64 [ 0, %26 ], [ %29, %28 ]
  %33 = getelementptr inbounds nuw %struct.UhValue, ptr %27, i64 %32
  %34 = tail call i32 @uh_value_eq(ptr noundef byval(%struct.UhValue) align 8 %33, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %28, label %72

36:                                               ; preds = %16
  %37 = icmp eq i32 %3, 3
  %38 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %39 = load ptr, ptr %38, align 8
  %40 = icmp ne ptr %39, null
  %41 = select i1 %37, i1 %40, i1 false
  %42 = load i32, ptr %1, align 8
  %43 = icmp eq i32 %42, 1
  %44 = select i1 %41, i1 %43, i1 false
  br i1 %44, label %45, label %72

45:                                               ; preds = %36
  %46 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %47 = load ptr, ptr %46, align 8
  %48 = icmp eq ptr %47, null
  %49 = select i1 %48, ptr @.str, ptr %47
  %50 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %49) #33
  %51 = add i64 %50, 1
  %52 = tail call noalias ptr @malloc(i64 noundef %51) #34
  %53 = icmp eq ptr %52, null
  br i1 %53, label %72, label %54

54:                                               ; preds = %45
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %52, ptr nonnull readonly align 1 %49, i64 %51, i1 false)
  %55 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %56 = load i64, ptr %55, align 8, !tbaa !65
  %57 = icmp eq i64 %56, 0
  br i1 %57, label %69, label %58

58:                                               ; preds = %54
  %59 = load ptr, ptr %39, align 8, !tbaa !68
  br label %63

60:                                               ; preds = %63
  %61 = add nuw i64 %64, 1
  %62 = icmp eq i64 %61, %56
  br i1 %62, label %69, label %63, !llvm.loop !69

63:                                               ; preds = %60, %58
  %64 = phi i64 [ 0, %58 ], [ %61, %60 ]
  %65 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %59, i64 %64
  %66 = load ptr, ptr %65, align 8, !tbaa !70
  %67 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %66, ptr noundef nonnull readonly dereferenceable(1) %52) #33
  %68 = icmp eq i32 %67, 0
  br i1 %68, label %69, label %60

69:                                               ; preds = %63, %60, %54, %5, %12
  %70 = phi ptr [ %6, %12 ], [ %6, %5 ], [ %52, %54 ], [ %52, %60 ], [ %52, %63 ]
  %71 = phi i32 [ %15, %12 ], [ 0, %5 ], [ 0, %54 ], [ 1, %63 ], [ 0, %60 ]
  tail call void @free(ptr noundef %70) #36
  br label %72

72:                                               ; preds = %31, %28, %69, %22, %45, %36
  %73 = phi i32 [ 0, %36 ], [ 0, %45 ], [ 0, %22 ], [ %71, %69 ], [ 1, %31 ], [ 0, %28 ]
  ret i32 %73
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_index(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  switch i32 %4, label %69 [
    i32 2, label %5
    i32 3, label %29
    i32 1, label %68
  ]

5:                                                ; preds = %3
  %6 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %7 = load double, ptr %6, align 8, !tbaa !35
  %8 = fptosi double %7 to i64
  tail call void @llvm.experimental.noalias.scope.decl(metadata !489)
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 24
  %10 = load ptr, ptr %9, align 8
  %11 = icmp eq ptr %10, null
  br i1 %11, label %12, label %14

12:                                               ; preds = %5
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !492
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %13, i8 0, i64 32, i1 false), !alias.scope !492
  br label %71

14:                                               ; preds = %5
  %15 = icmp slt i64 %8, 0
  %16 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %17 = load i64, ptr %16, align 8, !tbaa !49, !noalias !489
  br i1 %15, label %18, label %21

18:                                               ; preds = %14
  %19 = add nsw i64 %17, %8
  %20 = icmp slt i64 %19, 0
  br i1 %20, label %24, label %21

21:                                               ; preds = %18, %14
  %22 = phi i64 [ %19, %18 ], [ %8, %14 ]
  %23 = icmp ult i64 %22, %17
  br i1 %23, label %26, label %24

24:                                               ; preds = %21, %18
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !495
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %25, i8 0, i64 32, i1 false), !alias.scope !495
  br label %71

26:                                               ; preds = %21
  %27 = load ptr, ptr %10, align 8, !tbaa !52, !noalias !489
  %28 = getelementptr inbounds nuw %struct.UhValue, ptr %27, i64 %22
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %28, i64 40, i1 false), !tbaa.struct !25
  br label %71

29:                                               ; preds = %3
  tail call void @llvm.experimental.noalias.scope.decl(metadata !498)
  %30 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %31 = load ptr, ptr %30, align 8
  %32 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %33 = load ptr, ptr %32, align 8
  %34 = icmp eq ptr %33, null
  br i1 %34, label %35, label %37

35:                                               ; preds = %29
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !501
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %36, i8 0, i64 32, i1 false), !alias.scope !501
  br label %71

37:                                               ; preds = %29
  %38 = load i32, ptr %2, align 8
  %39 = icmp eq i32 %38, 1
  br i1 %39, label %40, label %47

40:                                               ; preds = %37
  %41 = icmp eq ptr %31, null
  %42 = select i1 %41, ptr @.str, ptr %31
  %43 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %42) #33, !noalias !498
  %44 = add i64 %43, 1
  %45 = tail call noalias ptr @malloc(i64 noundef %44) #34
  %46 = icmp eq ptr %45, null
  br i1 %46, label %47, label %49

47:                                               ; preds = %40, %37
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !504
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %48, i8 0, i64 32, i1 false), !alias.scope !504
  br label %71

49:                                               ; preds = %40
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %45, ptr nonnull readonly align 1 %42, i64 %44, i1 false), !noalias !498
  %50 = getelementptr inbounds nuw i8, ptr %33, i64 8
  %51 = load i64, ptr %50, align 8, !tbaa !65, !noalias !498
  %52 = icmp eq i64 %51, 0
  br i1 %52, label %64, label %53

53:                                               ; preds = %49
  %54 = load ptr, ptr %33, align 8, !tbaa !68, !noalias !498
  br label %58

55:                                               ; preds = %58
  %56 = add nuw i64 %59, 1
  %57 = icmp eq i64 %56, %51
  br i1 %57, label %64, label %58, !llvm.loop !69

58:                                               ; preds = %55, %53
  %59 = phi i64 [ 0, %53 ], [ %56, %55 ]
  %60 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %54, i64 %59
  %61 = load ptr, ptr %60, align 8, !tbaa !70, !noalias !498
  %62 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %61, ptr noundef nonnull readonly dereferenceable(1) %45) #33, !noalias !498
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %66, label %55

64:                                               ; preds = %55, %49
  tail call void @free(ptr noundef nonnull %45) #36, !noalias !498
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !507
  %65 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %65, i8 0, i64 32, i1 false), !alias.scope !507
  br label %71

66:                                               ; preds = %58
  tail call void @free(ptr noundef nonnull %45) #36, !noalias !498
  %67 = getelementptr inbounds nuw i8, ptr %60, i64 8
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) %67, i64 40, i1 false), !tbaa.struct !25
  br label %71

68:                                               ; preds = %3
  tail call void @uh_char_at(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  br label %71

69:                                               ; preds = %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !510
  %70 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %70, i8 0, i64 32, i1 false), !alias.scope !510
  br label %71

71:                                               ; preds = %66, %64, %47, %35, %26, %24, %12, %69, %68
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_store_index(ptr noundef readonly captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = icmp eq ptr %0, null
  br i1 %4, label %28, label %5

5:                                                ; preds = %3
  %6 = load i32, ptr %0, align 8, !tbaa !31
  switch i32 %6, label %28 [
    i32 2, label %7
    i32 3, label %27
  ]

7:                                                ; preds = %5
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %9 = load double, ptr %8, align 8, !tbaa !35
  %10 = fptosi double %9 to i64
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %12 = load ptr, ptr %11, align 8, !tbaa !47
  %13 = icmp eq ptr %12, null
  br i1 %13, label %28, label %14

14:                                               ; preds = %7
  %15 = icmp slt i64 %10, 0
  %16 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %17 = load i64, ptr %16, align 8, !tbaa !49
  br i1 %15, label %18, label %21

18:                                               ; preds = %14
  %19 = add nsw i64 %17, %10
  %20 = icmp slt i64 %19, 0
  br i1 %20, label %28, label %21

21:                                               ; preds = %14, %18
  %22 = phi i64 [ %19, %18 ], [ %10, %14 ]
  %23 = icmp ult i64 %22, %17
  br i1 %23, label %24, label %28

24:                                               ; preds = %21
  %25 = load ptr, ptr %12, align 8, !tbaa !52
  %26 = getelementptr inbounds nuw %struct.UhValue, ptr %25, i64 %22
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %26, ptr noundef nonnull align 8 dereferenceable(40) %2, i64 40, i1 false), !tbaa.struct !25
  br label %28

27:                                               ; preds = %5
  tail call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1, ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  br label %28

28:                                               ; preds = %5, %24, %7, %21, %18, %3, %27
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(read, inaccessiblemem: none) uwtable
define dso_local range(i32 0, 2) i32 @uh_is_true(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0) local_unnamed_addr #11 {
  %2 = load i32, ptr %0, align 8, !tbaa !31
  switch i32 %2, label %10 [
    i32 4, label %34
    i32 1, label %3
  ]

3:                                                ; preds = %1
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %5 = load ptr, ptr %4, align 8, !tbaa !46
  %6 = icmp eq ptr %5, null
  br i1 %6, label %34, label %7

7:                                                ; preds = %3
  %8 = load i8, ptr %5, align 1, !tbaa !76
  %9 = icmp ne i8 %8, 0
  br label %34

10:                                               ; preds = %1
  %11 = icmp eq i32 %2, 2
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %13 = load ptr, ptr %12, align 8
  %14 = icmp ne ptr %13, null
  %15 = select i1 %11, i1 %14, i1 false
  br i1 %15, label %16, label %20

16:                                               ; preds = %10
  %17 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %18 = load i64, ptr %17, align 8, !tbaa !49
  %19 = icmp ne i64 %18, 0
  br label %34

20:                                               ; preds = %10
  %21 = icmp eq i32 %2, 3
  %22 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %23 = load ptr, ptr %22, align 8
  %24 = icmp ne ptr %23, null
  %25 = select i1 %21, i1 %24, i1 false
  br i1 %25, label %26, label %30

26:                                               ; preds = %20
  %27 = getelementptr inbounds nuw i8, ptr %23, i64 8
  %28 = load i64, ptr %27, align 8, !tbaa !65
  %29 = icmp ne i64 %28, 0
  br label %34

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %32 = load double, ptr %31, align 8, !tbaa !35
  %33 = fcmp une double %32, 0.000000e+00
  br label %34

34:                                               ; preds = %3, %7, %1, %30, %26, %16
  %35 = phi i1 [ %19, %16 ], [ %29, %26 ], [ %33, %30 ], [ false, %1 ], [ false, %3 ], [ %9, %7 ]
  %36 = zext i1 %35 to i32
  ret i32 %36
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_print(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0) local_unnamed_addr #12 {
  %2 = load i32, ptr %0, align 8, !tbaa !31
  %3 = icmp eq i32 %2, 1
  br i1 %3, label %4, label %11

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %6 = load ptr, ptr %5, align 8, !tbaa !46
  %7 = icmp eq ptr %6, null
  br i1 %7, label %29, label %8

8:                                                ; preds = %4
  %9 = load ptr, ptr @stdout, align 8, !tbaa !513
  %10 = tail call i32 @fputs(ptr noundef nonnull %6, ptr noundef %9)
  br label %29

11:                                               ; preds = %1
  %12 = and i32 %2, -2
  %13 = icmp eq i32 %12, 2
  br i1 %13, label %14, label %20

14:                                               ; preds = %11
  %15 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %0)
  %16 = icmp eq ptr %15, null
  br i1 %16, label %29, label %17

17:                                               ; preds = %14
  %18 = load ptr, ptr @stdout, align 8, !tbaa !513
  %19 = tail call i32 @fputs(ptr noundef nonnull %15, ptr noundef %18)
  tail call void @free(ptr noundef nonnull %15) #36
  br label %29

20:                                               ; preds = %11
  %21 = icmp eq i32 %2, 4
  br i1 %21, label %22, label %25

22:                                               ; preds = %20
  %23 = load ptr, ptr @stdout, align 8, !tbaa !513
  %24 = tail call i64 @fwrite(ptr nonnull @.str.12, i64 4, i64 1, ptr %23)
  br label %29

25:                                               ; preds = %20
  %26 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %27 = load double, ptr %26, align 8, !tbaa !35
  %28 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.21, double noundef %27)
  br label %29

29:                                               ; preds = %14, %17, %25, %22, %4, %8
  %30 = load ptr, ptr @stdout, align 8, !tbaa !513
  %31 = tail call i32 @fputc(i32 noundef 10, ptr noundef %30)
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i32 @fputs(ptr noundef readonly captures(none), ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #16

; Function Attrs: nofree nounwind
declare noundef i32 @fputc(i32 noundef, ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nounwind sspstrong uwtable
define dso_local range(i32 -1, 2) i32 @uh_cmp(ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %0, align 8, !tbaa !31
  %4 = icmp eq i32 %3, 0
  %5 = load i32, ptr %1, align 8
  %6 = icmp eq i32 %5, 0
  %7 = select i1 %4, i1 %6, i1 false
  br i1 %7, label %8, label %17

8:                                                ; preds = %2
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %10 = load double, ptr %9, align 8, !tbaa !35
  %11 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %12 = load double, ptr %11, align 8, !tbaa !35
  %13 = fcmp olt double %10, %12
  br i1 %13, label %30, label %14

14:                                               ; preds = %8
  %15 = fcmp ogt double %10, %12
  %16 = zext i1 %15 to i32
  br label %30

17:                                               ; preds = %2
  %18 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %0)
  %19 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %20 = icmp eq ptr %18, null
  %21 = icmp eq ptr %19, null
  %22 = select i1 %20, i1 %21, i1 false
  br i1 %22, label %30, label %23

23:                                               ; preds = %17
  br i1 %20, label %24, label %25

24:                                               ; preds = %23
  tail call void @free(ptr noundef %19) #36
  br label %30

25:                                               ; preds = %23
  br i1 %21, label %26, label %27

26:                                               ; preds = %25
  tail call void @free(ptr noundef nonnull %18) #36
  br label %30

27:                                               ; preds = %25
  %28 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %18, ptr noundef nonnull dereferenceable(1) %19) #33
  tail call void @free(ptr noundef nonnull %18) #36
  tail call void @free(ptr noundef nonnull %19) #36
  %29 = tail call i32 @llvm.scmp.i32.i32(i32 %28, i32 0)
  br label %30

30:                                               ; preds = %24, %26, %27, %17, %14, %8
  %31 = phi i32 [ -1, %8 ], [ %16, %14 ], [ -1, %24 ], [ 1, %26 ], [ %29, %27 ], [ 0, %17 ]
  ret i32 %31
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_set_args(i32 noundef %0, ptr noundef readonly captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca [20 x i8], align 4
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %3)
  %4 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %5 = getelementptr inbounds nuw i8, ptr %3, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %5, i8 0, i64 16, i1 false), !alias.scope !515
  store i32 2, ptr @g_args, align 8, !tbaa !26
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(20) getelementptr inbounds nuw (i8, ptr @g_args, i64 4), ptr noundef nonnull align 4 dereferenceable(20) %3, i64 20, i1 false), !tbaa.struct !465
  store ptr %4, ptr getelementptr inbounds nuw (i8, ptr @g_args, i64 24), align 8, !tbaa !29
  store ptr null, ptr getelementptr inbounds nuw (i8, ptr @g_args, i64 32), align 8, !tbaa !30
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %3)
  %6 = icmp ne ptr %4, null
  %7 = icmp sgt i32 %0, 0
  %8 = and i1 %6, %7
  br i1 %8, label %9, label %54

9:                                                ; preds = %2
  %10 = zext nneg i32 %0 to i64
  br label %11

11:                                               ; preds = %9, %51
  %12 = phi i64 [ 0, %9 ], [ %52, %51 ]
  %13 = getelementptr inbounds nuw ptr, ptr %1, i64 %12
  %14 = load ptr, ptr %13, align 8, !tbaa !28
  %15 = icmp eq ptr %14, null
  br i1 %15, label %22, label %16

16:                                               ; preds = %11
  %17 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %14) #33, !noalias !518
  %18 = add i64 %17, 1
  %19 = tail call noalias ptr @malloc(i64 noundef %18) #34
  %20 = icmp eq ptr %19, null
  br i1 %20, label %22, label %21

21:                                               ; preds = %16
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %19, ptr nonnull readonly align 1 %14, i64 %18, i1 false), !noalias !518
  br label %22

22:                                               ; preds = %11, %16, %21
  %23 = phi ptr [ null, %11 ], [ %19, %21 ], [ null, %16 ]
  %24 = load i32, ptr @g_args, align 8, !tbaa !31
  %25 = icmp eq i32 %24, 2
  br i1 %25, label %26, label %51

26:                                               ; preds = %22
  %27 = load ptr, ptr getelementptr inbounds nuw (i8, ptr @g_args, i64 24), align 8, !tbaa !47
  %28 = icmp eq ptr %27, null
  br i1 %28, label %51, label %29

29:                                               ; preds = %26
  %30 = getelementptr inbounds nuw i8, ptr %27, i64 8
  %31 = load i64, ptr %30, align 8, !tbaa !49
  %32 = getelementptr inbounds nuw i8, ptr %27, i64 16
  %33 = load i64, ptr %32, align 8, !tbaa !51
  %34 = icmp eq i64 %31, %33
  %35 = load ptr, ptr %27, align 8, !tbaa !52
  br i1 %34, label %36, label %43

36:                                               ; preds = %29
  %37 = icmp eq i64 %31, 0
  %38 = shl i64 %31, 1
  %39 = select i1 %37, i64 8, i64 %38
  %40 = mul i64 %39, 40
  %41 = tail call ptr @realloc(ptr noundef %35, i64 noundef %40) #35
  store ptr %41, ptr %27, align 8, !tbaa !52
  store i64 %39, ptr %32, align 8, !tbaa !51
  %42 = load i64, ptr %30, align 8, !tbaa !49
  br label %43

43:                                               ; preds = %36, %29
  %44 = phi i64 [ %42, %36 ], [ %31, %29 ]
  %45 = phi ptr [ %41, %36 ], [ %35, %29 ]
  %46 = add i64 %44, 1
  store i64 %46, ptr %30, align 8, !tbaa !49
  %47 = getelementptr inbounds nuw %struct.UhValue, ptr %45, i64 %44
  store i32 1, ptr %47, align 8, !tbaa !26
  %48 = getelementptr inbounds nuw i8, ptr %47, i64 8
  store double 0.000000e+00, ptr %48, align 8, !tbaa !27
  %49 = getelementptr inbounds nuw i8, ptr %47, i64 16
  store ptr %23, ptr %49, align 8, !tbaa !28
  %50 = getelementptr inbounds nuw i8, ptr %47, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %50, i8 0, i64 16, i1 false)
  br label %51

51:                                               ; preds = %22, %26, %43
  %52 = add nuw nsw i64 %12, 1
  %53 = icmp eq i64 %52, %10
  br i1 %53, label %54, label %11, !llvm.loop !521

54:                                               ; preds = %51, %2
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(readwrite, inaccessiblemem: none) uwtable
define dso_local void @uh_args(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 40)) %0) local_unnamed_addr #8 {
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %0, ptr noundef nonnull align 8 dereferenceable(40) @g_args, i64 40, i1 false), !tbaa.struct !25
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(write, argmem: none, inaccessiblemem: none) uwtable
define dso_local void @uh_set_global_env(ptr noundef %0) local_unnamed_addr #27 {
  store ptr %0, ptr @g_env, align 8, !tbaa !522
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_sysobj(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) initializes((0, 4), (8, 40)) %0) local_unnamed_addr #12 {
  %2 = alloca %struct.UhValue, align 8
  %3 = alloca %struct.UhValue, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = alloca %struct.UhValue, align 8
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !523
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %8 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 32
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %7, i8 0, i64 24, i1 false), !alias.scope !523
  store ptr %8, ptr %9, align 8, !tbaa !48, !alias.scope !523
  tail call void @llvm.experimental.noalias.scope.decl(metadata !526)
  store i32 1, ptr %2, align 8, !tbaa !31, !alias.scope !526
  %10 = getelementptr inbounds nuw i8, ptr %2, i64 8
  store double 0.000000e+00, ptr %10, align 8, !tbaa !35, !alias.scope !526
  %11 = tail call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %12 = icmp eq ptr %11, null
  br i1 %12, label %14, label %13

13:                                               ; preds = %1
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %11, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.22, i64 5, i1 false), !noalias !526
  br label %14

14:                                               ; preds = %1, %13
  %15 = getelementptr inbounds nuw i8, ptr %2, i64 16
  store ptr %11, ptr %15, align 8, !tbaa !46, !alias.scope !526
  %16 = getelementptr inbounds nuw i8, ptr %2, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %16, i8 0, i64 16, i1 false), !alias.scope !526
  tail call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %2, ptr noundef nonnull byval(%struct.UhValue) align 8 @g_args)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3) #36
  store i32 3, ptr %3, align 8, !tbaa !31, !alias.scope !529
  %17 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %18 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %19 = getelementptr inbounds nuw i8, ptr %3, i64 32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %17, i8 0, i64 24, i1 false), !alias.scope !529
  store ptr %18, ptr %19, align 8, !tbaa !48, !alias.scope !529
  %20 = load ptr, ptr @environ, align 8, !tbaa !532
  %21 = icmp eq ptr %20, null
  br i1 %21, label %63, label %22

22:                                               ; preds = %14
  %23 = load ptr, ptr %20, align 8, !tbaa !28
  %24 = icmp eq ptr %23, null
  br i1 %24, label %63, label %25

25:                                               ; preds = %22
  %26 = getelementptr inbounds nuw i8, ptr %4, i64 8
  %27 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %28 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %29 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %30 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %31 = getelementptr inbounds nuw i8, ptr %5, i64 24
  br label %32

32:                                               ; preds = %25, %59
  %33 = phi ptr [ %23, %25 ], [ %61, %59 ]
  %34 = phi ptr [ %20, %25 ], [ %60, %59 ]
  %35 = call ptr @strchr(ptr noundef nonnull dereferenceable(1) %33, i32 noundef 61) #33
  %36 = icmp eq ptr %35, null
  br i1 %36, label %59, label %37

37:                                               ; preds = %32
  %38 = ptrtoint ptr %35 to i64
  %39 = ptrtoint ptr %33 to i64
  %40 = sub i64 %38, %39
  %41 = add i64 %40, 1
  %42 = call noalias ptr @malloc(i64 noundef %41) #34
  %43 = icmp eq ptr %42, null
  br i1 %43, label %59, label %44

44:                                               ; preds = %37
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %42, ptr nonnull align 1 %33, i64 %40, i1 false)
  %45 = getelementptr inbounds nuw i8, ptr %42, i64 %40
  store i8 0, ptr %45, align 1, !tbaa !76
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !535)
  store i32 1, ptr %4, align 8, !tbaa !31, !alias.scope !535
  store double 0.000000e+00, ptr %26, align 8, !tbaa !35, !alias.scope !535
  %46 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %42) #33, !noalias !535
  %47 = add i64 %46, 1
  %48 = call noalias ptr @malloc(i64 noundef %47) #34
  %49 = icmp eq ptr %48, null
  br i1 %49, label %51, label %50

50:                                               ; preds = %44
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %48, ptr nonnull readonly align 1 %42, i64 %47, i1 false), !noalias !535
  br label %51

51:                                               ; preds = %44, %50
  store ptr %48, ptr %27, align 8, !tbaa !46, !alias.scope !535
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %28, i8 0, i64 16, i1 false), !alias.scope !535
  call void @free(ptr noundef nonnull %42) #36
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5) #36
  %52 = getelementptr inbounds nuw i8, ptr %35, i64 1
  call void @llvm.experimental.noalias.scope.decl(metadata !538)
  store i32 1, ptr %5, align 8, !tbaa !31, !alias.scope !538
  store double 0.000000e+00, ptr %29, align 8, !tbaa !35, !alias.scope !538
  %53 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %52) #33, !noalias !538
  %54 = add i64 %53, 1
  %55 = call noalias ptr @malloc(i64 noundef %54) #34
  %56 = icmp eq ptr %55, null
  br i1 %56, label %58, label %57

57:                                               ; preds = %51
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %55, ptr nonnull readonly align 1 %52, i64 %54, i1 false), !noalias !538
  br label %58

58:                                               ; preds = %51, %57
  store ptr %55, ptr %30, align 8, !tbaa !46, !alias.scope !538
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %31, i8 0, i64 16, i1 false), !alias.scope !538
  call void @uh_dict_set(ptr noundef nonnull %3, ptr noundef nonnull byval(%struct.UhValue) align 8 %4, ptr noundef nonnull byval(%struct.UhValue) align 8 %5)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4) #36
  br label %59

59:                                               ; preds = %58, %37, %32
  %60 = getelementptr inbounds nuw i8, ptr %34, i64 8
  %61 = load ptr, ptr %60, align 8, !tbaa !28
  %62 = icmp eq ptr %61, null
  br i1 %62, label %63, label %32, !llvm.loop !541

63:                                               ; preds = %59, %22, %14
  call void @llvm.experimental.noalias.scope.decl(metadata !542)
  store i32 1, ptr %6, align 8, !tbaa !31, !alias.scope !542
  %64 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store double 0.000000e+00, ptr %64, align 8, !tbaa !35, !alias.scope !542
  %65 = call noalias dereferenceable_or_null(4) ptr @malloc(i64 noundef 4) #34
  %66 = icmp eq ptr %65, null
  br i1 %66, label %68, label %67

67:                                               ; preds = %63
  store i32 7761509, ptr %65, align 1, !noalias !542
  br label %68

68:                                               ; preds = %67, %63
  %69 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store ptr %65, ptr %69, align 8, !tbaa !46, !alias.scope !542
  %70 = getelementptr inbounds nuw i8, ptr %6, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %70, i8 0, i64 16, i1 false), !alias.scope !542
  call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %6, ptr noundef nonnull byval(%struct.UhValue) align 8 %3)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3) #36
  ret void
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @strchr(ptr noundef, i32 noundef) local_unnamed_addr #15

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_import(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.stat, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = load i32, ptr %1, align 8, !tbaa !31
  %7 = icmp eq i32 %6, 1
  %8 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %9 = load ptr, ptr %8, align 8
  %10 = icmp ne ptr %9, null
  %11 = select i1 %7, i1 %10, i1 false
  br i1 %11, label %20, label %12

12:                                               ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !545)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !545
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %13, align 8, !tbaa !35, !alias.scope !545
  %14 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %15 = icmp eq ptr %14, null
  br i1 %15, label %17, label %16

16:                                               ; preds = %12
  store i8 0, ptr %14, align 1, !noalias !545
  br label %17

17:                                               ; preds = %12, %16
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %14, ptr %18, align 8, !tbaa !46, !alias.scope !545
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %19, i8 0, i64 16, i1 false), !alias.scope !545
  br label %88

20:                                               ; preds = %2
  call void @llvm.lifetime.start.p0(i64 144, ptr nonnull %3) #36
  %21 = call i32 @stat(ptr noundef nonnull %9, ptr noundef nonnull %3) #36
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %23, label %29

23:                                               ; preds = %20
  %24 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %25 = load i32, ptr %24, align 8, !tbaa !548
  %26 = and i32 %25, 61440
  %27 = icmp eq i32 %26, 32768
  br i1 %27, label %28, label %29

28:                                               ; preds = %23
  tail call void @uh_read_file(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  br label %87

29:                                               ; preds = %23, %20
  %30 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %9) #33
  %31 = add i64 %30, 5
  %32 = tail call noalias ptr @malloc(i64 noundef %31) #34
  %33 = icmp eq ptr %32, null
  br i1 %33, label %54, label %34

34:                                               ; preds = %29
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %32, ptr nonnull align 1 %9, i64 %30, i1 false)
  %35 = getelementptr inbounds nuw i8, ptr %32, i64 %30
  store i32 6845742, ptr %35, align 1
  %36 = call i32 @stat(ptr noundef nonnull %32, ptr noundef nonnull %3) #36
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %38, label %53

38:                                               ; preds = %34
  %39 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %40 = load i32, ptr %39, align 8, !tbaa !548
  %41 = and i32 %40, 61440
  %42 = icmp eq i32 %41, 32768
  br i1 %42, label %43, label %53

43:                                               ; preds = %38
  tail call void @llvm.experimental.noalias.scope.decl(metadata !551)
  store i32 1, ptr %4, align 8, !tbaa !31, !alias.scope !551
  %44 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store double 0.000000e+00, ptr %44, align 8, !tbaa !35, !alias.scope !551
  %45 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %32) #33, !noalias !551
  %46 = add i64 %45, 1
  %47 = tail call noalias ptr @malloc(i64 noundef %46) #34
  %48 = icmp eq ptr %47, null
  br i1 %48, label %50, label %49

49:                                               ; preds = %43
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %47, ptr nonnull readonly align 1 %32, i64 %46, i1 false), !noalias !551
  br label %50

50:                                               ; preds = %43, %49
  %51 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store ptr %47, ptr %51, align 8, !tbaa !46, !alias.scope !551
  %52 = getelementptr inbounds nuw i8, ptr %4, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %52, i8 0, i64 16, i1 false), !alias.scope !551
  tail call void @uh_read_file(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %4)
  tail call void @free(ptr noundef nonnull %32) #36
  br label %87

53:                                               ; preds = %38, %34
  tail call void @free(ptr noundef nonnull %32) #36
  br label %54

54:                                               ; preds = %53, %29
  %55 = add i64 %30, 13
  %56 = tail call noalias ptr @malloc(i64 noundef %55) #34
  %57 = icmp eq ptr %56, null
  br i1 %57, label %79, label %58

58:                                               ; preds = %54
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %56, ptr nonnull align 1 %9, i64 %30, i1 false)
  %59 = getelementptr inbounds nuw i8, ptr %56, i64 %30
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(12) %59, ptr noundef nonnull align 1 dereferenceable(12) @.str.25, i64 12, i1 false)
  %60 = getelementptr i8, ptr %59, i64 12
  store i8 0, ptr %60, align 1, !tbaa !76
  %61 = call i32 @stat(ptr noundef nonnull %56, ptr noundef nonnull %3) #36
  %62 = icmp eq i32 %61, 0
  br i1 %62, label %63, label %78

63:                                               ; preds = %58
  %64 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %65 = load i32, ptr %64, align 8, !tbaa !548
  %66 = and i32 %65, 61440
  %67 = icmp eq i32 %66, 32768
  br i1 %67, label %68, label %78

68:                                               ; preds = %63
  tail call void @llvm.experimental.noalias.scope.decl(metadata !554)
  store i32 1, ptr %5, align 8, !tbaa !31, !alias.scope !554
  %69 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store double 0.000000e+00, ptr %69, align 8, !tbaa !35, !alias.scope !554
  %70 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %56) #33, !noalias !554
  %71 = add i64 %70, 1
  %72 = tail call noalias ptr @malloc(i64 noundef %71) #34
  %73 = icmp eq ptr %72, null
  br i1 %73, label %75, label %74

74:                                               ; preds = %68
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %72, ptr nonnull readonly align 1 %56, i64 %71, i1 false), !noalias !554
  br label %75

75:                                               ; preds = %68, %74
  %76 = getelementptr inbounds nuw i8, ptr %5, i64 16
  store ptr %72, ptr %76, align 8, !tbaa !46, !alias.scope !554
  %77 = getelementptr inbounds nuw i8, ptr %5, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %77, i8 0, i64 16, i1 false), !alias.scope !554
  tail call void @uh_read_file(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %5)
  tail call void @free(ptr noundef nonnull %56) #36
  br label %87

78:                                               ; preds = %63, %58
  tail call void @free(ptr noundef nonnull %56) #36
  br label %79

79:                                               ; preds = %78, %54
  tail call void @llvm.experimental.noalias.scope.decl(metadata !557)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !557
  %80 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %80, align 8, !tbaa !35, !alias.scope !557
  %81 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %82 = icmp eq ptr %81, null
  br i1 %82, label %84, label %83

83:                                               ; preds = %79
  store i8 0, ptr %81, align 1, !noalias !557
  br label %84

84:                                               ; preds = %79, %83
  %85 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %81, ptr %85, align 8, !tbaa !46, !alias.scope !557
  %86 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %86, i8 0, i64 16, i1 false), !alias.scope !557
  br label %87

87:                                               ; preds = %50, %84, %75, %28
  call void @llvm.lifetime.end.p0(i64 144, ptr nonnull %3) #36
  br label %88

88:                                               ; preds = %87, %17
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i32 @stat(ptr noundef readonly captures(none), ptr noundef captures(none)) local_unnamed_addr #16

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_http_request(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  %4 = alloca [36 x i8], align 4
  %5 = alloca %struct.UhCurlBuf, align 8
  %6 = alloca i64, align 8
  %7 = alloca %struct.UhValue, align 8
  %8 = alloca %struct.UhValue, align 8
  %9 = alloca %struct.UhValue, align 8
  %10 = alloca %struct.UhValue, align 8
  %11 = alloca %struct.UhValue, align 8
  %12 = alloca %struct.UhValue, align 8
  %13 = alloca %struct.UhValue, align 8
  %14 = alloca %struct.UhValue, align 8
  %15 = load i1, ptr @uh_curl_init_once.inited, align 4
  br i1 %15, label %18, label %16

16:                                               ; preds = %2
  %17 = tail call i32 @curl_global_init(i64 noundef 3) #36
  store i1 true, ptr @uh_curl_init_once.inited, align 4
  br label %18

18:                                               ; preds = %2, %16
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3) #36
  store i32 4, ptr %3, align 8, !tbaa !31, !alias.scope !560
  %19 = getelementptr inbounds nuw i8, ptr %3, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %19, i8 0, i64 32, i1 false), !alias.scope !560
  %20 = load i32, ptr %1, align 8, !tbaa !31
  %21 = icmp eq i32 %20, 1
  %22 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %23 = load ptr, ptr %22, align 8
  %24 = icmp ne ptr %23, null
  %25 = select i1 %21, i1 %24, i1 false
  br i1 %25, label %128, label %26

26:                                               ; preds = %18
  %27 = icmp eq i32 %20, 3
  br i1 %27, label %28, label %124

28:                                               ; preds = %26
  %29 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %30 = load ptr, ptr %29, align 8
  %31 = icmp eq ptr %30, null
  br i1 %31, label %124, label %32

32:                                               ; preds = %28
  %33 = getelementptr inbounds nuw i8, ptr %30, i64 8
  %34 = load i64, ptr %33, align 8, !tbaa !65, !noalias !563
  %35 = icmp eq i64 %34, 0
  br i1 %35, label %75, label %36

36:                                               ; preds = %32
  %37 = load ptr, ptr %30, align 8, !tbaa !68, !noalias !563
  br label %41

38:                                               ; preds = %41
  %39 = add nuw i64 %42, 1
  %40 = icmp eq i64 %39, %34
  br i1 %40, label %54, label %41, !llvm.loop !69

41:                                               ; preds = %38, %36
  %42 = phi i64 [ 0, %36 ], [ %39, %38 ]
  %43 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %37, i64 %42
  %44 = load ptr, ptr %43, align 8, !tbaa !70, !noalias !563
  %45 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %44, ptr noundef nonnull readonly dereferenceable(4) @.str.27) #33, !noalias !563
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %47, label %38

47:                                               ; preds = %41
  %48 = getelementptr inbounds nuw i8, ptr %43, i64 8
  %49 = load i32, ptr %48, align 8, !tbaa !26
  %50 = getelementptr inbounds nuw i8, ptr %43, i64 24
  %51 = load ptr, ptr %50, align 8, !tbaa !28
  %52 = icmp eq i32 %49, 1
  %53 = select i1 %52, ptr %51, ptr null
  br label %54

54:                                               ; preds = %38, %47
  %55 = phi ptr [ %53, %47 ], [ null, %38 ]
  %56 = load ptr, ptr %30, align 8, !tbaa !68, !noalias !566
  br label %60

57:                                               ; preds = %60
  %58 = add nuw i64 %61, 1
  %59 = icmp eq i64 %58, %34
  br i1 %59, label %76, label %60, !llvm.loop !69

60:                                               ; preds = %57, %54
  %61 = phi i64 [ 0, %54 ], [ %58, %57 ]
  %62 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %56, i64 %61
  %63 = load ptr, ptr %62, align 8, !tbaa !70, !noalias !566
  %64 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %63, ptr noundef nonnull readonly dereferenceable(7) @.str.28) #33, !noalias !566
  %65 = icmp eq i32 %64, 0
  br i1 %65, label %66, label %57

66:                                               ; preds = %60
  %67 = getelementptr inbounds nuw i8, ptr %62, i64 8
  %68 = load i32, ptr %67, align 8, !tbaa !26
  %69 = getelementptr inbounds nuw i8, ptr %62, i64 24
  %70 = load ptr, ptr %69, align 8, !tbaa !28
  %71 = icmp eq i32 %68, 1
  %72 = select i1 %71, ptr %70, ptr null
  %73 = icmp eq ptr %72, null
  %74 = select i1 %73, ptr @.str.26, ptr %72
  br label %76

75:                                               ; preds = %32
  call void @llvm.lifetime.start.p0(i64 36, ptr nonnull %4)
  br label %106

76:                                               ; preds = %57, %66
  %77 = phi ptr [ %74, %66 ], [ @.str.26, %57 ]
  %78 = load ptr, ptr %30, align 8, !tbaa !68, !noalias !569
  br label %82

79:                                               ; preds = %82
  %80 = add nuw i64 %83, 1
  %81 = icmp eq i64 %80, %34
  br i1 %81, label %93, label %82, !llvm.loop !69

82:                                               ; preds = %79, %76
  %83 = phi i64 [ 0, %76 ], [ %80, %79 ]
  %84 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %78, i64 %83
  %85 = load ptr, ptr %84, align 8, !tbaa !70, !noalias !569
  %86 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %85, ptr noundef nonnull readonly dereferenceable(8) @.str.29) #33, !noalias !569
  %87 = icmp eq i32 %86, 0
  br i1 %87, label %88, label %79

88:                                               ; preds = %82
  %89 = getelementptr inbounds nuw i8, ptr %84, i64 8
  %90 = load i32, ptr %89, align 8, !tbaa !26
  %91 = getelementptr inbounds nuw i8, ptr %84, i64 40
  %92 = load ptr, ptr %91, align 4, !tbaa !30
  br label %93

93:                                               ; preds = %79, %88
  %94 = phi ptr [ %92, %88 ], [ null, %79 ]
  %95 = phi i32 [ %90, %88 ], [ 4, %79 ]
  call void @llvm.lifetime.start.p0(i64 36, ptr nonnull %4)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !572)
  %96 = load ptr, ptr %30, align 8, !tbaa !68, !noalias !572
  br label %100

97:                                               ; preds = %100
  %98 = add nuw i64 %101, 1
  %99 = icmp eq i64 %98, %34
  br i1 %99, label %106, label %100, !llvm.loop !69

100:                                              ; preds = %97, %93
  %101 = phi i64 [ 0, %93 ], [ %98, %97 ]
  %102 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %96, i64 %101
  %103 = load ptr, ptr %102, align 8, !tbaa !70, !noalias !572
  %104 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %103, ptr noundef nonnull readonly dereferenceable(5) @.str.30) #33, !noalias !572
  %105 = icmp eq i32 %104, 0
  br i1 %105, label %112, label %97

106:                                              ; preds = %97, %75
  %107 = phi ptr [ null, %75 ], [ %94, %97 ]
  %108 = phi i32 [ 4, %75 ], [ %95, %97 ]
  %109 = phi ptr [ null, %75 ], [ %55, %97 ]
  %110 = phi ptr [ @.str.26, %75 ], [ %77, %97 ]
  %111 = getelementptr inbounds nuw i8, ptr %4, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(32) %111, i8 0, i64 32, i1 false), !alias.scope !575
  br label %116

112:                                              ; preds = %100
  %113 = getelementptr inbounds nuw i8, ptr %102, i64 8
  %114 = load i32, ptr %113, align 8, !tbaa !26
  %115 = getelementptr inbounds nuw i8, ptr %102, i64 12
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %4, ptr noundef nonnull align 4 dereferenceable(36) %115, i64 36, i1 false), !tbaa.struct !465
  br label %116

116:                                              ; preds = %112, %106
  %117 = phi i32 [ %108, %106 ], [ %95, %112 ]
  %118 = phi ptr [ %107, %106 ], [ %94, %112 ]
  %119 = phi ptr [ %109, %106 ], [ %55, %112 ]
  %120 = phi ptr [ %110, %106 ], [ %77, %112 ]
  %121 = phi i32 [ 4, %106 ], [ %114, %112 ]
  store i32 %121, ptr %3, align 8, !tbaa !26
  %122 = getelementptr inbounds nuw i8, ptr %3, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %122, ptr noundef nonnull align 4 dereferenceable(36) %4, i64 36, i1 false), !tbaa.struct !465
  call void @llvm.lifetime.end.p0(i64 36, ptr nonnull %4)
  %123 = icmp eq ptr %119, null
  br i1 %123, label %124, label %128

124:                                              ; preds = %28, %26, %116
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !578
  %125 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %126 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %127 = getelementptr inbounds nuw i8, ptr %0, i64 32
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %125, i8 0, i64 24, i1 false), !alias.scope !578
  store ptr %126, ptr %127, align 8, !tbaa !48, !alias.scope !578
  br label %263

128:                                              ; preds = %18, %116
  %129 = phi ptr [ %119, %116 ], [ %23, %18 ]
  %130 = phi ptr [ %120, %116 ], [ @.str.26, %18 ]
  %131 = phi i32 [ %121, %116 ], [ 4, %18 ]
  %132 = phi i32 [ %117, %116 ], [ 4, %18 ]
  %133 = phi ptr [ %118, %116 ], [ null, %18 ]
  %134 = tail call ptr @curl_easy_init() #36
  %135 = icmp eq ptr %134, null
  br i1 %135, label %136, label %140

136:                                              ; preds = %128
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !581
  %137 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %138 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %139 = getelementptr inbounds nuw i8, ptr %0, i64 32
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %137, i8 0, i64 24, i1 false), !alias.scope !581
  store ptr %138, ptr %139, align 8, !tbaa !48, !alias.scope !581
  br label %263

140:                                              ; preds = %128
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %5) #36
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %5, i8 0, i64 24, i1 false)
  %141 = tail call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %134, i32 noundef 10002, ptr noundef nonnull %129) #36
  %142 = tail call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %134, i32 noundef 20011, ptr noundef nonnull @uh_curl_write) #36
  %143 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %134, i32 noundef 10001, ptr noundef nonnull %5) #36
  %144 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %134, i32 noundef 52, i64 noundef 1) #36
  %145 = icmp eq i32 %132, 3
  %146 = icmp ne ptr %133, null
  %147 = select i1 %145, i1 %146, i1 false
  br i1 %147, label %148, label %182

148:                                              ; preds = %140
  %149 = getelementptr inbounds nuw i8, ptr %133, i64 8
  %150 = load i64, ptr %149, align 8, !tbaa !65
  %151 = icmp eq i64 %150, 0
  br i1 %151, label %182, label %152

152:                                              ; preds = %148, %173
  %153 = phi ptr [ %174, %173 ], [ null, %148 ]
  %154 = phi i64 [ %175, %173 ], [ 0, %148 ]
  %155 = load ptr, ptr %133, align 8, !tbaa !68
  %156 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %155, i64 %154
  %157 = load ptr, ptr %156, align 8, !tbaa !70
  %158 = getelementptr inbounds nuw i8, ptr %156, i64 8
  %159 = call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %158)
  %160 = icmp ne ptr %157, null
  %161 = icmp ne ptr %159, null
  %162 = select i1 %160, i1 %161, i1 false
  br i1 %162, label %163, label %173

163:                                              ; preds = %152
  %164 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %157) #33
  %165 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %159) #33
  %166 = add i64 %164, 3
  %167 = add i64 %166, %165
  %168 = call noalias ptr @malloc(i64 noundef %167) #34
  %169 = icmp eq ptr %168, null
  br i1 %169, label %173, label %170

170:                                              ; preds = %163
  %171 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull %168, i64 noundef %167, ptr noundef nonnull @.str.31, ptr noundef nonnull %157, ptr noundef nonnull %159) #36
  %172 = call ptr @curl_slist_append(ptr noundef %153, ptr noundef nonnull %168) #36
  call void @free(ptr noundef nonnull %168) #36
  br label %173

173:                                              ; preds = %163, %170, %152
  %174 = phi ptr [ %153, %152 ], [ %172, %170 ], [ %153, %163 ]
  call void @free(ptr noundef %159) #36
  %175 = add nuw i64 %154, 1
  %176 = load i64, ptr %149, align 8, !tbaa !65
  %177 = icmp ult i64 %175, %176
  br i1 %177, label %152, label %178, !llvm.loop !584

178:                                              ; preds = %173
  %179 = icmp eq ptr %174, null
  br i1 %179, label %182, label %180

180:                                              ; preds = %178
  %181 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %134, i32 noundef 10023, ptr noundef nonnull %174) #36
  br label %182

182:                                              ; preds = %148, %140, %180, %178
  %183 = phi i1 [ false, %180 ], [ true, %178 ], [ true, %140 ], [ true, %148 ]
  %184 = phi ptr [ %174, %180 ], [ null, %178 ], [ null, %140 ], [ null, %148 ]
  %185 = icmp eq i32 %131, 4
  br i1 %185, label %191, label %186

186:                                              ; preds = %182
  %187 = call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %3)
  %188 = icmp eq ptr %187, null
  %189 = select i1 %188, ptr @.str, ptr %187
  %190 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %134, i32 noundef 10015, ptr noundef nonnull %189) #36
  br label %191

191:                                              ; preds = %182, %186
  %192 = phi ptr [ %187, %186 ], [ null, %182 ]
  %193 = call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %130, ptr noundef nonnull dereferenceable(4) @.str.26) #33
  %194 = icmp eq i32 %193, 0
  br i1 %194, label %197, label %195

195:                                              ; preds = %191
  %196 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %134, i32 noundef 10036, ptr noundef nonnull %130) #36
  br label %197

197:                                              ; preds = %195, %191
  %198 = call i32 @curl_easy_perform(ptr noundef nonnull %134) #36
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %6) #36
  store i64 0, ptr %6, align 8, !tbaa !368
  %199 = call i32 (ptr, i32, ...) @curl_easy_getinfo(ptr noundef nonnull %134, i32 noundef 2097154, ptr noundef nonnull %6) #36
  br i1 %183, label %201, label %200

200:                                              ; preds = %197
  call void @curl_slist_free_all(ptr noundef nonnull %184) #36
  br label %201

201:                                              ; preds = %200, %197
  call void @curl_easy_cleanup(ptr noundef nonnull %134) #36
  call void @free(ptr noundef %192) #36
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !585
  %202 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %203 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %204 = getelementptr inbounds nuw i8, ptr %0, i64 32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %202, i8 0, i64 24, i1 false), !alias.scope !585
  store ptr %203, ptr %204, align 8, !tbaa !48, !alias.scope !585
  %205 = icmp eq i32 %198, 0
  br i1 %205, label %230, label %206

206:                                              ; preds = %201
  call void @llvm.experimental.noalias.scope.decl(metadata !588)
  store i32 1, ptr %7, align 8, !tbaa !31, !alias.scope !588
  %207 = getelementptr inbounds nuw i8, ptr %7, i64 8
  store double 0.000000e+00, ptr %207, align 8, !tbaa !35, !alias.scope !588
  %208 = call noalias dereferenceable_or_null(7) ptr @malloc(i64 noundef 7) #34
  %209 = icmp eq ptr %208, null
  br i1 %209, label %211, label %210

210:                                              ; preds = %206
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %208, ptr noundef nonnull readonly align 1 dereferenceable(7) @.str.32, i64 7, i1 false), !noalias !588
  br label %211

211:                                              ; preds = %206, %210
  %212 = getelementptr inbounds nuw i8, ptr %7, i64 16
  store ptr %208, ptr %212, align 8, !tbaa !46, !alias.scope !588
  %213 = getelementptr inbounds nuw i8, ptr %7, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %213, i8 0, i64 16, i1 false), !alias.scope !588
  store i32 0, ptr %8, align 8, !tbaa !31, !alias.scope !591
  %214 = getelementptr inbounds nuw i8, ptr %8, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %214, i8 0, i64 32, i1 false)
  call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %7, ptr noundef nonnull byval(%struct.UhValue) align 8 %8)
  call void @llvm.experimental.noalias.scope.decl(metadata !594)
  store i32 1, ptr %9, align 8, !tbaa !31, !alias.scope !594
  %215 = getelementptr inbounds nuw i8, ptr %9, i64 8
  store double 0.000000e+00, ptr %215, align 8, !tbaa !35, !alias.scope !594
  %216 = call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %217 = icmp eq ptr %216, null
  br i1 %217, label %219, label %218

218:                                              ; preds = %211
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %216, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.30, i64 5, i1 false), !noalias !594
  br label %219

219:                                              ; preds = %211, %218
  %220 = getelementptr inbounds nuw i8, ptr %9, i64 16
  store ptr %216, ptr %220, align 8, !tbaa !46, !alias.scope !594
  %221 = getelementptr inbounds nuw i8, ptr %9, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %221, i8 0, i64 16, i1 false), !alias.scope !594
  call void @llvm.experimental.noalias.scope.decl(metadata !597)
  store i32 1, ptr %10, align 8, !tbaa !31, !alias.scope !597
  %222 = getelementptr inbounds nuw i8, ptr %10, i64 8
  store double 0.000000e+00, ptr %222, align 8, !tbaa !35, !alias.scope !597
  %223 = call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %224 = icmp eq ptr %223, null
  br i1 %224, label %226, label %225

225:                                              ; preds = %219
  store i8 0, ptr %223, align 1, !noalias !597
  br label %226

226:                                              ; preds = %219, %225
  %227 = getelementptr inbounds nuw i8, ptr %10, i64 16
  store ptr %223, ptr %227, align 8, !tbaa !46, !alias.scope !597
  %228 = getelementptr inbounds nuw i8, ptr %10, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %228, i8 0, i64 16, i1 false), !alias.scope !597
  call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %9, ptr noundef nonnull byval(%struct.UhValue) align 8 %10)
  %229 = load ptr, ptr %5, align 8, !tbaa !600
  call void @free(ptr noundef %229) #36
  br label %262

230:                                              ; preds = %201
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %11) #36
  %231 = load ptr, ptr %5, align 8, !tbaa !600
  %232 = icmp eq ptr %231, null
  %233 = select i1 %232, ptr @.str, ptr %231
  call void @llvm.experimental.noalias.scope.decl(metadata !602)
  store i32 1, ptr %11, align 8, !tbaa !31, !alias.scope !602
  %234 = getelementptr inbounds nuw i8, ptr %11, i64 8
  store double 0.000000e+00, ptr %234, align 8, !tbaa !35, !alias.scope !602
  %235 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %233) #33, !noalias !602
  %236 = add i64 %235, 1
  %237 = call noalias ptr @malloc(i64 noundef %236) #34
  %238 = icmp eq ptr %237, null
  br i1 %238, label %240, label %239

239:                                              ; preds = %230
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %237, ptr nonnull readonly align 1 %233, i64 %236, i1 false), !noalias !602
  br label %240

240:                                              ; preds = %230, %239
  %241 = getelementptr inbounds nuw i8, ptr %11, i64 16
  store ptr %237, ptr %241, align 8, !tbaa !46, !alias.scope !602
  %242 = getelementptr inbounds nuw i8, ptr %11, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %242, i8 0, i64 16, i1 false), !alias.scope !602
  call void @llvm.experimental.noalias.scope.decl(metadata !605)
  store i32 1, ptr %12, align 8, !tbaa !31, !alias.scope !605
  %243 = getelementptr inbounds nuw i8, ptr %12, i64 8
  store double 0.000000e+00, ptr %243, align 8, !tbaa !35, !alias.scope !605
  %244 = call noalias dereferenceable_or_null(7) ptr @malloc(i64 noundef 7) #34
  %245 = icmp eq ptr %244, null
  br i1 %245, label %247, label %246

246:                                              ; preds = %240
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %244, ptr noundef nonnull readonly align 1 dereferenceable(7) @.str.32, i64 7, i1 false), !noalias !605
  br label %247

247:                                              ; preds = %240, %246
  %248 = getelementptr inbounds nuw i8, ptr %12, i64 16
  store ptr %244, ptr %248, align 8, !tbaa !46, !alias.scope !605
  %249 = getelementptr inbounds nuw i8, ptr %12, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %249, i8 0, i64 16, i1 false), !alias.scope !605
  %250 = load i64, ptr %6, align 8, !tbaa !368
  %251 = sitofp i64 %250 to double
  store i32 0, ptr %13, align 8, !tbaa !31, !alias.scope !608
  %252 = getelementptr inbounds nuw i8, ptr %13, i64 8
  store double %251, ptr %252, align 8, !tbaa !35, !alias.scope !608
  %253 = getelementptr inbounds nuw i8, ptr %13, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %253, i8 0, i64 24, i1 false), !alias.scope !608
  call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %12, ptr noundef nonnull byval(%struct.UhValue) align 8 %13)
  call void @llvm.experimental.noalias.scope.decl(metadata !611)
  store i32 1, ptr %14, align 8, !tbaa !31, !alias.scope !611
  %254 = getelementptr inbounds nuw i8, ptr %14, i64 8
  store double 0.000000e+00, ptr %254, align 8, !tbaa !35, !alias.scope !611
  %255 = call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %256 = icmp eq ptr %255, null
  br i1 %256, label %258, label %257

257:                                              ; preds = %247
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %255, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.30, i64 5, i1 false), !noalias !611
  br label %258

258:                                              ; preds = %247, %257
  %259 = getelementptr inbounds nuw i8, ptr %14, i64 16
  store ptr %255, ptr %259, align 8, !tbaa !46, !alias.scope !611
  %260 = getelementptr inbounds nuw i8, ptr %14, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %260, i8 0, i64 16, i1 false), !alias.scope !611
  call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %14, ptr noundef nonnull byval(%struct.UhValue) align 8 %11)
  %261 = load ptr, ptr %5, align 8, !tbaa !600
  call void @free(ptr noundef %261) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %11) #36
  br label %262

262:                                              ; preds = %258, %226
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %6) #36
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %5) #36
  br label %263

263:                                              ; preds = %136, %124, %262
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3) #36
  ret void
}

declare ptr @curl_easy_init() local_unnamed_addr #22

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #28

declare i32 @curl_easy_setopt(ptr noundef, i32 noundef, ...) local_unnamed_addr #22

; Function Attrs: nounwind sspstrong uwtable
define internal noundef i64 @uh_curl_write(ptr noundef readonly captures(none) %0, i64 noundef %1, i64 noundef %2, ptr noundef captures(none) %3) #12 {
  %5 = mul i64 %2, %1
  %6 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %7 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %8 = load i64, ptr %6, align 8, !tbaa !368
  %9 = add i64 %5, 1
  %10 = add i64 %9, %8
  %11 = load i64, ptr %7, align 8, !tbaa !368
  %12 = icmp ugt i64 %10, %11
  br i1 %12, label %15, label %13

13:                                               ; preds = %4
  %14 = load ptr, ptr %3, align 8, !tbaa !28
  br label %27

15:                                               ; preds = %4
  %16 = icmp eq i64 %11, 0
  %17 = shl i64 %11, 1
  %18 = select i1 %16, i64 64, i64 %17
  br label %19

19:                                               ; preds = %19, %15
  %20 = phi i64 [ %18, %15 ], [ %22, %19 ]
  %21 = icmp ult i64 %20, %10
  %22 = shl i64 %20, 1
  br i1 %21, label %19, label %23, !llvm.loop !614

23:                                               ; preds = %19
  %24 = load ptr, ptr %3, align 8, !tbaa !28
  %25 = tail call ptr @realloc(ptr noundef %24, i64 noundef %20) #35
  store ptr %25, ptr %3, align 8, !tbaa !28
  store i64 %20, ptr %7, align 8, !tbaa !368
  %26 = load i64, ptr %6, align 8, !tbaa !368
  br label %27

27:                                               ; preds = %13, %23
  %28 = phi i64 [ %8, %13 ], [ %26, %23 ]
  %29 = phi ptr [ %14, %13 ], [ %25, %23 ]
  %30 = getelementptr inbounds nuw i8, ptr %29, i64 %28
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %30, ptr readonly align 1 %0, i64 %5, i1 false)
  %31 = load i64, ptr %6, align 8, !tbaa !368
  %32 = add i64 %31, %5
  store i64 %32, ptr %6, align 8, !tbaa !368
  %33 = load ptr, ptr %3, align 8, !tbaa !28
  %34 = getelementptr inbounds nuw i8, ptr %33, i64 %32
  store i8 0, ptr %34, align 1, !tbaa !76
  ret i64 %5
}

declare ptr @curl_slist_append(ptr noundef, ptr noundef) local_unnamed_addr #22

declare i32 @curl_easy_perform(ptr noundef) local_unnamed_addr #22

declare i32 @curl_easy_getinfo(ptr noundef, i32 noundef, ...) local_unnamed_addr #22

declare void @curl_slist_free_all(ptr noundef) local_unnamed_addr #22

declare void @curl_easy_cleanup(ptr noundef) local_unnamed_addr #22

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_http_get(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  tail call void @uh_http_request(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  ret void
}

; Function Attrs: mustprogress nounwind sspstrong willreturn uwtable
define dso_local void @uh_http_handle(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #6 {
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp eq i32 %4, 1
  %6 = load i32, ptr %2, align 8
  %7 = icmp eq i32 %6, 1
  %8 = select i1 %5, i1 %7, i1 false
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %10 = load ptr, ptr %9, align 8
  %11 = icmp ne ptr %10, null
  %12 = select i1 %8, i1 %11, i1 false
  %13 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %14 = load ptr, ptr %13, align 8
  %15 = icmp ne ptr %14, null
  %16 = select i1 %12, i1 %15, i1 false
  br i1 %16, label %17, label %47

17:                                               ; preds = %3
  %18 = load i64, ptr @g_route_len, align 8, !tbaa !368
  %19 = load i64, ptr @g_route_cap, align 8, !tbaa !368
  %20 = icmp eq i64 %18, %19
  br i1 %20, label %21, label %30

21:                                               ; preds = %17
  %22 = icmp eq i64 %18, 0
  %23 = shl i64 %18, 1
  %24 = select i1 %22, i64 8, i64 %23
  %25 = load ptr, ptr @g_routes, align 8, !tbaa !485
  %26 = shl i64 %24, 4
  %27 = tail call ptr @realloc(ptr noundef %25, i64 noundef %26) #35
  %28 = icmp eq ptr %27, null
  br i1 %28, label %47, label %29

29:                                               ; preds = %21
  store ptr %27, ptr @g_routes, align 8, !tbaa !485
  store i64 %24, ptr @g_route_cap, align 8, !tbaa !368
  br label %30

30:                                               ; preds = %29, %17
  %31 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %10) #33
  %32 = add i64 %31, 1
  %33 = tail call noalias ptr @malloc(i64 noundef %32) #34
  %34 = icmp eq ptr %33, null
  br i1 %34, label %36, label %35

35:                                               ; preds = %30
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %33, ptr nonnull readonly align 1 %10, i64 %32, i1 false)
  br label %36

36:                                               ; preds = %35, %30
  %37 = load ptr, ptr @g_routes, align 8, !tbaa !485
  %38 = getelementptr inbounds nuw %struct.UhRoute, ptr %37, i64 %18
  store ptr %33, ptr %38, align 8, !tbaa !615
  %39 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %14) #33
  %40 = add i64 %39, 1
  %41 = tail call noalias ptr @malloc(i64 noundef %40) #34
  %42 = icmp eq ptr %41, null
  br i1 %42, label %44, label %43

43:                                               ; preds = %36
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %41, ptr nonnull readonly align 1 %14, i64 %40, i1 false)
  br label %44

44:                                               ; preds = %43, %36
  %45 = getelementptr inbounds nuw %struct.UhRoute, ptr %37, i64 %18, i32 1
  store ptr %41, ptr %45, align 8, !tbaa !617
  %46 = add i64 %18, 1
  store i64 %46, ptr @g_route_len, align 8, !tbaa !368
  br label %47

47:                                               ; preds = %44, %21, %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !618
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %48, i8 0, i64 32, i1 false), !alias.scope !618
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_http_listen(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = alloca %struct.UhValue, align 8
  %7 = alloca %struct.UhValue, align 8
  %8 = alloca %struct.UhValue, align 8
  %9 = alloca %struct.UhValue, align 8
  %10 = alloca %struct.UhValue, align 8
  %11 = alloca %struct.UhValue, align 8
  %12 = alloca %struct.UhValue, align 8
  %13 = alloca %struct.UhValue, align 8
  %14 = alloca %struct.UhValue, align 8
  %15 = alloca %struct.UhValue, align 8
  %16 = alloca %struct.UhValue, align 8
  %17 = alloca i32, align 4
  %18 = alloca %struct.sockaddr_in, align 4
  %19 = alloca [8192 x i8], align 16
  %20 = alloca %struct.UhValue, align 8
  %21 = alloca %struct.UhValue, align 8
  %22 = alloca [2 x %struct.UhValue], align 16
  %23 = alloca %struct.UhValue, align 8
  %24 = alloca %struct.UhValue, align 8
  %25 = alloca %struct.UhValue, align 8
  %26 = alloca %struct.UhValue, align 8
  %27 = alloca %struct.UhValue, align 8
  %28 = alloca %struct.UhValue, align 8
  %29 = alloca [256 x i8], align 16
  %30 = load i32, ptr %1, align 8, !tbaa !31
  %31 = icmp eq i32 %30, 1
  %32 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %33 = load ptr, ptr %32, align 8
  %34 = icmp ne ptr %33, null
  %35 = select i1 %31, i1 %34, i1 false
  %36 = select i1 %35, ptr %33, ptr @.str.33
  %37 = load i8, ptr %36, align 1, !tbaa !76
  %38 = icmp eq i8 %37, 58
  %39 = zext i1 %38 to i64
  %40 = getelementptr inbounds nuw i8, ptr %36, i64 %39
  %41 = load i8, ptr %40, align 1, !tbaa !76
  %42 = add i8 %41, -48
  %43 = icmp ult i8 %42, 10
  br i1 %43, label %44, label %58

44:                                               ; preds = %2, %44
  %45 = phi i8 [ %53, %44 ], [ %41, %2 ]
  %46 = phi i32 [ %51, %44 ], [ 0, %2 ]
  %47 = phi ptr [ %52, %44 ], [ %40, %2 ]
  %48 = mul nsw i32 %46, 10
  %49 = add nsw i8 %45, -48
  %50 = zext nneg i8 %49 to i32
  %51 = add nsw i32 %48, %50
  %52 = getelementptr inbounds nuw i8, ptr %47, i64 1
  %53 = load i8, ptr %52, align 1, !tbaa !76
  %54 = add i8 %53, -48
  %55 = icmp ult i8 %54, 10
  br i1 %55, label %44, label %56, !llvm.loop !621

56:                                               ; preds = %44
  %57 = icmp slt i32 %51, 1
  br i1 %57, label %58, label %60

58:                                               ; preds = %2, %56
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !622
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %59, i8 0, i64 32, i1 false)
  br label %380

60:                                               ; preds = %56
  %61 = tail call i32 @socket(i32 noundef 2, i32 noundef 1, i32 noundef 0) #36
  %62 = icmp slt i32 %61, 0
  br i1 %62, label %63, label %65

63:                                               ; preds = %60
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !625
  %64 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %64, i8 0, i64 32, i1 false)
  br label %380

65:                                               ; preds = %60
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %17) #36
  store i32 1, ptr %17, align 4, !tbaa !26
  %66 = call i32 @setsockopt(i32 noundef %61, i32 noundef 1, i32 noundef 2, ptr noundef nonnull %17, i32 noundef 4) #36
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %18) #36
  %67 = getelementptr inbounds nuw i8, ptr %18, i64 8
  store i64 0, ptr %67, align 4
  store i16 2, ptr %18, align 4, !tbaa !76
  %68 = getelementptr inbounds nuw i8, ptr %18, i64 4
  store i32 0, ptr %68, align 4, !tbaa !76
  %69 = trunc i32 %51 to i16
  %70 = call noundef i16 @llvm.bswap.i16(i16 %69)
  %71 = getelementptr inbounds nuw i8, ptr %18, i64 2
  store i16 %70, ptr %71, align 2, !tbaa !76
  %72 = call i32 @bind(i32 noundef %61, ptr noundef nonnull %18, i32 noundef 16) #36
  %73 = icmp eq i32 %72, 0
  br i1 %73, label %74, label %377

74:                                               ; preds = %65
  %75 = call i32 @listen(i32 noundef %61, i32 noundef 16) #36
  %76 = icmp eq i32 %75, 0
  br i1 %76, label %77, label %377

77:                                               ; preds = %74
  %78 = getelementptr inbounds nuw i8, ptr %20, i64 8
  %79 = getelementptr inbounds nuw i8, ptr %20, i64 32
  %80 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %81 = getelementptr inbounds nuw i8, ptr %11, i64 16
  %82 = getelementptr inbounds nuw i8, ptr %11, i64 24
  %83 = getelementptr inbounds nuw i8, ptr %12, i64 8
  %84 = getelementptr inbounds nuw i8, ptr %12, i64 16
  %85 = getelementptr inbounds nuw i8, ptr %12, i64 24
  %86 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %87 = getelementptr inbounds nuw i8, ptr %13, i64 16
  %88 = getelementptr inbounds nuw i8, ptr %13, i64 24
  %89 = getelementptr inbounds nuw i8, ptr %14, i64 8
  %90 = getelementptr inbounds nuw i8, ptr %14, i64 16
  %91 = getelementptr inbounds nuw i8, ptr %14, i64 24
  %92 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %93 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %94 = getelementptr inbounds nuw i8, ptr %15, i64 24
  %95 = getelementptr inbounds nuw i8, ptr %16, i64 8
  %96 = getelementptr inbounds nuw i8, ptr %16, i64 16
  %97 = getelementptr inbounds nuw i8, ptr %16, i64 24
  %98 = getelementptr inbounds nuw i8, ptr %21, i64 8
  %99 = getelementptr inbounds nuw i8, ptr %21, i64 32
  %100 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %101 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %102 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %103 = getelementptr inbounds nuw i8, ptr %4, i64 8
  %104 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %105 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %106 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %107 = getelementptr inbounds nuw i8, ptr %5, i64 24
  %108 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %109 = getelementptr inbounds nuw i8, ptr %6, i64 16
  %110 = getelementptr inbounds nuw i8, ptr %6, i64 24
  %111 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %112 = getelementptr inbounds nuw i8, ptr %7, i64 32
  %113 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %114 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %115 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %116 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %117 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %118 = getelementptr inbounds nuw i8, ptr %9, i64 24
  %119 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %120 = getelementptr inbounds nuw i8, ptr %10, i64 16
  %121 = getelementptr inbounds nuw i8, ptr %10, i64 24
  %122 = getelementptr inbounds nuw i8, ptr %22, i64 40
  %123 = getelementptr inbounds nuw i8, ptr %24, i64 8
  %124 = getelementptr inbounds nuw i8, ptr %24, i64 16
  %125 = getelementptr inbounds nuw i8, ptr %24, i64 24
  %126 = getelementptr inbounds nuw i8, ptr %25, i64 8
  %127 = getelementptr inbounds nuw i8, ptr %25, i64 16
  %128 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %129 = getelementptr inbounds nuw i8, ptr %26, i64 16
  %130 = getelementptr inbounds nuw i8, ptr %26, i64 24
  %131 = getelementptr inbounds nuw i8, ptr %27, i64 8
  %132 = getelementptr inbounds nuw i8, ptr %27, i64 16
  %133 = getelementptr inbounds nuw i8, ptr %27, i64 24
  %134 = getelementptr inbounds nuw i8, ptr %28, i64 8
  br label %135

135:                                              ; preds = %138, %77
  %136 = call i32 @accept(i32 noundef %61, ptr noundef null, ptr noundef null) #36
  %137 = icmp slt i32 %136, 0
  br i1 %137, label %138, label %139

138:                                              ; preds = %135, %376
  br label %135

139:                                              ; preds = %135
  call void @llvm.lifetime.start.p0(i64 8192, ptr nonnull %19) #36
  %140 = call i64 @recv(i32 noundef %136, ptr noundef nonnull %19, i64 noundef 8191, i32 noundef 0) #36
  %141 = icmp slt i64 %140, 1
  br i1 %141, label %142, label %144

142:                                              ; preds = %139
  %143 = call i32 @close(i32 noundef %136) #36
  br label %376

144:                                              ; preds = %139
  %145 = getelementptr inbounds nuw [8192 x i8], ptr %19, i64 0, i64 %140
  store i8 0, ptr %145, align 1, !tbaa !76
  %146 = call ptr @strstr(ptr noundef nonnull dereferenceable(1) %19, ptr noundef nonnull dereferenceable(1) @.str.34) #33
  %147 = icmp eq ptr %146, null
  br i1 %147, label %148, label %150

148:                                              ; preds = %144
  %149 = call i32 @close(i32 noundef %136) #36
  br label %376

150:                                              ; preds = %144
  %151 = call ptr @strtok(ptr noundef nonnull %19, ptr noundef nonnull @.str.35) #36
  %152 = icmp eq ptr %151, null
  br i1 %152, label %153, label %155

153:                                              ; preds = %150
  %154 = call i32 @close(i32 noundef %136) #36
  br label %376

155:                                              ; preds = %150
  %156 = getelementptr inbounds nuw i8, ptr %146, i64 4
  %157 = call ptr @strtok(ptr noundef nonnull %151, ptr noundef nonnull @.str.36) #36
  %158 = call ptr @strtok(ptr noundef null, ptr noundef nonnull @.str.36) #36
  %159 = icmp eq ptr %158, null
  br i1 %159, label %179, label %160

160:                                              ; preds = %155
  %161 = load i64, ptr @g_route_len, align 8, !tbaa !368
  %162 = icmp eq i64 %161, 0
  br i1 %162, label %179, label %163

163:                                              ; preds = %160
  %164 = load ptr, ptr @g_routes, align 8, !tbaa !485
  br label %165

165:                                              ; preds = %176, %163
  %166 = phi i64 [ 0, %163 ], [ %177, %176 ]
  %167 = getelementptr inbounds nuw %struct.UhRoute, ptr %164, i64 %166
  %168 = load ptr, ptr %167, align 8, !tbaa !615
  %169 = icmp eq ptr %168, null
  br i1 %169, label %176, label %170

170:                                              ; preds = %165
  %171 = call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %168, ptr noundef nonnull readonly dereferenceable(1) %158) #33
  %172 = icmp eq i32 %171, 0
  br i1 %172, label %173, label %176

173:                                              ; preds = %170
  %174 = getelementptr inbounds nuw i8, ptr %167, i64 8
  %175 = load ptr, ptr %174, align 8, !tbaa !617
  br label %179

176:                                              ; preds = %170, %165
  %177 = add nuw i64 %166, 1
  %178 = icmp eq i64 %177, %161
  br i1 %178, label %179, label %165, !llvm.loop !628

179:                                              ; preds = %176, %155, %160, %173
  %180 = phi ptr [ null, %155 ], [ %175, %173 ], [ null, %160 ], [ null, %176 ]
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %20) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !629)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %11)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %12)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %13)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %14)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %15)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %16)
  store i32 3, ptr %20, align 8, !tbaa !31, !alias.scope !632
  %181 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %78, i8 0, i64 24, i1 false), !alias.scope !632
  store ptr %181, ptr %79, align 8, !tbaa !48, !alias.scope !632
  call void @llvm.experimental.noalias.scope.decl(metadata !635)
  store i32 1, ptr %11, align 8, !tbaa !31, !alias.scope !635, !noalias !629
  store double 0.000000e+00, ptr %80, align 8, !tbaa !35, !alias.scope !635, !noalias !629
  %182 = call noalias dereferenceable_or_null(7) ptr @malloc(i64 noundef 7) #34
  %183 = icmp eq ptr %182, null
  br i1 %183, label %185, label %184

184:                                              ; preds = %179
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %182, ptr noundef nonnull readonly align 1 dereferenceable(7) @.str.28, i64 7, i1 false), !noalias !638
  br label %185

185:                                              ; preds = %184, %179
  store ptr %182, ptr %81, align 8, !tbaa !46, !alias.scope !635, !noalias !629
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %82, i8 0, i64 16, i1 false), !alias.scope !635, !noalias !629
  %186 = icmp eq ptr %157, null
  %187 = select i1 %186, ptr @.str, ptr %157
  call void @llvm.experimental.noalias.scope.decl(metadata !639)
  store i32 1, ptr %12, align 8, !tbaa !31, !alias.scope !639, !noalias !629
  store double 0.000000e+00, ptr %83, align 8, !tbaa !35, !alias.scope !639, !noalias !629
  %188 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %187) #33, !noalias !642
  %189 = add i64 %188, 1
  %190 = call noalias ptr @malloc(i64 noundef %189) #34
  %191 = icmp eq ptr %190, null
  br i1 %191, label %193, label %192

192:                                              ; preds = %185
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %190, ptr nonnull readonly align 1 %187, i64 %189, i1 false), !noalias !642
  br label %193

193:                                              ; preds = %192, %185
  store ptr %190, ptr %84, align 8, !tbaa !46, !alias.scope !639, !noalias !629
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %85, i8 0, i64 16, i1 false), !alias.scope !639, !noalias !629
  call void @uh_dict_set(ptr noundef nonnull align 8 %20, ptr noundef nonnull byval(%struct.UhValue) align 8 %11, ptr noundef nonnull byval(%struct.UhValue) align 8 %12)
  call void @llvm.experimental.noalias.scope.decl(metadata !643)
  store i32 1, ptr %13, align 8, !tbaa !31, !alias.scope !643, !noalias !629
  store double 0.000000e+00, ptr %86, align 8, !tbaa !35, !alias.scope !643, !noalias !629
  %194 = call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %195 = icmp eq ptr %194, null
  br i1 %195, label %197, label %196

196:                                              ; preds = %193
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %194, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !noalias !646
  br label %197

197:                                              ; preds = %196, %193
  store ptr %194, ptr %87, align 8, !tbaa !46, !alias.scope !643, !noalias !629
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %88, i8 0, i64 16, i1 false), !alias.scope !643, !noalias !629
  %198 = select i1 %159, ptr @.str, ptr %158
  call void @llvm.experimental.noalias.scope.decl(metadata !647)
  store i32 1, ptr %14, align 8, !tbaa !31, !alias.scope !647, !noalias !629
  store double 0.000000e+00, ptr %89, align 8, !tbaa !35, !alias.scope !647, !noalias !629
  %199 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %198) #33, !noalias !650
  %200 = add i64 %199, 1
  %201 = call noalias ptr @malloc(i64 noundef %200) #34
  %202 = icmp eq ptr %201, null
  br i1 %202, label %204, label %203

203:                                              ; preds = %197
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %201, ptr nonnull readonly align 1 %198, i64 %200, i1 false), !noalias !650
  br label %204

204:                                              ; preds = %203, %197
  store ptr %201, ptr %90, align 8, !tbaa !46, !alias.scope !647, !noalias !629
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %91, i8 0, i64 16, i1 false), !alias.scope !647, !noalias !629
  call void @uh_dict_set(ptr noundef nonnull align 8 %20, ptr noundef nonnull byval(%struct.UhValue) align 8 %13, ptr noundef nonnull byval(%struct.UhValue) align 8 %14)
  call void @llvm.experimental.noalias.scope.decl(metadata !651)
  store i32 1, ptr %15, align 8, !tbaa !31, !alias.scope !651, !noalias !629
  store double 0.000000e+00, ptr %92, align 8, !tbaa !35, !alias.scope !651, !noalias !629
  %205 = call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %206 = icmp eq ptr %205, null
  br i1 %206, label %208, label %207

207:                                              ; preds = %204
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %205, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.30, i64 5, i1 false), !noalias !654
  br label %208

208:                                              ; preds = %207, %204
  store ptr %205, ptr %93, align 8, !tbaa !46, !alias.scope !651, !noalias !629
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %94, i8 0, i64 16, i1 false), !alias.scope !651, !noalias !629
  call void @llvm.experimental.noalias.scope.decl(metadata !655)
  store i32 1, ptr %16, align 8, !tbaa !31, !alias.scope !655, !noalias !629
  store double 0.000000e+00, ptr %95, align 8, !tbaa !35, !alias.scope !655, !noalias !629
  %209 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %156) #33, !noalias !658
  %210 = add i64 %209, 1
  %211 = call noalias ptr @malloc(i64 noundef %210) #34
  %212 = icmp eq ptr %211, null
  br i1 %212, label %214, label %213

213:                                              ; preds = %208
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %211, ptr nonnull readonly align 1 %156, i64 %210, i1 false), !noalias !658
  br label %214

214:                                              ; preds = %208, %213
  store ptr %211, ptr %96, align 8, !tbaa !46, !alias.scope !655, !noalias !629
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %97, i8 0, i64 16, i1 false), !alias.scope !655, !noalias !629
  call void @uh_dict_set(ptr noundef nonnull align 8 %20, ptr noundef nonnull byval(%struct.UhValue) align 8 %15, ptr noundef nonnull byval(%struct.UhValue) align 8 %16)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %11)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %12)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %13)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %14)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %15)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %16)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %21) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !659)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %6)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %8)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %9)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %10)
  store i32 3, ptr %21, align 8, !tbaa !31, !alias.scope !662
  %215 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %98, i8 0, i64 24, i1 false), !alias.scope !662
  store ptr %215, ptr %99, align 8, !tbaa !48, !alias.scope !662
  call void @llvm.experimental.noalias.scope.decl(metadata !665)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !665, !noalias !659
  store double 0.000000e+00, ptr %100, align 8, !tbaa !35, !alias.scope !665, !noalias !659
  %216 = call noalias dereferenceable_or_null(7) ptr @malloc(i64 noundef 7) #34
  %217 = icmp eq ptr %216, null
  br i1 %217, label %219, label %218

218:                                              ; preds = %214
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %216, ptr noundef nonnull readonly align 1 dereferenceable(7) @.str.32, i64 7, i1 false), !noalias !668
  br label %219

219:                                              ; preds = %218, %214
  store ptr %216, ptr %101, align 8, !tbaa !46, !alias.scope !665, !noalias !659
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %102, i8 0, i64 16, i1 false), !alias.scope !665, !noalias !659
  store i32 0, ptr %4, align 8, !tbaa !31, !alias.scope !669, !noalias !659
  store double 2.000000e+02, ptr %103, align 8, !tbaa !35, !alias.scope !669, !noalias !659
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %104, i8 0, i64 24, i1 false), !alias.scope !669, !noalias !659
  call void @uh_dict_set(ptr noundef nonnull align 8 %21, ptr noundef nonnull byval(%struct.UhValue) align 8 %3, ptr noundef nonnull byval(%struct.UhValue) align 8 %4)
  call void @llvm.experimental.noalias.scope.decl(metadata !672)
  store i32 1, ptr %5, align 8, !tbaa !31, !alias.scope !672, !noalias !659
  store double 0.000000e+00, ptr %105, align 8, !tbaa !35, !alias.scope !672, !noalias !659
  %220 = call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %221 = icmp eq ptr %220, null
  br i1 %221, label %223, label %222

222:                                              ; preds = %219
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %220, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.30, i64 5, i1 false), !noalias !675
  br label %223

223:                                              ; preds = %222, %219
  store ptr %220, ptr %106, align 8, !tbaa !46, !alias.scope !672, !noalias !659
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %107, i8 0, i64 16, i1 false), !alias.scope !672, !noalias !659
  call void @llvm.experimental.noalias.scope.decl(metadata !676)
  store i32 1, ptr %6, align 8, !tbaa !31, !alias.scope !676, !noalias !659
  store double 0.000000e+00, ptr %108, align 8, !tbaa !35, !alias.scope !676, !noalias !659
  %224 = call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %225 = icmp eq ptr %224, null
  br i1 %225, label %227, label %226

226:                                              ; preds = %223
  store i8 0, ptr %224, align 1, !noalias !679
  br label %227

227:                                              ; preds = %226, %223
  store ptr %224, ptr %109, align 8, !tbaa !46, !alias.scope !676, !noalias !659
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %110, i8 0, i64 16, i1 false), !alias.scope !676, !noalias !659
  call void @uh_dict_set(ptr noundef nonnull align 8 %21, ptr noundef nonnull byval(%struct.UhValue) align 8 %5, ptr noundef nonnull byval(%struct.UhValue) align 8 %6)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %7) #36, !noalias !659
  store i32 3, ptr %7, align 8, !tbaa !31, !alias.scope !680, !noalias !659
  %228 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %111, i8 0, i64 24, i1 false), !alias.scope !680, !noalias !659
  store ptr %228, ptr %112, align 8, !tbaa !48, !alias.scope !680, !noalias !659
  call void @llvm.experimental.noalias.scope.decl(metadata !683)
  store i32 1, ptr %8, align 8, !tbaa !31, !alias.scope !683, !noalias !659
  store double 0.000000e+00, ptr %113, align 8, !tbaa !35, !alias.scope !683, !noalias !659
  %229 = call noalias dereferenceable_or_null(13) ptr @malloc(i64 noundef 13) #34
  %230 = icmp eq ptr %229, null
  br i1 %230, label %232, label %231

231:                                              ; preds = %227
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(13) %229, ptr noundef nonnull readonly align 1 dereferenceable(13) @.str.39, i64 13, i1 false), !noalias !686
  br label %232

232:                                              ; preds = %231, %227
  store ptr %229, ptr %114, align 8, !tbaa !46, !alias.scope !683, !noalias !659
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %115, i8 0, i64 16, i1 false), !alias.scope !683, !noalias !659
  call void @llvm.experimental.noalias.scope.decl(metadata !687)
  store i32 1, ptr %9, align 8, !tbaa !31, !alias.scope !687, !noalias !659
  store double 0.000000e+00, ptr %116, align 8, !tbaa !35, !alias.scope !687, !noalias !659
  %233 = call noalias dereferenceable_or_null(17) ptr @malloc(i64 noundef 17) #34
  %234 = icmp eq ptr %233, null
  br i1 %234, label %236, label %235

235:                                              ; preds = %232
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(17) %233, ptr noundef nonnull readonly align 1 dereferenceable(17) @.str.38, i64 17, i1 false), !noalias !690
  br label %236

236:                                              ; preds = %235, %232
  store ptr %233, ptr %117, align 8, !tbaa !46, !alias.scope !687, !noalias !659
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %118, i8 0, i64 16, i1 false), !alias.scope !687, !noalias !659
  call void @uh_dict_set(ptr noundef nonnull %7, ptr noundef nonnull byval(%struct.UhValue) align 8 %8, ptr noundef nonnull byval(%struct.UhValue) align 8 %9), !noalias !659
  call void @llvm.experimental.noalias.scope.decl(metadata !691)
  store i32 1, ptr %10, align 8, !tbaa !31, !alias.scope !691, !noalias !659
  store double 0.000000e+00, ptr %119, align 8, !tbaa !35, !alias.scope !691, !noalias !659
  %237 = call noalias dereferenceable_or_null(8) ptr @malloc(i64 noundef 8) #34
  %238 = icmp eq ptr %237, null
  br i1 %238, label %240, label %239

239:                                              ; preds = %236
  store i64 32495402123093352, ptr %237, align 1, !noalias !694
  br label %240

240:                                              ; preds = %236, %239
  store ptr %237, ptr %120, align 8, !tbaa !46, !alias.scope !691, !noalias !659
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %121, i8 0, i64 16, i1 false), !alias.scope !691, !noalias !659
  call void @uh_dict_set(ptr noundef nonnull align 8 %21, ptr noundef nonnull byval(%struct.UhValue) align 8 %10, ptr noundef nonnull byval(%struct.UhValue) align 8 %7)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %7) #36, !noalias !659
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %6)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %8)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %9)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %10)
  %241 = icmp eq ptr %180, null
  br i1 %241, label %247, label %242

242:                                              ; preds = %240
  %243 = load ptr, ptr @g_env, align 8, !tbaa !522
  call void @llvm.lifetime.start.p0(i64 80, ptr nonnull %22) #36
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(40) %22, ptr noundef nonnull align 8 dereferenceable(40) %20, i64 40, i1 false), !tbaa.struct !25
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %122, ptr noundef nonnull align 8 dereferenceable(40) %21, i64 40, i1 false), !tbaa.struct !25
  %244 = icmp eq ptr %243, null
  br i1 %244, label %246, label %245

245:                                              ; preds = %242
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %23) #36
  call void @uh_call_named(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %23, ptr noundef nonnull %243, ptr noundef nonnull %180, i32 noundef 2, ptr noundef nonnull %22) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %23) #36
  br label %246

246:                                              ; preds = %245, %242
  call void @llvm.lifetime.end.p0(i64 80, ptr nonnull %22) #36
  br label %260

247:                                              ; preds = %240
  call void @llvm.experimental.noalias.scope.decl(metadata !695)
  store i32 1, ptr %24, align 8, !tbaa !31, !alias.scope !695
  store double 0.000000e+00, ptr %123, align 8, !tbaa !35, !alias.scope !695
  %248 = call noalias dereferenceable_or_null(7) ptr @malloc(i64 noundef 7) #34
  %249 = icmp eq ptr %248, null
  br i1 %249, label %251, label %250

250:                                              ; preds = %247
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %248, ptr noundef nonnull readonly align 1 dereferenceable(7) @.str.32, i64 7, i1 false), !noalias !695
  br label %251

251:                                              ; preds = %247, %250
  store ptr %248, ptr %124, align 8, !tbaa !46, !alias.scope !695
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %125, i8 0, i64 16, i1 false), !alias.scope !695
  store i32 0, ptr %25, align 8, !tbaa !31, !alias.scope !698
  store double 4.040000e+02, ptr %126, align 8, !tbaa !35, !alias.scope !698
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %127, i8 0, i64 24, i1 false), !alias.scope !698
  call void @uh_dict_set(ptr noundef nonnull %21, ptr noundef nonnull byval(%struct.UhValue) align 8 %24, ptr noundef nonnull byval(%struct.UhValue) align 8 %25)
  call void @llvm.experimental.noalias.scope.decl(metadata !701)
  store i32 1, ptr %26, align 8, !tbaa !31, !alias.scope !701
  store double 0.000000e+00, ptr %128, align 8, !tbaa !35, !alias.scope !701
  %252 = call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %253 = icmp eq ptr %252, null
  br i1 %253, label %255, label %254

254:                                              ; preds = %251
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %252, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.30, i64 5, i1 false), !noalias !701
  br label %255

255:                                              ; preds = %251, %254
  store ptr %252, ptr %129, align 8, !tbaa !46, !alias.scope !701
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %130, i8 0, i64 16, i1 false), !alias.scope !701
  call void @llvm.experimental.noalias.scope.decl(metadata !704)
  store i32 1, ptr %27, align 8, !tbaa !31, !alias.scope !704
  store double 0.000000e+00, ptr %131, align 8, !tbaa !35, !alias.scope !704
  %256 = call noalias dereferenceable_or_null(10) ptr @malloc(i64 noundef 10) #34
  %257 = icmp eq ptr %256, null
  br i1 %257, label %259, label %258

258:                                              ; preds = %255
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(10) %256, ptr noundef nonnull readonly align 1 dereferenceable(10) @.str.37, i64 10, i1 false), !noalias !704
  br label %259

259:                                              ; preds = %255, %258
  store ptr %256, ptr %132, align 8, !tbaa !46, !alias.scope !704
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %133, i8 0, i64 16, i1 false), !alias.scope !704
  call void @uh_dict_set(ptr noundef nonnull %21, ptr noundef nonnull byval(%struct.UhValue) align 8 %26, ptr noundef nonnull byval(%struct.UhValue) align 8 %27)
  br label %260

260:                                              ; preds = %259, %246
  %261 = icmp eq ptr %215, null
  br i1 %261, label %262, label %263

262:                                              ; preds = %260
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %28) #36
  store i32 4, ptr %28, align 8, !tbaa !31, !alias.scope !707
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %134, i8 0, i64 32, i1 false), !alias.scope !707
  br label %358

263:                                              ; preds = %260
  %264 = getelementptr inbounds nuw i8, ptr %215, i64 8
  %265 = load i64, ptr %264, align 8, !tbaa !65, !noalias !712
  %266 = icmp eq i64 %265, 0
  br i1 %266, label %267, label %268

267:                                              ; preds = %263
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %28) #36
  br label %298

268:                                              ; preds = %263
  %269 = load ptr, ptr %215, align 8, !tbaa !68, !noalias !712
  br label %274

270:                                              ; preds = %274
  %271 = add nuw i64 %275, 1
  %272 = icmp eq i64 %271, %265
  br i1 %272, label %273, label %274, !llvm.loop !69

273:                                              ; preds = %270
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %28) #36
  br label %285

274:                                              ; preds = %270, %268
  %275 = phi i64 [ 0, %268 ], [ %271, %270 ]
  %276 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %269, i64 %275
  %277 = load ptr, ptr %276, align 8, !tbaa !70, !noalias !712
  %278 = call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %277, ptr noundef nonnull readonly dereferenceable(7) @.str.32) #33, !noalias !712
  %279 = icmp eq i32 %278, 0
  br i1 %279, label %280, label %270

280:                                              ; preds = %274
  %281 = getelementptr inbounds nuw i8, ptr %276, i64 8
  %282 = load i32, ptr %281, align 8, !tbaa !26
  %283 = getelementptr inbounds nuw i8, ptr %276, i64 16
  %284 = load double, ptr %283, align 8, !tbaa !27
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %28) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !715)
  br label %285

285:                                              ; preds = %280, %273
  %286 = phi i32 [ 4, %273 ], [ %282, %280 ]
  %287 = phi double [ 0.000000e+00, %273 ], [ %284, %280 ]
  %288 = load ptr, ptr %215, align 8, !tbaa !68, !noalias !715
  br label %292

289:                                              ; preds = %292
  %290 = add nuw i64 %293, 1
  %291 = icmp eq i64 %290, %265
  br i1 %291, label %298, label %292, !llvm.loop !69

292:                                              ; preds = %289, %285
  %293 = phi i64 [ 0, %285 ], [ %290, %289 ]
  %294 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %288, i64 %293
  %295 = load ptr, ptr %294, align 8, !tbaa !70, !noalias !715
  %296 = call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %295, ptr noundef nonnull readonly dereferenceable(5) @.str.30) #33, !noalias !715
  %297 = icmp eq i32 %296, 0
  br i1 %297, label %301, label %289

298:                                              ; preds = %289, %267
  %299 = phi i32 [ 4, %267 ], [ %286, %289 ]
  %300 = phi double [ 0.000000e+00, %267 ], [ %287, %289 ]
  store i32 4, ptr %28, align 8, !tbaa !31, !alias.scope !716
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %134, i8 0, i64 32, i1 false), !alias.scope !716
  br label %303

301:                                              ; preds = %292
  %302 = getelementptr inbounds nuw i8, ptr %294, i64 8
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %28, ptr noundef nonnull align 8 dereferenceable(40) %302, i64 40, i1 false), !tbaa.struct !25
  br label %303

303:                                              ; preds = %298, %301
  %304 = phi i32 [ %299, %298 ], [ %286, %301 ]
  %305 = phi double [ %300, %298 ], [ %287, %301 ]
  br i1 %266, label %352, label %306

306:                                              ; preds = %303
  %307 = load ptr, ptr %215, align 8, !tbaa !68, !noalias !719
  br label %311

308:                                              ; preds = %311
  %309 = add nuw i64 %312, 1
  %310 = icmp eq i64 %309, %265
  br i1 %310, label %352, label %311, !llvm.loop !69

311:                                              ; preds = %308, %306
  %312 = phi i64 [ 0, %306 ], [ %309, %308 ]
  %313 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %307, i64 %312
  %314 = load ptr, ptr %313, align 8, !tbaa !70, !noalias !719
  %315 = call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %314, ptr noundef nonnull readonly dereferenceable(8) @.str.29) #33, !noalias !719
  %316 = icmp eq i32 %315, 0
  br i1 %316, label %317, label %308

317:                                              ; preds = %311
  %318 = getelementptr inbounds nuw i8, ptr %313, i64 8
  %319 = load i32, ptr %318, align 8, !tbaa !26
  %320 = getelementptr inbounds nuw i8, ptr %313, i64 40
  %321 = load ptr, ptr %320, align 4, !tbaa !30
  %322 = icmp eq i32 %319, 3
  br i1 %322, label %323, label %352

323:                                              ; preds = %317
  %324 = icmp eq ptr %321, null
  br i1 %324, label %346, label %325

325:                                              ; preds = %323
  %326 = getelementptr inbounds nuw i8, ptr %321, i64 8
  %327 = load i64, ptr %326, align 8, !tbaa !65, !noalias !722
  %328 = icmp eq i64 %327, 0
  br i1 %328, label %346, label %329

329:                                              ; preds = %325
  %330 = load ptr, ptr %321, align 8, !tbaa !68, !noalias !722
  br label %334

331:                                              ; preds = %334
  %332 = add nuw i64 %335, 1
  %333 = icmp eq i64 %332, %327
  br i1 %333, label %346, label %334, !llvm.loop !69

334:                                              ; preds = %331, %329
  %335 = phi i64 [ 0, %329 ], [ %332, %331 ]
  %336 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %330, i64 %335
  %337 = load ptr, ptr %336, align 8, !tbaa !70, !noalias !722
  %338 = call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %337, ptr noundef nonnull readonly dereferenceable(13) @.str.39) #33, !noalias !722
  %339 = icmp eq i32 %338, 0
  br i1 %339, label %340, label %331

340:                                              ; preds = %334
  %341 = getelementptr inbounds nuw i8, ptr %336, i64 8
  %342 = load i32, ptr %341, align 8, !tbaa !26
  %343 = getelementptr inbounds nuw i8, ptr %336, i64 24
  %344 = load ptr, ptr %343, align 8, !tbaa !28
  %345 = icmp eq i32 %342, 1
  br label %346

346:                                              ; preds = %331, %325, %323, %340
  %347 = phi ptr [ %344, %340 ], [ null, %323 ], [ null, %325 ], [ null, %331 ]
  %348 = phi i1 [ %345, %340 ], [ false, %323 ], [ false, %325 ], [ false, %331 ]
  %349 = icmp ne ptr %347, null
  %350 = select i1 %348, i1 %349, i1 false
  %351 = select i1 %350, ptr %347, ptr @.str.38
  br label %352

352:                                              ; preds = %308, %303, %346, %317
  %353 = phi ptr [ %351, %346 ], [ @.str.38, %317 ], [ @.str.38, %303 ], [ @.str.38, %308 ]
  %354 = freeze i32 %304
  %355 = icmp eq i32 %354, 0
  %356 = fptosi double %305 to i64
  %357 = select i1 %355, i64 %356, i64 200
  br label %358

358:                                              ; preds = %352, %262
  %359 = phi ptr [ @.str.38, %262 ], [ %353, %352 ]
  %360 = phi i64 [ 200, %262 ], [ %357, %352 ]
  %361 = call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %28)
  %362 = icmp ne ptr %361, null
  br i1 %362, label %363, label %365

363:                                              ; preds = %358
  %364 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %361) #33
  br label %365

365:                                              ; preds = %358, %363
  %366 = phi i64 [ %364, %363 ], [ 0, %358 ]
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %29) #36
  %367 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %29, i64 noundef 256, ptr noundef nonnull @.str.40, i64 noundef %360, ptr noundef %359, i64 noundef %366) #36
  %368 = sext i32 %367 to i64
  %369 = call i64 @send(i32 noundef %136, ptr noundef nonnull %29, i64 noundef %368, i32 noundef 0) #36
  %370 = icmp ne i64 %366, 0
  %371 = and i1 %362, %370
  br i1 %371, label %372, label %374

372:                                              ; preds = %365
  %373 = call i64 @send(i32 noundef %136, ptr noundef nonnull %361, i64 noundef %366, i32 noundef 0) #36
  br label %374

374:                                              ; preds = %372, %365
  call void @free(ptr noundef %361) #36
  %375 = call i32 @close(i32 noundef %136) #36
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %29) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %28) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %21) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %20) #36
  br label %376

376:                                              ; preds = %148, %374, %153, %142
  call void @llvm.lifetime.end.p0(i64 8192, ptr nonnull %19) #36
  br label %138

377:                                              ; preds = %74, %65
  %378 = call i32 @close(i32 noundef %61) #36
  store i32 0, ptr %0, align 8, !tbaa !31
  %379 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %379, i8 0, i64 32, i1 false)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %18) #36
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %17) #36
  br label %380

380:                                              ; preds = %63, %377, %58
  ret void
}

; Function Attrs: nounwind
declare i32 @socket(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #23

; Function Attrs: nounwind
declare i32 @setsockopt(i32 noundef, i32 noundef, i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #23

; Function Attrs: nounwind
declare i32 @bind(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #23

declare i32 @close(i32 noundef) local_unnamed_addr #22

; Function Attrs: nounwind
declare i32 @listen(i32 noundef, i32 noundef) local_unnamed_addr #23

declare i32 @accept(i32 noundef, ptr noundef, ptr noundef) local_unnamed_addr #22

declare i64 @recv(i32 noundef, ptr noundef, i64 noundef, i32 noundef) local_unnamed_addr #22

; Function Attrs: mustprogress nocallback nofree nounwind willreturn
declare ptr @strtok(ptr noundef, ptr noundef readonly captures(none)) local_unnamed_addr #19

declare void @uh_call_named(ptr dead_on_unwind writable sret(%struct.UhValue) align 8, ptr noundef, ptr noundef, i32 noundef, ptr noundef) local_unnamed_addr #22

declare i64 @send(i32 noundef, ptr noundef, i64 noundef, i32 noundef) local_unnamed_addr #22

; Function Attrs: nofree nounwind sspstrong uwtable
define dso_local void @uh_http_method(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #4 {
  %3 = load i32, ptr %1, align 8
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %5 = load ptr, ptr %4, align 8
  %6 = icmp ne i32 %3, 3
  %7 = icmp eq ptr %5, null
  %8 = select i1 %6, i1 true, i1 %7
  br i1 %8, label %31, label %9

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !65, !noalias !725
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %31, label %13

13:                                               ; preds = %9
  %14 = load ptr, ptr %5, align 8, !tbaa !68, !noalias !725
  br label %18

15:                                               ; preds = %18
  %16 = add nuw i64 %19, 1
  %17 = icmp eq i64 %16, %11
  br i1 %17, label %31, label %18, !llvm.loop !69

18:                                               ; preds = %15, %13
  %19 = phi i64 [ 0, %13 ], [ %16, %15 ]
  %20 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %14, i64 %19
  %21 = load ptr, ptr %20, align 8, !tbaa !70, !noalias !725
  %22 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %21, ptr noundef nonnull readonly dereferenceable(7) @.str.28) #33, !noalias !725
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %15

24:                                               ; preds = %18
  %25 = getelementptr inbounds nuw i8, ptr %20, i64 8
  %26 = load i32, ptr %25, align 8, !tbaa !26
  %27 = getelementptr inbounds nuw i8, ptr %20, i64 24
  %28 = load ptr, ptr %27, align 8, !tbaa !28
  %29 = icmp eq i32 %26, 1
  %30 = select i1 %29, ptr %28, ptr null
  br label %31

31:                                               ; preds = %15, %2, %9, %24
  %32 = phi ptr [ %30, %24 ], [ null, %2 ], [ null, %9 ], [ null, %15 ]
  %33 = icmp eq ptr %32, null
  %34 = select i1 %33, ptr @.str, ptr %32
  tail call void @llvm.experimental.noalias.scope.decl(metadata !728)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !728
  %35 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %35, align 8, !tbaa !35, !alias.scope !728
  %36 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %34) #33, !noalias !728
  %37 = add i64 %36, 1
  %38 = tail call noalias ptr @malloc(i64 noundef %37) #34
  %39 = icmp eq ptr %38, null
  br i1 %39, label %41, label %40

40:                                               ; preds = %31
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %38, ptr nonnull readonly align 1 %34, i64 %37, i1 false), !noalias !728
  br label %41

41:                                               ; preds = %31, %40
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %38, ptr %42, align 8, !tbaa !46, !alias.scope !728
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %43, i8 0, i64 16, i1 false), !alias.scope !728
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_http_json(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(address_is_null) %2) local_unnamed_addr #12 {
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca ptr, align 8
  %8 = alloca %struct.UhValue, align 8
  %9 = alloca %struct.UhValue, align 8
  %10 = alloca %struct.UhValue, align 8
  %11 = load i32, ptr %2, align 8, !tbaa !31
  %12 = icmp eq i32 %11, 3
  br i1 %12, label %13, label %109

13:                                               ; preds = %3
  %14 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %15 = load ptr, ptr %14, align 8
  %16 = icmp eq ptr %15, null
  br i1 %16, label %38, label %17

17:                                               ; preds = %13
  %18 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %19 = load i64, ptr %18, align 8, !tbaa !65, !noalias !731
  %20 = icmp eq i64 %19, 0
  br i1 %20, label %38, label %21

21:                                               ; preds = %17
  %22 = load ptr, ptr %15, align 8, !tbaa !68, !noalias !731
  br label %26

23:                                               ; preds = %26
  %24 = add nuw i64 %27, 1
  %25 = icmp eq i64 %24, %19
  br i1 %25, label %38, label %26, !llvm.loop !69

26:                                               ; preds = %23, %21
  %27 = phi i64 [ 0, %21 ], [ %24, %23 ]
  %28 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %22, i64 %27
  %29 = load ptr, ptr %28, align 8, !tbaa !70, !noalias !731
  %30 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %29, ptr noundef nonnull readonly dereferenceable(5) @.str.30) #33, !noalias !731
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %32, label %23

32:                                               ; preds = %26
  %33 = getelementptr inbounds nuw i8, ptr %28, i64 8
  %34 = load i32, ptr %33, align 8, !tbaa !26
  %35 = getelementptr inbounds nuw i8, ptr %28, i64 24
  %36 = load ptr, ptr %35, align 8, !tbaa !28
  %37 = icmp eq i32 %34, 1
  br label %38

38:                                               ; preds = %23, %17, %13, %32
  %39 = phi ptr [ %36, %32 ], [ null, %13 ], [ null, %17 ], [ null, %23 ]
  %40 = phi i1 [ %37, %32 ], [ false, %13 ], [ false, %17 ], [ false, %23 ]
  %41 = load i32, ptr %1, align 8, !tbaa !31
  %42 = icmp eq i32 %41, 0
  %43 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %44 = load double, ptr %43, align 8
  %45 = fcmp oeq double %44, 0.000000e+00
  %46 = select i1 %42, i1 %45, i1 false
  %47 = icmp eq i32 %41, 4
  %48 = or i1 %47, %46
  br i1 %48, label %49, label %55

49:                                               ; preds = %38
  %50 = icmp ne ptr %39, null
  %51 = select i1 %40, i1 %50, i1 false
  br i1 %51, label %52, label %53

52:                                               ; preds = %49
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %7) #36, !noalias !734
  store ptr %39, ptr %7, align 8, !tbaa !28, !noalias !734
  call fastcc void @uh_json_parse_value(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef %7)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %7) #36, !noalias !734
  br label %111

53:                                               ; preds = %49
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !737
  %54 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %54, i8 0, i64 32, i1 false), !alias.scope !737
  br label %111

55:                                               ; preds = %38
  %56 = icmp eq i32 %41, 3
  br i1 %56, label %57, label %88

57:                                               ; preds = %55
  %58 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %59 = load ptr, ptr %58, align 8
  %60 = icmp eq ptr %59, null
  br i1 %60, label %88, label %61

61:                                               ; preds = %57
  %62 = getelementptr inbounds nuw i8, ptr %59, i64 8
  %63 = load i64, ptr %62, align 8, !tbaa !65, !noalias !740
  %64 = icmp eq i64 %63, 0
  br i1 %64, label %88, label %65

65:                                               ; preds = %61
  %66 = load ptr, ptr %59, align 8, !tbaa !68, !noalias !740
  br label %70

67:                                               ; preds = %70
  %68 = add nuw i64 %71, 1
  %69 = icmp eq i64 %68, %63
  br i1 %69, label %88, label %70, !llvm.loop !69

70:                                               ; preds = %67, %65
  %71 = phi i64 [ 0, %65 ], [ %68, %67 ]
  %72 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %66, i64 %71
  %73 = load ptr, ptr %72, align 8, !tbaa !70, !noalias !740
  %74 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %73, ptr noundef nonnull readonly dereferenceable(7) @.str.32) #33, !noalias !740
  %75 = icmp eq i32 %74, 0
  br i1 %75, label %76, label %67

76:                                               ; preds = %70
  %77 = getelementptr inbounds nuw i8, ptr %72, i64 8
  %78 = load i32, ptr %77, align 8, !tbaa !26
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %80, label %88

80:                                               ; preds = %76
  tail call void @llvm.experimental.noalias.scope.decl(metadata !743)
  store i32 1, ptr %8, align 8, !tbaa !31, !alias.scope !743
  %81 = getelementptr inbounds nuw i8, ptr %8, i64 8
  store double 0.000000e+00, ptr %81, align 8, !tbaa !35, !alias.scope !743
  %82 = tail call noalias dereferenceable_or_null(7) ptr @malloc(i64 noundef 7) #34
  %83 = icmp eq ptr %82, null
  br i1 %83, label %85, label %84

84:                                               ; preds = %80
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %82, ptr noundef nonnull readonly align 1 dereferenceable(7) @.str.32, i64 7, i1 false), !noalias !743
  br label %85

85:                                               ; preds = %80, %84
  %86 = getelementptr inbounds nuw i8, ptr %8, i64 16
  store ptr %82, ptr %86, align 8, !tbaa !46, !alias.scope !743
  %87 = getelementptr inbounds nuw i8, ptr %8, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %87, i8 0, i64 16, i1 false), !alias.scope !743
  call void @uh_dict_set(ptr noundef nonnull %2, ptr noundef nonnull byval(%struct.UhValue) align 8 %8, ptr noundef nonnull byval(%struct.UhValue) align 8 %77)
  br label %88

88:                                               ; preds = %76, %85, %57, %61, %67, %55
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %9) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !746)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %4) #36, !noalias !746
  store ptr null, ptr %4, align 8, !tbaa !28, !noalias !746
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %5) #36, !noalias !746
  store i64 0, ptr %5, align 8, !tbaa !368, !noalias !746
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %6) #36, !noalias !746
  store i64 0, ptr %6, align 8, !tbaa !368, !noalias !746
  call fastcc void @uh_json_stringify_value(ptr noundef %4, ptr noundef %5, ptr noundef %6, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %89 = load ptr, ptr %4, align 8, !tbaa !28, !noalias !746
  %90 = icmp eq ptr %89, null
  br i1 %90, label %91, label %96

91:                                               ; preds = %88
  call void @llvm.experimental.noalias.scope.decl(metadata !749)
  store i32 1, ptr %9, align 8, !tbaa !31, !alias.scope !752
  %92 = getelementptr inbounds nuw i8, ptr %9, i64 8
  store double 0.000000e+00, ptr %92, align 8, !tbaa !35, !alias.scope !752
  %93 = call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %94 = icmp eq ptr %93, null
  br i1 %94, label %98, label %95

95:                                               ; preds = %91
  store i8 0, ptr %93, align 1, !noalias !752
  br label %98

96:                                               ; preds = %88
  store i32 1, ptr %9, align 8, !tbaa !31, !alias.scope !746
  %97 = getelementptr inbounds nuw i8, ptr %9, i64 8
  store double 0.000000e+00, ptr %97, align 8, !tbaa !35, !alias.scope !746
  br label %98

98:                                               ; preds = %91, %95, %96
  %99 = phi ptr [ %89, %96 ], [ %93, %95 ], [ %93, %91 ]
  %100 = getelementptr inbounds nuw i8, ptr %9, i64 16
  store ptr %99, ptr %100, align 8, !tbaa !46, !alias.scope !746
  %101 = getelementptr inbounds nuw i8, ptr %9, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %101, i8 0, i64 16, i1 false), !alias.scope !746
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %6) #36, !noalias !746
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %5) #36, !noalias !746
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %4) #36, !noalias !746
  call void @llvm.experimental.noalias.scope.decl(metadata !753)
  store i32 1, ptr %10, align 8, !tbaa !31, !alias.scope !753
  %102 = getelementptr inbounds nuw i8, ptr %10, i64 8
  store double 0.000000e+00, ptr %102, align 8, !tbaa !35, !alias.scope !753
  %103 = call noalias dereferenceable_or_null(5) ptr @malloc(i64 noundef 5) #34
  %104 = icmp eq ptr %103, null
  br i1 %104, label %106, label %105

105:                                              ; preds = %98
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %103, ptr noundef nonnull readonly align 1 dereferenceable(5) @.str.30, i64 5, i1 false), !noalias !753
  br label %106

106:                                              ; preds = %105, %98
  %107 = getelementptr inbounds nuw i8, ptr %10, i64 16
  store ptr %103, ptr %107, align 8, !tbaa !46, !alias.scope !753
  %108 = getelementptr inbounds nuw i8, ptr %10, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %108, i8 0, i64 16, i1 false), !alias.scope !753
  call void @uh_dict_set(ptr noundef nonnull %2, ptr noundef nonnull byval(%struct.UhValue) align 8 %10, ptr noundef nonnull byval(%struct.UhValue) align 8 %9)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %9) #36
  br label %109

109:                                              ; preds = %106, %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !756
  %110 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %110, i8 0, i64 32, i1 false), !alias.scope !756
  br label %111

111:                                              ; preds = %52, %53, %109
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_json_parse(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca ptr, align 8
  %4 = load i32, ptr %1, align 8, !tbaa !31
  %5 = icmp ne i32 %4, 1
  %6 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %7 = load ptr, ptr %6, align 8
  %8 = icmp eq ptr %7, null
  %9 = select i1 %5, i1 true, i1 %8
  br i1 %9, label %10, label %12

10:                                               ; preds = %2
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !759
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %11, i8 0, i64 32, i1 false), !alias.scope !759
  br label %13

12:                                               ; preds = %2
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #36
  store ptr %7, ptr %3, align 8, !tbaa !28
  call fastcc void @uh_json_parse_value(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef %3)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #36
  br label %13

13:                                               ; preds = %12, %10
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_json_stringify(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #36
  store ptr null, ptr %3, align 8, !tbaa !28
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %4) #36
  store i64 0, ptr %4, align 8, !tbaa !368
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %5) #36
  store i64 0, ptr %5, align 8, !tbaa !368
  call fastcc void @uh_json_stringify_value(ptr noundef %3, ptr noundef %4, ptr noundef %5, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %6 = load ptr, ptr %3, align 8, !tbaa !28
  %7 = icmp eq ptr %6, null
  br i1 %7, label %8, label %13

8:                                                ; preds = %2
  call void @llvm.experimental.noalias.scope.decl(metadata !762)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !762
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %9, align 8, !tbaa !35, !alias.scope !762
  %10 = call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %11 = icmp eq ptr %10, null
  br i1 %11, label %15, label %12

12:                                               ; preds = %8
  store i8 0, ptr %10, align 1, !noalias !762
  br label %15

13:                                               ; preds = %2
  store i32 1, ptr %0, align 8, !tbaa !31
  %14 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %14, align 8, !tbaa !35
  br label %15

15:                                               ; preds = %12, %8, %13
  %16 = phi ptr [ %6, %13 ], [ %10, %8 ], [ %10, %12 ]
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %16, ptr %17, align 8, !tbaa !46
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %18, i8 0, i64 16, i1 false)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %5) #36
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %4) #36
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #36
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_db_connect(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca ptr, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = load i32, ptr %1, align 8, !tbaa !31
  %7 = icmp eq i32 %6, 3
  br i1 %7, label %8, label %54

8:                                                ; preds = %2
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %10 = load ptr, ptr %9, align 8
  %11 = icmp eq ptr %10, null
  br i1 %11, label %54, label %12

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %14 = load i64, ptr %13, align 8, !tbaa !65, !noalias !765
  %15 = icmp eq i64 %14, 0
  br i1 %15, label %54, label %16

16:                                               ; preds = %12
  %17 = load ptr, ptr %10, align 8, !tbaa !68, !noalias !765
  br label %21

18:                                               ; preds = %21
  %19 = add nuw i64 %22, 1
  %20 = icmp eq i64 %19, %14
  br i1 %20, label %36, label %21, !llvm.loop !69

21:                                               ; preds = %18, %16
  %22 = phi i64 [ 0, %16 ], [ %19, %18 ]
  %23 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %17, i64 %22
  %24 = load ptr, ptr %23, align 8, !tbaa !70, !noalias !765
  %25 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %24, ptr noundef nonnull readonly dereferenceable(9) @.str.41) #33, !noalias !765
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %27, label %18

27:                                               ; preds = %21
  %28 = getelementptr inbounds nuw i8, ptr %23, i64 8
  %29 = load i32, ptr %28, align 8, !tbaa !26
  %30 = getelementptr inbounds nuw i8, ptr %23, i64 24
  %31 = load ptr, ptr %30, align 8, !tbaa !28
  %32 = icmp eq i32 %29, 1
  %33 = icmp ne ptr %31, null
  %34 = select i1 %32, i1 %33, i1 false
  %35 = select i1 %32, ptr %31, ptr null
  br i1 %34, label %54, label %36

36:                                               ; preds = %18, %27
  %37 = load ptr, ptr %10, align 8, !tbaa !68, !noalias !768
  br label %41

38:                                               ; preds = %41
  %39 = add nuw i64 %42, 1
  %40 = icmp eq i64 %39, %14
  br i1 %40, label %54, label %41, !llvm.loop !69

41:                                               ; preds = %38, %36
  %42 = phi i64 [ 0, %36 ], [ %39, %38 ]
  %43 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %37, i64 %42
  %44 = load ptr, ptr %43, align 8, !tbaa !70, !noalias !768
  %45 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %44, ptr noundef nonnull readonly dereferenceable(5) @.str.3) #33, !noalias !768
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %47, label %38

47:                                               ; preds = %41
  %48 = getelementptr inbounds nuw i8, ptr %43, i64 8
  %49 = load i32, ptr %48, align 8, !tbaa !26
  %50 = getelementptr inbounds nuw i8, ptr %43, i64 24
  %51 = load ptr, ptr %50, align 8, !tbaa !28
  %52 = icmp eq i32 %49, 1
  %53 = select i1 %52, ptr %51, ptr null
  br label %54

54:                                               ; preds = %38, %27, %12, %8, %47, %2
  %55 = phi ptr [ null, %2 ], [ %53, %47 ], [ null, %8 ], [ %35, %27 ], [ null, %12 ], [ null, %38 ]
  %56 = icmp eq ptr %55, null
  %57 = select i1 %56, ptr @.str.42, ptr %55
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #36
  store ptr null, ptr %3, align 8, !tbaa !771
  %58 = call i32 @sqlite3_open(ptr noundef nonnull %57, ptr noundef nonnull %3) #36
  %59 = icmp eq i32 %58, 0
  %60 = load ptr, ptr %3, align 8, !tbaa !771
  br i1 %59, label %67, label %61

61:                                               ; preds = %54
  %62 = icmp eq ptr %60, null
  br i1 %62, label %65, label %63

63:                                               ; preds = %61
  %64 = call i32 @sqlite3_close(ptr noundef nonnull %60) #36
  br label %65

65:                                               ; preds = %63, %61
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !773
  %66 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %66, i8 0, i64 32, i1 false), !alias.scope !773
  br label %101

67:                                               ; preds = %54
  %68 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %57) #33
  %69 = add i64 %68, 1
  %70 = call noalias ptr @malloc(i64 noundef %69) #34
  %71 = icmp eq ptr %70, null
  br i1 %71, label %73, label %72

72:                                               ; preds = %67
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %70, ptr nonnull readonly align 1 %57, i64 %69, i1 false)
  br label %73

73:                                               ; preds = %67, %72
  %74 = load ptr, ptr @g_db, align 8, !tbaa !485
  %75 = load i64, ptr @g_db_len, align 8, !tbaa !368
  %76 = shl i64 %75, 4
  %77 = add i64 %76, 16
  %78 = call ptr @realloc(ptr noundef %74, i64 noundef %77) #35
  %79 = icmp eq ptr %78, null
  br i1 %79, label %80, label %84

80:                                               ; preds = %73
  %81 = load ptr, ptr %3, align 8, !tbaa !771
  %82 = call i32 @sqlite3_close(ptr noundef %81) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !776
  %83 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %83, i8 0, i64 32, i1 false), !alias.scope !776
  br label %101

84:                                               ; preds = %73
  store ptr %78, ptr @g_db, align 8, !tbaa !485
  %85 = getelementptr inbounds nuw %struct.UhDbConn, ptr %78, i64 %75
  store ptr %60, ptr %85, align 8, !tbaa !771
  %86 = getelementptr inbounds nuw i8, ptr %85, i64 8
  store ptr %70, ptr %86, align 8, !tbaa !28
  %87 = add i64 %75, 1
  store i64 %87, ptr @g_db_len, align 8, !tbaa !368
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !779
  %88 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %89 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %90 = getelementptr inbounds nuw i8, ptr %0, i64 32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %88, i8 0, i64 24, i1 false), !alias.scope !779
  store ptr %89, ptr %90, align 8, !tbaa !48, !alias.scope !779
  call void @llvm.experimental.noalias.scope.decl(metadata !782)
  store i32 1, ptr %4, align 8, !tbaa !31, !alias.scope !782
  %91 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store double 0.000000e+00, ptr %91, align 8, !tbaa !35, !alias.scope !782
  %92 = call noalias dereferenceable_or_null(8) ptr @malloc(i64 noundef 8) #34
  %93 = icmp eq ptr %92, null
  br i1 %93, label %95, label %94

94:                                               ; preds = %84
  store i64 28263356064620383, ptr %92, align 1, !noalias !782
  br label %95

95:                                               ; preds = %84, %94
  %96 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store ptr %92, ptr %96, align 8, !tbaa !46, !alias.scope !782
  %97 = getelementptr inbounds nuw i8, ptr %4, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %97, i8 0, i64 16, i1 false), !alias.scope !782
  %98 = uitofp i64 %87 to double
  store i32 0, ptr %5, align 8, !tbaa !31, !alias.scope !785
  %99 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store double %98, ptr %99, align 8, !tbaa !35, !alias.scope !785
  %100 = getelementptr inbounds nuw i8, ptr %5, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %100, i8 0, i64 24, i1 false), !alias.scope !785
  call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %4, ptr noundef nonnull byval(%struct.UhValue) align 8 %5)
  br label %101

101:                                              ; preds = %80, %95, %65
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #36
  ret void
}

declare i32 @sqlite3_open(ptr noundef, ptr noundef) local_unnamed_addr #22

declare i32 @sqlite3_close(ptr noundef) local_unnamed_addr #22

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_db_exec(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca ptr, align 8
  %5 = load i32, ptr %2, align 8
  %6 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %7 = load ptr, ptr %6, align 8
  %8 = icmp ne i32 %5, 3
  %9 = icmp eq ptr %7, null
  %10 = select i1 %8, i1 true, i1 %9
  br i1 %10, label %44, label %11

11:                                               ; preds = %3
  %12 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %13 = load i64, ptr %12, align 8, !tbaa !65, !noalias !788
  %14 = icmp eq i64 %13, 0
  br i1 %14, label %44, label %15

15:                                               ; preds = %11
  %16 = load ptr, ptr %7, align 8, !tbaa !68, !noalias !788
  br label %20

17:                                               ; preds = %20
  %18 = add nuw i64 %21, 1
  %19 = icmp eq i64 %18, %13
  br i1 %19, label %44, label %20, !llvm.loop !69

20:                                               ; preds = %17, %15
  %21 = phi i64 [ 0, %15 ], [ %18, %17 ]
  %22 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %16, i64 %21
  %23 = load ptr, ptr %22, align 8, !tbaa !70, !noalias !788
  %24 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %23, ptr noundef nonnull readonly dereferenceable(8) @.str.43) #33, !noalias !788
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %17

26:                                               ; preds = %20
  %27 = getelementptr inbounds nuw i8, ptr %22, i64 8
  %28 = load i32, ptr %27, align 8, !tbaa !26
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %30, label %44

30:                                               ; preds = %26
  %31 = getelementptr inbounds nuw i8, ptr %22, i64 16
  %32 = load double, ptr %31, align 8, !tbaa !27
  %33 = fptosi double %32 to i64
  %34 = icmp slt i64 %33, 1
  %35 = load i64, ptr @g_db_len, align 8
  %36 = icmp ult i64 %35, %33
  %37 = select i1 %34, i1 true, i1 %36
  br i1 %37, label %44, label %38

38:                                               ; preds = %30
  %39 = load ptr, ptr @g_db, align 8, !tbaa !485
  %40 = getelementptr %struct.UhDbConn, ptr %39, i64 %33
  %41 = getelementptr i8, ptr %40, i64 -16
  %42 = load ptr, ptr %41, align 8, !tbaa !791
  %43 = icmp eq ptr %42, null
  br i1 %43, label %44, label %46

44:                                               ; preds = %17, %3, %11, %30, %26, %38
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !793
  %45 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %45, i8 0, i64 32, i1 false)
  br label %61

46:                                               ; preds = %38
  %47 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %48 = icmp eq ptr %47, null
  br i1 %48, label %49, label %51

49:                                               ; preds = %46
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !796
  %50 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %50, i8 0, i64 32, i1 false)
  br label %61

51:                                               ; preds = %46
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %4) #36
  store ptr null, ptr %4, align 8, !tbaa !28
  %52 = call i32 @sqlite3_exec(ptr noundef nonnull %42, ptr noundef nonnull %47, ptr noundef null, ptr noundef null, ptr noundef nonnull %4) #36
  %53 = load ptr, ptr %4, align 8, !tbaa !28
  %54 = icmp eq ptr %53, null
  br i1 %54, label %56, label %55

55:                                               ; preds = %51
  call void @sqlite3_free(ptr noundef nonnull %53) #36
  br label %56

56:                                               ; preds = %55, %51
  call void @free(ptr noundef nonnull %47) #36
  %57 = icmp eq i32 %52, 0
  %58 = uitofp i1 %57 to double
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !799
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %58, ptr %59, align 8, !tbaa !35, !alias.scope !799
  %60 = getelementptr inbounds nuw i8, ptr %0, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %60, i8 0, i64 24, i1 false), !alias.scope !799
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %4) #36
  br label %61

61:                                               ; preds = %49, %56, %44
  ret void
}

declare i32 @sqlite3_exec(ptr noundef, ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #22

declare void @sqlite3_free(ptr noundef) local_unnamed_addr #22

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_db_query(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca ptr, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = alloca %struct.UhValue, align 8
  %7 = alloca [36 x i8], align 4
  %8 = alloca %struct.UhValue, align 8
  %9 = load i32, ptr %2, align 8
  %10 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %11 = load ptr, ptr %10, align 8
  %12 = icmp ne i32 %9, 3
  %13 = icmp eq ptr %11, null
  %14 = select i1 %12, i1 true, i1 %13
  br i1 %14, label %48, label %15

15:                                               ; preds = %3
  %16 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %17 = load i64, ptr %16, align 8, !tbaa !65, !noalias !802
  %18 = icmp eq i64 %17, 0
  br i1 %18, label %48, label %19

19:                                               ; preds = %15
  %20 = load ptr, ptr %11, align 8, !tbaa !68, !noalias !802
  br label %24

21:                                               ; preds = %24
  %22 = add nuw i64 %25, 1
  %23 = icmp eq i64 %22, %17
  br i1 %23, label %48, label %24, !llvm.loop !69

24:                                               ; preds = %21, %19
  %25 = phi i64 [ 0, %19 ], [ %22, %21 ]
  %26 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %20, i64 %25
  %27 = load ptr, ptr %26, align 8, !tbaa !70, !noalias !802
  %28 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %27, ptr noundef nonnull readonly dereferenceable(8) @.str.43) #33, !noalias !802
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %30, label %21

30:                                               ; preds = %24
  %31 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %32 = load i32, ptr %31, align 8, !tbaa !26
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %34, label %48

34:                                               ; preds = %30
  %35 = getelementptr inbounds nuw i8, ptr %26, i64 16
  %36 = load double, ptr %35, align 8, !tbaa !27
  %37 = fptosi double %36 to i64
  %38 = icmp slt i64 %37, 1
  %39 = load i64, ptr @g_db_len, align 8
  %40 = icmp ult i64 %39, %37
  %41 = select i1 %38, i1 true, i1 %40
  br i1 %41, label %48, label %42

42:                                               ; preds = %34
  %43 = load ptr, ptr @g_db, align 8, !tbaa !485
  %44 = getelementptr %struct.UhDbConn, ptr %43, i64 %37
  %45 = getelementptr i8, ptr %44, i64 -16
  %46 = load ptr, ptr %45, align 8, !tbaa !791
  %47 = icmp eq ptr %46, null
  br i1 %47, label %48, label %53

48:                                               ; preds = %21, %3, %15, %34, %30, %42
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !805
  %49 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %50 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %51 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %49, i8 0, i64 16, i1 false), !alias.scope !805
  store ptr %50, ptr %51, align 8, !tbaa !47, !alias.scope !805
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %52, align 8, !tbaa !48, !alias.scope !805
  br label %154

53:                                               ; preds = %42
  %54 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %55 = icmp eq ptr %54, null
  br i1 %55, label %56, label %61

56:                                               ; preds = %53
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !808
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %58 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %57, i8 0, i64 16, i1 false), !alias.scope !808
  store ptr %58, ptr %59, align 8, !tbaa !47, !alias.scope !808
  %60 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %60, align 8, !tbaa !48, !alias.scope !808
  br label %154

61:                                               ; preds = %53
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %4) #36
  store ptr null, ptr %4, align 8, !tbaa !811
  %62 = call i32 @sqlite3_prepare_v2(ptr noundef nonnull %46, ptr noundef nonnull %54, i32 noundef -1, ptr noundef nonnull %4, ptr noundef null) #36
  %63 = icmp eq i32 %62, 0
  call void @free(ptr noundef nonnull %54) #36
  store i32 2, ptr %0, align 8, !tbaa !31
  %64 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %65 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %66 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %64, i8 0, i64 16, i1 false)
  store ptr %65, ptr %66, align 8, !tbaa !47
  %67 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %67, align 8, !tbaa !48
  br i1 %63, label %68, label %153

68:                                               ; preds = %61
  %69 = icmp eq ptr %65, null
  %70 = load ptr, ptr %4, align 8, !tbaa !811
  %71 = call i32 @sqlite3_column_count(ptr noundef %70) #36
  %72 = load ptr, ptr %4, align 8, !tbaa !811
  %73 = call i32 @sqlite3_step(ptr noundef %72) #36
  %74 = icmp eq i32 %73, 100
  br i1 %74, label %75, label %150

75:                                               ; preds = %68
  %76 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %77 = getelementptr inbounds nuw i8, ptr %5, i64 32
  %78 = icmp sgt i32 %71, 0
  %79 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %80 = getelementptr inbounds nuw i8, ptr %6, i64 16
  %81 = getelementptr inbounds nuw i8, ptr %6, i64 24
  %82 = getelementptr inbounds nuw i8, ptr %6, i64 4
  %83 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %84 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %85 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %86 = getelementptr inbounds nuw i8, ptr %65, i64 8
  %87 = getelementptr inbounds nuw i8, ptr %65, i64 16
  %88 = getelementptr inbounds nuw i8, ptr %7, i64 4
  br label %89

89:                                               ; preds = %75, %109
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5) #36
  store i32 3, ptr %5, align 8, !tbaa !31, !alias.scope !813
  %90 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %76, i8 0, i64 24, i1 false), !alias.scope !813
  store ptr %90, ptr %77, align 8, !tbaa !48, !alias.scope !813
  br i1 %78, label %113, label %91

91:                                               ; preds = %147, %89
  br i1 %69, label %109, label %92

92:                                               ; preds = %91
  %93 = load i64, ptr %86, align 8, !tbaa !49
  %94 = load i64, ptr %87, align 8, !tbaa !51
  %95 = icmp eq i64 %93, %94
  %96 = load ptr, ptr %65, align 8, !tbaa !52
  br i1 %95, label %97, label %104

97:                                               ; preds = %92
  %98 = icmp eq i64 %93, 0
  %99 = shl i64 %93, 1
  %100 = select i1 %98, i64 8, i64 %99
  %101 = mul i64 %100, 40
  %102 = call ptr @realloc(ptr noundef %96, i64 noundef %101) #35
  store ptr %102, ptr %65, align 8, !tbaa !52
  store i64 %100, ptr %87, align 8, !tbaa !51
  %103 = load i64, ptr %86, align 8, !tbaa !49
  br label %104

104:                                              ; preds = %97, %92
  %105 = phi i64 [ %103, %97 ], [ %93, %92 ]
  %106 = phi ptr [ %102, %97 ], [ %96, %92 ]
  %107 = add i64 %105, 1
  store i64 %107, ptr %86, align 8, !tbaa !49
  %108 = getelementptr inbounds nuw %struct.UhValue, ptr %106, i64 %105
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %108, ptr noundef nonnull align 8 dereferenceable(40) %5, i64 40, i1 false)
  br label %109

109:                                              ; preds = %91, %104
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5) #36
  %110 = load ptr, ptr %4, align 8, !tbaa !811
  %111 = call i32 @sqlite3_step(ptr noundef %110) #36
  %112 = icmp eq i32 %111, 100
  br i1 %112, label %89, label %150, !llvm.loop !816

113:                                              ; preds = %89, %147
  %114 = phi i32 [ %148, %147 ], [ 0, %89 ]
  %115 = load ptr, ptr %4, align 8, !tbaa !811
  %116 = call ptr @sqlite3_column_name(ptr noundef %115, i32 noundef %114) #36
  %117 = load ptr, ptr %4, align 8, !tbaa !811
  %118 = call i32 @sqlite3_column_type(ptr noundef %117, i32 noundef %114) #36
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %6) #36
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %79, i8 0, i64 32, i1 false), !alias.scope !817
  switch i32 %118, label %137 [
    i32 1, label %119
    i32 2, label %123
    i32 3, label %126
  ]

119:                                              ; preds = %113
  %120 = load ptr, ptr %4, align 8, !tbaa !811
  %121 = call i64 @sqlite3_column_int64(ptr noundef %120, i32 noundef %114) #36
  %122 = sitofp i64 %121 to double
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %80, i8 0, i64 24, i1 false)
  store i32 0, ptr %6, align 8, !tbaa !26
  store double %122, ptr %79, align 8, !tbaa !27
  br label %138

123:                                              ; preds = %113
  %124 = load ptr, ptr %4, align 8, !tbaa !811
  %125 = call double @sqlite3_column_double(ptr noundef %124, i32 noundef %114) #36
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %80, i8 0, i64 24, i1 false)
  store i32 0, ptr %6, align 8, !tbaa !26
  store double %125, ptr %79, align 8, !tbaa !27
  br label %138

126:                                              ; preds = %113
  %127 = load ptr, ptr %4, align 8, !tbaa !811
  %128 = call ptr @sqlite3_column_text(ptr noundef %127, i32 noundef %114) #36
  %129 = icmp eq ptr %128, null
  %130 = select i1 %129, ptr @.str, ptr %128
  %131 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %130) #33, !noalias !820
  %132 = add i64 %131, 1
  %133 = call noalias ptr @malloc(i64 noundef %132) #34
  %134 = icmp eq ptr %133, null
  br i1 %134, label %136, label %135

135:                                              ; preds = %126
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %133, ptr nonnull readonly align 1 %130, i64 %132, i1 false), !noalias !820
  br label %136

136:                                              ; preds = %126, %135
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %81, i8 0, i64 16, i1 false)
  store i32 1, ptr %6, align 8, !tbaa !26
  store double 0.000000e+00, ptr %79, align 8, !tbaa !27
  store ptr %133, ptr %80, align 8, !tbaa !28
  br label %138

137:                                              ; preds = %113
  call void @llvm.lifetime.start.p0(i64 36, ptr nonnull %7)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(32) %88, i8 0, i64 32, i1 false), !alias.scope !823
  store i32 4, ptr %6, align 8, !tbaa !26
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %82, ptr noundef nonnull align 4 dereferenceable(36) %7, i64 36, i1 false), !tbaa.struct !465
  call void @llvm.lifetime.end.p0(i64 36, ptr nonnull %7)
  br label %138

138:                                              ; preds = %123, %137, %136, %119
  %139 = icmp eq ptr %116, null
  br i1 %139, label %147, label %140

140:                                              ; preds = %138
  call void @llvm.experimental.noalias.scope.decl(metadata !826)
  store i32 1, ptr %8, align 8, !tbaa !31, !alias.scope !826
  store double 0.000000e+00, ptr %83, align 8, !tbaa !35, !alias.scope !826
  %141 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %116) #33, !noalias !826
  %142 = add i64 %141, 1
  %143 = call noalias ptr @malloc(i64 noundef %142) #34
  %144 = icmp eq ptr %143, null
  br i1 %144, label %146, label %145

145:                                              ; preds = %140
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %143, ptr nonnull readonly align 1 %116, i64 %142, i1 false), !noalias !826
  br label %146

146:                                              ; preds = %140, %145
  store ptr %143, ptr %84, align 8, !tbaa !46, !alias.scope !826
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %85, i8 0, i64 16, i1 false), !alias.scope !826
  call void @uh_dict_set(ptr noundef nonnull %5, ptr noundef nonnull byval(%struct.UhValue) align 8 %8, ptr noundef nonnull byval(%struct.UhValue) align 8 %6)
  br label %147

147:                                              ; preds = %146, %138
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %6) #36
  %148 = add nuw nsw i32 %114, 1
  %149 = icmp eq i32 %148, %71
  br i1 %149, label %91, label %113, !llvm.loop !829

150:                                              ; preds = %109, %68
  %151 = load ptr, ptr %4, align 8, !tbaa !811
  %152 = call i32 @sqlite3_finalize(ptr noundef %151) #36
  br label %153

153:                                              ; preds = %61, %150
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %4) #36
  br label %154

154:                                              ; preds = %48, %56, %153
  ret void
}

declare i32 @sqlite3_prepare_v2(ptr noundef, ptr noundef, i32 noundef, ptr noundef, ptr noundef) local_unnamed_addr #22

declare i32 @sqlite3_column_count(ptr noundef) local_unnamed_addr #22

declare i32 @sqlite3_step(ptr noundef) local_unnamed_addr #22

declare ptr @sqlite3_column_name(ptr noundef, i32 noundef) local_unnamed_addr #22

declare i32 @sqlite3_column_type(ptr noundef, i32 noundef) local_unnamed_addr #22

declare i64 @sqlite3_column_int64(ptr noundef, i32 noundef) local_unnamed_addr #22

declare double @sqlite3_column_double(ptr noundef, i32 noundef) local_unnamed_addr #22

declare ptr @sqlite3_column_text(ptr noundef, i32 noundef) local_unnamed_addr #22

declare i32 @sqlite3_finalize(ptr noundef) local_unnamed_addr #22

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_db_begin(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  tail call void @llvm.experimental.noalias.scope.decl(metadata !830)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !830
  %4 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store double 0.000000e+00, ptr %4, align 8, !tbaa !35, !alias.scope !830
  %5 = tail call noalias dereferenceable_or_null(6) ptr @malloc(i64 noundef 6) #34
  %6 = icmp eq ptr %5, null
  br i1 %6, label %8, label %7

7:                                                ; preds = %2
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %5, ptr noundef nonnull readonly align 1 dereferenceable(6) @.str.44, i64 6, i1 false), !noalias !830
  br label %8

8:                                                ; preds = %2, %7
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store ptr %5, ptr %9, align 8, !tbaa !46, !alias.scope !830
  %10 = getelementptr inbounds nuw i8, ptr %3, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %10, i8 0, i64 16, i1 false), !alias.scope !830
  tail call void @uh_db_exec(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %3, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_db_commit(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  tail call void @llvm.experimental.noalias.scope.decl(metadata !833)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !833
  %4 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store double 0.000000e+00, ptr %4, align 8, !tbaa !35, !alias.scope !833
  %5 = tail call noalias dereferenceable_or_null(7) ptr @malloc(i64 noundef 7) #34
  %6 = icmp eq ptr %5, null
  br i1 %6, label %8, label %7

7:                                                ; preds = %2
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %5, ptr noundef nonnull readonly align 1 dereferenceable(7) @.str.45, i64 7, i1 false), !noalias !833
  br label %8

8:                                                ; preds = %2, %7
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store ptr %5, ptr %9, align 8, !tbaa !46, !alias.scope !833
  %10 = getelementptr inbounds nuw i8, ptr %3, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %10, i8 0, i64 16, i1 false), !alias.scope !833
  tail call void @uh_db_exec(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %3, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_thread_start(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  %6 = load i32, ptr %2, align 8, !tbaa !31
  %7 = icmp ne i32 %6, 1
  %8 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %9 = load ptr, ptr %8, align 8
  %10 = icmp eq ptr %9, null
  %11 = select i1 %7, i1 true, i1 %10
  br i1 %11, label %12, label %14

12:                                               ; preds = %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !836
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %13, i8 0, i64 32, i1 false), !alias.scope !836
  br label %60

14:                                               ; preds = %3
  %15 = tail call noalias dereferenceable_or_null(56) ptr @malloc(i64 noundef 56) #34
  %16 = icmp eq ptr %15, null
  br i1 %16, label %17, label %19

17:                                               ; preds = %14
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !839
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %18, i8 0, i64 32, i1 false), !alias.scope !839
  br label %60

19:                                               ; preds = %14
  %20 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %9) #33
  %21 = add i64 %20, 1
  %22 = tail call noalias ptr @malloc(i64 noundef %21) #34
  %23 = icmp eq ptr %22, null
  br i1 %23, label %25, label %24

24:                                               ; preds = %19
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %22, ptr nonnull readonly align 1 %9, i64 %21, i1 false)
  br label %25

25:                                               ; preds = %19, %24
  %26 = getelementptr inbounds nuw i8, ptr %15, i64 8
  store ptr %22, ptr %26, align 8, !tbaa !842
  %27 = getelementptr inbounds nuw i8, ptr %15, i64 16
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %27, ptr noundef nonnull align 8 dereferenceable(40) %1, i64 40, i1 false), !tbaa.struct !25
  %28 = load ptr, ptr @g_threads, align 8, !tbaa !844
  %29 = load i64, ptr @g_thread_len, align 8, !tbaa !368
  %30 = shl i64 %29, 3
  %31 = add i64 %30, 8
  %32 = tail call ptr @realloc(ptr noundef %28, i64 noundef %31) #35
  %33 = icmp eq ptr %32, null
  br i1 %33, label %34, label %36

34:                                               ; preds = %25
  tail call void @free(ptr noundef %22) #36
  tail call void @free(ptr noundef nonnull %15) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !845
  %35 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %35, i8 0, i64 32, i1 false), !alias.scope !845
  br label %60

36:                                               ; preds = %25
  store ptr %32, ptr @g_threads, align 8, !tbaa !844
  %37 = getelementptr inbounds nuw ptr, ptr %32, i64 %29
  store ptr %15, ptr %37, align 8, !tbaa !485
  %38 = tail call i32 @pthread_create(ptr noundef nonnull %15, ptr noundef null, ptr noundef nonnull @uh_thread_entry, ptr noundef nonnull %15) #36
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %43, label %40

40:                                               ; preds = %36
  %41 = load ptr, ptr %26, align 8, !tbaa !842
  tail call void @free(ptr noundef %41) #36
  tail call void @free(ptr noundef nonnull %15) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !848
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %42, i8 0, i64 32, i1 false), !alias.scope !848
  br label %60

43:                                               ; preds = %36
  %44 = add i64 %29, 1
  %45 = load i64, ptr @g_thread_len, align 8, !tbaa !368
  %46 = add i64 %45, 1
  store i64 %46, ptr @g_thread_len, align 8, !tbaa !368
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !851
  %47 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %48 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %49 = getelementptr inbounds nuw i8, ptr %0, i64 32
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %47, i8 0, i64 24, i1 false), !alias.scope !851
  store ptr %48, ptr %49, align 8, !tbaa !48, !alias.scope !851
  tail call void @llvm.experimental.noalias.scope.decl(metadata !854)
  store i32 1, ptr %4, align 8, !tbaa !31, !alias.scope !854
  %50 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store double 0.000000e+00, ptr %50, align 8, !tbaa !35, !alias.scope !854
  %51 = tail call noalias dereferenceable_or_null(12) ptr @malloc(i64 noundef 12) #34
  %52 = icmp eq ptr %51, null
  br i1 %52, label %54, label %53

53:                                               ; preds = %43
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(12) %51, ptr noundef nonnull readonly align 1 dereferenceable(12) @.str.46, i64 12, i1 false), !noalias !854
  br label %54

54:                                               ; preds = %43, %53
  %55 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store ptr %51, ptr %55, align 8, !tbaa !46, !alias.scope !854
  %56 = getelementptr inbounds nuw i8, ptr %4, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %56, i8 0, i64 16, i1 false), !alias.scope !854
  %57 = uitofp i64 %44 to double
  store i32 0, ptr %5, align 8, !tbaa !31, !alias.scope !857
  %58 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store double %57, ptr %58, align 8, !tbaa !35, !alias.scope !857
  %59 = getelementptr inbounds nuw i8, ptr %5, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %59, i8 0, i64 24, i1 false), !alias.scope !857
  tail call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %4, ptr noundef nonnull byval(%struct.UhValue) align 8 %5)
  br label %60

60:                                               ; preds = %17, %40, %54, %34, %12
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #23

; Function Attrs: nounwind sspstrong uwtable
define internal noalias noundef ptr @uh_thread_entry(ptr noundef readonly captures(address_is_null) %0) #12 {
  %2 = alloca [1 x %struct.UhValue], align 16
  %3 = alloca %struct.UhValue, align 8
  %4 = load ptr, ptr @g_env, align 8, !tbaa !522
  %5 = icmp ne ptr %4, null
  %6 = icmp ne ptr %0, null
  %7 = and i1 %6, %5
  br i1 %7, label %8, label %14

8:                                                ; preds = %1
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %10 = load ptr, ptr %9, align 8, !tbaa !842
  %11 = icmp eq ptr %10, null
  br i1 %11, label %14, label %12

12:                                               ; preds = %8
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %2) #36
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 16
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(40) %2, ptr noundef nonnull align 8 dereferenceable(40) %13, i64 40, i1 false), !tbaa.struct !25
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3) #36
  call void @uh_call_named(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %3, ptr noundef nonnull %4, ptr noundef nonnull %10, i32 noundef 1, ptr noundef nonnull %2) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %2) #36
  br label %14

14:                                               ; preds = %12, %8, %1
  ret ptr null
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_thread_join(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %1, align 8
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %5 = load ptr, ptr %4, align 8
  %6 = icmp ne i32 %3, 3
  %7 = icmp eq ptr %5, null
  %8 = select i1 %6, i1 true, i1 %7
  br i1 %8, label %49, label %9

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %11 = load i64, ptr %10, align 8, !tbaa !65, !noalias !860
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %49, label %13

13:                                               ; preds = %9
  %14 = load ptr, ptr %5, align 8, !tbaa !68, !noalias !860
  br label %18

15:                                               ; preds = %18
  %16 = add nuw i64 %19, 1
  %17 = icmp eq i64 %16, %11
  br i1 %17, label %49, label %18, !llvm.loop !69

18:                                               ; preds = %15, %13
  %19 = phi i64 [ 0, %13 ], [ %16, %15 ]
  %20 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %14, i64 %19
  %21 = load ptr, ptr %20, align 8, !tbaa !70, !noalias !860
  %22 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %21, ptr noundef nonnull readonly dereferenceable(12) @.str.46) #33, !noalias !860
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %15

24:                                               ; preds = %18
  %25 = getelementptr inbounds nuw i8, ptr %20, i64 8
  %26 = load i32, ptr %25, align 8, !tbaa !26
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %28, label %49

28:                                               ; preds = %24
  %29 = getelementptr inbounds nuw i8, ptr %20, i64 16
  %30 = load double, ptr %29, align 8, !tbaa !27
  %31 = fptosi double %30 to i64
  %32 = icmp slt i64 %31, 1
  %33 = load i64, ptr @g_thread_len, align 8
  %34 = icmp ult i64 %33, %31
  %35 = select i1 %32, i1 true, i1 %34
  br i1 %35, label %49, label %36

36:                                               ; preds = %28
  %37 = load ptr, ptr @g_threads, align 8, !tbaa !844
  %38 = add nsw i64 %31, -1
  %39 = getelementptr inbounds nuw ptr, ptr %37, i64 %38
  %40 = load ptr, ptr %39, align 8, !tbaa !485
  %41 = icmp eq ptr %40, null
  br i1 %41, label %49, label %42

42:                                               ; preds = %36
  %43 = load i64, ptr %40, align 8, !tbaa !863
  %44 = tail call i32 @pthread_join(i64 noundef %43, ptr noundef null) #36
  %45 = getelementptr inbounds nuw i8, ptr %40, i64 8
  %46 = load ptr, ptr %45, align 8, !tbaa !842
  tail call void @free(ptr noundef %46) #36
  tail call void @free(ptr noundef nonnull %40) #36
  %47 = load ptr, ptr @g_threads, align 8, !tbaa !844
  %48 = getelementptr inbounds nuw ptr, ptr %47, i64 %38
  store ptr null, ptr %48, align 8, !tbaa !485
  br label %49

49:                                               ; preds = %15, %36, %42, %28, %24, %9, %2
  store i32 4, ptr %0, align 8, !tbaa !31
  %50 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %50, i8 0, i64 32, i1 false)
  ret void
}

declare i32 @pthread_join(i64 noundef, ptr noundef) local_unnamed_addr #22

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_mutex_lock(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %1, align 8
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %5 = load ptr, ptr %4, align 8
  %6 = icmp ne i32 %3, 3
  %7 = icmp eq ptr %5, null
  %8 = select i1 %6, i1 true, i1 %7
  br i1 %8, label %39, label %9

9:                                                ; preds = %2
  %10 = load i64, ptr @g_mutex_len, align 8, !tbaa !368
  %11 = icmp eq i64 %10, 0
  %12 = load ptr, ptr @g_mutexes, align 8, !tbaa !485
  br i1 %11, label %23, label %16

13:                                               ; preds = %16
  %14 = add nuw i64 %17, 1
  %15 = icmp eq i64 %14, %10
  br i1 %15, label %23, label %16, !llvm.loop !864

16:                                               ; preds = %9, %13
  %17 = phi i64 [ %14, %13 ], [ 0, %9 ]
  %18 = getelementptr inbounds nuw %struct.UhMutex, ptr %12, i64 %17
  %19 = load ptr, ptr %18, align 8, !tbaa !865
  %20 = icmp eq ptr %19, %5
  br i1 %20, label %21, label %13

21:                                               ; preds = %16
  %22 = getelementptr inbounds nuw i8, ptr %18, i64 8
  br label %36

23:                                               ; preds = %13, %9
  %24 = mul i64 %10, 48
  %25 = add i64 %24, 48
  %26 = tail call ptr @realloc(ptr noundef %12, i64 noundef %25) #35
  %27 = icmp eq ptr %26, null
  br i1 %27, label %39, label %28

28:                                               ; preds = %23
  store ptr %26, ptr @g_mutexes, align 8, !tbaa !485
  %29 = getelementptr inbounds nuw %struct.UhMutex, ptr %26, i64 %10
  store ptr %5, ptr %29, align 8, !tbaa !865
  %30 = getelementptr inbounds nuw %struct.UhMutex, ptr %26, i64 %10, i32 1
  %31 = tail call i32 @pthread_mutex_init(ptr noundef nonnull %30, ptr noundef null) #36
  %32 = load i64, ptr @g_mutex_len, align 8, !tbaa !368
  %33 = add i64 %32, 1
  store i64 %33, ptr @g_mutex_len, align 8, !tbaa !368
  %34 = load ptr, ptr @g_mutexes, align 8, !tbaa !485
  %35 = getelementptr inbounds nuw %struct.UhMutex, ptr %34, i64 %32, i32 1
  br label %36

36:                                               ; preds = %28, %21
  %37 = phi ptr [ %22, %21 ], [ %35, %28 ]
  %38 = tail call i32 @pthread_mutex_lock(ptr noundef nonnull %37) #36
  br label %39

39:                                               ; preds = %23, %2, %36
  store i32 4, ptr %0, align 8, !tbaa !31
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %40, i8 0, i64 32, i1 false)
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(ptr noundef) local_unnamed_addr #23

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_mutex_unlock(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %1, align 8
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %5 = load ptr, ptr %4, align 8
  %6 = icmp ne i32 %3, 3
  %7 = icmp eq ptr %5, null
  %8 = select i1 %6, i1 true, i1 %7
  br i1 %8, label %39, label %9

9:                                                ; preds = %2
  %10 = load i64, ptr @g_mutex_len, align 8, !tbaa !368
  %11 = icmp eq i64 %10, 0
  %12 = load ptr, ptr @g_mutexes, align 8, !tbaa !485
  br i1 %11, label %23, label %16

13:                                               ; preds = %16
  %14 = add nuw i64 %17, 1
  %15 = icmp eq i64 %14, %10
  br i1 %15, label %23, label %16, !llvm.loop !864

16:                                               ; preds = %9, %13
  %17 = phi i64 [ %14, %13 ], [ 0, %9 ]
  %18 = getelementptr inbounds nuw %struct.UhMutex, ptr %12, i64 %17
  %19 = load ptr, ptr %18, align 8, !tbaa !865
  %20 = icmp eq ptr %19, %5
  br i1 %20, label %21, label %13

21:                                               ; preds = %16
  %22 = getelementptr inbounds nuw i8, ptr %18, i64 8
  br label %36

23:                                               ; preds = %13, %9
  %24 = mul i64 %10, 48
  %25 = add i64 %24, 48
  %26 = tail call ptr @realloc(ptr noundef %12, i64 noundef %25) #35
  %27 = icmp eq ptr %26, null
  br i1 %27, label %39, label %28

28:                                               ; preds = %23
  store ptr %26, ptr @g_mutexes, align 8, !tbaa !485
  %29 = getelementptr inbounds nuw %struct.UhMutex, ptr %26, i64 %10
  store ptr %5, ptr %29, align 8, !tbaa !865
  %30 = getelementptr inbounds nuw %struct.UhMutex, ptr %26, i64 %10, i32 1
  %31 = tail call i32 @pthread_mutex_init(ptr noundef nonnull %30, ptr noundef null) #36
  %32 = load i64, ptr @g_mutex_len, align 8, !tbaa !368
  %33 = add i64 %32, 1
  store i64 %33, ptr @g_mutex_len, align 8, !tbaa !368
  %34 = load ptr, ptr @g_mutexes, align 8, !tbaa !485
  %35 = getelementptr inbounds nuw %struct.UhMutex, ptr %34, i64 %32, i32 1
  br label %36

36:                                               ; preds = %28, %21
  %37 = phi ptr [ %22, %21 ], [ %35, %28 ]
  %38 = tail call i32 @pthread_mutex_unlock(ptr noundef nonnull %37) #36
  br label %39

39:                                               ; preds = %23, %2, %36
  store i32 4, ptr %0, align 8, !tbaa !31
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %40, i8 0, i64 32, i1 false)
  ret void
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(ptr noundef) local_unnamed_addr #23

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_ws_connect(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca [256 x i8], align 16
  %6 = alloca %struct.UhSha1, align 16
  %7 = alloca [20 x i8], align 16
  %8 = alloca [16 x i8], align 16
  %9 = alloca [1024 x i8], align 16
  %10 = alloca [4096 x i8], align 16
  %11 = alloca [128 x i8], align 16
  %12 = alloca %struct.addrinfo, align 8
  %13 = alloca [16 x i8], align 16
  %14 = alloca ptr, align 8
  %15 = load i32, ptr %1, align 8, !tbaa !31
  %16 = icmp eq i32 %15, 1
  %17 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %18 = load ptr, ptr %17, align 8
  %19 = icmp ne ptr %18, null
  %20 = select i1 %16, i1 %19, i1 false
  br i1 %20, label %115, label %21

21:                                               ; preds = %2
  %22 = icmp eq i32 %15, 3
  %23 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %24 = load ptr, ptr %23, align 8
  %25 = icmp ne ptr %24, null
  %26 = select i1 %22, i1 %25, i1 false
  br i1 %26, label %27, label %164

27:                                               ; preds = %21
  %28 = getelementptr inbounds nuw i8, ptr %24, i64 8
  %29 = load i64, ptr %28, align 8, !tbaa !65, !noalias !867
  %30 = icmp eq i64 %29, 0
  br i1 %30, label %164, label %31

31:                                               ; preds = %27
  %32 = load ptr, ptr %24, align 8, !tbaa !68, !noalias !867
  br label %36

33:                                               ; preds = %36
  %34 = add nuw i64 %37, 1
  %35 = icmp eq i64 %34, %29
  br i1 %35, label %50, label %36, !llvm.loop !69

36:                                               ; preds = %33, %31
  %37 = phi i64 [ 0, %31 ], [ %34, %33 ]
  %38 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %32, i64 %37
  %39 = load ptr, ptr %38, align 8, !tbaa !70, !noalias !867
  %40 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %39, ptr noundef nonnull readonly dereferenceable(4) @.str.27) #33, !noalias !867
  %41 = icmp eq i32 %40, 0
  br i1 %41, label %42, label %33

42:                                               ; preds = %36
  %43 = getelementptr inbounds nuw i8, ptr %38, i64 8
  %44 = load i32, ptr %43, align 8, !tbaa !26
  %45 = getelementptr inbounds nuw i8, ptr %38, i64 24
  %46 = load ptr, ptr %45, align 8, !tbaa !28
  %47 = icmp eq i32 %44, 1
  %48 = icmp ne ptr %46, null
  %49 = select i1 %47, i1 %48, i1 false
  br i1 %49, label %115, label %50

50:                                               ; preds = %33, %42
  %51 = load ptr, ptr %24, align 8, !tbaa !68, !noalias !870
  br label %55

52:                                               ; preds = %55
  %53 = add nuw i64 %56, 1
  %54 = icmp eq i64 %53, %29
  br i1 %54, label %68, label %55, !llvm.loop !69

55:                                               ; preds = %52, %50
  %56 = phi i64 [ 0, %50 ], [ %53, %52 ]
  %57 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %51, i64 %56
  %58 = load ptr, ptr %57, align 8, !tbaa !70, !noalias !870
  %59 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %58, ptr noundef nonnull readonly dereferenceable(5) @.str.48) #33, !noalias !870
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %61, label %52

61:                                               ; preds = %55
  %62 = getelementptr inbounds nuw i8, ptr %57, i64 8
  %63 = load i32, ptr %62, align 8, !tbaa !26
  %64 = getelementptr inbounds nuw i8, ptr %57, i64 24
  %65 = load ptr, ptr %64, align 8, !tbaa !28
  %66 = icmp eq i32 %63, 1
  %67 = select i1 %66, ptr %65, ptr null
  br label %68

68:                                               ; preds = %52, %61
  %69 = phi ptr [ %67, %61 ], [ null, %52 ]
  %70 = load ptr, ptr %24, align 8, !tbaa !68, !noalias !873
  br label %74

71:                                               ; preds = %74
  %72 = add nuw i64 %75, 1
  %73 = icmp eq i64 %72, %29
  br i1 %73, label %88, label %74, !llvm.loop !69

74:                                               ; preds = %71, %68
  %75 = phi i64 [ 0, %68 ], [ %72, %71 ]
  %76 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %70, i64 %75
  %77 = load ptr, ptr %76, align 8, !tbaa !70, !noalias !873
  %78 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %77, ptr noundef nonnull readonly dereferenceable(5) @.str.49) #33, !noalias !873
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %80, label %71

80:                                               ; preds = %74
  %81 = getelementptr inbounds nuw i8, ptr %76, i64 8
  %82 = load i32, ptr %81, align 8, !tbaa !26
  %83 = getelementptr inbounds nuw i8, ptr %76, i64 16
  %84 = load double, ptr %83, align 8, !tbaa !27
  %85 = icmp eq i32 %82, 0
  %86 = fptosi double %84 to i32
  %87 = select i1 %85, i32 %86, i32 0
  br label %88

88:                                               ; preds = %71, %80
  %89 = phi i32 [ %87, %80 ], [ 0, %71 ]
  %90 = load ptr, ptr %24, align 8, !tbaa !68, !noalias !876
  br label %94

91:                                               ; preds = %94
  %92 = add nuw i64 %95, 1
  %93 = icmp eq i64 %92, %29
  br i1 %93, label %106, label %94, !llvm.loop !69

94:                                               ; preds = %91, %88
  %95 = phi i64 [ 0, %88 ], [ %92, %91 ]
  %96 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %90, i64 %95
  %97 = load ptr, ptr %96, align 8, !tbaa !70, !noalias !876
  %98 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %97, ptr noundef nonnull readonly dereferenceable(5) @.str.3) #33, !noalias !876
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %100, label %91

100:                                              ; preds = %94
  %101 = getelementptr inbounds nuw i8, ptr %96, i64 8
  %102 = load i32, ptr %101, align 8, !tbaa !26
  %103 = getelementptr inbounds nuw i8, ptr %96, i64 24
  %104 = load ptr, ptr %103, align 8, !tbaa !28
  %105 = icmp eq i32 %102, 1
  br label %106

106:                                              ; preds = %91, %100
  %107 = phi ptr [ %104, %100 ], [ null, %91 ]
  %108 = phi i1 [ %105, %100 ], [ false, %91 ]
  %109 = icmp ne ptr %107, null
  %110 = select i1 %108, i1 %109, i1 false
  %111 = select i1 %110, ptr %107, ptr @.str.47
  %112 = icmp eq ptr %69, null
  %113 = icmp slt i32 %89, 1
  %114 = select i1 %112, i1 true, i1 %113
  br i1 %114, label %164, label %171

115:                                              ; preds = %42, %2
  %116 = phi ptr [ %18, %2 ], [ %46, %42 ]
  %117 = tail call i32 @strncmp(ptr noundef nonnull dereferenceable(1) %116, ptr noundef nonnull dereferenceable(6) @.str.61, i64 noundef 5) #33
  %118 = icmp eq i32 %117, 0
  br i1 %118, label %122, label %119

119:                                              ; preds = %115
  %120 = tail call i32 @strncmp(ptr noundef nonnull dereferenceable(1) %116, ptr noundef nonnull dereferenceable(7) @.str.62, i64 noundef 6) #33
  %121 = icmp eq i32 %120, 0
  br i1 %121, label %122, label %160

122:                                              ; preds = %119, %115
  %123 = phi i64 [ 5, %115 ], [ 6, %119 ]
  %124 = getelementptr inbounds nuw i8, ptr %116, i64 %123
  %125 = tail call ptr @strchr(ptr noundef nonnull dereferenceable(1) %124, i32 noundef 47) #33
  %126 = icmp eq ptr %125, null
  br i1 %126, label %127, label %130

127:                                              ; preds = %122
  %128 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %124) #33
  %129 = getelementptr inbounds nuw i8, ptr %124, i64 %128
  br label %130

130:                                              ; preds = %127, %122
  %131 = phi ptr [ %129, %127 ], [ %125, %122 ]
  %132 = ptrtoint ptr %131 to i64
  %133 = ptrtoint ptr %124 to i64
  %134 = sub i64 %132, %133
  %135 = tail call ptr @memchr(ptr noundef nonnull %124, i32 noundef 58, i64 noundef %134) #33
  %136 = select i1 %118, i32 80, i32 443
  %137 = icmp eq ptr %135, null
  %138 = ptrtoint ptr %135 to i64
  %139 = sub i64 %138, %133
  %140 = select i1 %137, i64 %134, i64 %139
  %141 = icmp eq i64 %140, 0
  br i1 %141, label %160, label %142

142:                                              ; preds = %130
  %143 = add i64 %140, 1
  %144 = tail call noalias ptr @malloc(i64 noundef %143) #34
  %145 = icmp eq ptr %144, null
  br i1 %145, label %160, label %146

146:                                              ; preds = %142
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %144, ptr nonnull align 1 %124, i64 %140, i1 false)
  %147 = getelementptr inbounds nuw i8, ptr %144, i64 %140
  store i8 0, ptr %147, align 1, !tbaa !76
  br i1 %137, label %152, label %148

148:                                              ; preds = %146
  %149 = getelementptr inbounds nuw i8, ptr %135, i64 1
  %150 = tail call i64 @strtol(ptr noundef nonnull captures(none) %149, ptr noundef null, i32 noundef 10) #36
  %151 = trunc i64 %150 to i32
  br label %152

152:                                              ; preds = %148, %146
  %153 = phi i32 [ %151, %148 ], [ %136, %146 ]
  %154 = select i1 %126, ptr @.str.47, ptr %125
  %155 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %154) #33
  %156 = add i64 %155, 1
  %157 = tail call noalias ptr @malloc(i64 noundef %156) #34
  %158 = icmp eq ptr %157, null
  br i1 %158, label %159, label %162

159:                                              ; preds = %152
  tail call void @free(ptr noundef nonnull %144) #36
  br label %160

160:                                              ; preds = %119, %130, %142, %159
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !879
  %161 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %161, i8 0, i64 32, i1 false), !alias.scope !879
  br label %800

162:                                              ; preds = %152
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %157, ptr nonnull readonly align 1 %154, i64 %156, i1 false)
  %163 = icmp slt i32 %153, 1
  br i1 %163, label %164, label %168

164:                                              ; preds = %27, %21, %106, %162
  %165 = phi ptr [ %157, %162 ], [ null, %106 ], [ null, %21 ], [ null, %27 ]
  %166 = phi ptr [ %144, %162 ], [ null, %106 ], [ null, %21 ], [ null, %27 ]
  tail call void @free(ptr noundef %166) #36
  tail call void @free(ptr noundef %165) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !882
  %167 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %167, i8 0, i64 32, i1 false), !alias.scope !882
  br label %800

168:                                              ; preds = %162
  br i1 %118, label %171, label %169

169:                                              ; preds = %168
  tail call void @free(ptr noundef nonnull %144) #36
  tail call void @free(ptr noundef nonnull %157) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !885
  %170 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %170, i8 0, i64 32, i1 false), !alias.scope !885
  br label %800

171:                                              ; preds = %106, %168
  %172 = phi i32 [ %153, %168 ], [ %89, %106 ]
  %173 = phi ptr [ %144, %168 ], [ null, %106 ]
  %174 = phi ptr [ %157, %168 ], [ null, %106 ]
  %175 = phi ptr [ %144, %168 ], [ %69, %106 ]
  %176 = phi ptr [ %157, %168 ], [ %111, %106 ]
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %12) #36
  %177 = getelementptr inbounds nuw i8, ptr %12, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %12, i8 0, i64 48, i1 false)
  store i32 1, ptr %177, align 8, !tbaa !888
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %13) #36
  %178 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %13, i64 noundef 16, ptr noundef nonnull @.str.50, i32 noundef %172) #36
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %14) #36
  store ptr null, ptr %14, align 8, !tbaa !892
  %179 = call i32 @getaddrinfo(ptr noundef nonnull %175, ptr noundef nonnull %13, ptr noundef nonnull %12, ptr noundef nonnull %14) #36
  %180 = icmp eq i32 %179, 0
  %181 = load ptr, ptr %14, align 8
  %182 = icmp ne ptr %181, null
  %183 = select i1 %180, i1 %182, i1 false
  br i1 %183, label %186, label %184

184:                                              ; preds = %171
  call void @free(ptr noundef %173) #36
  call void @free(ptr noundef %174) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !893
  %185 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %185, i8 0, i64 32, i1 false), !alias.scope !893
  br label %799

186:                                              ; preds = %171, %205
  %187 = phi ptr [ %207, %205 ], [ %181, %171 ]
  %188 = getelementptr inbounds nuw i8, ptr %187, i64 4
  %189 = load i32, ptr %188, align 4, !tbaa !896
  %190 = getelementptr inbounds nuw i8, ptr %187, i64 8
  %191 = load i32, ptr %190, align 8, !tbaa !888
  %192 = getelementptr inbounds nuw i8, ptr %187, i64 12
  %193 = load i32, ptr %192, align 4, !tbaa !897
  %194 = call i32 @socket(i32 noundef %189, i32 noundef %191, i32 noundef %193) #36
  %195 = icmp slt i32 %194, 0
  br i1 %195, label %205, label %196

196:                                              ; preds = %186
  %197 = getelementptr inbounds nuw i8, ptr %187, i64 24
  %198 = load ptr, ptr %197, align 8, !tbaa !898
  %199 = getelementptr inbounds nuw i8, ptr %187, i64 16
  %200 = load i32, ptr %199, align 8, !tbaa !899
  %201 = call i32 @connect(i32 noundef %194, ptr noundef %198, i32 noundef %200) #36
  %202 = icmp eq i32 %201, 0
  br i1 %202, label %212, label %203

203:                                              ; preds = %196
  %204 = call i32 @close(i32 noundef %194) #36
  br label %205

205:                                              ; preds = %186, %203
  %206 = getelementptr inbounds nuw i8, ptr %187, i64 40
  %207 = load ptr, ptr %206, align 8, !tbaa !900
  %208 = icmp eq ptr %207, null
  br i1 %208, label %209, label %186, !llvm.loop !901

209:                                              ; preds = %205
  %210 = load ptr, ptr %14, align 8, !tbaa !892
  call void @freeaddrinfo(ptr noundef %210) #36
  call void @free(ptr noundef %173) #36
  call void @free(ptr noundef %174) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !902
  %211 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %211, i8 0, i64 32, i1 false), !alias.scope !902
  br label %799

212:                                              ; preds = %196
  %213 = load ptr, ptr %14, align 8, !tbaa !892
  call void @freeaddrinfo(ptr noundef %213) #36
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %8) #36
  %214 = call noalias ptr @fopen(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.1)
  %215 = icmp eq ptr %214, null
  br i1 %215, label %220, label %216

216:                                              ; preds = %212
  %217 = call i64 @fread(ptr noundef nonnull %8, i64 noundef 1, i64 noundef 16, ptr noundef nonnull %214)
  %218 = call i32 @fclose(ptr noundef nonnull %214)
  %219 = icmp eq i64 %217, 16
  br i1 %219, label %268, label %220

220:                                              ; preds = %216, %212
  %221 = call i32 @rand() #36
  %222 = trunc i32 %221 to i8
  store i8 %222, ptr %8, align 16, !tbaa !76
  %223 = call i32 @rand() #36
  %224 = trunc i32 %223 to i8
  %225 = getelementptr inbounds nuw i8, ptr %8, i64 1
  store i8 %224, ptr %225, align 1, !tbaa !76
  %226 = call i32 @rand() #36
  %227 = trunc i32 %226 to i8
  %228 = getelementptr inbounds nuw i8, ptr %8, i64 2
  store i8 %227, ptr %228, align 2, !tbaa !76
  %229 = call i32 @rand() #36
  %230 = trunc i32 %229 to i8
  %231 = getelementptr inbounds nuw i8, ptr %8, i64 3
  store i8 %230, ptr %231, align 1, !tbaa !76
  %232 = call i32 @rand() #36
  %233 = trunc i32 %232 to i8
  %234 = getelementptr inbounds nuw i8, ptr %8, i64 4
  store i8 %233, ptr %234, align 4, !tbaa !76
  %235 = call i32 @rand() #36
  %236 = trunc i32 %235 to i8
  %237 = getelementptr inbounds nuw i8, ptr %8, i64 5
  store i8 %236, ptr %237, align 1, !tbaa !76
  %238 = call i32 @rand() #36
  %239 = trunc i32 %238 to i8
  %240 = getelementptr inbounds nuw i8, ptr %8, i64 6
  store i8 %239, ptr %240, align 2, !tbaa !76
  %241 = call i32 @rand() #36
  %242 = trunc i32 %241 to i8
  %243 = getelementptr inbounds nuw i8, ptr %8, i64 7
  store i8 %242, ptr %243, align 1, !tbaa !76
  %244 = call i32 @rand() #36
  %245 = trunc i32 %244 to i8
  %246 = getelementptr inbounds nuw i8, ptr %8, i64 8
  store i8 %245, ptr %246, align 8, !tbaa !76
  %247 = call i32 @rand() #36
  %248 = trunc i32 %247 to i8
  %249 = getelementptr inbounds nuw i8, ptr %8, i64 9
  store i8 %248, ptr %249, align 1, !tbaa !76
  %250 = call i32 @rand() #36
  %251 = trunc i32 %250 to i8
  %252 = getelementptr inbounds nuw i8, ptr %8, i64 10
  store i8 %251, ptr %252, align 2, !tbaa !76
  %253 = call i32 @rand() #36
  %254 = trunc i32 %253 to i8
  %255 = getelementptr inbounds nuw i8, ptr %8, i64 11
  store i8 %254, ptr %255, align 1, !tbaa !76
  %256 = call i32 @rand() #36
  %257 = trunc i32 %256 to i8
  %258 = getelementptr inbounds nuw i8, ptr %8, i64 12
  store i8 %257, ptr %258, align 4, !tbaa !76
  %259 = call i32 @rand() #36
  %260 = trunc i32 %259 to i8
  %261 = getelementptr inbounds nuw i8, ptr %8, i64 13
  store i8 %260, ptr %261, align 1, !tbaa !76
  %262 = call i32 @rand() #36
  %263 = trunc i32 %262 to i8
  %264 = getelementptr inbounds nuw i8, ptr %8, i64 14
  store i8 %263, ptr %264, align 2, !tbaa !76
  %265 = call i32 @rand() #36
  %266 = trunc i32 %265 to i8
  %267 = getelementptr inbounds nuw i8, ptr %8, i64 15
  store i8 %266, ptr %267, align 1, !tbaa !76
  br label %268

268:                                              ; preds = %220, %216
  %269 = call noalias dereferenceable_or_null(25) ptr @malloc(i64 noundef 25) #34
  %270 = icmp eq ptr %269, null
  br i1 %270, label %781, label %271

271:                                              ; preds = %268
  %272 = getelementptr inbounds nuw i8, ptr %8, i64 1
  %273 = getelementptr inbounds nuw i8, ptr %8, i64 2
  %274 = load i8, ptr %272, align 1, !tbaa !76
  %275 = zext i8 %274 to i32
  %276 = shl nuw nsw i32 %275, 8
  %277 = load i8, ptr %273, align 2, !tbaa !76
  %278 = zext i8 %277 to i32
  %279 = or disjoint i32 %276, %278
  %280 = load i8, ptr %8, align 16, !tbaa !76
  %281 = zext i8 %280 to i32
  %282 = shl nuw nsw i32 %281, 16
  %283 = or disjoint i32 %282, %276
  %284 = lshr i32 %281, 2
  %285 = zext nneg i32 %284 to i64
  %286 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %285
  %287 = load i8, ptr %286, align 1, !tbaa !76
  store i8 %287, ptr %269, align 1, !tbaa !76
  %288 = lshr i32 %283, 12
  %289 = and i32 %288, 63
  %290 = zext nneg i32 %289 to i64
  %291 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %290
  %292 = load i8, ptr %291, align 1, !tbaa !76
  %293 = getelementptr i8, ptr %269, i64 1
  store i8 %292, ptr %293, align 1, !tbaa !76
  %294 = lshr i32 %279, 6
  %295 = and i32 %294, 63
  %296 = zext nneg i32 %295 to i64
  %297 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %296
  %298 = load i8, ptr %297, align 1, !tbaa !76
  %299 = getelementptr i8, ptr %269, i64 2
  store i8 %298, ptr %299, align 1, !tbaa !76
  %300 = and i32 %278, 63
  %301 = zext nneg i32 %300 to i64
  %302 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %301
  %303 = load i8, ptr %302, align 1, !tbaa !76
  %304 = getelementptr inbounds nuw i8, ptr %269, i64 3
  store i8 %303, ptr %304, align 1, !tbaa !76
  %305 = getelementptr inbounds nuw i8, ptr %8, i64 4
  %306 = load i8, ptr %305, align 4, !tbaa !76
  %307 = zext i8 %306 to i32
  %308 = shl nuw nsw i32 %307, 8
  %309 = getelementptr inbounds nuw i8, ptr %8, i64 5
  %310 = load i8, ptr %309, align 1, !tbaa !76
  %311 = zext i8 %310 to i32
  %312 = or disjoint i32 %308, %311
  %313 = getelementptr inbounds nuw i8, ptr %8, i64 3
  %314 = load i8, ptr %313, align 1, !tbaa !76
  %315 = zext i8 %314 to i32
  %316 = shl nuw nsw i32 %315, 16
  %317 = or disjoint i32 %316, %308
  %318 = lshr i32 %315, 2
  %319 = zext nneg i32 %318 to i64
  %320 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %319
  %321 = load i8, ptr %320, align 1, !tbaa !76
  %322 = getelementptr inbounds nuw i8, ptr %269, i64 4
  store i8 %321, ptr %322, align 1, !tbaa !76
  %323 = lshr i32 %317, 12
  %324 = and i32 %323, 63
  %325 = zext nneg i32 %324 to i64
  %326 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %325
  %327 = load i8, ptr %326, align 1, !tbaa !76
  %328 = getelementptr i8, ptr %269, i64 5
  store i8 %327, ptr %328, align 1, !tbaa !76
  %329 = lshr i32 %312, 6
  %330 = and i32 %329, 63
  %331 = zext nneg i32 %330 to i64
  %332 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %331
  %333 = load i8, ptr %332, align 1, !tbaa !76
  %334 = getelementptr i8, ptr %269, i64 6
  store i8 %333, ptr %334, align 1, !tbaa !76
  %335 = and i32 %311, 63
  %336 = zext nneg i32 %335 to i64
  %337 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %336
  %338 = load i8, ptr %337, align 1, !tbaa !76
  %339 = getelementptr inbounds nuw i8, ptr %269, i64 7
  store i8 %338, ptr %339, align 1, !tbaa !76
  %340 = getelementptr inbounds nuw i8, ptr %8, i64 7
  %341 = load i8, ptr %340, align 1, !tbaa !76
  %342 = zext i8 %341 to i32
  %343 = shl nuw nsw i32 %342, 8
  %344 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %345 = load i8, ptr %344, align 8, !tbaa !76
  %346 = zext i8 %345 to i32
  %347 = or disjoint i32 %343, %346
  %348 = getelementptr inbounds nuw i8, ptr %8, i64 6
  %349 = load i8, ptr %348, align 2, !tbaa !76
  %350 = zext i8 %349 to i32
  %351 = shl nuw nsw i32 %350, 16
  %352 = or disjoint i32 %351, %343
  %353 = lshr i32 %350, 2
  %354 = zext nneg i32 %353 to i64
  %355 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %354
  %356 = load i8, ptr %355, align 1, !tbaa !76
  %357 = getelementptr inbounds nuw i8, ptr %269, i64 8
  store i8 %356, ptr %357, align 1, !tbaa !76
  %358 = lshr i32 %352, 12
  %359 = and i32 %358, 63
  %360 = zext nneg i32 %359 to i64
  %361 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %360
  %362 = load i8, ptr %361, align 1, !tbaa !76
  %363 = getelementptr i8, ptr %269, i64 9
  store i8 %362, ptr %363, align 1, !tbaa !76
  %364 = lshr i32 %347, 6
  %365 = and i32 %364, 63
  %366 = zext nneg i32 %365 to i64
  %367 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %366
  %368 = load i8, ptr %367, align 1, !tbaa !76
  %369 = getelementptr i8, ptr %269, i64 10
  store i8 %368, ptr %369, align 1, !tbaa !76
  %370 = and i32 %346, 63
  %371 = zext nneg i32 %370 to i64
  %372 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %371
  %373 = load i8, ptr %372, align 1, !tbaa !76
  %374 = getelementptr inbounds nuw i8, ptr %269, i64 11
  store i8 %373, ptr %374, align 1, !tbaa !76
  %375 = getelementptr inbounds nuw i8, ptr %8, i64 10
  %376 = load i8, ptr %375, align 2, !tbaa !76
  %377 = zext i8 %376 to i32
  %378 = shl nuw nsw i32 %377, 8
  %379 = getelementptr inbounds nuw i8, ptr %8, i64 11
  %380 = load i8, ptr %379, align 1, !tbaa !76
  %381 = zext i8 %380 to i32
  %382 = or disjoint i32 %378, %381
  %383 = getelementptr inbounds nuw i8, ptr %8, i64 9
  %384 = load i8, ptr %383, align 1, !tbaa !76
  %385 = zext i8 %384 to i32
  %386 = shl nuw nsw i32 %385, 16
  %387 = or disjoint i32 %386, %378
  %388 = lshr i32 %385, 2
  %389 = zext nneg i32 %388 to i64
  %390 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %389
  %391 = load i8, ptr %390, align 1, !tbaa !76
  %392 = getelementptr inbounds nuw i8, ptr %269, i64 12
  store i8 %391, ptr %392, align 1, !tbaa !76
  %393 = lshr i32 %387, 12
  %394 = and i32 %393, 63
  %395 = zext nneg i32 %394 to i64
  %396 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %395
  %397 = load i8, ptr %396, align 1, !tbaa !76
  %398 = getelementptr i8, ptr %269, i64 13
  store i8 %397, ptr %398, align 1, !tbaa !76
  %399 = lshr i32 %382, 6
  %400 = and i32 %399, 63
  %401 = zext nneg i32 %400 to i64
  %402 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %401
  %403 = load i8, ptr %402, align 1, !tbaa !76
  %404 = getelementptr i8, ptr %269, i64 14
  store i8 %403, ptr %404, align 1, !tbaa !76
  %405 = and i32 %381, 63
  %406 = zext nneg i32 %405 to i64
  %407 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %406
  %408 = load i8, ptr %407, align 1, !tbaa !76
  %409 = getelementptr inbounds nuw i8, ptr %269, i64 15
  store i8 %408, ptr %409, align 1, !tbaa !76
  %410 = getelementptr inbounds nuw i8, ptr %8, i64 13
  %411 = load i8, ptr %410, align 1, !tbaa !76
  %412 = zext i8 %411 to i32
  %413 = shl nuw nsw i32 %412, 8
  %414 = getelementptr inbounds nuw i8, ptr %8, i64 14
  %415 = load i8, ptr %414, align 2, !tbaa !76
  %416 = zext i8 %415 to i32
  %417 = or disjoint i32 %413, %416
  %418 = getelementptr inbounds nuw i8, ptr %8, i64 12
  %419 = load i8, ptr %418, align 4, !tbaa !76
  %420 = zext i8 %419 to i32
  %421 = shl nuw nsw i32 %420, 16
  %422 = or disjoint i32 %421, %413
  %423 = lshr i32 %420, 2
  %424 = zext nneg i32 %423 to i64
  %425 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %424
  %426 = load i8, ptr %425, align 1, !tbaa !76
  %427 = getelementptr inbounds nuw i8, ptr %269, i64 16
  store i8 %426, ptr %427, align 1, !tbaa !76
  %428 = lshr i32 %422, 12
  %429 = and i32 %428, 63
  %430 = zext nneg i32 %429 to i64
  %431 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %430
  %432 = load i8, ptr %431, align 1, !tbaa !76
  %433 = getelementptr i8, ptr %269, i64 17
  store i8 %432, ptr %433, align 1, !tbaa !76
  %434 = lshr i32 %417, 6
  %435 = and i32 %434, 63
  %436 = zext nneg i32 %435 to i64
  %437 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %436
  %438 = load i8, ptr %437, align 1, !tbaa !76
  %439 = getelementptr i8, ptr %269, i64 18
  store i8 %438, ptr %439, align 1, !tbaa !76
  %440 = and i32 %416, 63
  %441 = zext nneg i32 %440 to i64
  %442 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %441
  %443 = load i8, ptr %442, align 1, !tbaa !76
  %444 = getelementptr inbounds nuw i8, ptr %269, i64 19
  store i8 %443, ptr %444, align 1, !tbaa !76
  %445 = getelementptr inbounds nuw i8, ptr %8, i64 15
  %446 = load i8, ptr %445, align 1, !tbaa !76
  %447 = zext i8 %446 to i32
  %448 = shl nuw nsw i32 %447, 4
  %449 = lshr i32 %447, 2
  %450 = zext nneg i32 %449 to i64
  %451 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %450
  %452 = load i8, ptr %451, align 1, !tbaa !76
  %453 = getelementptr inbounds nuw i8, ptr %269, i64 20
  store i8 %452, ptr %453, align 1, !tbaa !76
  %454 = and i32 %448, 48
  %455 = zext nneg i32 %454 to i64
  %456 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %455
  %457 = load i8, ptr %456, align 16, !tbaa !76
  %458 = getelementptr i8, ptr %269, i64 21
  store i8 %457, ptr %458, align 1, !tbaa !76
  %459 = getelementptr i8, ptr %269, i64 22
  store i8 61, ptr %459, align 1, !tbaa !76
  %460 = getelementptr inbounds nuw i8, ptr %269, i64 23
  store i8 61, ptr %460, align 1, !tbaa !76
  %461 = getelementptr inbounds nuw i8, ptr %269, i64 24
  store i8 0, ptr %461, align 1, !tbaa !76
  call void @llvm.lifetime.start.p0(i64 1024, ptr nonnull %9) #36
  %462 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %9, i64 noundef 1024, ptr noundef nonnull @.str.63, ptr noundef %176, ptr noundef nonnull %175, i32 noundef %172, ptr noundef nonnull %269) #36
  %463 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %9) #33
  %464 = call i64 @send(i32 noundef range(i32 0, -2147483648) %194, ptr noundef nonnull %9, i64 noundef %463, i32 noundef 0) #36
  %465 = icmp slt i64 %464, 0
  br i1 %465, label %466, label %467

466:                                              ; preds = %271
  call void @free(ptr noundef nonnull %269) #36
  br label %780

467:                                              ; preds = %271
  call void @llvm.lifetime.start.p0(i64 4096, ptr nonnull %10) #36
  br label %468

468:                                              ; preds = %476, %467
  %469 = phi i64 [ 0, %467 ], [ %477, %476 ]
  %470 = icmp ult i64 %469, 4095
  br i1 %470, label %471, label %483

471:                                              ; preds = %468
  %472 = getelementptr inbounds nuw i8, ptr %10, i64 %469
  %473 = sub nuw nsw i64 4095, %469
  %474 = call i64 @recv(i32 noundef range(i32 0, -2147483648) %194, ptr noundef nonnull %472, i64 noundef %473, i32 noundef 0) #36
  %475 = icmp slt i64 %474, 1
  br i1 %475, label %481, label %476

476:                                              ; preds = %471
  %477 = add nuw i64 %474, %469
  %478 = getelementptr inbounds nuw [4096 x i8], ptr %10, i64 0, i64 %477
  store i8 0, ptr %478, align 1, !tbaa !76
  %479 = call ptr @strstr(ptr noundef nonnull dereferenceable(1) %10, ptr noundef nonnull dereferenceable(1) @.str.34) #33
  %480 = icmp eq ptr %479, null
  br i1 %480, label %468, label %483

481:                                              ; preds = %471
  %482 = icmp eq i64 %469, 0
  br i1 %482, label %540, label %483

483:                                              ; preds = %476, %468, %481
  %484 = call ptr @strstr(ptr noundef nonnull dereferenceable(1) %10, ptr noundef nonnull dereferenceable(1) @.str.64) #33
  %485 = icmp eq ptr %484, null
  br i1 %485, label %540, label %486

486:                                              ; preds = %483
  %487 = call ptr @strstr(ptr noundef nonnull dereferenceable(1) %10, ptr noundef nonnull dereferenceable(1) @.str.65) #33
  %488 = icmp eq ptr %487, null
  br i1 %488, label %540, label %489

489:                                              ; preds = %486
  %490 = getelementptr inbounds nuw i8, ptr %487, i64 21
  br label %491

491:                                              ; preds = %494, %489
  %492 = phi ptr [ %490, %489 ], [ %495, %494 ]
  %493 = load i8, ptr %492, align 1, !tbaa !76
  switch i8 %493, label %496 [
    i8 32, label %494
    i8 9, label %494
  ]

494:                                              ; preds = %491, %491
  %495 = getelementptr inbounds nuw i8, ptr %492, i64 1
  br label %491, !llvm.loop !905

496:                                              ; preds = %491
  call void @llvm.lifetime.start.p0(i64 128, ptr nonnull %11) #36
  br label %497

497:                                              ; preds = %505, %496
  %498 = phi i8 [ %509, %505 ], [ %493, %496 ]
  %499 = phi ptr [ %506, %505 ], [ %492, %496 ]
  %500 = phi i64 [ %507, %505 ], [ 0, %496 ]
  switch i8 %498, label %501 [
    i8 0, label %510
    i8 13, label %510
  ]

501:                                              ; preds = %497
  %502 = icmp ne i8 %498, 10
  %503 = icmp samesign ult i64 %500, 127
  %504 = select i1 %502, i1 %503, i1 false
  br i1 %504, label %505, label %510

505:                                              ; preds = %501
  %506 = getelementptr inbounds nuw i8, ptr %499, i64 1
  %507 = add nuw nsw i64 %500, 1
  %508 = getelementptr inbounds nuw [128 x i8], ptr %11, i64 0, i64 %500
  store i8 %498, ptr %508, align 1, !tbaa !76
  %509 = load i8, ptr %506, align 1, !tbaa !76
  br label %497, !llvm.loop !906

510:                                              ; preds = %501, %497, %497
  %511 = getelementptr inbounds nuw [128 x i8], ptr %11, i64 0, i64 %500
  store i8 0, ptr %511, align 1, !tbaa !76
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %5) #36
  %512 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %5, i64 noundef 256, ptr noundef nonnull @.str.67, ptr noundef nonnull %269, ptr noundef nonnull @.str.66) #36
  call void @llvm.lifetime.start.p0(i64 104, ptr nonnull %6) #36
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %7) #36
  %513 = getelementptr inbounds nuw i8, ptr %6, i64 96
  store i64 0, ptr %513, align 16, !tbaa !907
  %514 = getelementptr inbounds nuw i8, ptr %6, i64 24
  store i64 0, ptr %514, align 8, !tbaa !909
  store <4 x i32> <i32 1732584193, i32 -271733879, i32 -1732584194, i32 271733878>, ptr %6, align 16, !tbaa !26
  %515 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store i32 -1009589776, ptr %515, align 16, !tbaa !26
  %516 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %5) #33
  %517 = icmp eq i64 %516, 0
  br i1 %517, label %536, label %518

518:                                              ; preds = %510
  %519 = getelementptr inbounds nuw i8, ptr %6, i64 32
  br label %520

520:                                              ; preds = %532, %518
  %521 = phi i64 [ 0, %518 ], [ %533, %532 ]
  %522 = phi i64 [ 0, %518 ], [ %534, %532 ]
  %523 = getelementptr inbounds nuw i8, ptr %5, i64 %522
  %524 = load i8, ptr %523, align 1, !tbaa !76
  %525 = add i64 %521, 1
  store i64 %525, ptr %513, align 16, !tbaa !907
  %526 = getelementptr inbounds nuw [64 x i8], ptr %519, i64 0, i64 %521
  store i8 %524, ptr %526, align 1, !tbaa !76
  %527 = load i64, ptr %513, align 16, !tbaa !907
  %528 = icmp eq i64 %527, 64
  br i1 %528, label %529, label %532

529:                                              ; preds = %520
  call fastcc void @uh_sha1_transform(ptr noundef nonnull %6, ptr noundef %519)
  %530 = load i64, ptr %514, align 8, !tbaa !909
  %531 = add i64 %530, 512
  store i64 %531, ptr %514, align 8, !tbaa !909
  store i64 0, ptr %513, align 16, !tbaa !907
  br label %532

532:                                              ; preds = %529, %520
  %533 = phi i64 [ %527, %520 ], [ 0, %529 ]
  %534 = add nuw i64 %522, 1
  %535 = icmp eq i64 %534, %516
  br i1 %535, label %536, label %520, !llvm.loop !910

536:                                              ; preds = %532, %510
  call fastcc void @uh_sha1_final(ptr noundef %6, ptr noundef %7)
  %537 = call noalias dereferenceable_or_null(29) ptr @malloc(i64 noundef 29) #34
  %538 = icmp eq ptr %537, null
  br i1 %538, label %539, label %541

539:                                              ; preds = %536
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %7) #36
  call void @llvm.lifetime.end.p0(i64 104, ptr nonnull %6) #36
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %5) #36
  call void @free(ptr noundef %269) #36
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %11) #36
  call void @llvm.lifetime.end.p0(i64 4096, ptr nonnull %10) #36
  br label %780

540:                                              ; preds = %486, %481, %483
  call void @free(ptr noundef %269) #36
  call void @llvm.lifetime.end.p0(i64 4096, ptr nonnull %10) #36
  br label %780

541:                                              ; preds = %536
  %542 = getelementptr inbounds nuw i8, ptr %7, i64 1
  %543 = getelementptr inbounds nuw i8, ptr %7, i64 2
  %544 = load i8, ptr %542, align 1, !tbaa !76
  %545 = zext i8 %544 to i32
  %546 = shl nuw nsw i32 %545, 8
  %547 = load i8, ptr %543, align 2, !tbaa !76
  %548 = zext i8 %547 to i32
  %549 = or disjoint i32 %546, %548
  %550 = load i8, ptr %7, align 16, !tbaa !76
  %551 = zext i8 %550 to i32
  %552 = shl nuw nsw i32 %551, 16
  %553 = or disjoint i32 %552, %546
  %554 = lshr i32 %551, 2
  %555 = zext nneg i32 %554 to i64
  %556 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %555
  %557 = load i8, ptr %556, align 1, !tbaa !76
  store i8 %557, ptr %537, align 1, !tbaa !76
  %558 = lshr i32 %553, 12
  %559 = and i32 %558, 63
  %560 = zext nneg i32 %559 to i64
  %561 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %560
  %562 = load i8, ptr %561, align 1, !tbaa !76
  %563 = getelementptr i8, ptr %537, i64 1
  store i8 %562, ptr %563, align 1, !tbaa !76
  %564 = lshr i32 %549, 6
  %565 = and i32 %564, 63
  %566 = zext nneg i32 %565 to i64
  %567 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %566
  %568 = load i8, ptr %567, align 1, !tbaa !76
  %569 = getelementptr i8, ptr %537, i64 2
  store i8 %568, ptr %569, align 1, !tbaa !76
  %570 = and i32 %548, 63
  %571 = zext nneg i32 %570 to i64
  %572 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %571
  %573 = load i8, ptr %572, align 1, !tbaa !76
  %574 = getelementptr inbounds nuw i8, ptr %537, i64 3
  store i8 %573, ptr %574, align 1, !tbaa !76
  %575 = getelementptr inbounds nuw i8, ptr %7, i64 4
  %576 = load i8, ptr %575, align 4, !tbaa !76
  %577 = zext i8 %576 to i32
  %578 = shl nuw nsw i32 %577, 8
  %579 = getelementptr inbounds nuw i8, ptr %7, i64 5
  %580 = load i8, ptr %579, align 1, !tbaa !76
  %581 = zext i8 %580 to i32
  %582 = or disjoint i32 %578, %581
  %583 = getelementptr inbounds nuw i8, ptr %7, i64 3
  %584 = load i8, ptr %583, align 1, !tbaa !76
  %585 = zext i8 %584 to i32
  %586 = shl nuw nsw i32 %585, 16
  %587 = or disjoint i32 %586, %578
  %588 = lshr i32 %585, 2
  %589 = zext nneg i32 %588 to i64
  %590 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %589
  %591 = load i8, ptr %590, align 1, !tbaa !76
  %592 = getelementptr inbounds nuw i8, ptr %537, i64 4
  store i8 %591, ptr %592, align 1, !tbaa !76
  %593 = lshr i32 %587, 12
  %594 = and i32 %593, 63
  %595 = zext nneg i32 %594 to i64
  %596 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %595
  %597 = load i8, ptr %596, align 1, !tbaa !76
  %598 = getelementptr i8, ptr %537, i64 5
  store i8 %597, ptr %598, align 1, !tbaa !76
  %599 = lshr i32 %582, 6
  %600 = and i32 %599, 63
  %601 = zext nneg i32 %600 to i64
  %602 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %601
  %603 = load i8, ptr %602, align 1, !tbaa !76
  %604 = getelementptr i8, ptr %537, i64 6
  store i8 %603, ptr %604, align 1, !tbaa !76
  %605 = and i32 %581, 63
  %606 = zext nneg i32 %605 to i64
  %607 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %606
  %608 = load i8, ptr %607, align 1, !tbaa !76
  %609 = getelementptr inbounds nuw i8, ptr %537, i64 7
  store i8 %608, ptr %609, align 1, !tbaa !76
  %610 = getelementptr inbounds nuw i8, ptr %7, i64 7
  %611 = load i8, ptr %610, align 1, !tbaa !76
  %612 = zext i8 %611 to i32
  %613 = shl nuw nsw i32 %612, 8
  %614 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %615 = load i8, ptr %614, align 8, !tbaa !76
  %616 = zext i8 %615 to i32
  %617 = or disjoint i32 %613, %616
  %618 = getelementptr inbounds nuw i8, ptr %7, i64 6
  %619 = load i8, ptr %618, align 2, !tbaa !76
  %620 = zext i8 %619 to i32
  %621 = shl nuw nsw i32 %620, 16
  %622 = or disjoint i32 %621, %613
  %623 = lshr i32 %620, 2
  %624 = zext nneg i32 %623 to i64
  %625 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %624
  %626 = load i8, ptr %625, align 1, !tbaa !76
  %627 = getelementptr inbounds nuw i8, ptr %537, i64 8
  store i8 %626, ptr %627, align 1, !tbaa !76
  %628 = lshr i32 %622, 12
  %629 = and i32 %628, 63
  %630 = zext nneg i32 %629 to i64
  %631 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %630
  %632 = load i8, ptr %631, align 1, !tbaa !76
  %633 = getelementptr i8, ptr %537, i64 9
  store i8 %632, ptr %633, align 1, !tbaa !76
  %634 = lshr i32 %617, 6
  %635 = and i32 %634, 63
  %636 = zext nneg i32 %635 to i64
  %637 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %636
  %638 = load i8, ptr %637, align 1, !tbaa !76
  %639 = getelementptr i8, ptr %537, i64 10
  store i8 %638, ptr %639, align 1, !tbaa !76
  %640 = and i32 %616, 63
  %641 = zext nneg i32 %640 to i64
  %642 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %641
  %643 = load i8, ptr %642, align 1, !tbaa !76
  %644 = getelementptr inbounds nuw i8, ptr %537, i64 11
  store i8 %643, ptr %644, align 1, !tbaa !76
  %645 = getelementptr inbounds nuw i8, ptr %7, i64 10
  %646 = load i8, ptr %645, align 2, !tbaa !76
  %647 = zext i8 %646 to i32
  %648 = shl nuw nsw i32 %647, 8
  %649 = getelementptr inbounds nuw i8, ptr %7, i64 11
  %650 = load i8, ptr %649, align 1, !tbaa !76
  %651 = zext i8 %650 to i32
  %652 = or disjoint i32 %648, %651
  %653 = getelementptr inbounds nuw i8, ptr %7, i64 9
  %654 = load i8, ptr %653, align 1, !tbaa !76
  %655 = zext i8 %654 to i32
  %656 = shl nuw nsw i32 %655, 16
  %657 = or disjoint i32 %656, %648
  %658 = lshr i32 %655, 2
  %659 = zext nneg i32 %658 to i64
  %660 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %659
  %661 = load i8, ptr %660, align 1, !tbaa !76
  %662 = getelementptr inbounds nuw i8, ptr %537, i64 12
  store i8 %661, ptr %662, align 1, !tbaa !76
  %663 = lshr i32 %657, 12
  %664 = and i32 %663, 63
  %665 = zext nneg i32 %664 to i64
  %666 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %665
  %667 = load i8, ptr %666, align 1, !tbaa !76
  %668 = getelementptr i8, ptr %537, i64 13
  store i8 %667, ptr %668, align 1, !tbaa !76
  %669 = lshr i32 %652, 6
  %670 = and i32 %669, 63
  %671 = zext nneg i32 %670 to i64
  %672 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %671
  %673 = load i8, ptr %672, align 1, !tbaa !76
  %674 = getelementptr i8, ptr %537, i64 14
  store i8 %673, ptr %674, align 1, !tbaa !76
  %675 = and i32 %651, 63
  %676 = zext nneg i32 %675 to i64
  %677 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %676
  %678 = load i8, ptr %677, align 1, !tbaa !76
  %679 = getelementptr inbounds nuw i8, ptr %537, i64 15
  store i8 %678, ptr %679, align 1, !tbaa !76
  %680 = getelementptr inbounds nuw i8, ptr %7, i64 13
  %681 = load i8, ptr %680, align 1, !tbaa !76
  %682 = zext i8 %681 to i32
  %683 = shl nuw nsw i32 %682, 8
  %684 = getelementptr inbounds nuw i8, ptr %7, i64 14
  %685 = load i8, ptr %684, align 2, !tbaa !76
  %686 = zext i8 %685 to i32
  %687 = or disjoint i32 %683, %686
  %688 = getelementptr inbounds nuw i8, ptr %7, i64 12
  %689 = load i8, ptr %688, align 4, !tbaa !76
  %690 = zext i8 %689 to i32
  %691 = shl nuw nsw i32 %690, 16
  %692 = or disjoint i32 %691, %683
  %693 = lshr i32 %690, 2
  %694 = zext nneg i32 %693 to i64
  %695 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %694
  %696 = load i8, ptr %695, align 1, !tbaa !76
  %697 = getelementptr inbounds nuw i8, ptr %537, i64 16
  store i8 %696, ptr %697, align 1, !tbaa !76
  %698 = lshr i32 %692, 12
  %699 = and i32 %698, 63
  %700 = zext nneg i32 %699 to i64
  %701 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %700
  %702 = load i8, ptr %701, align 1, !tbaa !76
  %703 = getelementptr i8, ptr %537, i64 17
  store i8 %702, ptr %703, align 1, !tbaa !76
  %704 = lshr i32 %687, 6
  %705 = and i32 %704, 63
  %706 = zext nneg i32 %705 to i64
  %707 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %706
  %708 = load i8, ptr %707, align 1, !tbaa !76
  %709 = getelementptr i8, ptr %537, i64 18
  store i8 %708, ptr %709, align 1, !tbaa !76
  %710 = and i32 %686, 63
  %711 = zext nneg i32 %710 to i64
  %712 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %711
  %713 = load i8, ptr %712, align 1, !tbaa !76
  %714 = getelementptr inbounds nuw i8, ptr %537, i64 19
  store i8 %713, ptr %714, align 1, !tbaa !76
  %715 = getelementptr inbounds nuw i8, ptr %7, i64 16
  %716 = load i8, ptr %715, align 16, !tbaa !76
  %717 = zext i8 %716 to i32
  %718 = shl nuw nsw i32 %717, 8
  %719 = getelementptr inbounds nuw i8, ptr %7, i64 17
  %720 = load i8, ptr %719, align 1, !tbaa !76
  %721 = zext i8 %720 to i32
  %722 = or disjoint i32 %718, %721
  %723 = getelementptr inbounds nuw i8, ptr %7, i64 15
  %724 = load i8, ptr %723, align 1, !tbaa !76
  %725 = zext i8 %724 to i32
  %726 = shl nuw nsw i32 %725, 16
  %727 = or disjoint i32 %726, %718
  %728 = lshr i32 %725, 2
  %729 = zext nneg i32 %728 to i64
  %730 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %729
  %731 = load i8, ptr %730, align 1, !tbaa !76
  %732 = getelementptr inbounds nuw i8, ptr %537, i64 20
  store i8 %731, ptr %732, align 1, !tbaa !76
  %733 = lshr i32 %727, 12
  %734 = and i32 %733, 63
  %735 = zext nneg i32 %734 to i64
  %736 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %735
  %737 = load i8, ptr %736, align 1, !tbaa !76
  %738 = getelementptr i8, ptr %537, i64 21
  store i8 %737, ptr %738, align 1, !tbaa !76
  %739 = lshr i32 %722, 6
  %740 = and i32 %739, 63
  %741 = zext nneg i32 %740 to i64
  %742 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %741
  %743 = load i8, ptr %742, align 1, !tbaa !76
  %744 = getelementptr i8, ptr %537, i64 22
  store i8 %743, ptr %744, align 1, !tbaa !76
  %745 = and i32 %721, 63
  %746 = zext nneg i32 %745 to i64
  %747 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %746
  %748 = load i8, ptr %747, align 1, !tbaa !76
  %749 = getelementptr inbounds nuw i8, ptr %537, i64 23
  store i8 %748, ptr %749, align 1, !tbaa !76
  %750 = getelementptr inbounds nuw i8, ptr %7, i64 18
  %751 = load i8, ptr %750, align 2, !tbaa !76
  %752 = zext i8 %751 to i32
  %753 = shl nuw nsw i32 %752, 16
  %754 = getelementptr inbounds nuw i8, ptr %7, i64 19
  %755 = load i8, ptr %754, align 1, !tbaa !76
  %756 = zext i8 %755 to i32
  %757 = shl nuw nsw i32 %756, 8
  %758 = or disjoint i32 %757, %753
  %759 = lshr i32 %752, 2
  %760 = zext nneg i32 %759 to i64
  %761 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %760
  %762 = load i8, ptr %761, align 1, !tbaa !76
  %763 = getelementptr inbounds nuw i8, ptr %537, i64 24
  store i8 %762, ptr %763, align 1, !tbaa !76
  %764 = lshr i32 %758, 12
  %765 = and i32 %764, 63
  %766 = zext nneg i32 %765 to i64
  %767 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %766
  %768 = load i8, ptr %767, align 1, !tbaa !76
  %769 = getelementptr i8, ptr %537, i64 25
  store i8 %768, ptr %769, align 1, !tbaa !76
  %770 = shl nuw nsw i32 %756, 2
  %771 = and i32 %770, 60
  %772 = zext nneg i32 %771 to i64
  %773 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %772
  %774 = load i8, ptr %773, align 4, !tbaa !76
  %775 = getelementptr i8, ptr %537, i64 26
  store i8 %774, ptr %775, align 1, !tbaa !76
  %776 = getelementptr inbounds nuw i8, ptr %537, i64 27
  store i8 61, ptr %776, align 1, !tbaa !76
  %777 = getelementptr inbounds nuw i8, ptr %537, i64 28
  store i8 0, ptr %777, align 1, !tbaa !76
  %778 = call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %537, ptr noundef nonnull readonly dereferenceable(1) %11) #33
  %779 = icmp eq i32 %778, 0
  call void @free(ptr noundef nonnull %537) #36
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %7) #36
  call void @llvm.lifetime.end.p0(i64 104, ptr nonnull %6) #36
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %5) #36
  call void @free(ptr noundef %269) #36
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %11) #36
  call void @llvm.lifetime.end.p0(i64 4096, ptr nonnull %10) #36
  call void @llvm.lifetime.end.p0(i64 1024, ptr nonnull %9) #36
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #36
  br i1 %779, label %785, label %782

780:                                              ; preds = %539, %540, %466
  call void @llvm.lifetime.end.p0(i64 1024, ptr nonnull %9) #36
  br label %781

781:                                              ; preds = %780, %268
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %8) #36
  br label %782

782:                                              ; preds = %781, %541
  %783 = call i32 @close(i32 noundef %194) #36
  call void @free(ptr noundef %173) #36
  call void @free(ptr noundef %174) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !911
  %784 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %784, i8 0, i64 32, i1 false), !alias.scope !911
  br label %799

785:                                              ; preds = %541
  call void @llvm.experimental.noalias.scope.decl(metadata !914)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !917
  %786 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %787 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %788 = getelementptr inbounds nuw i8, ptr %0, i64 32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %786, i8 0, i64 24, i1 false), !alias.scope !917
  store ptr %787, ptr %788, align 8, !tbaa !48, !alias.scope !917
  call void @llvm.experimental.noalias.scope.decl(metadata !920)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !920, !noalias !914
  %789 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store double 0.000000e+00, ptr %789, align 8, !tbaa !35, !alias.scope !920, !noalias !914
  %790 = call noalias dereferenceable_or_null(8) ptr @malloc(i64 noundef 8) #34
  %791 = icmp eq ptr %790, null
  br i1 %791, label %793, label %792

792:                                              ; preds = %785
  store i64 28260057816194911, ptr %790, align 1, !noalias !923
  br label %793

793:                                              ; preds = %785, %792
  %794 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store ptr %790, ptr %794, align 8, !tbaa !46, !alias.scope !920, !noalias !914
  %795 = getelementptr inbounds nuw i8, ptr %3, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %795, i8 0, i64 16, i1 false), !alias.scope !920, !noalias !914
  %796 = uitofp nneg i32 %194 to double
  store i32 0, ptr %4, align 8, !tbaa !31, !alias.scope !924, !noalias !914
  %797 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store double %796, ptr %797, align 8, !tbaa !35, !alias.scope !924, !noalias !914
  %798 = getelementptr inbounds nuw i8, ptr %4, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %798, i8 0, i64 24, i1 false), !alias.scope !924, !noalias !914
  call void @uh_dict_set(ptr noundef nonnull align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %3, ptr noundef nonnull byval(%struct.UhValue) align 8 %4)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  call void @free(ptr noundef %173) #36
  call void @free(ptr noundef %174) #36
  br label %799

799:                                              ; preds = %209, %782, %793, %184
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %14) #36
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %13) #36
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %12) #36
  br label %800

800:                                              ; preds = %799, %169, %164, %160
  ret void
}

declare i32 @getaddrinfo(ptr noundef, ptr noundef, ptr noundef, ptr noundef) local_unnamed_addr #22

declare i32 @connect(i32 noundef, ptr noundef, i32 noundef) local_unnamed_addr #22

; Function Attrs: nounwind
declare void @freeaddrinfo(ptr noundef) local_unnamed_addr #23

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_ws_receive(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca [10 x i8], align 1
  %4 = alloca [2 x i8], align 1
  %5 = alloca [2 x i8], align 1
  %6 = alloca [8 x i8], align 1
  %7 = alloca [4 x i8], align 4
  %8 = load i32, ptr %1, align 8
  %9 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %10 = load ptr, ptr %9, align 8
  %11 = icmp ne i32 %8, 3
  %12 = icmp eq ptr %10, null
  %13 = select i1 %11, i1 true, i1 %12
  %14 = getelementptr inbounds nuw i8, ptr %3, i64 9
  %15 = getelementptr inbounds nuw i8, ptr %3, i64 3
  %16 = getelementptr inbounds nuw i8, ptr %3, i64 1
  br i1 %13, label %58, label %17

17:                                               ; preds = %2
  %18 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %19 = load i64, ptr %18, align 8, !tbaa !65, !noalias !927
  %20 = icmp eq i64 %19, 0
  br i1 %20, label %58, label %21

21:                                               ; preds = %17
  %22 = load ptr, ptr %10, align 8, !tbaa !68, !noalias !927
  br label %26

23:                                               ; preds = %26
  %24 = add nuw i64 %27, 1
  %25 = icmp eq i64 %24, %19
  br i1 %25, label %58, label %26, !llvm.loop !69

26:                                               ; preds = %23, %21
  %27 = phi i64 [ 0, %21 ], [ %24, %23 ]
  %28 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %22, i64 %27
  %29 = load ptr, ptr %28, align 8, !tbaa !70, !noalias !927
  %30 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %29, ptr noundef nonnull readonly dereferenceable(8) @.str.53) #33, !noalias !927
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %32, label %23

32:                                               ; preds = %26
  %33 = getelementptr inbounds nuw i8, ptr %28, i64 8
  %34 = load i32, ptr %33, align 8, !tbaa !26
  %35 = getelementptr inbounds nuw i8, ptr %28, i64 16
  %36 = load double, ptr %35, align 8, !tbaa !27
  %37 = freeze i32 %34
  %38 = icmp ne i32 %37, 0
  %39 = fptosi double %36 to i32
  %40 = icmp slt i32 %39, 0
  %41 = select i1 %38, i1 true, i1 %40
  br i1 %41, label %58, label %42

42:                                               ; preds = %32
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %4) #36
  %43 = call i64 @recv(i32 noundef %39, ptr noundef nonnull %4, i64 noundef 2, i32 noundef 256) #36
  %44 = icmp slt i64 %43, 1
  br i1 %44, label %60, label %45

45:                                               ; preds = %42
  %46 = getelementptr inbounds nuw i8, ptr %4, i64 1
  %47 = getelementptr inbounds nuw i8, ptr %5, i64 1
  %48 = getelementptr inbounds nuw i8, ptr %3, i64 2
  %49 = getelementptr inbounds nuw i8, ptr %3, i64 7
  %50 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %51 = getelementptr inbounds nuw i8, ptr %6, i64 1
  %52 = getelementptr inbounds nuw i8, ptr %6, i64 2
  %53 = getelementptr inbounds nuw i8, ptr %6, i64 3
  %54 = getelementptr inbounds nuw i8, ptr %6, i64 4
  %55 = getelementptr inbounds nuw i8, ptr %6, i64 5
  %56 = getelementptr inbounds nuw i8, ptr %6, i64 6
  %57 = getelementptr inbounds nuw i8, ptr %6, i64 7
  br label %62

58:                                               ; preds = %23, %2, %17, %32
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !930
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %59, i8 0, i64 32, i1 false), !alias.scope !930
  br label %219

60:                                               ; preds = %214, %42
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !933
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %61, i8 0, i64 32, i1 false), !alias.scope !933
  br label %217

62:                                               ; preds = %45, %214
  %63 = load i8, ptr %4, align 1, !tbaa !76
  %64 = and i8 %63, 15
  %65 = load i8, ptr %46, align 1, !tbaa !76
  %66 = and i8 %65, 127
  %67 = icmp eq i8 %66, 126
  br i1 %67, label %68, label %80

68:                                               ; preds = %62
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %5) #36
  %69 = call i64 @recv(i32 noundef %39, ptr noundef nonnull %5, i64 noundef 2, i32 noundef 256) #36
  %70 = icmp eq i64 %69, 2
  br i1 %70, label %71, label %78

71:                                               ; preds = %68
  %72 = load i8, ptr %5, align 1, !tbaa !76
  %73 = zext i8 %72 to i64
  %74 = shl nuw nsw i64 %73, 8
  %75 = load i8, ptr %47, align 1, !tbaa !76
  %76 = zext i8 %75 to i64
  %77 = or disjoint i64 %74, %76
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %5) #36
  br label %119

78:                                               ; preds = %68
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !936
  %79 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %79, i8 0, i64 32, i1 false), !alias.scope !936
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %5) #36
  br label %217

80:                                               ; preds = %62
  %81 = zext nneg i8 %66 to i64
  %82 = icmp eq i8 %66, 127
  br i1 %82, label %83, label %119

83:                                               ; preds = %80
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %6) #36
  %84 = call i64 @recv(i32 noundef %39, ptr noundef nonnull %6, i64 noundef 8, i32 noundef 256) #36
  %85 = icmp eq i64 %84, 8
  br i1 %85, label %86, label %117

86:                                               ; preds = %83
  %87 = load i8, ptr %6, align 1, !tbaa !76
  %88 = zext i8 %87 to i64
  %89 = load i8, ptr %51, align 1, !tbaa !76
  %90 = zext i8 %89 to i64
  %91 = shl nuw nsw i64 %88, 16
  %92 = shl nuw nsw i64 %90, 8
  %93 = or disjoint i64 %91, %92
  %94 = load i8, ptr %52, align 1, !tbaa !76
  %95 = zext i8 %94 to i64
  %96 = or disjoint i64 %93, %95
  %97 = load i8, ptr %53, align 1, !tbaa !76
  %98 = zext i8 %97 to i64
  %99 = shl nuw nsw i64 %96, 16
  %100 = shl nuw nsw i64 %98, 8
  %101 = or disjoint i64 %99, %100
  %102 = load i8, ptr %54, align 1, !tbaa !76
  %103 = zext i8 %102 to i64
  %104 = or disjoint i64 %101, %103
  %105 = load i8, ptr %55, align 1, !tbaa !76
  %106 = zext i8 %105 to i64
  %107 = shl nuw nsw i64 %104, 16
  %108 = shl nuw nsw i64 %106, 8
  %109 = or disjoint i64 %107, %108
  %110 = load i8, ptr %56, align 1, !tbaa !76
  %111 = zext i8 %110 to i64
  %112 = or disjoint i64 %109, %111
  %113 = shl nuw i64 %112, 8
  %114 = load i8, ptr %57, align 1, !tbaa !76
  %115 = zext i8 %114 to i64
  %116 = or disjoint i64 %113, %115
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %6) #36
  br label %119

117:                                              ; preds = %83
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !939
  %118 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %118, i8 0, i64 32, i1 false), !alias.scope !939
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %6) #36
  br label %217

119:                                              ; preds = %86, %71, %80
  %120 = phi i64 [ %116, %86 ], [ %81, %80 ], [ %77, %71 ]
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #36
  store i32 0, ptr %7, align 4
  %121 = icmp slt i8 %65, 0
  br i1 %121, label %122, label %127

122:                                              ; preds = %119
  %123 = call i64 @recv(i32 noundef %39, ptr noundef nonnull %7, i64 noundef 4, i32 noundef 256) #36
  %124 = icmp eq i64 %123, 4
  br i1 %124, label %127, label %125

125:                                              ; preds = %122
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !942
  %126 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %126, i8 0, i64 32, i1 false), !alias.scope !942
  br label %218

127:                                              ; preds = %122, %119
  %128 = icmp ugt i64 %120, 1048576
  br i1 %128, label %129, label %131

129:                                              ; preds = %127
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !945
  %130 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %130, i8 0, i64 32, i1 false), !alias.scope !945
  br label %218

131:                                              ; preds = %127
  %132 = add nuw nsw i64 %120, 1
  %133 = call noalias ptr @malloc(i64 noundef %132) #34
  %134 = icmp eq ptr %133, null
  br i1 %134, label %135, label %137

135:                                              ; preds = %131
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !948
  %136 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %136, i8 0, i64 32, i1 false), !alias.scope !948
  br label %218

137:                                              ; preds = %131
  %138 = icmp eq i64 %120, 0
  br i1 %138, label %178, label %139

139:                                              ; preds = %137
  %140 = call i64 @recv(i32 noundef %39, ptr noundef nonnull %133, i64 noundef %120, i32 noundef 256) #36
  %141 = icmp eq i64 %140, %120
  br i1 %141, label %144, label %142

142:                                              ; preds = %139
  call void @free(ptr noundef nonnull %133) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !951
  %143 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %143, i8 0, i64 32, i1 false), !alias.scope !951
  br label %218

144:                                              ; preds = %139
  br i1 %121, label %145, label %178

145:                                              ; preds = %144
  %146 = icmp eq i64 %120, 4
  br i1 %146, label %147, label %151

147:                                              ; preds = %145
  %148 = load <4 x i8>, ptr %133, align 1, !tbaa !76
  %149 = load <4 x i8>, ptr %7, align 4, !tbaa !76
  %150 = xor <4 x i8> %149, %148
  store <4 x i8> %150, ptr %133, align 1, !tbaa !76
  br label %178

151:                                              ; preds = %145
  %152 = and i64 %120, 1
  %153 = icmp eq i64 %152, 0
  br i1 %153, label %158, label %154

154:                                              ; preds = %151
  %155 = load i8, ptr %133, align 1, !tbaa !76
  %156 = load i8, ptr %7, align 1, !tbaa !76
  %157 = xor i8 %156, %155
  store i8 %157, ptr %133, align 1, !tbaa !76
  br label %158

158:                                              ; preds = %154, %151
  %159 = phi i64 [ 0, %151 ], [ 1, %154 ]
  %160 = icmp eq i64 %120, 1
  br i1 %160, label %178, label %161

161:                                              ; preds = %158, %161
  %162 = phi i64 [ %176, %161 ], [ %159, %158 ]
  %163 = getelementptr inbounds nuw i8, ptr %133, i64 %162
  %164 = load i8, ptr %163, align 1, !tbaa !76
  %165 = and i64 %162, 3
  %166 = getelementptr inbounds nuw [4 x i8], ptr %7, i64 0, i64 %165
  %167 = load i8, ptr %166, align 1, !tbaa !76
  %168 = xor i8 %167, %164
  store i8 %168, ptr %163, align 1, !tbaa !76
  %169 = add nuw nsw i64 %162, 1
  %170 = getelementptr inbounds nuw i8, ptr %133, i64 %169
  %171 = load i8, ptr %170, align 1, !tbaa !76
  %172 = and i64 %169, 3
  %173 = getelementptr inbounds nuw [4 x i8], ptr %7, i64 0, i64 %172
  %174 = load i8, ptr %173, align 1, !tbaa !76
  %175 = xor i8 %174, %171
  store i8 %175, ptr %170, align 1, !tbaa !76
  %176 = add nuw nsw i64 %162, 2
  %177 = icmp eq i64 %176, %120
  br i1 %177, label %178, label %161, !llvm.loop !954

178:                                              ; preds = %158, %161, %147, %137, %144
  %179 = getelementptr inbounds nuw i8, ptr %133, i64 %120
  store i8 0, ptr %179, align 1, !tbaa !76
  switch i8 %64, label %214 [
    i8 8, label %180
    i8 9, label %182
    i8 1, label %204
  ]

180:                                              ; preds = %178
  call void @free(ptr noundef nonnull %133) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !956
  %181 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %181, i8 0, i64 32, i1 false), !alias.scope !956
  br label %218

182:                                              ; preds = %178
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %3) #36
  store i8 -118, ptr %3, align 1, !tbaa !76
  %183 = icmp samesign ult i64 %120, 126
  br i1 %183, label %194, label %184

184:                                              ; preds = %182
  %185 = icmp samesign ult i64 %120, 65536
  br i1 %185, label %186, label %189

186:                                              ; preds = %184
  store i8 126, ptr %16, align 1, !tbaa !76
  %187 = lshr i64 %120, 8
  %188 = trunc nuw i64 %187 to i8
  store i8 %188, ptr %48, align 1, !tbaa !76
  br label %194

189:                                              ; preds = %184
  store i8 127, ptr %16, align 1, !tbaa !76
  %190 = lshr i64 %120, 16
  %191 = trunc nuw nsw i64 %190 to i8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %48, i8 0, i64 5, i1 false)
  store i8 %191, ptr %49, align 1, !tbaa !76
  %192 = lshr i64 %120, 8
  %193 = trunc i64 %192 to i8
  store i8 %193, ptr %50, align 1, !tbaa !76
  br label %194

194:                                              ; preds = %189, %186, %182
  %195 = phi ptr [ %14, %189 ], [ %15, %186 ], [ %16, %182 ]
  %196 = phi i64 [ 10, %189 ], [ 4, %186 ], [ 2, %182 ]
  %197 = trunc i64 %120 to i8
  store i8 %197, ptr %195, align 1, !tbaa !76
  %198 = call i64 @send(i32 noundef %39, ptr noundef nonnull %3, i64 noundef %196, i32 noundef 0) #36
  %199 = icmp ne i64 %198, %196
  %200 = or i1 %138, %199
  br i1 %200, label %203, label %201

201:                                              ; preds = %194
  %202 = call i64 @send(i32 noundef %39, ptr noundef nonnull %133, i64 noundef %120, i32 noundef 0) #36
  br label %203

203:                                              ; preds = %194, %201
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %3) #36
  br label %214

204:                                              ; preds = %178
  call void @llvm.experimental.noalias.scope.decl(metadata !959)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !959
  %205 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %205, align 8, !tbaa !35, !alias.scope !959
  %206 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %133) #33, !noalias !959
  %207 = add i64 %206, 1
  %208 = call noalias ptr @malloc(i64 noundef %207) #34
  %209 = icmp eq ptr %208, null
  br i1 %209, label %211, label %210

210:                                              ; preds = %204
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %208, ptr nonnull readonly align 1 %133, i64 %207, i1 false), !noalias !959
  br label %211

211:                                              ; preds = %204, %210
  %212 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %208, ptr %212, align 8, !tbaa !46, !alias.scope !959
  %213 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %213, i8 0, i64 16, i1 false), !alias.scope !959
  call void @free(ptr noundef nonnull %133) #36
  br label %218

214:                                              ; preds = %178, %203
  call void @free(ptr noundef nonnull %133) #36
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #36
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %4) #36
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %4) #36
  %215 = call i64 @recv(i32 noundef %39, ptr noundef nonnull %4, i64 noundef 2, i32 noundef 256) #36
  %216 = icmp slt i64 %215, 1
  br i1 %216, label %60, label %62

217:                                              ; preds = %117, %78, %60
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %4) #36
  br label %219

218:                                              ; preds = %135, %211, %180, %142, %129, %125
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #36
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %4) #36
  br label %219

219:                                              ; preds = %218, %217, %58
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_ws_serve(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca [4096 x i8], align 16
  %6 = alloca [128 x i8], align 16
  %7 = alloca [256 x i8], align 16
  %8 = alloca %struct.UhSha1, align 16
  %9 = alloca [20 x i8], align 16
  %10 = alloca [512 x i8], align 16
  %11 = alloca i32, align 4
  %12 = alloca %struct.sockaddr_in, align 4
  %13 = alloca %struct.UhValue, align 8
  %14 = alloca [1 x %struct.UhValue], align 16
  %15 = alloca %struct.UhValue, align 8
  %16 = load i32, ptr %1, align 8, !tbaa !31
  %17 = icmp eq i32 %16, 3
  br i1 %17, label %18, label %72

18:                                               ; preds = %2
  %19 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %20 = load ptr, ptr %19, align 8
  %21 = icmp eq ptr %20, null
  br i1 %21, label %72, label %22

22:                                               ; preds = %18
  %23 = getelementptr inbounds nuw i8, ptr %20, i64 8
  %24 = load i64, ptr %23, align 8, !tbaa !65, !noalias !962
  %25 = icmp eq i64 %24, 0
  br i1 %25, label %46, label %26

26:                                               ; preds = %22
  %27 = load ptr, ptr %20, align 8, !tbaa !68, !noalias !962
  br label %31

28:                                               ; preds = %31
  %29 = add nuw i64 %32, 1
  %30 = icmp eq i64 %29, %24
  br i1 %30, label %46, label %31, !llvm.loop !69

31:                                               ; preds = %28, %26
  %32 = phi i64 [ 0, %26 ], [ %29, %28 ]
  %33 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %27, i64 %32
  %34 = load ptr, ptr %33, align 8, !tbaa !70, !noalias !962
  %35 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %34, ptr noundef nonnull readonly dereferenceable(5) @.str.49) #33, !noalias !962
  %36 = icmp eq i32 %35, 0
  br i1 %36, label %37, label %28

37:                                               ; preds = %31
  %38 = getelementptr inbounds nuw i8, ptr %33, i64 8
  %39 = load i32, ptr %38, align 8, !tbaa !26
  %40 = getelementptr inbounds nuw i8, ptr %33, i64 16
  %41 = load double, ptr %40, align 8, !tbaa !27
  %42 = freeze i32 %39
  %43 = icmp eq i32 %42, 0
  %44 = fptosi double %41 to i32
  %45 = select i1 %43, i32 %44, i32 0
  br label %46

46:                                               ; preds = %28, %37, %22
  %47 = phi i32 [ 0, %22 ], [ %45, %37 ], [ 0, %28 ]
  %48 = getelementptr inbounds nuw i8, ptr %20, i64 8
  %49 = load i64, ptr %48, align 8, !tbaa !65, !noalias !965
  %50 = icmp eq i64 %49, 0
  br i1 %50, label %72, label %51

51:                                               ; preds = %46
  %52 = load ptr, ptr %20, align 8, !tbaa !68, !noalias !965
  br label %56

53:                                               ; preds = %56
  %54 = add nuw i64 %57, 1
  %55 = icmp eq i64 %54, %49
  br i1 %55, label %72, label %56, !llvm.loop !69

56:                                               ; preds = %53, %51
  %57 = phi i64 [ 0, %51 ], [ %54, %53 ]
  %58 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %52, i64 %57
  %59 = load ptr, ptr %58, align 8, !tbaa !70, !noalias !965
  %60 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %59, ptr noundef nonnull readonly dereferenceable(8) @.str.51) #33, !noalias !965
  %61 = icmp eq i32 %60, 0
  br i1 %61, label %62, label %53

62:                                               ; preds = %56
  %63 = getelementptr inbounds nuw i8, ptr %58, i64 8
  %64 = load i32, ptr %63, align 8, !tbaa !26
  %65 = getelementptr inbounds nuw i8, ptr %58, i64 24
  %66 = load ptr, ptr %65, align 8, !tbaa !28
  %67 = icmp eq i32 %64, 1
  %68 = icmp sgt i32 %47, 0
  %69 = icmp ne ptr %66, null
  %70 = select i1 %68, i1 %67, i1 false
  %71 = select i1 %70, i1 %69, i1 false
  br i1 %71, label %74, label %72

72:                                               ; preds = %53, %18, %46, %2, %62
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !968
  %73 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %73, i8 0, i64 32, i1 false)
  br label %430

74:                                               ; preds = %62
  %75 = tail call i32 @socket(i32 noundef 2, i32 noundef 1, i32 noundef 0) #36
  %76 = icmp slt i32 %75, 0
  br i1 %76, label %77, label %79

77:                                               ; preds = %74
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !971
  %78 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %78, i8 0, i64 32, i1 false)
  br label %430

79:                                               ; preds = %74
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %11) #36
  store i32 1, ptr %11, align 4, !tbaa !26
  %80 = call i32 @setsockopt(i32 noundef %75, i32 noundef 1, i32 noundef 2, ptr noundef nonnull %11, i32 noundef 4) #36
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %12) #36
  %81 = getelementptr inbounds nuw i8, ptr %12, i64 8
  store i64 0, ptr %81, align 4
  store i16 2, ptr %12, align 4, !tbaa !76
  %82 = getelementptr inbounds nuw i8, ptr %12, i64 4
  store i32 0, ptr %82, align 4, !tbaa !76
  %83 = trunc i32 %47 to i16
  %84 = call noundef i16 @llvm.bswap.i16(i16 %83)
  %85 = getelementptr inbounds nuw i8, ptr %12, i64 2
  store i16 %84, ptr %85, align 2, !tbaa !76
  %86 = call i32 @bind(i32 noundef %75, ptr noundef nonnull %12, i32 noundef 16) #36
  %87 = icmp eq i32 %86, 0
  br i1 %87, label %88, label %427

88:                                               ; preds = %79
  %89 = call i32 @listen(i32 noundef %75, i32 noundef 16) #36
  %90 = icmp eq i32 %89, 0
  br i1 %90, label %91, label %427

91:                                               ; preds = %88
  %92 = getelementptr inbounds nuw i8, ptr %8, i64 96
  %93 = getelementptr inbounds nuw i8, ptr %8, i64 24
  %94 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %95 = getelementptr inbounds nuw i8, ptr %8, i64 32
  %96 = getelementptr inbounds nuw i8, ptr %9, i64 1
  %97 = getelementptr inbounds nuw i8, ptr %9, i64 2
  %98 = getelementptr inbounds nuw i8, ptr %9, i64 4
  %99 = getelementptr inbounds nuw i8, ptr %9, i64 5
  %100 = getelementptr inbounds nuw i8, ptr %9, i64 3
  %101 = getelementptr inbounds nuw i8, ptr %9, i64 7
  %102 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %103 = getelementptr inbounds nuw i8, ptr %9, i64 6
  %104 = getelementptr inbounds nuw i8, ptr %9, i64 10
  %105 = getelementptr inbounds nuw i8, ptr %9, i64 11
  %106 = getelementptr inbounds nuw i8, ptr %9, i64 9
  %107 = getelementptr inbounds nuw i8, ptr %9, i64 13
  %108 = getelementptr inbounds nuw i8, ptr %9, i64 14
  %109 = getelementptr inbounds nuw i8, ptr %9, i64 12
  %110 = getelementptr inbounds nuw i8, ptr %9, i64 16
  %111 = getelementptr inbounds nuw i8, ptr %9, i64 17
  %112 = getelementptr inbounds nuw i8, ptr %9, i64 15
  %113 = getelementptr inbounds nuw i8, ptr %9, i64 18
  %114 = getelementptr inbounds nuw i8, ptr %9, i64 19
  %115 = getelementptr inbounds nuw i8, ptr %13, i64 8
  %116 = getelementptr inbounds nuw i8, ptr %13, i64 32
  %117 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %118 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %119 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %120 = getelementptr inbounds nuw i8, ptr %4, i64 8
  %121 = getelementptr inbounds nuw i8, ptr %4, i64 16
  br label %122

122:                                              ; preds = %426, %91
  %123 = call i32 @accept(i32 noundef %75, ptr noundef null, ptr noundef null) #36
  %124 = icmp slt i32 %123, 0
  br i1 %124, label %426, label %125

125:                                              ; preds = %122
  call void @llvm.lifetime.start.p0(i64 4096, ptr nonnull %5) #36
  br label %126

126:                                              ; preds = %134, %125
  %127 = phi i64 [ 0, %125 ], [ %135, %134 ]
  %128 = icmp ult i64 %127, 4095
  br i1 %128, label %129, label %141

129:                                              ; preds = %126
  %130 = getelementptr inbounds nuw i8, ptr %5, i64 %127
  %131 = sub nuw nsw i64 4095, %127
  %132 = call i64 @recv(i32 noundef range(i32 0, -2147483648) %123, ptr noundef nonnull %130, i64 noundef %131, i32 noundef 0) #36
  %133 = icmp slt i64 %132, 1
  br i1 %133, label %139, label %134

134:                                              ; preds = %129
  %135 = add nuw i64 %132, %127
  %136 = getelementptr inbounds nuw [4096 x i8], ptr %5, i64 0, i64 %135
  store i8 0, ptr %136, align 1, !tbaa !76
  %137 = call ptr @strstr(ptr noundef nonnull dereferenceable(1) %5, ptr noundef nonnull dereferenceable(1) @.str.34) #33
  %138 = icmp eq ptr %137, null
  br i1 %138, label %126, label %141

139:                                              ; preds = %129
  %140 = icmp eq i64 %127, 0
  br i1 %140, label %193, label %141

141:                                              ; preds = %134, %126, %139
  %142 = call ptr @strstr(ptr noundef nonnull dereferenceable(1) %5, ptr noundef nonnull dereferenceable(1) @.str.68) #33
  %143 = icmp eq ptr %142, null
  br i1 %143, label %193, label %144

144:                                              ; preds = %141
  %145 = getelementptr inbounds nuw i8, ptr %142, i64 18
  br label %146

146:                                              ; preds = %149, %144
  %147 = phi ptr [ %145, %144 ], [ %150, %149 ]
  %148 = load i8, ptr %147, align 1, !tbaa !76
  switch i8 %148, label %151 [
    i8 32, label %149
    i8 9, label %149
  ]

149:                                              ; preds = %146, %146
  %150 = getelementptr inbounds nuw i8, ptr %147, i64 1
  br label %146, !llvm.loop !974

151:                                              ; preds = %146
  call void @llvm.lifetime.start.p0(i64 128, ptr nonnull %6) #36
  br label %152

152:                                              ; preds = %160, %151
  %153 = phi i8 [ %148, %151 ], [ %164, %160 ]
  %154 = phi ptr [ %147, %151 ], [ %161, %160 ]
  %155 = phi i64 [ 0, %151 ], [ %162, %160 ]
  switch i8 %153, label %156 [
    i8 0, label %165
    i8 13, label %165
  ]

156:                                              ; preds = %152
  %157 = icmp ne i8 %153, 10
  %158 = icmp samesign ult i64 %155, 127
  %159 = select i1 %157, i1 %158, i1 false
  br i1 %159, label %160, label %165

160:                                              ; preds = %156
  %161 = getelementptr inbounds nuw i8, ptr %154, i64 1
  %162 = add nuw nsw i64 %155, 1
  %163 = getelementptr inbounds nuw [128 x i8], ptr %6, i64 0, i64 %155
  store i8 %153, ptr %163, align 1, !tbaa !76
  %164 = load i8, ptr %161, align 1, !tbaa !76
  br label %152, !llvm.loop !975

165:                                              ; preds = %156, %152, %152
  %166 = getelementptr inbounds nuw [128 x i8], ptr %6, i64 0, i64 %155
  store i8 0, ptr %166, align 1, !tbaa !76
  %167 = icmp eq i64 %155, 0
  br i1 %167, label %192, label %168

168:                                              ; preds = %165
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %7) #36
  %169 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %7, i64 noundef 256, ptr noundef nonnull @.str.67, ptr noundef nonnull %6, ptr noundef nonnull @.str.66) #36
  call void @llvm.lifetime.start.p0(i64 104, ptr nonnull %8) #36
  call void @llvm.lifetime.start.p0(i64 20, ptr nonnull %9) #36
  store i64 0, ptr %92, align 16, !tbaa !907
  store i64 0, ptr %93, align 8, !tbaa !909
  store <4 x i32> <i32 1732584193, i32 -271733879, i32 -1732584194, i32 271733878>, ptr %8, align 16, !tbaa !26
  store i32 -1009589776, ptr %94, align 16, !tbaa !26
  %170 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %7) #33
  %171 = icmp eq i64 %170, 0
  br i1 %171, label %188, label %172

172:                                              ; preds = %168, %184
  %173 = phi i64 [ %185, %184 ], [ 0, %168 ]
  %174 = phi i64 [ %186, %184 ], [ 0, %168 ]
  %175 = getelementptr inbounds nuw i8, ptr %7, i64 %174
  %176 = load i8, ptr %175, align 1, !tbaa !76
  %177 = add i64 %173, 1
  store i64 %177, ptr %92, align 16, !tbaa !907
  %178 = getelementptr inbounds nuw [64 x i8], ptr %95, i64 0, i64 %173
  store i8 %176, ptr %178, align 1, !tbaa !76
  %179 = load i64, ptr %92, align 16, !tbaa !907
  %180 = icmp eq i64 %179, 64
  br i1 %180, label %181, label %184

181:                                              ; preds = %172
  call fastcc void @uh_sha1_transform(ptr noundef nonnull %8, ptr noundef %95)
  %182 = load i64, ptr %93, align 8, !tbaa !909
  %183 = add i64 %182, 512
  store i64 %183, ptr %93, align 8, !tbaa !909
  store i64 0, ptr %92, align 16, !tbaa !907
  br label %184

184:                                              ; preds = %181, %172
  %185 = phi i64 [ %179, %172 ], [ 0, %181 ]
  %186 = add nuw i64 %174, 1
  %187 = icmp eq i64 %186, %170
  br i1 %187, label %188, label %172, !llvm.loop !910

188:                                              ; preds = %184, %168
  call fastcc void @uh_sha1_final(ptr noundef %8, ptr noundef %9)
  %189 = call noalias dereferenceable_or_null(29) ptr @malloc(i64 noundef 29) #34
  %190 = icmp eq ptr %189, null
  br i1 %190, label %191, label %194

191:                                              ; preds = %188
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %9) #36
  call void @llvm.lifetime.end.p0(i64 104, ptr nonnull %8) #36
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %7) #36
  br label %192

192:                                              ; preds = %165, %191
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %6) #36
  br label %193

193:                                              ; preds = %192, %141, %139
  call void @llvm.lifetime.end.p0(i64 4096, ptr nonnull %5) #36
  br label %424

194:                                              ; preds = %188
  %195 = load i8, ptr %96, align 1, !tbaa !76
  %196 = zext i8 %195 to i32
  %197 = shl nuw nsw i32 %196, 8
  %198 = load i8, ptr %97, align 2, !tbaa !76
  %199 = zext i8 %198 to i32
  %200 = or disjoint i32 %197, %199
  %201 = load i8, ptr %9, align 16, !tbaa !76
  %202 = zext i8 %201 to i32
  %203 = shl nuw nsw i32 %202, 16
  %204 = or disjoint i32 %203, %197
  %205 = lshr i32 %202, 2
  %206 = zext nneg i32 %205 to i64
  %207 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %206
  %208 = load i8, ptr %207, align 1, !tbaa !76
  store i8 %208, ptr %189, align 1, !tbaa !76
  %209 = lshr i32 %204, 12
  %210 = and i32 %209, 63
  %211 = zext nneg i32 %210 to i64
  %212 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %211
  %213 = load i8, ptr %212, align 1, !tbaa !76
  %214 = getelementptr i8, ptr %189, i64 1
  store i8 %213, ptr %214, align 1, !tbaa !76
  %215 = lshr i32 %200, 6
  %216 = and i32 %215, 63
  %217 = zext nneg i32 %216 to i64
  %218 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %217
  %219 = load i8, ptr %218, align 1, !tbaa !76
  %220 = getelementptr i8, ptr %189, i64 2
  store i8 %219, ptr %220, align 1, !tbaa !76
  %221 = and i32 %199, 63
  %222 = zext nneg i32 %221 to i64
  %223 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %222
  %224 = load i8, ptr %223, align 1, !tbaa !76
  %225 = getelementptr inbounds nuw i8, ptr %189, i64 3
  store i8 %224, ptr %225, align 1, !tbaa !76
  %226 = load i8, ptr %98, align 4, !tbaa !76
  %227 = zext i8 %226 to i32
  %228 = shl nuw nsw i32 %227, 8
  %229 = load i8, ptr %99, align 1, !tbaa !76
  %230 = zext i8 %229 to i32
  %231 = or disjoint i32 %228, %230
  %232 = load i8, ptr %100, align 1, !tbaa !76
  %233 = zext i8 %232 to i32
  %234 = shl nuw nsw i32 %233, 16
  %235 = or disjoint i32 %234, %228
  %236 = lshr i32 %233, 2
  %237 = zext nneg i32 %236 to i64
  %238 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %237
  %239 = load i8, ptr %238, align 1, !tbaa !76
  %240 = getelementptr inbounds nuw i8, ptr %189, i64 4
  store i8 %239, ptr %240, align 1, !tbaa !76
  %241 = lshr i32 %235, 12
  %242 = and i32 %241, 63
  %243 = zext nneg i32 %242 to i64
  %244 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %243
  %245 = load i8, ptr %244, align 1, !tbaa !76
  %246 = getelementptr i8, ptr %189, i64 5
  store i8 %245, ptr %246, align 1, !tbaa !76
  %247 = lshr i32 %231, 6
  %248 = and i32 %247, 63
  %249 = zext nneg i32 %248 to i64
  %250 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %249
  %251 = load i8, ptr %250, align 1, !tbaa !76
  %252 = getelementptr i8, ptr %189, i64 6
  store i8 %251, ptr %252, align 1, !tbaa !76
  %253 = and i32 %230, 63
  %254 = zext nneg i32 %253 to i64
  %255 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %254
  %256 = load i8, ptr %255, align 1, !tbaa !76
  %257 = getelementptr inbounds nuw i8, ptr %189, i64 7
  store i8 %256, ptr %257, align 1, !tbaa !76
  %258 = load i8, ptr %101, align 1, !tbaa !76
  %259 = zext i8 %258 to i32
  %260 = shl nuw nsw i32 %259, 8
  %261 = load i8, ptr %102, align 8, !tbaa !76
  %262 = zext i8 %261 to i32
  %263 = or disjoint i32 %260, %262
  %264 = load i8, ptr %103, align 2, !tbaa !76
  %265 = zext i8 %264 to i32
  %266 = shl nuw nsw i32 %265, 16
  %267 = or disjoint i32 %266, %260
  %268 = lshr i32 %265, 2
  %269 = zext nneg i32 %268 to i64
  %270 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %269
  %271 = load i8, ptr %270, align 1, !tbaa !76
  %272 = getelementptr inbounds nuw i8, ptr %189, i64 8
  store i8 %271, ptr %272, align 1, !tbaa !76
  %273 = lshr i32 %267, 12
  %274 = and i32 %273, 63
  %275 = zext nneg i32 %274 to i64
  %276 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %275
  %277 = load i8, ptr %276, align 1, !tbaa !76
  %278 = getelementptr i8, ptr %189, i64 9
  store i8 %277, ptr %278, align 1, !tbaa !76
  %279 = lshr i32 %263, 6
  %280 = and i32 %279, 63
  %281 = zext nneg i32 %280 to i64
  %282 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %281
  %283 = load i8, ptr %282, align 1, !tbaa !76
  %284 = getelementptr i8, ptr %189, i64 10
  store i8 %283, ptr %284, align 1, !tbaa !76
  %285 = and i32 %262, 63
  %286 = zext nneg i32 %285 to i64
  %287 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %286
  %288 = load i8, ptr %287, align 1, !tbaa !76
  %289 = getelementptr inbounds nuw i8, ptr %189, i64 11
  store i8 %288, ptr %289, align 1, !tbaa !76
  %290 = load i8, ptr %104, align 2, !tbaa !76
  %291 = zext i8 %290 to i32
  %292 = shl nuw nsw i32 %291, 8
  %293 = load i8, ptr %105, align 1, !tbaa !76
  %294 = zext i8 %293 to i32
  %295 = or disjoint i32 %292, %294
  %296 = load i8, ptr %106, align 1, !tbaa !76
  %297 = zext i8 %296 to i32
  %298 = shl nuw nsw i32 %297, 16
  %299 = or disjoint i32 %298, %292
  %300 = lshr i32 %297, 2
  %301 = zext nneg i32 %300 to i64
  %302 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %301
  %303 = load i8, ptr %302, align 1, !tbaa !76
  %304 = getelementptr inbounds nuw i8, ptr %189, i64 12
  store i8 %303, ptr %304, align 1, !tbaa !76
  %305 = lshr i32 %299, 12
  %306 = and i32 %305, 63
  %307 = zext nneg i32 %306 to i64
  %308 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %307
  %309 = load i8, ptr %308, align 1, !tbaa !76
  %310 = getelementptr i8, ptr %189, i64 13
  store i8 %309, ptr %310, align 1, !tbaa !76
  %311 = lshr i32 %295, 6
  %312 = and i32 %311, 63
  %313 = zext nneg i32 %312 to i64
  %314 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %313
  %315 = load i8, ptr %314, align 1, !tbaa !76
  %316 = getelementptr i8, ptr %189, i64 14
  store i8 %315, ptr %316, align 1, !tbaa !76
  %317 = and i32 %294, 63
  %318 = zext nneg i32 %317 to i64
  %319 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %318
  %320 = load i8, ptr %319, align 1, !tbaa !76
  %321 = getelementptr inbounds nuw i8, ptr %189, i64 15
  store i8 %320, ptr %321, align 1, !tbaa !76
  %322 = load i8, ptr %107, align 1, !tbaa !76
  %323 = zext i8 %322 to i32
  %324 = shl nuw nsw i32 %323, 8
  %325 = load i8, ptr %108, align 2, !tbaa !76
  %326 = zext i8 %325 to i32
  %327 = or disjoint i32 %324, %326
  %328 = load i8, ptr %109, align 4, !tbaa !76
  %329 = zext i8 %328 to i32
  %330 = shl nuw nsw i32 %329, 16
  %331 = or disjoint i32 %330, %324
  %332 = lshr i32 %329, 2
  %333 = zext nneg i32 %332 to i64
  %334 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %333
  %335 = load i8, ptr %334, align 1, !tbaa !76
  %336 = getelementptr inbounds nuw i8, ptr %189, i64 16
  store i8 %335, ptr %336, align 1, !tbaa !76
  %337 = lshr i32 %331, 12
  %338 = and i32 %337, 63
  %339 = zext nneg i32 %338 to i64
  %340 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %339
  %341 = load i8, ptr %340, align 1, !tbaa !76
  %342 = getelementptr i8, ptr %189, i64 17
  store i8 %341, ptr %342, align 1, !tbaa !76
  %343 = lshr i32 %327, 6
  %344 = and i32 %343, 63
  %345 = zext nneg i32 %344 to i64
  %346 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %345
  %347 = load i8, ptr %346, align 1, !tbaa !76
  %348 = getelementptr i8, ptr %189, i64 18
  store i8 %347, ptr %348, align 1, !tbaa !76
  %349 = and i32 %326, 63
  %350 = zext nneg i32 %349 to i64
  %351 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %350
  %352 = load i8, ptr %351, align 1, !tbaa !76
  %353 = getelementptr inbounds nuw i8, ptr %189, i64 19
  store i8 %352, ptr %353, align 1, !tbaa !76
  %354 = load i8, ptr %110, align 16, !tbaa !76
  %355 = zext i8 %354 to i32
  %356 = shl nuw nsw i32 %355, 8
  %357 = load i8, ptr %111, align 1, !tbaa !76
  %358 = zext i8 %357 to i32
  %359 = or disjoint i32 %356, %358
  %360 = load i8, ptr %112, align 1, !tbaa !76
  %361 = zext i8 %360 to i32
  %362 = shl nuw nsw i32 %361, 16
  %363 = or disjoint i32 %362, %356
  %364 = lshr i32 %361, 2
  %365 = zext nneg i32 %364 to i64
  %366 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %365
  %367 = load i8, ptr %366, align 1, !tbaa !76
  %368 = getelementptr inbounds nuw i8, ptr %189, i64 20
  store i8 %367, ptr %368, align 1, !tbaa !76
  %369 = lshr i32 %363, 12
  %370 = and i32 %369, 63
  %371 = zext nneg i32 %370 to i64
  %372 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %371
  %373 = load i8, ptr %372, align 1, !tbaa !76
  %374 = getelementptr i8, ptr %189, i64 21
  store i8 %373, ptr %374, align 1, !tbaa !76
  %375 = lshr i32 %359, 6
  %376 = and i32 %375, 63
  %377 = zext nneg i32 %376 to i64
  %378 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %377
  %379 = load i8, ptr %378, align 1, !tbaa !76
  %380 = getelementptr i8, ptr %189, i64 22
  store i8 %379, ptr %380, align 1, !tbaa !76
  %381 = and i32 %358, 63
  %382 = zext nneg i32 %381 to i64
  %383 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %382
  %384 = load i8, ptr %383, align 1, !tbaa !76
  %385 = getelementptr inbounds nuw i8, ptr %189, i64 23
  store i8 %384, ptr %385, align 1, !tbaa !76
  %386 = load i8, ptr %113, align 2, !tbaa !76
  %387 = zext i8 %386 to i32
  %388 = shl nuw nsw i32 %387, 16
  %389 = load i8, ptr %114, align 1, !tbaa !76
  %390 = zext i8 %389 to i32
  %391 = shl nuw nsw i32 %390, 8
  %392 = or disjoint i32 %391, %388
  %393 = lshr i32 %387, 2
  %394 = zext nneg i32 %393 to i64
  %395 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %394
  %396 = load i8, ptr %395, align 1, !tbaa !76
  %397 = getelementptr inbounds nuw i8, ptr %189, i64 24
  store i8 %396, ptr %397, align 1, !tbaa !76
  %398 = lshr i32 %392, 12
  %399 = and i32 %398, 63
  %400 = zext nneg i32 %399 to i64
  %401 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %400
  %402 = load i8, ptr %401, align 1, !tbaa !76
  %403 = getelementptr i8, ptr %189, i64 25
  store i8 %402, ptr %403, align 1, !tbaa !76
  %404 = shl nuw nsw i32 %390, 2
  %405 = and i32 %404, 60
  %406 = zext nneg i32 %405 to i64
  %407 = getelementptr inbounds nuw [65 x i8], ptr @uh_base64_encode.tbl, i64 0, i64 %406
  %408 = load i8, ptr %407, align 4, !tbaa !76
  %409 = getelementptr i8, ptr %189, i64 26
  store i8 %408, ptr %409, align 1, !tbaa !76
  %410 = getelementptr inbounds nuw i8, ptr %189, i64 27
  store i8 61, ptr %410, align 1, !tbaa !76
  %411 = getelementptr inbounds nuw i8, ptr %189, i64 28
  store i8 0, ptr %411, align 1, !tbaa !76
  call void @llvm.lifetime.start.p0(i64 512, ptr nonnull %10) #36
  %412 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %10, i64 noundef 512, ptr noundef nonnull @.str.69, ptr noundef nonnull %189) #36
  call void @free(ptr noundef nonnull %189) #36
  %413 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %10) #33
  %414 = call i64 @send(i32 noundef range(i32 0, -2147483648) %123, ptr noundef nonnull %10, i64 noundef %413, i32 noundef 0) #36
  call void @llvm.lifetime.end.p0(i64 512, ptr nonnull %10) #36
  call void @llvm.lifetime.end.p0(i64 20, ptr nonnull %9) #36
  call void @llvm.lifetime.end.p0(i64 104, ptr nonnull %8) #36
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %7) #36
  call void @llvm.lifetime.end.p0(i64 128, ptr nonnull %6) #36
  call void @llvm.lifetime.end.p0(i64 4096, ptr nonnull %5) #36
  %415 = load ptr, ptr @g_env, align 8, !tbaa !522
  %416 = icmp eq ptr %415, null
  br i1 %416, label %424, label %417

417:                                              ; preds = %194
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %13) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !976)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %3)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4)
  store i32 3, ptr %13, align 8, !tbaa !31, !alias.scope !979
  %418 = call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %115, i8 0, i64 24, i1 false), !alias.scope !979
  store ptr %418, ptr %116, align 8, !tbaa !48, !alias.scope !979
  call void @llvm.experimental.noalias.scope.decl(metadata !982)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !982, !noalias !976
  store double 0.000000e+00, ptr %117, align 8, !tbaa !35, !alias.scope !982, !noalias !976
  %419 = call noalias dereferenceable_or_null(8) ptr @malloc(i64 noundef 8) #34
  %420 = icmp eq ptr %419, null
  br i1 %420, label %422, label %421

421:                                              ; preds = %417
  store i64 28260057816194911, ptr %419, align 1, !noalias !985
  br label %422

422:                                              ; preds = %417, %421
  store ptr %419, ptr %118, align 8, !tbaa !46, !alias.scope !982, !noalias !976
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %119, i8 0, i64 16, i1 false), !alias.scope !982, !noalias !976
  %423 = uitofp nneg i32 %123 to double
  store i32 0, ptr %4, align 8, !tbaa !31, !alias.scope !986, !noalias !976
  store double %423, ptr %120, align 8, !tbaa !35, !alias.scope !986, !noalias !976
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %121, i8 0, i64 24, i1 false), !alias.scope !986, !noalias !976
  call void @uh_dict_set(ptr noundef nonnull align 8 %13, ptr noundef nonnull byval(%struct.UhValue) align 8 %3, ptr noundef nonnull byval(%struct.UhValue) align 8 %4)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %3)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4)
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %14) #36
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(40) %14, ptr noundef nonnull align 8 dereferenceable(40) %13, i64 40, i1 false), !tbaa.struct !25
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %15) #36
  call void @uh_call_named(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %15, ptr noundef nonnull %415, ptr noundef nonnull %66, i32 noundef 1, ptr noundef nonnull %14) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %15) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %14) #36
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %13) #36
  br label %424

424:                                              ; preds = %194, %422, %193
  %425 = call i32 @close(i32 noundef %123) #36
  br label %426

426:                                              ; preds = %424, %122
  br label %122

427:                                              ; preds = %88, %79
  %428 = call i32 @close(i32 noundef %75) #36
  store i32 0, ptr %0, align 8, !tbaa !31
  %429 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %429, i8 0, i64 32, i1 false)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %12) #36
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %11) #36
  br label %430

430:                                              ; preds = %77, %427, %72
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_smtp_connect(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) initializes((0, 4), (8, 40)) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca %struct.UhValue, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca %struct.UhValue, align 8
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !989
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %7 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 32
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %6, i8 0, i64 24, i1 false), !alias.scope !989
  store ptr %7, ptr %8, align 8, !tbaa !48, !alias.scope !989
  tail call void @llvm.experimental.noalias.scope.decl(metadata !992)
  store i32 1, ptr %3, align 8, !tbaa !31, !alias.scope !992
  %9 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store double 0.000000e+00, ptr %9, align 8, !tbaa !35, !alias.scope !992
  %10 = tail call noalias dereferenceable_or_null(7) ptr @malloc(i64 noundef 7) #34
  %11 = icmp eq ptr %10, null
  br i1 %11, label %13, label %12

12:                                               ; preds = %2
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %10, ptr noundef nonnull readonly align 1 dereferenceable(7) @.str.52, i64 7, i1 false), !noalias !992
  br label %13

13:                                               ; preds = %2, %12
  %14 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store ptr %10, ptr %14, align 8, !tbaa !46, !alias.scope !992
  %15 = getelementptr inbounds nuw i8, ptr %3, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %15, i8 0, i64 16, i1 false), !alias.scope !992
  store i32 0, ptr %4, align 8, !tbaa !31, !alias.scope !995
  %16 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store double 1.000000e+00, ptr %16, align 8, !tbaa !35, !alias.scope !995
  %17 = getelementptr inbounds nuw i8, ptr %4, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %17, i8 0, i64 24, i1 false), !alias.scope !995
  tail call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %3, ptr noundef nonnull byval(%struct.UhValue) align 8 %4)
  %18 = load i32, ptr %1, align 8, !tbaa !31
  %19 = icmp eq i32 %18, 3
  %20 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %21 = load ptr, ptr %20, align 8
  %22 = icmp ne ptr %21, null
  %23 = select i1 %19, i1 %22, i1 false
  br i1 %23, label %24, label %50

24:                                               ; preds = %13
  %25 = getelementptr inbounds nuw i8, ptr %21, i64 8
  %26 = load i64, ptr %25, align 8, !tbaa !65
  %27 = icmp eq i64 %26, 0
  br i1 %27, label %50, label %28

28:                                               ; preds = %24
  %29 = getelementptr inbounds nuw i8, ptr %5, i64 8
  %30 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %31 = getelementptr inbounds nuw i8, ptr %5, i64 24
  br label %32

32:                                               ; preds = %28, %44
  %33 = phi i64 [ 0, %28 ], [ %47, %44 ]
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %5) #36
  %34 = load ptr, ptr %21, align 8, !tbaa !68
  %35 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %34, i64 %33
  %36 = load ptr, ptr %35, align 8, !tbaa !70
  tail call void @llvm.experimental.noalias.scope.decl(metadata !998)
  store i32 1, ptr %5, align 8, !tbaa !31, !alias.scope !998
  store double 0.000000e+00, ptr %29, align 8, !tbaa !35, !alias.scope !998
  %37 = icmp eq ptr %36, null
  br i1 %37, label %44, label %38

38:                                               ; preds = %32
  %39 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %36) #33, !noalias !998
  %40 = add i64 %39, 1
  %41 = tail call noalias ptr @malloc(i64 noundef %40) #34
  %42 = icmp eq ptr %41, null
  br i1 %42, label %44, label %43

43:                                               ; preds = %38
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %41, ptr nonnull readonly align 1 %36, i64 %40, i1 false), !noalias !998
  br label %44

44:                                               ; preds = %32, %38, %43
  %45 = phi ptr [ null, %32 ], [ %41, %43 ], [ null, %38 ]
  store ptr %45, ptr %30, align 8, !tbaa !46, !alias.scope !998
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %31, i8 0, i64 16, i1 false), !alias.scope !998
  %46 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %34, i64 %33, i32 1
  tail call void @uh_dict_set(ptr noundef nonnull %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %5, ptr noundef nonnull byval(%struct.UhValue) align 8 %46)
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %5) #36
  %47 = add nuw i64 %33, 1
  %48 = load i64, ptr %25, align 8, !tbaa !65
  %49 = icmp ult i64 %47, %48
  br i1 %49, label %32, label %50, !llvm.loop !1001

50:                                               ; preds = %44, %24, %13
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(argmem: write) uwtable
define dso_local void @uh_smtp_disconnect(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) initializes((0, 4), (8, 40)) %0, ptr noundef readnone byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #0 {
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !1002
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %3, i8 0, i64 32, i1 false), !alias.scope !1002
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_send(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca [256 x i8], align 16
  %5 = alloca %struct.UhUpload, align 8
  %6 = alloca [10 x i8], align 1
  %7 = alloca ptr, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca %struct.UhValue, align 8
  %11 = load i32, ptr %2, align 8, !tbaa !31
  %12 = icmp eq i32 %11, 3
  br i1 %12, label %13, label %1144

13:                                               ; preds = %3
  %14 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %15 = load ptr, ptr %14, align 8
  %16 = icmp eq ptr %15, null
  br i1 %16, label %1144, label %17

17:                                               ; preds = %13
  %18 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %19 = load i64, ptr %18, align 8, !tbaa !65, !noalias !1005
  %20 = icmp eq i64 %19, 0
  br i1 %20, label %1144, label %21

21:                                               ; preds = %17
  %22 = load ptr, ptr %15, align 8, !tbaa !68, !noalias !1005
  br label %26

23:                                               ; preds = %26
  %24 = add nuw i64 %27, 1
  %25 = icmp eq i64 %24, %19
  br i1 %25, label %103, label %26, !llvm.loop !69

26:                                               ; preds = %23, %21
  %27 = phi i64 [ 0, %21 ], [ %24, %23 ]
  %28 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %22, i64 %27
  %29 = load ptr, ptr %28, align 8, !tbaa !70, !noalias !1005
  %30 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %29, ptr noundef nonnull readonly dereferenceable(8) @.str.53) #33, !noalias !1005
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %32, label %23

32:                                               ; preds = %26
  %33 = getelementptr inbounds nuw i8, ptr %28, i64 8
  %34 = load i32, ptr %33, align 8, !tbaa !26
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %103

36:                                               ; preds = %32
  %37 = getelementptr inbounds nuw i8, ptr %28, i64 16
  %38 = load double, ptr %37, align 8, !tbaa !27
  %39 = fptosi double %38 to i32
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %10) #36
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %10, ptr noundef nonnull align 8 dereferenceable(40) %1, i64 40, i1 false), !tbaa.struct !25
  %40 = load i32, ptr %1, align 8, !tbaa !31
  %41 = and i32 %40, -2
  %42 = icmp eq i32 %41, 2
  br i1 %42, label %43, label %55

43:                                               ; preds = %36
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %7) #36, !noalias !1008
  store ptr null, ptr %7, align 8, !tbaa !28, !noalias !1008
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %8) #36, !noalias !1008
  store i64 0, ptr %8, align 8, !tbaa !368, !noalias !1008
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %9) #36, !noalias !1008
  store i64 0, ptr %9, align 8, !tbaa !368, !noalias !1008
  call fastcc void @uh_json_stringify_value(ptr noundef %7, ptr noundef %8, ptr noundef %9, ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %44 = load ptr, ptr %7, align 8, !tbaa !28, !noalias !1008
  %45 = icmp eq ptr %44, null
  br i1 %45, label %46, label %50

46:                                               ; preds = %43
  %47 = call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %48 = icmp eq ptr %47, null
  br i1 %48, label %50, label %49

49:                                               ; preds = %46
  store i8 0, ptr %47, align 1, !noalias !1011
  br label %50

50:                                               ; preds = %43, %46, %49
  %51 = phi ptr [ %47, %49 ], [ null, %46 ], [ %44, %43 ]
  %52 = getelementptr inbounds nuw i8, ptr %10, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %52, i8 0, i64 16, i1 false)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %9) #36, !noalias !1008
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %8) #36, !noalias !1008
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %7) #36, !noalias !1008
  store i32 1, ptr %10, align 8, !tbaa !26
  %53 = getelementptr inbounds nuw i8, ptr %10, i64 8
  store double 0.000000e+00, ptr %53, align 8, !tbaa !27
  %54 = getelementptr inbounds nuw i8, ptr %10, i64 16
  store ptr %51, ptr %54, align 8, !tbaa !28
  br label %55

55:                                               ; preds = %36, %50
  %56 = call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %10)
  %57 = icmp eq ptr %56, null
  br i1 %57, label %101, label %58

58:                                               ; preds = %55
  %59 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %56) #33
  call void @llvm.lifetime.start.p0(i64 10, ptr nonnull %6) #36
  store i8 -127, ptr %6, align 1, !tbaa !76
  %60 = icmp ult i64 %59, 126
  %61 = getelementptr inbounds nuw i8, ptr %6, i64 9
  %62 = getelementptr inbounds nuw i8, ptr %6, i64 3
  %63 = getelementptr inbounds nuw i8, ptr %6, i64 1
  br i1 %60, label %90, label %64

64:                                               ; preds = %58
  %65 = icmp ult i64 %59, 65536
  %66 = getelementptr inbounds nuw i8, ptr %6, i64 2
  br i1 %65, label %67, label %70

67:                                               ; preds = %64
  store i8 126, ptr %63, align 1, !tbaa !76
  %68 = lshr i64 %59, 8
  %69 = trunc nuw i64 %68 to i8
  store i8 %69, ptr %66, align 1, !tbaa !76
  br label %90

70:                                               ; preds = %64
  store i8 127, ptr %63, align 1, !tbaa !76
  %71 = lshr i64 %59, 56
  %72 = trunc nuw i64 %71 to i8
  store i8 %72, ptr %66, align 1, !tbaa !76
  %73 = lshr i64 %59, 48
  %74 = trunc i64 %73 to i8
  store i8 %74, ptr %62, align 1, !tbaa !76
  %75 = lshr i64 %59, 40
  %76 = trunc i64 %75 to i8
  %77 = getelementptr inbounds nuw i8, ptr %6, i64 4
  store i8 %76, ptr %77, align 1, !tbaa !76
  %78 = lshr i64 %59, 32
  %79 = trunc i64 %78 to i8
  %80 = getelementptr inbounds nuw i8, ptr %6, i64 5
  store i8 %79, ptr %80, align 1, !tbaa !76
  %81 = lshr i64 %59, 24
  %82 = trunc i64 %81 to i8
  %83 = getelementptr inbounds nuw i8, ptr %6, i64 6
  store i8 %82, ptr %83, align 1, !tbaa !76
  %84 = lshr i64 %59, 16
  %85 = trunc i64 %84 to i8
  %86 = getelementptr inbounds nuw i8, ptr %6, i64 7
  store i8 %85, ptr %86, align 1, !tbaa !76
  %87 = lshr i64 %59, 8
  %88 = trunc i64 %87 to i8
  %89 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store i8 %88, ptr %89, align 1, !tbaa !76
  br label %90

90:                                               ; preds = %70, %67, %58
  %91 = phi ptr [ %61, %70 ], [ %62, %67 ], [ %63, %58 ]
  %92 = phi i64 [ 10, %70 ], [ 4, %67 ], [ 2, %58 ]
  %93 = trunc i64 %59 to i8
  store i8 %93, ptr %91, align 1, !tbaa !76
  %94 = call i64 @send(i32 noundef %39, ptr noundef nonnull %6, i64 noundef %92, i32 noundef 0) #36
  %95 = icmp ne i64 %94, %92
  %96 = icmp eq i64 %59, 0
  %97 = or i1 %96, %95
  br i1 %97, label %100, label %98

98:                                               ; preds = %90
  %99 = call i64 @send(i32 noundef %39, ptr noundef nonnull %56, i64 noundef %59, i32 noundef 0) #36
  br label %100

100:                                              ; preds = %98, %90
  call void @llvm.lifetime.end.p0(i64 10, ptr nonnull %6) #36
  br label %101

101:                                              ; preds = %55, %100
  call void @free(ptr noundef %56) #36
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !1014
  %102 = getelementptr inbounds nuw i8, ptr %0, i64 8
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %102, i8 0, i64 32, i1 false), !alias.scope !1014
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %10) #36
  br label %1146

103:                                              ; preds = %23, %32
  %104 = load ptr, ptr %15, align 8, !tbaa !68, !noalias !1017
  br label %108

105:                                              ; preds = %108
  %106 = add nuw i64 %109, 1
  %107 = icmp eq i64 %106, %19
  br i1 %107, label %1144, label %108, !llvm.loop !69

108:                                              ; preds = %105, %103
  %109 = phi i64 [ 0, %103 ], [ %106, %105 ]
  %110 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %104, i64 %109
  %111 = load ptr, ptr %110, align 8, !tbaa !70, !noalias !1017
  %112 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %111, ptr noundef nonnull readonly dereferenceable(7) @.str.52) #33, !noalias !1017
  %113 = icmp eq i32 %112, 0
  br i1 %113, label %114, label %105

114:                                              ; preds = %108
  %115 = getelementptr inbounds nuw i8, ptr %110, i64 8
  %116 = load i32, ptr %115, align 8, !tbaa !26
  %117 = getelementptr inbounds nuw i8, ptr %110, i64 16
  %118 = load double, ptr %117, align 8, !tbaa !27
  %119 = icmp eq i32 %116, 0
  %120 = fcmp une double %118, 0.000000e+00
  %121 = select i1 %119, i1 %120, i1 false
  br i1 %121, label %122, label %1144

122:                                              ; preds = %114
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1020)
  %123 = load i32, ptr %1, align 8
  %124 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %125 = load ptr, ptr %124, align 8
  br label %129

126:                                              ; preds = %129
  %127 = add nuw i64 %130, 1
  %128 = icmp eq i64 %127, %19
  br i1 %128, label %142, label %129, !llvm.loop !69

129:                                              ; preds = %126, %122
  %130 = phi i64 [ 0, %122 ], [ %127, %126 ]
  %131 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %104, i64 %130
  %132 = load ptr, ptr %131, align 8, !tbaa !70, !noalias !1023
  %133 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %132, ptr noundef nonnull readonly dereferenceable(5) @.str.48) #33, !noalias !1023
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %135, label %126

135:                                              ; preds = %129
  %136 = getelementptr inbounds nuw i8, ptr %131, i64 8
  %137 = load i32, ptr %136, align 8, !tbaa !26, !noalias !1020
  %138 = getelementptr inbounds nuw i8, ptr %131, i64 24
  %139 = load ptr, ptr %138, align 8, !tbaa !28, !noalias !1020
  %140 = icmp eq i32 %137, 1
  %141 = select i1 %140, ptr %139, ptr null
  br label %142

142:                                              ; preds = %126, %135
  %143 = phi ptr [ %141, %135 ], [ null, %126 ]
  br label %147

144:                                              ; preds = %147
  %145 = add nuw i64 %148, 1
  %146 = icmp eq i64 %145, %19
  br i1 %146, label %160, label %147, !llvm.loop !69

147:                                              ; preds = %144, %142
  %148 = phi i64 [ 0, %142 ], [ %145, %144 ]
  %149 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %104, i64 %148
  %150 = load ptr, ptr %149, align 8, !tbaa !70, !noalias !1026
  %151 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %150, ptr noundef nonnull readonly dereferenceable(9) @.str.70) #33, !noalias !1026
  %152 = icmp eq i32 %151, 0
  br i1 %152, label %153, label %144

153:                                              ; preds = %147
  %154 = getelementptr inbounds nuw i8, ptr %149, i64 8
  %155 = load i32, ptr %154, align 8, !tbaa !26, !noalias !1020
  %156 = getelementptr inbounds nuw i8, ptr %149, i64 24
  %157 = load ptr, ptr %156, align 8, !tbaa !28, !noalias !1020
  %158 = icmp eq i32 %155, 1
  %159 = select i1 %158, ptr %157, ptr null
  br label %160

160:                                              ; preds = %144, %153
  %161 = phi ptr [ %159, %153 ], [ null, %144 ]
  br label %165

162:                                              ; preds = %165
  %163 = add nuw i64 %166, 1
  %164 = icmp eq i64 %163, %19
  br i1 %164, label %178, label %165, !llvm.loop !69

165:                                              ; preds = %162, %160
  %166 = phi i64 [ 0, %160 ], [ %163, %162 ]
  %167 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %104, i64 %166
  %168 = load ptr, ptr %167, align 8, !tbaa !70, !noalias !1029
  %169 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %168, ptr noundef nonnull readonly dereferenceable(9) @.str.71) #33, !noalias !1029
  %170 = icmp eq i32 %169, 0
  br i1 %170, label %171, label %162

171:                                              ; preds = %165
  %172 = getelementptr inbounds nuw i8, ptr %167, i64 8
  %173 = load i32, ptr %172, align 8, !tbaa !26, !noalias !1020
  %174 = getelementptr inbounds nuw i8, ptr %167, i64 24
  %175 = load ptr, ptr %174, align 8, !tbaa !28, !noalias !1020
  %176 = icmp eq i32 %173, 1
  %177 = select i1 %176, ptr %175, ptr null
  br label %178

178:                                              ; preds = %162, %171
  %179 = phi ptr [ %177, %171 ], [ null, %162 ]
  br label %183

180:                                              ; preds = %183
  %181 = add nuw i64 %184, 1
  %182 = icmp eq i64 %181, %19
  br i1 %182, label %198, label %183, !llvm.loop !69

183:                                              ; preds = %180, %178
  %184 = phi i64 [ 0, %178 ], [ %181, %180 ]
  %185 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %104, i64 %184
  %186 = load ptr, ptr %185, align 8, !tbaa !70, !noalias !1032
  %187 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %186, ptr noundef nonnull readonly dereferenceable(5) @.str.49) #33, !noalias !1032
  %188 = icmp eq i32 %187, 0
  br i1 %188, label %189, label %180

189:                                              ; preds = %183
  %190 = getelementptr inbounds nuw i8, ptr %185, i64 8
  %191 = load i32, ptr %190, align 8, !tbaa !26, !noalias !1020
  %192 = getelementptr inbounds nuw i8, ptr %185, i64 16
  %193 = load double, ptr %192, align 8, !tbaa !27, !noalias !1020
  %194 = freeze i32 %191
  %195 = icmp eq i32 %194, 0
  %196 = fptosi double %193 to i32
  %197 = select i1 %195, i32 %196, i32 25
  br label %198

198:                                              ; preds = %180, %189
  %199 = phi i32 [ %197, %189 ], [ 25, %180 ]
  br label %203

200:                                              ; preds = %203
  %201 = add nuw i64 %204, 1
  %202 = icmp eq i64 %201, %19
  br i1 %202, label %218, label %203, !llvm.loop !69

203:                                              ; preds = %200, %198
  %204 = phi i64 [ 0, %198 ], [ %201, %200 ]
  %205 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %104, i64 %204
  %206 = load ptr, ptr %205, align 8, !tbaa !70, !noalias !1035
  %207 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %206, ptr noundef nonnull readonly dereferenceable(4) @.str.72) #33, !noalias !1035
  %208 = icmp eq i32 %207, 0
  br i1 %208, label %209, label %200

209:                                              ; preds = %203
  %210 = getelementptr inbounds nuw i8, ptr %205, i64 8
  %211 = load i32, ptr %210, align 8, !tbaa !26, !noalias !1020
  %212 = getelementptr inbounds nuw i8, ptr %205, i64 16
  %213 = load double, ptr %212, align 8, !tbaa !27, !noalias !1020
  %214 = icmp eq i32 %211, 0
  %215 = fcmp une double %213, 0.000000e+00
  %216 = select i1 %214, i1 %215, i1 false
  %217 = select i1 %216, ptr @.str.80, ptr @.str.10
  br label %218

218:                                              ; preds = %200, %209
  %219 = phi ptr [ %217, %209 ], [ @.str.10, %200 ]
  br label %223

220:                                              ; preds = %223
  %221 = add nuw i64 %224, 1
  %222 = icmp eq i64 %221, %19
  br i1 %222, label %237, label %223, !llvm.loop !69

223:                                              ; preds = %220, %218
  %224 = phi i64 [ 0, %218 ], [ %221, %220 ]
  %225 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %104, i64 %224
  %226 = load ptr, ptr %225, align 8, !tbaa !70, !noalias !1038
  %227 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %226, ptr noundef nonnull readonly dereferenceable(9) @.str.73) #33, !noalias !1038
  %228 = icmp eq i32 %227, 0
  br i1 %228, label %229, label %220

229:                                              ; preds = %223
  %230 = getelementptr inbounds nuw i8, ptr %225, i64 8
  %231 = load i32, ptr %230, align 8, !tbaa !26, !noalias !1020
  %232 = getelementptr inbounds nuw i8, ptr %225, i64 16
  %233 = load double, ptr %232, align 8, !tbaa !27, !noalias !1020
  %234 = icmp eq i32 %231, 0
  %235 = fcmp une double %233, 0.000000e+00
  %236 = select i1 %234, i1 %235, i1 false
  br label %237

237:                                              ; preds = %220, %229
  %238 = phi i1 [ %236, %229 ], [ false, %220 ]
  br label %242

239:                                              ; preds = %242
  %240 = add nuw i64 %243, 1
  %241 = icmp eq i64 %240, %19
  br i1 %241, label %256, label %242, !llvm.loop !69

242:                                              ; preds = %239, %237
  %243 = phi i64 [ 0, %237 ], [ %240, %239 ]
  %244 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %104, i64 %243
  %245 = load ptr, ptr %244, align 8, !tbaa !70, !noalias !1041
  %246 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %245, ptr noundef nonnull readonly dereferenceable(9) @.str.74) #33, !noalias !1041
  %247 = icmp eq i32 %246, 0
  br i1 %247, label %248, label %239

248:                                              ; preds = %242
  %249 = getelementptr inbounds nuw i8, ptr %244, i64 8
  %250 = load i32, ptr %249, align 8, !tbaa !26, !noalias !1020
  %251 = getelementptr inbounds nuw i8, ptr %244, i64 16
  %252 = load double, ptr %251, align 8, !tbaa !27, !noalias !1020
  %253 = icmp eq i32 %250, 0
  %254 = fcmp une double %252, 0.000000e+00
  %255 = select i1 %253, i1 %254, i1 false
  br label %256

256:                                              ; preds = %239, %248
  %257 = phi i1 [ %255, %248 ], [ false, %239 ]
  %258 = icmp ne i32 %123, 3
  %259 = icmp eq ptr %125, null
  %260 = select i1 %258, i1 true, i1 %259
  br i1 %260, label %398, label %261

261:                                              ; preds = %256
  %262 = getelementptr inbounds nuw i8, ptr %125, i64 8
  %263 = load i64, ptr %262, align 8, !tbaa !65, !noalias !1044
  %264 = icmp eq i64 %263, 0
  br i1 %264, label %398, label %265

265:                                              ; preds = %261
  %266 = load ptr, ptr %125, align 8, !tbaa !68, !noalias !1044
  br label %270

267:                                              ; preds = %270
  %268 = add nuw i64 %271, 1
  %269 = icmp eq i64 %268, %263
  br i1 %269, label %283, label %270, !llvm.loop !69

270:                                              ; preds = %267, %265
  %271 = phi i64 [ 0, %265 ], [ %268, %267 ]
  %272 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %266, i64 %271
  %273 = load ptr, ptr %272, align 8, !tbaa !70, !noalias !1044
  %274 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %273, ptr noundef nonnull readonly dereferenceable(5) @.str.75) #33, !noalias !1044
  %275 = icmp eq i32 %274, 0
  br i1 %275, label %276, label %267

276:                                              ; preds = %270
  %277 = getelementptr inbounds nuw i8, ptr %272, i64 8
  %278 = load i32, ptr %277, align 8, !tbaa !26, !noalias !1020
  %279 = getelementptr inbounds nuw i8, ptr %272, i64 24
  %280 = load ptr, ptr %279, align 8, !tbaa !28, !noalias !1020
  %281 = icmp eq i32 %278, 1
  %282 = select i1 %281, ptr %280, ptr null
  br label %283

283:                                              ; preds = %267, %276
  %284 = phi ptr [ %282, %276 ], [ null, %267 ]
  br label %288

285:                                              ; preds = %288
  %286 = add nuw i64 %289, 1
  %287 = icmp eq i64 %286, %263
  br i1 %287, label %301, label %288, !llvm.loop !69

288:                                              ; preds = %285, %283
  %289 = phi i64 [ 0, %283 ], [ %286, %285 ]
  %290 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %266, i64 %289
  %291 = load ptr, ptr %290, align 8, !tbaa !70, !noalias !1047
  %292 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %291, ptr noundef nonnull readonly dereferenceable(8) @.str.76) #33, !noalias !1047
  %293 = icmp eq i32 %292, 0
  br i1 %293, label %294, label %285

294:                                              ; preds = %288
  %295 = getelementptr inbounds nuw i8, ptr %290, i64 8
  %296 = load i32, ptr %295, align 8, !tbaa !26, !noalias !1020
  %297 = getelementptr inbounds nuw i8, ptr %290, i64 24
  %298 = load ptr, ptr %297, align 8, !tbaa !28, !noalias !1020
  %299 = icmp eq i32 %296, 1
  %300 = select i1 %299, ptr %298, ptr null
  br label %301

301:                                              ; preds = %285, %294
  %302 = phi ptr [ %300, %294 ], [ null, %285 ]
  br label %306

303:                                              ; preds = %306
  %304 = add nuw i64 %307, 1
  %305 = icmp eq i64 %304, %263
  br i1 %305, label %319, label %306, !llvm.loop !69

306:                                              ; preds = %303, %301
  %307 = phi i64 [ 0, %301 ], [ %304, %303 ]
  %308 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %266, i64 %307
  %309 = load ptr, ptr %308, align 8, !tbaa !70, !noalias !1050
  %310 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %309, ptr noundef nonnull readonly dereferenceable(5) @.str.30) #33, !noalias !1050
  %311 = icmp eq i32 %310, 0
  br i1 %311, label %312, label %303

312:                                              ; preds = %306
  %313 = getelementptr inbounds nuw i8, ptr %308, i64 8
  %314 = load i32, ptr %313, align 8, !tbaa !26, !noalias !1020
  %315 = getelementptr inbounds nuw i8, ptr %308, i64 24
  %316 = load ptr, ptr %315, align 8, !tbaa !28, !noalias !1020
  %317 = icmp eq i32 %314, 1
  %318 = select i1 %317, ptr %316, ptr null
  br label %319

319:                                              ; preds = %303, %312
  %320 = phi ptr [ %318, %312 ], [ null, %303 ]
  br label %324

321:                                              ; preds = %324
  %322 = add nuw i64 %325, 1
  %323 = icmp eq i64 %322, %263
  br i1 %323, label %337, label %324, !llvm.loop !69

324:                                              ; preds = %321, %319
  %325 = phi i64 [ 0, %319 ], [ %322, %321 ]
  %326 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %266, i64 %325
  %327 = load ptr, ptr %326, align 8, !tbaa !70, !noalias !1053
  %328 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %327, ptr noundef nonnull readonly dereferenceable(5) @.str.77) #33, !noalias !1053
  %329 = icmp eq i32 %328, 0
  br i1 %329, label %330, label %321

330:                                              ; preds = %324
  %331 = getelementptr inbounds nuw i8, ptr %326, i64 8
  %332 = load i32, ptr %331, align 8, !tbaa !26, !noalias !1020
  %333 = getelementptr inbounds nuw i8, ptr %326, i64 24
  %334 = load ptr, ptr %333, align 8, !tbaa !28, !noalias !1020
  %335 = icmp eq i32 %332, 1
  %336 = select i1 %335, ptr %334, ptr null
  br label %337

337:                                              ; preds = %321, %330
  %338 = phi ptr [ %336, %330 ], [ null, %321 ]
  br label %342

339:                                              ; preds = %352, %348, %342
  %340 = add nuw i64 %343, 1
  %341 = icmp eq i64 %340, %263
  br i1 %341, label %362, label %342, !llvm.loop !69

342:                                              ; preds = %339, %337
  %343 = phi i64 [ 0, %337 ], [ %340, %339 ]
  %344 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %266, i64 %343
  %345 = load ptr, ptr %344, align 8, !tbaa !70, !noalias !1056
  %346 = load i8, ptr %345, align 1, !noalias !1020
  %347 = icmp eq i8 %346, 116
  br i1 %347, label %348, label %339

348:                                              ; preds = %342
  %349 = getelementptr inbounds nuw i8, ptr %345, i64 1
  %350 = load i8, ptr %349, align 1, !noalias !1020
  %351 = icmp eq i8 %350, 111
  br i1 %351, label %352, label %339

352:                                              ; preds = %348
  %353 = getelementptr inbounds nuw i8, ptr %345, i64 2
  %354 = load i8, ptr %353, align 1, !noalias !1020
  %355 = icmp eq i8 %354, 0
  br i1 %355, label %356, label %339

356:                                              ; preds = %352
  %357 = getelementptr inbounds nuw i8, ptr %344, i64 8
  %358 = load i32, ptr %357, align 8, !tbaa !26, !noalias !1020
  %359 = getelementptr inbounds nuw i8, ptr %344, i64 32
  %360 = load ptr, ptr %359, align 8, !tbaa !29, !noalias !1020
  %361 = icmp eq i32 %358, 2
  br label %362

362:                                              ; preds = %339, %356
  %363 = phi i1 [ %361, %356 ], [ false, %339 ]
  %364 = phi ptr [ %360, %356 ], [ null, %339 ]
  br label %368

365:                                              ; preds = %378, %374, %368
  %366 = add nuw i64 %369, 1
  %367 = icmp eq i64 %366, %263
  br i1 %367, label %388, label %368, !llvm.loop !69

368:                                              ; preds = %365, %362
  %369 = phi i64 [ 0, %362 ], [ %366, %365 ]
  %370 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %266, i64 %369
  %371 = load ptr, ptr %370, align 8, !tbaa !70, !noalias !1059
  %372 = load i8, ptr %371, align 1, !noalias !1020
  %373 = icmp eq i8 %372, 99
  br i1 %373, label %374, label %365

374:                                              ; preds = %368
  %375 = getelementptr inbounds nuw i8, ptr %371, i64 1
  %376 = load i8, ptr %375, align 1, !noalias !1020
  %377 = icmp eq i8 %376, 99
  br i1 %377, label %378, label %365

378:                                              ; preds = %374
  %379 = getelementptr inbounds nuw i8, ptr %371, i64 2
  %380 = load i8, ptr %379, align 1, !noalias !1020
  %381 = icmp eq i8 %380, 0
  br i1 %381, label %382, label %365

382:                                              ; preds = %378
  %383 = getelementptr inbounds nuw i8, ptr %370, i64 8
  %384 = load i32, ptr %383, align 8, !tbaa !26, !noalias !1020
  %385 = getelementptr inbounds nuw i8, ptr %370, i64 32
  %386 = load ptr, ptr %385, align 8, !tbaa !29, !noalias !1020
  %387 = icmp eq i32 %384, 2
  br label %388

388:                                              ; preds = %365, %382
  %389 = phi ptr [ %386, %382 ], [ null, %365 ]
  %390 = phi i1 [ %387, %382 ], [ false, %365 ]
  %391 = icmp ne ptr %143, null
  %392 = icmp ne ptr %284, null
  %393 = select i1 %391, i1 %392, i1 false
  br i1 %393, label %394, label %398

394:                                              ; preds = %388
  %395 = icmp ne ptr %320, null
  %396 = icmp ne ptr %338, null
  %397 = select i1 %395, i1 true, i1 %396
  br i1 %397, label %400, label %398

398:                                              ; preds = %394, %388, %261, %256
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !1062
  %399 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %399, i8 0, i64 32, i1 false), !alias.scope !1020
  br label %1146

400:                                              ; preds = %394
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %4) #36, !noalias !1020
  %401 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %4, i64 noundef 256, ptr noundef nonnull @.str.81, ptr noundef nonnull %219, ptr noundef nonnull %143, i32 noundef %199) #36, !noalias !1020
  %402 = tail call dereferenceable_or_null(64) ptr @malloc(i64 64)
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %402, ptr noundef nonnull align 1 dereferenceable(7) @.str.82, i64 7, i1 false), !noalias !1020
  %403 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %284) #33, !noalias !1020
  %404 = add i64 %403, 1
  %405 = add i64 %403, 7
  %406 = icmp ugt i64 %405, 64
  br i1 %406, label %407, label %413

407:                                              ; preds = %400, %407
  %408 = phi i64 [ %409, %407 ], [ 64, %400 ]
  %409 = shl i64 %408, 1
  %410 = icmp ult i64 %409, %405
  br i1 %410, label %407, label %411, !llvm.loop !107

411:                                              ; preds = %407
  %412 = tail call ptr @realloc(ptr noundef nonnull %402, i64 noundef %409) #35, !noalias !1020
  br label %413

413:                                              ; preds = %411, %400
  %414 = phi ptr [ %412, %411 ], [ %402, %400 ]
  %415 = phi i64 [ %409, %411 ], [ 64, %400 ]
  %416 = getelementptr inbounds nuw i8, ptr %414, i64 6
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %416, ptr nonnull readonly align 1 %284, i64 %404, i1 false), !noalias !1020
  %417 = add i64 %403, 9
  %418 = icmp ugt i64 %417, %415
  br i1 %418, label %419, label %425

419:                                              ; preds = %413, %419
  %420 = phi i64 [ %421, %419 ], [ %415, %413 ]
  %421 = shl i64 %420, 1
  %422 = icmp ult i64 %421, %417
  br i1 %422, label %419, label %423, !llvm.loop !107

423:                                              ; preds = %419
  %424 = tail call ptr @realloc(ptr noundef %414, i64 noundef %421) #35, !noalias !1020
  br label %425

425:                                              ; preds = %423, %413
  %426 = phi ptr [ %424, %423 ], [ %414, %413 ]
  %427 = phi i64 [ %421, %423 ], [ %415, %413 ]
  %428 = getelementptr i8, ptr %426, i64 %403
  %429 = getelementptr i8, ptr %428, i64 6
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %429, ptr noundef nonnull align 1 dereferenceable(3) @.str.35, i64 3, i1 false), !noalias !1020
  %430 = add i64 %403, 8
  %431 = icmp ne ptr %364, null
  %432 = select i1 %363, i1 %431, i1 false
  br i1 %432, label %433, label %533

433:                                              ; preds = %425
  %434 = getelementptr inbounds nuw i8, ptr %364, i64 8
  %435 = load i64, ptr %434, align 8, !tbaa !49, !noalias !1020
  %436 = icmp eq i64 %435, 0
  br i1 %436, label %533, label %437

437:                                              ; preds = %433
  %438 = add i64 %403, 13
  %439 = icmp ugt i64 %438, %427
  br i1 %439, label %440, label %446

440:                                              ; preds = %437, %440
  %441 = phi i64 [ %442, %440 ], [ %427, %437 ]
  %442 = shl i64 %441, 1
  %443 = icmp ult i64 %442, %438
  br i1 %443, label %440, label %444, !llvm.loop !107

444:                                              ; preds = %440
  %445 = tail call ptr @realloc(ptr noundef nonnull %426, i64 noundef %442) #35, !noalias !1020
  br label %446

446:                                              ; preds = %444, %437
  %447 = phi ptr [ %445, %444 ], [ %426, %437 ]
  %448 = phi i64 [ %442, %444 ], [ %427, %437 ]
  %449 = getelementptr inbounds nuw i8, ptr %447, i64 %430
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %449, ptr noundef nonnull align 1 dereferenceable(5) @.str.83, i64 5, i1 false), !noalias !1020
  %450 = add i64 %403, 12
  %451 = load i64, ptr %434, align 8, !tbaa !49, !noalias !1020
  %452 = icmp eq i64 %451, 0
  br i1 %452, label %453, label %474

453:                                              ; preds = %526, %446
  %454 = phi ptr [ %447, %446 ], [ %527, %526 ]
  %455 = phi i64 [ %450, %446 ], [ %528, %526 ]
  %456 = phi i64 [ %448, %446 ], [ %529, %526 ]
  %457 = add i64 %455, 3
  %458 = icmp ugt i64 %457, %456
  br i1 %458, label %459, label %469

459:                                              ; preds = %453
  %460 = icmp eq i64 %456, 0
  %461 = shl i64 %456, 1
  %462 = select i1 %460, i64 64, i64 %461
  br label %463

463:                                              ; preds = %463, %459
  %464 = phi i64 [ %462, %459 ], [ %466, %463 ]
  %465 = icmp ult i64 %464, %457
  %466 = shl i64 %464, 1
  br i1 %465, label %463, label %467, !llvm.loop !107

467:                                              ; preds = %463
  %468 = tail call ptr @realloc(ptr noundef %454, i64 noundef %464) #35, !noalias !1020
  br label %469

469:                                              ; preds = %467, %453
  %470 = phi ptr [ %468, %467 ], [ %454, %453 ]
  %471 = phi i64 [ %464, %467 ], [ %456, %453 ]
  %472 = getelementptr inbounds nuw i8, ptr %470, i64 %455
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %472, ptr noundef nonnull align 1 dereferenceable(3) @.str.35, i64 3, i1 false), !noalias !1020
  %473 = add i64 %455, 2
  br label %533

474:                                              ; preds = %446, %526
  %475 = phi i64 [ %530, %526 ], [ 0, %446 ]
  %476 = phi i64 [ %529, %526 ], [ %448, %446 ]
  %477 = phi i64 [ %528, %526 ], [ %450, %446 ]
  %478 = phi ptr [ %527, %526 ], [ %447, %446 ]
  %479 = load ptr, ptr %364, align 8, !tbaa !52, !noalias !1020
  %480 = getelementptr inbounds nuw %struct.UhValue, ptr %479, i64 %475
  %481 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef byval(%struct.UhValue) align 8 %480), !noalias !1020
  %482 = icmp eq ptr %481, null
  br i1 %482, label %526, label %483

483:                                              ; preds = %474
  %484 = icmp eq i64 %475, 0
  br i1 %484, label %503, label %485

485:                                              ; preds = %483
  %486 = add i64 %477, 3
  %487 = icmp ugt i64 %486, %476
  br i1 %487, label %488, label %498

488:                                              ; preds = %485
  %489 = icmp eq i64 %476, 0
  %490 = shl i64 %476, 1
  %491 = select i1 %489, i64 64, i64 %490
  br label %492

492:                                              ; preds = %492, %488
  %493 = phi i64 [ %491, %488 ], [ %495, %492 ]
  %494 = icmp ult i64 %493, %486
  %495 = shl i64 %493, 1
  br i1 %494, label %492, label %496, !llvm.loop !107

496:                                              ; preds = %492
  %497 = tail call ptr @realloc(ptr noundef %478, i64 noundef %493) #35, !noalias !1020
  br label %498

498:                                              ; preds = %496, %485
  %499 = phi ptr [ %497, %496 ], [ %478, %485 ]
  %500 = phi i64 [ %493, %496 ], [ %476, %485 ]
  %501 = getelementptr inbounds nuw i8, ptr %499, i64 %477
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %501, ptr noundef nonnull align 1 dereferenceable(3) @.str.84, i64 3, i1 false), !noalias !1020
  %502 = add i64 %477, 2
  br label %503

503:                                              ; preds = %498, %483
  %504 = phi ptr [ %478, %483 ], [ %499, %498 ]
  %505 = phi i64 [ %477, %483 ], [ %502, %498 ]
  %506 = phi i64 [ %476, %483 ], [ %500, %498 ]
  %507 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %481) #33, !noalias !1020
  %508 = add i64 %507, 1
  %509 = add i64 %508, %505
  %510 = icmp ugt i64 %509, %506
  br i1 %510, label %511, label %521

511:                                              ; preds = %503
  %512 = icmp eq i64 %506, 0
  %513 = shl i64 %506, 1
  %514 = select i1 %512, i64 64, i64 %513
  br label %515

515:                                              ; preds = %515, %511
  %516 = phi i64 [ %514, %511 ], [ %518, %515 ]
  %517 = icmp ult i64 %516, %509
  %518 = shl i64 %516, 1
  br i1 %517, label %515, label %519, !llvm.loop !107

519:                                              ; preds = %515
  %520 = tail call ptr @realloc(ptr noundef %504, i64 noundef %516) #35, !noalias !1020
  br label %521

521:                                              ; preds = %519, %503
  %522 = phi ptr [ %520, %519 ], [ %504, %503 ]
  %523 = phi i64 [ %516, %519 ], [ %506, %503 ]
  %524 = getelementptr inbounds nuw i8, ptr %522, i64 %505
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %524, ptr nonnull readonly align 1 %481, i64 %508, i1 false), !noalias !1020
  %525 = add i64 %507, %505
  br label %526

526:                                              ; preds = %521, %474
  %527 = phi ptr [ %478, %474 ], [ %522, %521 ]
  %528 = phi i64 [ %477, %474 ], [ %525, %521 ]
  %529 = phi i64 [ %476, %474 ], [ %523, %521 ]
  tail call void @free(ptr noundef %481) #36, !noalias !1020
  %530 = add nuw i64 %475, 1
  %531 = load i64, ptr %434, align 8, !tbaa !49, !noalias !1020
  %532 = icmp ult i64 %530, %531
  br i1 %532, label %474, label %453, !llvm.loop !1065

533:                                              ; preds = %469, %433, %425
  %534 = phi ptr [ %426, %433 ], [ %470, %469 ], [ %426, %425 ]
  %535 = phi i64 [ %430, %433 ], [ %473, %469 ], [ %430, %425 ]
  %536 = phi i64 [ %427, %433 ], [ %471, %469 ], [ %427, %425 ]
  %537 = icmp ne ptr %389, null
  %538 = select i1 %390, i1 %537, i1 false
  br i1 %538, label %539, label %643

539:                                              ; preds = %533
  %540 = getelementptr inbounds nuw i8, ptr %389, i64 8
  %541 = load i64, ptr %540, align 8, !tbaa !49, !noalias !1020
  %542 = icmp eq i64 %541, 0
  br i1 %542, label %643, label %543

543:                                              ; preds = %539
  %544 = add i64 %535, 5
  %545 = icmp ugt i64 %544, %536
  br i1 %545, label %546, label %556

546:                                              ; preds = %543
  %547 = icmp eq i64 %536, 0
  %548 = shl i64 %536, 1
  %549 = select i1 %547, i64 64, i64 %548
  br label %550

550:                                              ; preds = %550, %546
  %551 = phi i64 [ %549, %546 ], [ %553, %550 ]
  %552 = icmp ult i64 %551, %544
  %553 = shl i64 %551, 1
  br i1 %552, label %550, label %554, !llvm.loop !107

554:                                              ; preds = %550
  %555 = tail call ptr @realloc(ptr noundef nonnull %534, i64 noundef %551) #35, !noalias !1020
  br label %556

556:                                              ; preds = %554, %543
  %557 = phi ptr [ %555, %554 ], [ %534, %543 ]
  %558 = phi i64 [ %551, %554 ], [ %536, %543 ]
  %559 = getelementptr inbounds nuw i8, ptr %557, i64 %535
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %559, ptr noundef nonnull align 1 dereferenceable(5) @.str.85, i64 5, i1 false), !noalias !1020
  %560 = add i64 %535, 4
  %561 = load i64, ptr %540, align 8, !tbaa !49, !noalias !1020
  %562 = icmp eq i64 %561, 0
  br i1 %562, label %563, label %584

563:                                              ; preds = %636, %556
  %564 = phi ptr [ %557, %556 ], [ %637, %636 ]
  %565 = phi i64 [ %560, %556 ], [ %638, %636 ]
  %566 = phi i64 [ %558, %556 ], [ %639, %636 ]
  %567 = add i64 %565, 3
  %568 = icmp ugt i64 %567, %566
  br i1 %568, label %569, label %579

569:                                              ; preds = %563
  %570 = icmp eq i64 %566, 0
  %571 = shl i64 %566, 1
  %572 = select i1 %570, i64 64, i64 %571
  br label %573

573:                                              ; preds = %573, %569
  %574 = phi i64 [ %572, %569 ], [ %576, %573 ]
  %575 = icmp ult i64 %574, %567
  %576 = shl i64 %574, 1
  br i1 %575, label %573, label %577, !llvm.loop !107

577:                                              ; preds = %573
  %578 = tail call ptr @realloc(ptr noundef %564, i64 noundef %574) #35, !noalias !1020
  br label %579

579:                                              ; preds = %577, %563
  %580 = phi ptr [ %578, %577 ], [ %564, %563 ]
  %581 = phi i64 [ %574, %577 ], [ %566, %563 ]
  %582 = getelementptr inbounds nuw i8, ptr %580, i64 %565
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %582, ptr noundef nonnull align 1 dereferenceable(3) @.str.35, i64 3, i1 false), !noalias !1020
  %583 = add i64 %565, 2
  br label %643

584:                                              ; preds = %556, %636
  %585 = phi i64 [ %640, %636 ], [ 0, %556 ]
  %586 = phi i64 [ %639, %636 ], [ %558, %556 ]
  %587 = phi i64 [ %638, %636 ], [ %560, %556 ]
  %588 = phi ptr [ %637, %636 ], [ %557, %556 ]
  %589 = load ptr, ptr %389, align 8, !tbaa !52, !noalias !1020
  %590 = getelementptr inbounds nuw %struct.UhValue, ptr %589, i64 %585
  %591 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef byval(%struct.UhValue) align 8 %590), !noalias !1020
  %592 = icmp eq ptr %591, null
  br i1 %592, label %636, label %593

593:                                              ; preds = %584
  %594 = icmp eq i64 %585, 0
  br i1 %594, label %613, label %595

595:                                              ; preds = %593
  %596 = add i64 %587, 3
  %597 = icmp ugt i64 %596, %586
  br i1 %597, label %598, label %608

598:                                              ; preds = %595
  %599 = icmp eq i64 %586, 0
  %600 = shl i64 %586, 1
  %601 = select i1 %599, i64 64, i64 %600
  br label %602

602:                                              ; preds = %602, %598
  %603 = phi i64 [ %601, %598 ], [ %605, %602 ]
  %604 = icmp ult i64 %603, %596
  %605 = shl i64 %603, 1
  br i1 %604, label %602, label %606, !llvm.loop !107

606:                                              ; preds = %602
  %607 = tail call ptr @realloc(ptr noundef %588, i64 noundef %603) #35, !noalias !1020
  br label %608

608:                                              ; preds = %606, %595
  %609 = phi ptr [ %607, %606 ], [ %588, %595 ]
  %610 = phi i64 [ %603, %606 ], [ %586, %595 ]
  %611 = getelementptr inbounds nuw i8, ptr %609, i64 %587
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %611, ptr noundef nonnull align 1 dereferenceable(3) @.str.84, i64 3, i1 false), !noalias !1020
  %612 = add i64 %587, 2
  br label %613

613:                                              ; preds = %608, %593
  %614 = phi ptr [ %588, %593 ], [ %609, %608 ]
  %615 = phi i64 [ %587, %593 ], [ %612, %608 ]
  %616 = phi i64 [ %586, %593 ], [ %610, %608 ]
  %617 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %591) #33, !noalias !1020
  %618 = add i64 %617, 1
  %619 = add i64 %618, %615
  %620 = icmp ugt i64 %619, %616
  br i1 %620, label %621, label %631

621:                                              ; preds = %613
  %622 = icmp eq i64 %616, 0
  %623 = shl i64 %616, 1
  %624 = select i1 %622, i64 64, i64 %623
  br label %625

625:                                              ; preds = %625, %621
  %626 = phi i64 [ %624, %621 ], [ %628, %625 ]
  %627 = icmp ult i64 %626, %619
  %628 = shl i64 %626, 1
  br i1 %627, label %625, label %629, !llvm.loop !107

629:                                              ; preds = %625
  %630 = tail call ptr @realloc(ptr noundef %614, i64 noundef %626) #35, !noalias !1020
  br label %631

631:                                              ; preds = %629, %613
  %632 = phi ptr [ %630, %629 ], [ %614, %613 ]
  %633 = phi i64 [ %626, %629 ], [ %616, %613 ]
  %634 = getelementptr inbounds nuw i8, ptr %632, i64 %615
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %634, ptr nonnull readonly align 1 %591, i64 %618, i1 false), !noalias !1020
  %635 = add i64 %617, %615
  br label %636

636:                                              ; preds = %631, %584
  %637 = phi ptr [ %588, %584 ], [ %632, %631 ]
  %638 = phi i64 [ %587, %584 ], [ %635, %631 ]
  %639 = phi i64 [ %586, %584 ], [ %633, %631 ]
  tail call void @free(ptr noundef %591) #36, !noalias !1020
  %640 = add nuw i64 %585, 1
  %641 = load i64, ptr %540, align 8, !tbaa !49, !noalias !1020
  %642 = icmp ult i64 %640, %641
  br i1 %642, label %584, label %563, !llvm.loop !1066

643:                                              ; preds = %579, %539, %533
  %644 = phi ptr [ %534, %539 ], [ %580, %579 ], [ %534, %533 ]
  %645 = phi i64 [ %535, %539 ], [ %583, %579 ], [ %535, %533 ]
  %646 = phi i64 [ %536, %539 ], [ %581, %579 ], [ %536, %533 ]
  %647 = icmp eq ptr %302, null
  br i1 %647, label %702, label %648

648:                                              ; preds = %643
  %649 = add i64 %645, 10
  %650 = icmp ugt i64 %649, %646
  br i1 %650, label %651, label %661

651:                                              ; preds = %648
  %652 = icmp eq i64 %646, 0
  %653 = shl i64 %646, 1
  %654 = select i1 %652, i64 64, i64 %653
  br label %655

655:                                              ; preds = %655, %651
  %656 = phi i64 [ %654, %651 ], [ %658, %655 ]
  %657 = icmp ult i64 %656, %649
  %658 = shl i64 %656, 1
  br i1 %657, label %655, label %659, !llvm.loop !107

659:                                              ; preds = %655
  %660 = tail call ptr @realloc(ptr noundef nonnull %644, i64 noundef %656) #35, !noalias !1020
  br label %661

661:                                              ; preds = %659, %648
  %662 = phi ptr [ %660, %659 ], [ %644, %648 ]
  %663 = phi i64 [ %656, %659 ], [ %646, %648 ]
  %664 = getelementptr inbounds nuw i8, ptr %662, i64 %645
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(10) %664, ptr noundef nonnull align 1 dereferenceable(10) @.str.86, i64 10, i1 false), !noalias !1020
  %665 = add i64 %645, 9
  %666 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %302) #33, !noalias !1020
  %667 = add i64 %666, 1
  %668 = add i64 %667, %665
  %669 = icmp ugt i64 %668, %663
  br i1 %669, label %670, label %680

670:                                              ; preds = %661
  %671 = icmp eq i64 %663, 0
  %672 = shl i64 %663, 1
  %673 = select i1 %671, i64 64, i64 %672
  br label %674

674:                                              ; preds = %674, %670
  %675 = phi i64 [ %673, %670 ], [ %677, %674 ]
  %676 = icmp ult i64 %675, %668
  %677 = shl i64 %675, 1
  br i1 %676, label %674, label %678, !llvm.loop !107

678:                                              ; preds = %674
  %679 = tail call ptr @realloc(ptr noundef nonnull %662, i64 noundef %675) #35, !noalias !1020
  br label %680

680:                                              ; preds = %678, %661
  %681 = phi ptr [ %679, %678 ], [ %662, %661 ]
  %682 = phi i64 [ %675, %678 ], [ %663, %661 ]
  %683 = getelementptr inbounds nuw i8, ptr %681, i64 %665
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %683, ptr nonnull readonly align 1 %302, i64 %667, i1 false), !noalias !1020
  %684 = add i64 %666, %665
  %685 = add i64 %684, 3
  %686 = icmp ugt i64 %685, %682
  br i1 %686, label %687, label %697

687:                                              ; preds = %680
  %688 = icmp eq i64 %682, 0
  %689 = shl i64 %682, 1
  %690 = select i1 %688, i64 64, i64 %689
  br label %691

691:                                              ; preds = %691, %687
  %692 = phi i64 [ %690, %687 ], [ %694, %691 ]
  %693 = icmp ult i64 %692, %685
  %694 = shl i64 %692, 1
  br i1 %693, label %691, label %695, !llvm.loop !107

695:                                              ; preds = %691
  %696 = tail call ptr @realloc(ptr noundef %681, i64 noundef %692) #35, !noalias !1020
  br label %697

697:                                              ; preds = %695, %680
  %698 = phi ptr [ %696, %695 ], [ %681, %680 ]
  %699 = phi i64 [ %692, %695 ], [ %682, %680 ]
  %700 = getelementptr inbounds nuw i8, ptr %698, i64 %684
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %700, ptr noundef nonnull align 1 dereferenceable(3) @.str.35, i64 3, i1 false), !noalias !1020
  %701 = add i64 %684, 2
  br label %702

702:                                              ; preds = %697, %643
  %703 = phi ptr [ %644, %643 ], [ %698, %697 ]
  %704 = phi i64 [ %645, %643 ], [ %701, %697 ]
  %705 = phi i64 [ %646, %643 ], [ %699, %697 ]
  %706 = and i1 %395, %396
  br i1 %706, label %707, label %965

707:                                              ; preds = %702
  %708 = add i64 %704, 20
  %709 = icmp ugt i64 %708, %705
  br i1 %709, label %710, label %720

710:                                              ; preds = %707
  %711 = icmp eq i64 %705, 0
  %712 = shl i64 %705, 1
  %713 = select i1 %711, i64 64, i64 %712
  br label %714

714:                                              ; preds = %714, %710
  %715 = phi i64 [ %713, %710 ], [ %717, %714 ]
  %716 = icmp ult i64 %715, %708
  %717 = shl i64 %715, 1
  br i1 %716, label %714, label %718, !llvm.loop !107

718:                                              ; preds = %714
  %719 = tail call ptr @realloc(ptr noundef nonnull %703, i64 noundef %715) #35, !noalias !1020
  br label %720

720:                                              ; preds = %718, %707
  %721 = phi ptr [ %719, %718 ], [ %703, %707 ]
  %722 = phi i64 [ %715, %718 ], [ %705, %707 ]
  %723 = getelementptr inbounds nuw i8, ptr %721, i64 %704
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(20) %723, ptr noundef nonnull align 1 dereferenceable(20) @.str.88, i64 20, i1 false), !noalias !1020
  %724 = add i64 %704, 67
  %725 = icmp ugt i64 %724, %722
  br i1 %725, label %726, label %736

726:                                              ; preds = %720
  %727 = icmp eq i64 %722, 0
  %728 = shl i64 %722, 1
  %729 = select i1 %727, i64 64, i64 %728
  br label %730

730:                                              ; preds = %730, %726
  %731 = phi i64 [ %729, %726 ], [ %733, %730 ]
  %732 = icmp ult i64 %731, %724
  %733 = shl i64 %731, 1
  br i1 %732, label %730, label %734, !llvm.loop !107

734:                                              ; preds = %730
  %735 = tail call ptr @realloc(ptr noundef nonnull %721, i64 noundef %731) #35, !noalias !1020
  br label %736

736:                                              ; preds = %734, %720
  %737 = phi ptr [ %735, %734 ], [ %721, %720 ]
  %738 = phi i64 [ %731, %734 ], [ %722, %720 ]
  %739 = getelementptr i8, ptr %737, i64 %704
  %740 = getelementptr i8, ptr %739, i64 19
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(48) %740, ptr noundef nonnull align 1 dereferenceable(48) @.str.89, i64 48, i1 false), !noalias !1020
  %741 = add i64 %704, 81
  %742 = icmp ugt i64 %741, %738
  br i1 %742, label %743, label %753

743:                                              ; preds = %736
  %744 = icmp eq i64 %738, 0
  %745 = shl i64 %738, 1
  %746 = select i1 %744, i64 64, i64 %745
  br label %747

747:                                              ; preds = %747, %743
  %748 = phi i64 [ %746, %743 ], [ %750, %747 ]
  %749 = icmp ult i64 %748, %741
  %750 = shl i64 %748, 1
  br i1 %749, label %747, label %751, !llvm.loop !107

751:                                              ; preds = %747
  %752 = tail call ptr @realloc(ptr noundef nonnull %737, i64 noundef %748) #35, !noalias !1020
  br label %753

753:                                              ; preds = %751, %736
  %754 = phi ptr [ %752, %751 ], [ %737, %736 ]
  %755 = phi i64 [ %748, %751 ], [ %738, %736 ]
  %756 = getelementptr i8, ptr %754, i64 %704
  %757 = getelementptr i8, ptr %756, i64 66
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(15) %757, ptr noundef nonnull align 1 dereferenceable(15) @.str.87, i64 15, i1 false), !noalias !1020
  %758 = add i64 %704, 86
  %759 = icmp ugt i64 %758, %755
  br i1 %759, label %760, label %770

760:                                              ; preds = %753
  %761 = icmp eq i64 %755, 0
  %762 = shl i64 %755, 1
  %763 = select i1 %761, i64 64, i64 %762
  br label %764

764:                                              ; preds = %764, %760
  %765 = phi i64 [ %763, %760 ], [ %767, %764 ]
  %766 = icmp ult i64 %765, %758
  %767 = shl i64 %765, 1
  br i1 %766, label %764, label %768, !llvm.loop !107

768:                                              ; preds = %764
  %769 = tail call ptr @realloc(ptr noundef nonnull %754, i64 noundef %765) #35, !noalias !1020
  br label %770

770:                                              ; preds = %768, %753
  %771 = phi ptr [ %769, %768 ], [ %754, %753 ]
  %772 = phi i64 [ %765, %768 ], [ %755, %753 ]
  %773 = getelementptr i8, ptr %771, i64 %704
  %774 = getelementptr i8, ptr %773, i64 80
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %774, ptr noundef nonnull align 1 dereferenceable(6) @.str.90, i64 6, i1 false), !noalias !1020
  %775 = add i64 %704, 88
  %776 = icmp ugt i64 %775, %772
  br i1 %776, label %777, label %787

777:                                              ; preds = %770
  %778 = icmp eq i64 %772, 0
  %779 = shl i64 %772, 1
  %780 = select i1 %778, i64 64, i64 %779
  br label %781

781:                                              ; preds = %781, %777
  %782 = phi i64 [ %780, %777 ], [ %784, %781 ]
  %783 = icmp ult i64 %782, %775
  %784 = shl i64 %782, 1
  br i1 %783, label %781, label %785, !llvm.loop !107

785:                                              ; preds = %781
  %786 = tail call ptr @realloc(ptr noundef nonnull %771, i64 noundef %782) #35, !noalias !1020
  br label %787

787:                                              ; preds = %785, %770
  %788 = phi ptr [ %786, %785 ], [ %771, %770 ]
  %789 = phi i64 [ %782, %785 ], [ %772, %770 ]
  %790 = getelementptr i8, ptr %788, i64 %704
  %791 = getelementptr i8, ptr %790, i64 85
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %791, ptr noundef nonnull align 1 dereferenceable(3) @.str.91, i64 3, i1 false), !noalias !1020
  %792 = add i64 %704, 102
  %793 = icmp ugt i64 %792, %789
  br i1 %793, label %794, label %804

794:                                              ; preds = %787
  %795 = icmp eq i64 %789, 0
  %796 = shl i64 %789, 1
  %797 = select i1 %795, i64 64, i64 %796
  br label %798

798:                                              ; preds = %798, %794
  %799 = phi i64 [ %797, %794 ], [ %801, %798 ]
  %800 = icmp ult i64 %799, %792
  %801 = shl i64 %799, 1
  br i1 %800, label %798, label %802, !llvm.loop !107

802:                                              ; preds = %798
  %803 = tail call ptr @realloc(ptr noundef nonnull %788, i64 noundef %799) #35, !noalias !1020
  br label %804

804:                                              ; preds = %802, %787
  %805 = phi ptr [ %803, %802 ], [ %788, %787 ]
  %806 = phi i64 [ %799, %802 ], [ %789, %787 ]
  %807 = getelementptr i8, ptr %805, i64 %704
  %808 = getelementptr i8, ptr %807, i64 87
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(15) %808, ptr noundef nonnull align 1 dereferenceable(15) @.str.87, i64 15, i1 false), !noalias !1020
  %809 = add i64 %704, 147
  %810 = icmp ugt i64 %809, %806
  br i1 %810, label %811, label %821

811:                                              ; preds = %804
  %812 = icmp eq i64 %806, 0
  %813 = shl i64 %806, 1
  %814 = select i1 %812, i64 64, i64 %813
  br label %815

815:                                              ; preds = %815, %811
  %816 = phi i64 [ %814, %811 ], [ %818, %815 ]
  %817 = icmp ult i64 %816, %809
  %818 = shl i64 %816, 1
  br i1 %817, label %815, label %819, !llvm.loop !107

819:                                              ; preds = %815
  %820 = tail call ptr @realloc(ptr noundef nonnull %805, i64 noundef %816) #35, !noalias !1020
  br label %821

821:                                              ; preds = %819, %804
  %822 = phi ptr [ %820, %819 ], [ %805, %804 ]
  %823 = phi i64 [ %816, %819 ], [ %806, %804 ]
  %824 = getelementptr i8, ptr %822, i64 %704
  %825 = getelementptr i8, ptr %824, i64 101
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(46) %825, ptr noundef nonnull align 1 dereferenceable(46) @.str.92, i64 46, i1 false), !noalias !1020
  %826 = add i64 %704, 146
  %827 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %320) #33, !noalias !1020
  %828 = add i64 %827, 1
  %829 = add i64 %828, %826
  %830 = icmp ugt i64 %829, %823
  br i1 %830, label %831, label %841

831:                                              ; preds = %821
  %832 = icmp eq i64 %823, 0
  %833 = shl i64 %823, 1
  %834 = select i1 %832, i64 64, i64 %833
  br label %835

835:                                              ; preds = %835, %831
  %836 = phi i64 [ %834, %831 ], [ %838, %835 ]
  %837 = icmp ult i64 %836, %829
  %838 = shl i64 %836, 1
  br i1 %837, label %835, label %839, !llvm.loop !107

839:                                              ; preds = %835
  %840 = tail call ptr @realloc(ptr noundef nonnull %822, i64 noundef %836) #35, !noalias !1020
  br label %841

841:                                              ; preds = %839, %821
  %842 = phi ptr [ %840, %839 ], [ %822, %821 ]
  %843 = phi i64 [ %836, %839 ], [ %823, %821 ]
  %844 = getelementptr inbounds nuw i8, ptr %842, i64 %826
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %844, ptr nonnull readonly align 1 %320, i64 %828, i1 false), !noalias !1020
  %845 = add i64 %827, %826
  %846 = add i64 %845, 5
  %847 = icmp ugt i64 %846, %843
  br i1 %847, label %848, label %858

848:                                              ; preds = %841
  %849 = icmp eq i64 %843, 0
  %850 = shl i64 %843, 1
  %851 = select i1 %849, i64 64, i64 %850
  br label %852

852:                                              ; preds = %852, %848
  %853 = phi i64 [ %851, %848 ], [ %855, %852 ]
  %854 = icmp ult i64 %853, %846
  %855 = shl i64 %853, 1
  br i1 %854, label %852, label %856, !llvm.loop !107

856:                                              ; preds = %852
  %857 = tail call ptr @realloc(ptr noundef %842, i64 noundef %853) #35, !noalias !1020
  br label %858

858:                                              ; preds = %856, %841
  %859 = phi ptr [ %857, %856 ], [ %842, %841 ]
  %860 = phi i64 [ %853, %856 ], [ %843, %841 ]
  %861 = getelementptr inbounds nuw i8, ptr %859, i64 %845
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %861, ptr noundef nonnull align 1 dereferenceable(5) @.str.93, i64 5, i1 false), !noalias !1020
  %862 = add i64 %845, 19
  %863 = icmp ugt i64 %862, %860
  br i1 %863, label %864, label %874

864:                                              ; preds = %858
  %865 = icmp eq i64 %860, 0
  %866 = shl i64 %860, 1
  %867 = select i1 %865, i64 64, i64 %866
  br label %868

868:                                              ; preds = %868, %864
  %869 = phi i64 [ %867, %864 ], [ %871, %868 ]
  %870 = icmp ult i64 %869, %862
  %871 = shl i64 %869, 1
  br i1 %870, label %868, label %872, !llvm.loop !107

872:                                              ; preds = %868
  %873 = tail call ptr @realloc(ptr noundef nonnull %859, i64 noundef %869) #35, !noalias !1020
  br label %874

874:                                              ; preds = %872, %858
  %875 = phi ptr [ %873, %872 ], [ %859, %858 ]
  %876 = phi i64 [ %869, %872 ], [ %860, %858 ]
  %877 = getelementptr i8, ptr %875, i64 %845
  %878 = getelementptr i8, ptr %877, i64 4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(15) %878, ptr noundef nonnull align 1 dereferenceable(15) @.str.87, i64 15, i1 false), !noalias !1020
  %879 = add i64 %845, 63
  %880 = icmp ugt i64 %879, %876
  br i1 %880, label %881, label %891

881:                                              ; preds = %874
  %882 = icmp eq i64 %876, 0
  %883 = shl i64 %876, 1
  %884 = select i1 %882, i64 64, i64 %883
  br label %885

885:                                              ; preds = %885, %881
  %886 = phi i64 [ %884, %881 ], [ %888, %885 ]
  %887 = icmp ult i64 %886, %879
  %888 = shl i64 %886, 1
  br i1 %887, label %885, label %889, !llvm.loop !107

889:                                              ; preds = %885
  %890 = tail call ptr @realloc(ptr noundef nonnull %875, i64 noundef %886) #35, !noalias !1020
  br label %891

891:                                              ; preds = %889, %874
  %892 = phi ptr [ %890, %889 ], [ %875, %874 ]
  %893 = phi i64 [ %886, %889 ], [ %876, %874 ]
  %894 = getelementptr i8, ptr %892, i64 %845
  %895 = getelementptr i8, ptr %894, i64 18
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(45) %895, ptr noundef nonnull align 1 dereferenceable(45) @.str.94, i64 45, i1 false), !noalias !1020
  %896 = add i64 %845, 62
  %897 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %338) #33, !noalias !1020
  %898 = add i64 %897, 1
  %899 = add i64 %898, %896
  %900 = icmp ugt i64 %899, %893
  br i1 %900, label %901, label %911

901:                                              ; preds = %891
  %902 = icmp eq i64 %893, 0
  %903 = shl i64 %893, 1
  %904 = select i1 %902, i64 64, i64 %903
  br label %905

905:                                              ; preds = %905, %901
  %906 = phi i64 [ %904, %901 ], [ %908, %905 ]
  %907 = icmp ult i64 %906, %899
  %908 = shl i64 %906, 1
  br i1 %907, label %905, label %909, !llvm.loop !107

909:                                              ; preds = %905
  %910 = tail call ptr @realloc(ptr noundef nonnull %892, i64 noundef %906) #35, !noalias !1020
  br label %911

911:                                              ; preds = %909, %891
  %912 = phi ptr [ %910, %909 ], [ %892, %891 ]
  %913 = phi i64 [ %906, %909 ], [ %893, %891 ]
  %914 = getelementptr inbounds nuw i8, ptr %912, i64 %896
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %914, ptr nonnull readonly align 1 %338, i64 %898, i1 false), !noalias !1020
  %915 = add i64 %897, %896
  %916 = add i64 %915, 5
  %917 = icmp ugt i64 %916, %913
  br i1 %917, label %918, label %928

918:                                              ; preds = %911
  %919 = icmp eq i64 %913, 0
  %920 = shl i64 %913, 1
  %921 = select i1 %919, i64 64, i64 %920
  br label %922

922:                                              ; preds = %922, %918
  %923 = phi i64 [ %921, %918 ], [ %925, %922 ]
  %924 = icmp ult i64 %923, %916
  %925 = shl i64 %923, 1
  br i1 %924, label %922, label %926, !llvm.loop !107

926:                                              ; preds = %922
  %927 = tail call ptr @realloc(ptr noundef %912, i64 noundef %923) #35, !noalias !1020
  br label %928

928:                                              ; preds = %926, %911
  %929 = phi ptr [ %927, %926 ], [ %912, %911 ]
  %930 = phi i64 [ %923, %926 ], [ %913, %911 ]
  %931 = getelementptr inbounds nuw i8, ptr %929, i64 %915
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %931, ptr noundef nonnull align 1 dereferenceable(5) @.str.93, i64 5, i1 false), !noalias !1020
  %932 = add i64 %915, 19
  %933 = icmp ugt i64 %932, %930
  br i1 %933, label %934, label %944

934:                                              ; preds = %928
  %935 = icmp eq i64 %930, 0
  %936 = shl i64 %930, 1
  %937 = select i1 %935, i64 64, i64 %936
  br label %938

938:                                              ; preds = %938, %934
  %939 = phi i64 [ %937, %934 ], [ %941, %938 ]
  %940 = icmp ult i64 %939, %932
  %941 = shl i64 %939, 1
  br i1 %940, label %938, label %942, !llvm.loop !107

942:                                              ; preds = %938
  %943 = tail call ptr @realloc(ptr noundef nonnull %929, i64 noundef %939) #35, !noalias !1020
  br label %944

944:                                              ; preds = %942, %928
  %945 = phi ptr [ %943, %942 ], [ %929, %928 ]
  %946 = phi i64 [ %939, %942 ], [ %930, %928 ]
  %947 = getelementptr i8, ptr %945, i64 %915
  %948 = getelementptr i8, ptr %947, i64 4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(15) %948, ptr noundef nonnull align 1 dereferenceable(15) @.str.87, i64 15, i1 false), !noalias !1020
  %949 = add i64 %915, 23
  %950 = icmp ugt i64 %949, %946
  br i1 %950, label %951, label %961

951:                                              ; preds = %944
  %952 = icmp eq i64 %946, 0
  %953 = shl i64 %946, 1
  %954 = select i1 %952, i64 64, i64 %953
  br label %955

955:                                              ; preds = %955, %951
  %956 = phi i64 [ %954, %951 ], [ %958, %955 ]
  %957 = icmp ult i64 %956, %949
  %958 = shl i64 %956, 1
  br i1 %957, label %955, label %959, !llvm.loop !107

959:                                              ; preds = %955
  %960 = tail call ptr @realloc(ptr noundef nonnull %945, i64 noundef %956) #35, !noalias !1020
  br label %961

961:                                              ; preds = %959, %944
  %962 = phi ptr [ %960, %959 ], [ %945, %944 ]
  %963 = getelementptr i8, ptr %962, i64 %915
  %964 = getelementptr i8, ptr %963, i64 18
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %964, ptr noundef nonnull align 1 dereferenceable(5) @.str.95, i64 5, i1 false), !noalias !1020
  br label %1054

965:                                              ; preds = %702
  br i1 %396, label %966, label %1018

966:                                              ; preds = %965
  %967 = add i64 %704, 20
  %968 = icmp ugt i64 %967, %705
  br i1 %968, label %969, label %979

969:                                              ; preds = %966
  %970 = icmp eq i64 %705, 0
  %971 = shl i64 %705, 1
  %972 = select i1 %970, i64 64, i64 %971
  br label %973

973:                                              ; preds = %973, %969
  %974 = phi i64 [ %972, %969 ], [ %976, %973 ]
  %975 = icmp ult i64 %974, %967
  %976 = shl i64 %974, 1
  br i1 %975, label %973, label %977, !llvm.loop !107

977:                                              ; preds = %973
  %978 = tail call ptr @realloc(ptr noundef nonnull %703, i64 noundef %974) #35, !noalias !1020
  br label %979

979:                                              ; preds = %977, %966
  %980 = phi ptr [ %978, %977 ], [ %703, %966 ]
  %981 = phi i64 [ %974, %977 ], [ %705, %966 ]
  %982 = getelementptr inbounds nuw i8, ptr %980, i64 %704
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(20) %982, ptr noundef nonnull align 1 dereferenceable(20) @.str.88, i64 20, i1 false), !noalias !1020
  %983 = add i64 %704, 62
  %984 = icmp ugt i64 %983, %981
  br i1 %984, label %985, label %995

985:                                              ; preds = %979
  %986 = icmp eq i64 %981, 0
  %987 = shl i64 %981, 1
  %988 = select i1 %986, i64 64, i64 %987
  br label %989

989:                                              ; preds = %989, %985
  %990 = phi i64 [ %988, %985 ], [ %992, %989 ]
  %991 = icmp ult i64 %990, %983
  %992 = shl i64 %990, 1
  br i1 %991, label %989, label %993, !llvm.loop !107

993:                                              ; preds = %989
  %994 = tail call ptr @realloc(ptr noundef nonnull %980, i64 noundef %990) #35, !noalias !1020
  br label %995

995:                                              ; preds = %993, %979
  %996 = phi ptr [ %994, %993 ], [ %980, %979 ]
  %997 = phi i64 [ %990, %993 ], [ %981, %979 ]
  %998 = getelementptr i8, ptr %996, i64 %704
  %999 = getelementptr i8, ptr %998, i64 19
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(43) %999, ptr noundef nonnull align 1 dereferenceable(43) @.str.96, i64 43, i1 false), !noalias !1020
  %1000 = add i64 %704, 61
  %1001 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %338) #33, !noalias !1020
  %1002 = add i64 %1001, 1
  %1003 = add i64 %1002, %1000
  %1004 = icmp ugt i64 %1003, %997
  br i1 %1004, label %1005, label %1015

1005:                                             ; preds = %995
  %1006 = icmp eq i64 %997, 0
  %1007 = shl i64 %997, 1
  %1008 = select i1 %1006, i64 64, i64 %1007
  br label %1009

1009:                                             ; preds = %1009, %1005
  %1010 = phi i64 [ %1008, %1005 ], [ %1012, %1009 ]
  %1011 = icmp ult i64 %1010, %1003
  %1012 = shl i64 %1010, 1
  br i1 %1011, label %1009, label %1013, !llvm.loop !107

1013:                                             ; preds = %1009
  %1014 = tail call ptr @realloc(ptr noundef nonnull %996, i64 noundef %1010) #35, !noalias !1020
  br label %1015

1015:                                             ; preds = %1013, %995
  %1016 = phi ptr [ %1014, %1013 ], [ %996, %995 ]
  %1017 = getelementptr inbounds nuw i8, ptr %1016, i64 %1000
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %1017, ptr nonnull readonly align 1 %338, i64 %1002, i1 false), !noalias !1020
  br label %1054

1018:                                             ; preds = %965
  %1019 = add i64 %704, 3
  %1020 = icmp ugt i64 %1019, %705
  br i1 %1020, label %1021, label %1031

1021:                                             ; preds = %1018
  %1022 = icmp eq i64 %705, 0
  %1023 = shl i64 %705, 1
  %1024 = select i1 %1022, i64 64, i64 %1023
  br label %1025

1025:                                             ; preds = %1025, %1021
  %1026 = phi i64 [ %1024, %1021 ], [ %1028, %1025 ]
  %1027 = icmp ult i64 %1026, %1019
  %1028 = shl i64 %1026, 1
  br i1 %1027, label %1025, label %1029, !llvm.loop !107

1029:                                             ; preds = %1025
  %1030 = tail call ptr @realloc(ptr noundef nonnull %703, i64 noundef %1026) #35, !noalias !1020
  br label %1031

1031:                                             ; preds = %1029, %1018
  %1032 = phi ptr [ %1030, %1029 ], [ %703, %1018 ]
  %1033 = phi i64 [ %1026, %1029 ], [ %705, %1018 ]
  %1034 = getelementptr inbounds nuw i8, ptr %1032, i64 %704
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %1034, ptr noundef nonnull align 1 dereferenceable(3) @.str.35, i64 3, i1 false), !noalias !1020
  %1035 = add i64 %704, 2
  %1036 = select i1 %395, ptr %320, ptr @.str
  %1037 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %1036) #33, !noalias !1020
  %1038 = add i64 %1037, 1
  %1039 = add i64 %1038, %1035
  %1040 = icmp ugt i64 %1039, %1033
  br i1 %1040, label %1041, label %1051

1041:                                             ; preds = %1031
  %1042 = icmp eq i64 %1033, 0
  %1043 = shl i64 %1033, 1
  %1044 = select i1 %1042, i64 64, i64 %1043
  br label %1045

1045:                                             ; preds = %1045, %1041
  %1046 = phi i64 [ %1044, %1041 ], [ %1048, %1045 ]
  %1047 = icmp ult i64 %1046, %1039
  %1048 = shl i64 %1046, 1
  br i1 %1047, label %1045, label %1049, !llvm.loop !107

1049:                                             ; preds = %1045
  %1050 = tail call ptr @realloc(ptr noundef nonnull %1032, i64 noundef %1046) #35, !noalias !1020
  br label %1051

1051:                                             ; preds = %1049, %1031
  %1052 = phi ptr [ %1050, %1049 ], [ %1032, %1031 ]
  %1053 = getelementptr inbounds nuw i8, ptr %1052, i64 %1035
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %1053, ptr nonnull readonly align 1 %1036, i64 %1038, i1 false), !noalias !1020
  br label %1054

1054:                                             ; preds = %1051, %1015, %961
  %1055 = phi ptr [ %962, %961 ], [ %1016, %1015 ], [ %1052, %1051 ]
  br i1 %432, label %1056, label %1074

1056:                                             ; preds = %1054
  %1057 = getelementptr inbounds nuw i8, ptr %364, i64 8
  %1058 = load i64, ptr %1057, align 8, !tbaa !49, !noalias !1020
  %1059 = icmp eq i64 %1058, 0
  br i1 %1059, label %1074, label %1060

1060:                                             ; preds = %1056, %1069
  %1061 = phi ptr [ %1070, %1069 ], [ null, %1056 ]
  %1062 = phi i64 [ %1071, %1069 ], [ 0, %1056 ]
  %1063 = load ptr, ptr %364, align 8, !tbaa !52, !noalias !1020
  %1064 = getelementptr inbounds nuw %struct.UhValue, ptr %1063, i64 %1062
  %1065 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef byval(%struct.UhValue) align 8 %1064), !noalias !1020
  %1066 = icmp eq ptr %1065, null
  br i1 %1066, label %1069, label %1067

1067:                                             ; preds = %1060
  %1068 = tail call ptr @curl_slist_append(ptr noundef %1061, ptr noundef nonnull %1065) #36, !noalias !1020
  br label %1069

1069:                                             ; preds = %1067, %1060
  %1070 = phi ptr [ %1068, %1067 ], [ %1061, %1060 ]
  tail call void @free(ptr noundef %1065) #36, !noalias !1020
  %1071 = add nuw i64 %1062, 1
  %1072 = load i64, ptr %1057, align 8, !tbaa !49, !noalias !1020
  %1073 = icmp ult i64 %1071, %1072
  br i1 %1073, label %1060, label %1074, !llvm.loop !1067

1074:                                             ; preds = %1069, %1056, %1054
  %1075 = phi ptr [ null, %1054 ], [ null, %1056 ], [ %1070, %1069 ]
  br i1 %538, label %1076, label %1094

1076:                                             ; preds = %1074
  %1077 = getelementptr inbounds nuw i8, ptr %389, i64 8
  %1078 = load i64, ptr %1077, align 8, !tbaa !49, !noalias !1020
  %1079 = icmp eq i64 %1078, 0
  br i1 %1079, label %1094, label %1080

1080:                                             ; preds = %1076, %1089
  %1081 = phi ptr [ %1090, %1089 ], [ %1075, %1076 ]
  %1082 = phi i64 [ %1091, %1089 ], [ 0, %1076 ]
  %1083 = load ptr, ptr %389, align 8, !tbaa !52, !noalias !1020
  %1084 = getelementptr inbounds nuw %struct.UhValue, ptr %1083, i64 %1082
  %1085 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef byval(%struct.UhValue) align 8 %1084), !noalias !1020
  %1086 = icmp eq ptr %1085, null
  br i1 %1086, label %1089, label %1087

1087:                                             ; preds = %1080
  %1088 = tail call ptr @curl_slist_append(ptr noundef %1081, ptr noundef nonnull %1085) #36, !noalias !1020
  br label %1089

1089:                                             ; preds = %1087, %1080
  %1090 = phi ptr [ %1088, %1087 ], [ %1081, %1080 ]
  tail call void @free(ptr noundef %1085) #36, !noalias !1020
  %1091 = add nuw i64 %1082, 1
  %1092 = load i64, ptr %1077, align 8, !tbaa !49, !noalias !1020
  %1093 = icmp ult i64 %1091, %1092
  br i1 %1093, label %1080, label %1094, !llvm.loop !1068

1094:                                             ; preds = %1089, %1076, %1074
  %1095 = phi ptr [ %1075, %1074 ], [ %1075, %1076 ], [ %1090, %1089 ]
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %5) #36, !noalias !1020
  %1096 = icmp eq ptr %1055, null
  %1097 = select i1 %1096, ptr @.str, ptr %1055
  store ptr %1097, ptr %5, align 8, !tbaa !600, !noalias !1020
  %1098 = getelementptr inbounds nuw i8, ptr %5, i64 8
  br i1 %1096, label %1101, label %1099

1099:                                             ; preds = %1094
  %1100 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %1055) #33, !noalias !1020
  br label %1101

1101:                                             ; preds = %1099, %1094
  %1102 = phi i64 [ %1100, %1099 ], [ 0, %1094 ]
  store i64 %1102, ptr %1098, align 8, !tbaa !1069, !noalias !1020
  %1103 = getelementptr inbounds nuw i8, ptr %5, i64 16
  store i64 0, ptr %1103, align 8, !tbaa !1070, !noalias !1020
  %1104 = load i1, ptr @uh_curl_init_once.inited, align 4, !noalias !1020
  br i1 %1104, label %1107, label %1105

1105:                                             ; preds = %1101
  %1106 = tail call i32 @curl_global_init(i64 noundef 3) #36, !noalias !1020
  store i1 true, ptr @uh_curl_init_once.inited, align 4, !noalias !1020
  br label %1107

1107:                                             ; preds = %1105, %1101
  %1108 = tail call ptr @curl_easy_init() #36, !noalias !1020
  %1109 = icmp eq ptr %1108, null
  br i1 %1109, label %1110, label %1115

1110:                                             ; preds = %1107
  tail call void @free(ptr noundef %1055) #36, !noalias !1020
  %1111 = icmp eq ptr %1095, null
  br i1 %1111, label %1113, label %1112

1112:                                             ; preds = %1110
  tail call void @curl_slist_free_all(ptr noundef nonnull %1095) #36, !noalias !1020
  br label %1113

1113:                                             ; preds = %1112, %1110
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !1071
  %1114 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %1114, i8 0, i64 32, i1 false), !alias.scope !1020
  br label %1143

1115:                                             ; preds = %1107
  %1116 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 10002, ptr noundef nonnull %4) #36, !noalias !1020
  %1117 = icmp eq ptr %161, null
  %1118 = select i1 %1117, ptr @.str, ptr %161
  %1119 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 10173, ptr noundef nonnull %1118) #36, !noalias !1020
  %1120 = icmp eq ptr %179, null
  %1121 = select i1 %1120, ptr @.str, ptr %179
  %1122 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 10174, ptr noundef nonnull %1121) #36, !noalias !1020
  %1123 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 10186, ptr noundef nonnull %284) #36, !noalias !1020
  %1124 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 10187, ptr noundef %1095) #36, !noalias !1020
  %1125 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 20012, ptr noundef nonnull @uh_smtp_read_cb) #36, !noalias !1020
  %1126 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 10009, ptr noundef nonnull %5) #36, !noalias !1020
  %1127 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 46, i64 noundef 1) #36, !noalias !1020
  br i1 %238, label %1128, label %1130

1128:                                             ; preds = %1115
  %1129 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 119, i64 noundef 3) #36, !noalias !1020
  br label %1130

1130:                                             ; preds = %1128, %1115
  br i1 %257, label %1131, label %1134

1131:                                             ; preds = %1130
  %1132 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 64, i64 noundef 0) #36, !noalias !1020
  %1133 = call i32 (ptr, i32, ...) @curl_easy_setopt(ptr noundef nonnull %1108, i32 noundef 81, i64 noundef 0) #36, !noalias !1020
  br label %1134

1134:                                             ; preds = %1131, %1130
  %1135 = call i32 @curl_easy_perform(ptr noundef nonnull %1108) #36, !noalias !1020
  call void @curl_easy_cleanup(ptr noundef nonnull %1108) #36, !noalias !1020
  %1136 = icmp eq ptr %1095, null
  br i1 %1136, label %1138, label %1137

1137:                                             ; preds = %1134
  call void @curl_slist_free_all(ptr noundef nonnull %1095) #36, !noalias !1020
  br label %1138

1138:                                             ; preds = %1137, %1134
  call void @free(ptr noundef %1055) #36, !noalias !1020
  %1139 = icmp eq i32 %1135, 0
  %1140 = uitofp i1 %1139 to double
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !1074
  %1141 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %1140, ptr %1141, align 8, !tbaa !35, !alias.scope !1074
  %1142 = getelementptr inbounds nuw i8, ptr %0, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %1142, i8 0, i64 24, i1 false), !alias.scope !1074
  br label %1143

1143:                                             ; preds = %1138, %1113
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %5) #36, !noalias !1020
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %4) #36, !noalias !1020
  br label %1146

1144:                                             ; preds = %105, %17, %13, %114, %3
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !1077
  %1145 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %1145, i8 0, i64 32, i1 false), !alias.scope !1077
  br label %1146

1146:                                             ; preds = %398, %1143, %101, %1144
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_crypto_sha256(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = alloca [65 x i8], align 16
  %4 = alloca %struct.UhSha256, align 16
  %5 = alloca [32 x i8], align 16
  %6 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %7 = icmp eq ptr %6, null
  br i1 %7, label %8, label %16

8:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1080)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1080
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %9, align 8, !tbaa !35, !alias.scope !1080
  %10 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %11 = icmp eq ptr %10, null
  br i1 %11, label %13, label %12

12:                                               ; preds = %8
  store i8 0, ptr %10, align 1, !noalias !1080
  br label %13

13:                                               ; preds = %8, %12
  %14 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %10, ptr %14, align 8, !tbaa !46, !alias.scope !1080
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %15, i8 0, i64 16, i1 false), !alias.scope !1080
  br label %62

16:                                               ; preds = %2
  call void @llvm.lifetime.start.p0(i64 112, ptr nonnull %4) #36
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %5) #36
  %17 = getelementptr inbounds nuw i8, ptr %4, i64 104
  store i64 0, ptr %17, align 8, !tbaa !1083
  %18 = getelementptr inbounds nuw i8, ptr %4, i64 32
  store i64 0, ptr %18, align 16, !tbaa !1085
  store <4 x i32> <i32 1779033703, i32 -1150833019, i32 1013904242, i32 -1521486534>, ptr %4, align 16, !tbaa !26
  %19 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store <4 x i32> <i32 1359893119, i32 -1694144372, i32 528734635, i32 1541459225>, ptr %19, align 16, !tbaa !26
  %20 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %6) #33
  %21 = icmp eq i64 %20, 0
  br i1 %21, label %40, label %22

22:                                               ; preds = %16
  %23 = getelementptr inbounds nuw i8, ptr %4, i64 40
  br label %24

24:                                               ; preds = %36, %22
  %25 = phi i64 [ 0, %22 ], [ %37, %36 ]
  %26 = phi i64 [ 0, %22 ], [ %38, %36 ]
  %27 = getelementptr inbounds nuw i8, ptr %6, i64 %26
  %28 = load i8, ptr %27, align 1, !tbaa !76
  %29 = add i64 %25, 1
  store i64 %29, ptr %17, align 8, !tbaa !1083
  %30 = getelementptr inbounds nuw [64 x i8], ptr %23, i64 0, i64 %25
  store i8 %28, ptr %30, align 1, !tbaa !76
  %31 = load i64, ptr %17, align 8, !tbaa !1083
  %32 = icmp eq i64 %31, 64
  br i1 %32, label %33, label %36

33:                                               ; preds = %24
  call fastcc void @uh_sha256_transform(ptr noundef nonnull %4, ptr noundef %23)
  %34 = load i64, ptr %18, align 16, !tbaa !1085
  %35 = add i64 %34, 512
  store i64 %35, ptr %18, align 16, !tbaa !1085
  store i64 0, ptr %17, align 8, !tbaa !1083
  br label %36

36:                                               ; preds = %33, %24
  %37 = phi i64 [ %31, %24 ], [ 0, %33 ]
  %38 = add nuw i64 %26, 1
  %39 = icmp eq i64 %38, %20
  br i1 %39, label %40, label %24, !llvm.loop !1086

40:                                               ; preds = %36, %16
  call fastcc void @uh_sha256_final(ptr noundef %4, ptr noundef %5)
  tail call void @free(ptr noundef nonnull %6) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1087)
  call void @llvm.lifetime.start.p0(i64 65, ptr nonnull %3) #36, !noalias !1087
  br label %49

41:                                               ; preds = %49
  %42 = getelementptr inbounds nuw i8, ptr %3, i64 64
  store i8 0, ptr %42, align 16, !tbaa !76, !noalias !1087
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1090)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1093
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %43, align 8, !tbaa !35, !alias.scope !1093
  %44 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %3) #33, !noalias !1093
  %45 = add i64 %44, 1
  %46 = tail call noalias ptr @malloc(i64 noundef %45) #34
  %47 = icmp eq ptr %46, null
  br i1 %47, label %59, label %48

48:                                               ; preds = %41
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %46, ptr nonnull readonly align 16 %3, i64 %45, i1 false), !noalias !1093
  br label %59

49:                                               ; preds = %49, %40
  %50 = phi i64 [ 0, %40 ], [ %57, %49 ]
  %51 = shl nuw nsw i64 %50, 1
  %52 = getelementptr inbounds nuw i8, ptr %3, i64 %51
  %53 = getelementptr inbounds nuw i8, ptr %5, i64 %50
  %54 = load i8, ptr %53, align 1, !tbaa !76, !noalias !1087
  %55 = zext i8 %54 to i32
  %56 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %52, i64 noundef 3, ptr noundef nonnull @.str.19, i32 noundef %55) #36, !noalias !1087
  %57 = add nuw nsw i64 %50, 1
  %58 = icmp eq i64 %57, 32
  br i1 %58, label %41, label %49, !llvm.loop !1094

59:                                               ; preds = %41, %48
  %60 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %46, ptr %60, align 8, !tbaa !46, !alias.scope !1093
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %61, i8 0, i64 16, i1 false), !alias.scope !1093
  call void @llvm.lifetime.end.p0(i64 65, ptr nonnull %3) #36, !noalias !1087
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %5) #36
  call void @llvm.lifetime.end.p0(i64 112, ptr nonnull %4) #36
  br label %62

62:                                               ; preds = %59, %13
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind sspstrong memory(argmem: readwrite) uwtable
define internal fastcc void @uh_sha256_final(ptr noundef nonnull captures(none) %0, ptr noundef nonnull writeonly captures(none) initializes((0, 32)) %1) unnamed_addr #29 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 104
  %4 = load i64, ptr %3, align 8, !tbaa !1083
  %5 = icmp ult i64 %4, 56
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %7 = getelementptr inbounds nuw [64 x i8], ptr %6, i64 0, i64 %4
  store i8 -128, ptr %7, align 1, !tbaa !76
  br i1 %5, label %8, label %14

8:                                                ; preds = %2
  %9 = icmp eq i64 %4, 55
  br i1 %9, label %22, label %10

10:                                               ; preds = %8
  %11 = getelementptr i8, ptr %0, i64 %4
  %12 = getelementptr i8, ptr %11, i64 41
  %13 = sub nuw nsw i64 55, %4
  tail call void @llvm.memset.p0.i64(ptr align 1 %12, i8 0, i64 %13, i1 false), !tbaa !76
  br label %22

14:                                               ; preds = %2
  %15 = add i64 %4, 1
  %16 = icmp ult i64 %15, 64
  br i1 %16, label %17, label %21

17:                                               ; preds = %14
  %18 = getelementptr i8, ptr %0, i64 %4
  %19 = getelementptr i8, ptr %18, i64 41
  %20 = sub nsw i64 63, %4
  tail call void @llvm.memset.p0.i64(ptr align 1 %19, i8 0, i64 %20, i1 false), !tbaa !76
  br label %21

21:                                               ; preds = %17, %14
  tail call fastcc void @uh_sha256_transform(ptr noundef %0, ptr noundef %6)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %6, i8 0, i64 56, i1 false)
  br label %22

22:                                               ; preds = %10, %8, %21
  %23 = load i64, ptr %3, align 8, !tbaa !1083
  %24 = shl i64 %23, 3
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %26 = load i64, ptr %25, align 8, !tbaa !1085
  %27 = add i64 %26, %24
  store i64 %27, ptr %25, align 8, !tbaa !1085
  %28 = trunc i64 %27 to i8
  %29 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %30 = getelementptr inbounds nuw i8, ptr %0, i64 103
  store i8 %28, ptr %30, align 1, !tbaa !76
  %31 = lshr i64 %27, 8
  %32 = trunc i64 %31 to i8
  %33 = getelementptr inbounds nuw i8, ptr %0, i64 102
  store i8 %32, ptr %33, align 2, !tbaa !76
  %34 = lshr i64 %27, 16
  %35 = trunc i64 %34 to i8
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 101
  store i8 %35, ptr %36, align 1, !tbaa !76
  %37 = lshr i64 %27, 24
  %38 = trunc i64 %37 to i8
  %39 = getelementptr inbounds nuw i8, ptr %0, i64 100
  store i8 %38, ptr %39, align 4, !tbaa !76
  %40 = lshr i64 %27, 32
  %41 = trunc i64 %40 to i8
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 99
  store i8 %41, ptr %42, align 1, !tbaa !76
  %43 = lshr i64 %27, 40
  %44 = trunc i64 %43 to i8
  %45 = getelementptr inbounds nuw i8, ptr %0, i64 98
  store i8 %44, ptr %45, align 2, !tbaa !76
  %46 = lshr i64 %27, 48
  %47 = trunc i64 %46 to i8
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 97
  store i8 %47, ptr %48, align 1, !tbaa !76
  %49 = lshr i64 %27, 56
  %50 = trunc nuw i64 %49 to i8
  %51 = getelementptr inbounds nuw i8, ptr %0, i64 96
  store i8 %50, ptr %51, align 8, !tbaa !76
  tail call fastcc void @uh_sha256_transform(ptr noundef %0, ptr noundef %29)
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %53 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %54 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %55 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %56 = getelementptr inbounds nuw i8, ptr %0, i64 20
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %58 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %59 = load i32, ptr %0, align 8, !tbaa !26
  %60 = lshr i32 %59, 24
  %61 = trunc nuw i32 %60 to i8
  store i8 %61, ptr %1, align 1, !tbaa !76
  %62 = load i32, ptr %52, align 4, !tbaa !26
  %63 = lshr i32 %62, 24
  %64 = trunc nuw i32 %63 to i8
  %65 = getelementptr inbounds nuw i8, ptr %1, i64 4
  store i8 %64, ptr %65, align 1, !tbaa !76
  %66 = load i32, ptr %53, align 8, !tbaa !26
  %67 = lshr i32 %66, 24
  %68 = trunc nuw i32 %67 to i8
  %69 = getelementptr inbounds nuw i8, ptr %1, i64 8
  store i8 %68, ptr %69, align 1, !tbaa !76
  %70 = load i32, ptr %54, align 4, !tbaa !26
  %71 = lshr i32 %70, 24
  %72 = trunc nuw i32 %71 to i8
  %73 = getelementptr inbounds nuw i8, ptr %1, i64 12
  store i8 %72, ptr %73, align 1, !tbaa !76
  %74 = load i32, ptr %55, align 8, !tbaa !26
  %75 = lshr i32 %74, 24
  %76 = trunc nuw i32 %75 to i8
  %77 = getelementptr inbounds nuw i8, ptr %1, i64 16
  store i8 %76, ptr %77, align 1, !tbaa !76
  %78 = load i32, ptr %56, align 4, !tbaa !26
  %79 = lshr i32 %78, 24
  %80 = trunc nuw i32 %79 to i8
  %81 = getelementptr inbounds nuw i8, ptr %1, i64 20
  store i8 %80, ptr %81, align 1, !tbaa !76
  %82 = load i32, ptr %57, align 8, !tbaa !26
  %83 = lshr i32 %82, 24
  %84 = trunc nuw i32 %83 to i8
  %85 = getelementptr inbounds nuw i8, ptr %1, i64 24
  store i8 %84, ptr %85, align 1, !tbaa !76
  %86 = load i32, ptr %58, align 4, !tbaa !26
  %87 = lshr i32 %86, 24
  %88 = trunc nuw i32 %87 to i8
  %89 = getelementptr inbounds nuw i8, ptr %1, i64 28
  store i8 %88, ptr %89, align 1, !tbaa !76
  %90 = load i32, ptr %0, align 8, !tbaa !26
  %91 = lshr i32 %90, 16
  %92 = trunc i32 %91 to i8
  %93 = getelementptr inbounds nuw i8, ptr %1, i64 1
  store i8 %92, ptr %93, align 1, !tbaa !76
  %94 = load i32, ptr %52, align 4, !tbaa !26
  %95 = lshr i32 %94, 16
  %96 = trunc i32 %95 to i8
  %97 = getelementptr inbounds nuw i8, ptr %1, i64 5
  store i8 %96, ptr %97, align 1, !tbaa !76
  %98 = load i32, ptr %53, align 8, !tbaa !26
  %99 = lshr i32 %98, 16
  %100 = trunc i32 %99 to i8
  %101 = getelementptr inbounds nuw i8, ptr %1, i64 9
  store i8 %100, ptr %101, align 1, !tbaa !76
  %102 = load i32, ptr %54, align 4, !tbaa !26
  %103 = lshr i32 %102, 16
  %104 = trunc i32 %103 to i8
  %105 = getelementptr inbounds nuw i8, ptr %1, i64 13
  store i8 %104, ptr %105, align 1, !tbaa !76
  %106 = load i32, ptr %55, align 8, !tbaa !26
  %107 = lshr i32 %106, 16
  %108 = trunc i32 %107 to i8
  %109 = getelementptr inbounds nuw i8, ptr %1, i64 17
  store i8 %108, ptr %109, align 1, !tbaa !76
  %110 = load i32, ptr %56, align 4, !tbaa !26
  %111 = lshr i32 %110, 16
  %112 = trunc i32 %111 to i8
  %113 = getelementptr inbounds nuw i8, ptr %1, i64 21
  store i8 %112, ptr %113, align 1, !tbaa !76
  %114 = load i32, ptr %57, align 8, !tbaa !26
  %115 = lshr i32 %114, 16
  %116 = trunc i32 %115 to i8
  %117 = getelementptr inbounds nuw i8, ptr %1, i64 25
  store i8 %116, ptr %117, align 1, !tbaa !76
  %118 = load i32, ptr %58, align 4, !tbaa !26
  %119 = lshr i32 %118, 16
  %120 = trunc i32 %119 to i8
  %121 = getelementptr inbounds nuw i8, ptr %1, i64 29
  store i8 %120, ptr %121, align 1, !tbaa !76
  %122 = load i32, ptr %0, align 8, !tbaa !26
  %123 = lshr i32 %122, 8
  %124 = trunc i32 %123 to i8
  %125 = getelementptr inbounds nuw i8, ptr %1, i64 2
  store i8 %124, ptr %125, align 1, !tbaa !76
  %126 = load i32, ptr %52, align 4, !tbaa !26
  %127 = lshr i32 %126, 8
  %128 = trunc i32 %127 to i8
  %129 = getelementptr inbounds nuw i8, ptr %1, i64 6
  store i8 %128, ptr %129, align 1, !tbaa !76
  %130 = load i32, ptr %53, align 8, !tbaa !26
  %131 = lshr i32 %130, 8
  %132 = trunc i32 %131 to i8
  %133 = getelementptr inbounds nuw i8, ptr %1, i64 10
  store i8 %132, ptr %133, align 1, !tbaa !76
  %134 = load i32, ptr %54, align 4, !tbaa !26
  %135 = lshr i32 %134, 8
  %136 = trunc i32 %135 to i8
  %137 = getelementptr inbounds nuw i8, ptr %1, i64 14
  store i8 %136, ptr %137, align 1, !tbaa !76
  %138 = load i32, ptr %55, align 8, !tbaa !26
  %139 = lshr i32 %138, 8
  %140 = trunc i32 %139 to i8
  %141 = getelementptr inbounds nuw i8, ptr %1, i64 18
  store i8 %140, ptr %141, align 1, !tbaa !76
  %142 = load i32, ptr %56, align 4, !tbaa !26
  %143 = lshr i32 %142, 8
  %144 = trunc i32 %143 to i8
  %145 = getelementptr inbounds nuw i8, ptr %1, i64 22
  store i8 %144, ptr %145, align 1, !tbaa !76
  %146 = load i32, ptr %57, align 8, !tbaa !26
  %147 = lshr i32 %146, 8
  %148 = trunc i32 %147 to i8
  %149 = getelementptr inbounds nuw i8, ptr %1, i64 26
  store i8 %148, ptr %149, align 1, !tbaa !76
  %150 = load i32, ptr %58, align 4, !tbaa !26
  %151 = lshr i32 %150, 8
  %152 = trunc i32 %151 to i8
  %153 = getelementptr inbounds nuw i8, ptr %1, i64 30
  store i8 %152, ptr %153, align 1, !tbaa !76
  %154 = load i32, ptr %0, align 8, !tbaa !26
  %155 = trunc i32 %154 to i8
  %156 = getelementptr inbounds nuw i8, ptr %1, i64 3
  store i8 %155, ptr %156, align 1, !tbaa !76
  %157 = load i32, ptr %52, align 4, !tbaa !26
  %158 = trunc i32 %157 to i8
  %159 = getelementptr inbounds nuw i8, ptr %1, i64 7
  store i8 %158, ptr %159, align 1, !tbaa !76
  %160 = load i32, ptr %53, align 8, !tbaa !26
  %161 = trunc i32 %160 to i8
  %162 = getelementptr inbounds nuw i8, ptr %1, i64 11
  store i8 %161, ptr %162, align 1, !tbaa !76
  %163 = load i32, ptr %54, align 4, !tbaa !26
  %164 = trunc i32 %163 to i8
  %165 = getelementptr inbounds nuw i8, ptr %1, i64 15
  store i8 %164, ptr %165, align 1, !tbaa !76
  %166 = load i32, ptr %55, align 8, !tbaa !26
  %167 = trunc i32 %166 to i8
  %168 = getelementptr inbounds nuw i8, ptr %1, i64 19
  store i8 %167, ptr %168, align 1, !tbaa !76
  %169 = load i32, ptr %56, align 4, !tbaa !26
  %170 = trunc i32 %169 to i8
  %171 = getelementptr inbounds nuw i8, ptr %1, i64 23
  store i8 %170, ptr %171, align 1, !tbaa !76
  %172 = load i32, ptr %57, align 8, !tbaa !26
  %173 = trunc i32 %172 to i8
  %174 = getelementptr inbounds nuw i8, ptr %1, i64 27
  store i8 %173, ptr %174, align 1, !tbaa !76
  %175 = load i32, ptr %58, align 4, !tbaa !26
  %176 = trunc i32 %175 to i8
  %177 = getelementptr inbounds nuw i8, ptr %1, i64 31
  store i8 %176, ptr %177, align 1, !tbaa !76
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_crypto_hmac_sha256(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca [65 x i8], align 16
  %5 = alloca [64 x i8], align 16
  %6 = alloca %struct.UhSha256, align 16
  %7 = alloca [64 x i8], align 16
  %8 = alloca [64 x i8], align 16
  %9 = alloca %struct.UhSha256, align 16
  %10 = alloca [32 x i8], align 16
  %11 = alloca %struct.UhSha256, align 16
  %12 = alloca [32 x i8], align 16
  %13 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %14 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  %15 = icmp ne ptr %13, null
  %16 = icmp ne ptr %14, null
  %17 = select i1 %15, i1 %16, i1 false
  br i1 %17, label %26, label %18

18:                                               ; preds = %3
  tail call void @free(ptr noundef %13) #36
  tail call void @free(ptr noundef %14) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1095)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1095
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %19, align 8, !tbaa !35, !alias.scope !1095
  %20 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %21 = icmp eq ptr %20, null
  br i1 %21, label %23, label %22

22:                                               ; preds = %18
  store i8 0, ptr %20, align 1, !noalias !1095
  br label %23

23:                                               ; preds = %18, %22
  %24 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %20, ptr %24, align 8, !tbaa !46, !alias.scope !1095
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %25, i8 0, i64 16, i1 false), !alias.scope !1095
  br label %172

26:                                               ; preds = %3
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5) #36
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(64) %5, i8 0, i64 64, i1 false)
  %27 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %14) #33
  %28 = icmp ugt i64 %27, 64
  br i1 %28, label %29, label %51

29:                                               ; preds = %26
  call void @llvm.lifetime.start.p0(i64 112, ptr nonnull %6) #36
  %30 = getelementptr inbounds nuw i8, ptr %6, i64 104
  %31 = getelementptr inbounds nuw i8, ptr %6, i64 32
  store i64 0, ptr %31, align 16, !tbaa !1085
  store <4 x i32> <i32 1779033703, i32 -1150833019, i32 1013904242, i32 -1521486534>, ptr %6, align 16, !tbaa !26
  %32 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store <4 x i32> <i32 1359893119, i32 -1694144372, i32 528734635, i32 1541459225>, ptr %32, align 16, !tbaa !26
  %33 = getelementptr inbounds nuw i8, ptr %6, i64 40
  br label %34

34:                                               ; preds = %46, %29
  %35 = phi i64 [ 0, %29 ], [ %47, %46 ]
  %36 = phi i64 [ 0, %29 ], [ %48, %46 ]
  %37 = getelementptr inbounds nuw i8, ptr %14, i64 %36
  %38 = load i8, ptr %37, align 1, !tbaa !76
  %39 = add i64 %35, 1
  store i64 %39, ptr %30, align 8, !tbaa !1083
  %40 = getelementptr inbounds nuw [64 x i8], ptr %33, i64 0, i64 %35
  store i8 %38, ptr %40, align 1, !tbaa !76
  %41 = load i64, ptr %30, align 8, !tbaa !1083
  %42 = icmp eq i64 %41, 64
  br i1 %42, label %43, label %46

43:                                               ; preds = %34
  call fastcc void @uh_sha256_transform(ptr noundef nonnull %6, ptr noundef %33)
  %44 = load i64, ptr %31, align 16, !tbaa !1085
  %45 = add i64 %44, 512
  store i64 %45, ptr %31, align 16, !tbaa !1085
  store i64 0, ptr %30, align 8, !tbaa !1083
  br label %46

46:                                               ; preds = %43, %34
  %47 = phi i64 [ %41, %34 ], [ 0, %43 ]
  %48 = add nuw i64 %36, 1
  %49 = icmp eq i64 %48, %27
  br i1 %49, label %50, label %34, !llvm.loop !1086

50:                                               ; preds = %46
  call fastcc void @uh_sha256_final(ptr noundef %6, ptr noundef %5)
  call void @llvm.lifetime.end.p0(i64 112, ptr nonnull %6) #36
  br label %52

51:                                               ; preds = %26
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %5, ptr nonnull align 1 %14, i64 %27, i1 false)
  br label %52

52:                                               ; preds = %51, %50
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %7) #36
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %8) #36
  %53 = getelementptr inbounds nuw i8, ptr %5, i64 16
  %54 = load <16 x i8>, ptr %5, align 16, !tbaa !76
  %55 = load <16 x i8>, ptr %53, align 16, !tbaa !76
  %56 = xor <16 x i8> %54, splat (i8 92)
  %57 = xor <16 x i8> %55, splat (i8 92)
  %58 = getelementptr inbounds nuw i8, ptr %7, i64 16
  store <16 x i8> %56, ptr %7, align 16, !tbaa !76
  store <16 x i8> %57, ptr %58, align 16, !tbaa !76
  %59 = xor <16 x i8> %54, splat (i8 54)
  %60 = xor <16 x i8> %55, splat (i8 54)
  %61 = getelementptr inbounds nuw i8, ptr %8, i64 16
  store <16 x i8> %59, ptr %8, align 16, !tbaa !76
  store <16 x i8> %60, ptr %61, align 16, !tbaa !76
  %62 = getelementptr inbounds nuw i8, ptr %5, i64 32
  %63 = getelementptr inbounds nuw i8, ptr %5, i64 48
  %64 = load <16 x i8>, ptr %62, align 16, !tbaa !76
  %65 = load <16 x i8>, ptr %63, align 16, !tbaa !76
  %66 = xor <16 x i8> %64, splat (i8 92)
  %67 = xor <16 x i8> %65, splat (i8 92)
  %68 = getelementptr inbounds nuw i8, ptr %7, i64 32
  %69 = getelementptr inbounds nuw i8, ptr %7, i64 48
  store <16 x i8> %66, ptr %68, align 16, !tbaa !76
  store <16 x i8> %67, ptr %69, align 16, !tbaa !76
  %70 = xor <16 x i8> %64, splat (i8 54)
  %71 = xor <16 x i8> %65, splat (i8 54)
  %72 = getelementptr inbounds nuw i8, ptr %8, i64 32
  %73 = getelementptr inbounds nuw i8, ptr %8, i64 48
  store <16 x i8> %70, ptr %72, align 16, !tbaa !76
  store <16 x i8> %71, ptr %73, align 16, !tbaa !76
  call void @llvm.lifetime.start.p0(i64 112, ptr nonnull %9) #36
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %10) #36
  %74 = getelementptr inbounds nuw i8, ptr %9, i64 104
  %75 = getelementptr inbounds nuw i8, ptr %9, i64 32
  store i64 0, ptr %75, align 16, !tbaa !1085
  store <4 x i32> <i32 1779033703, i32 -1150833019, i32 1013904242, i32 -1521486534>, ptr %9, align 16, !tbaa !26
  %76 = getelementptr inbounds nuw i8, ptr %9, i64 16
  store <4 x i32> <i32 1359893119, i32 -1694144372, i32 528734635, i32 1541459225>, ptr %76, align 16, !tbaa !26
  %77 = getelementptr inbounds nuw i8, ptr %9, i64 40
  br label %78

78:                                               ; preds = %90, %52
  %79 = phi i64 [ 0, %52 ], [ %91, %90 ]
  %80 = phi i64 [ 0, %52 ], [ %92, %90 ]
  %81 = getelementptr inbounds nuw i8, ptr %8, i64 %80
  %82 = load i8, ptr %81, align 1, !tbaa !76
  %83 = add i64 %79, 1
  store i64 %83, ptr %74, align 8, !tbaa !1083
  %84 = getelementptr inbounds nuw [64 x i8], ptr %77, i64 0, i64 %79
  store i8 %82, ptr %84, align 1, !tbaa !76
  %85 = load i64, ptr %74, align 8, !tbaa !1083
  %86 = icmp eq i64 %85, 64
  br i1 %86, label %87, label %90

87:                                               ; preds = %78
  call fastcc void @uh_sha256_transform(ptr noundef nonnull %9, ptr noundef %77)
  %88 = load i64, ptr %75, align 16, !tbaa !1085
  %89 = add i64 %88, 512
  store i64 %89, ptr %75, align 16, !tbaa !1085
  store i64 0, ptr %74, align 8, !tbaa !1083
  br label %90

90:                                               ; preds = %87, %78
  %91 = phi i64 [ %85, %78 ], [ 0, %87 ]
  %92 = add nuw nsw i64 %80, 1
  %93 = icmp eq i64 %92, 64
  br i1 %93, label %94, label %78, !llvm.loop !1086

94:                                               ; preds = %90
  %95 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %13) #33
  %96 = icmp eq i64 %95, 0
  br i1 %96, label %113, label %97

97:                                               ; preds = %94, %109
  %98 = phi i64 [ %110, %109 ], [ %91, %94 ]
  %99 = phi i64 [ %111, %109 ], [ 0, %94 ]
  %100 = getelementptr inbounds nuw i8, ptr %13, i64 %99
  %101 = load i8, ptr %100, align 1, !tbaa !76
  %102 = add i64 %98, 1
  store i64 %102, ptr %74, align 8, !tbaa !1083
  %103 = getelementptr inbounds nuw [64 x i8], ptr %77, i64 0, i64 %98
  store i8 %101, ptr %103, align 1, !tbaa !76
  %104 = load i64, ptr %74, align 8, !tbaa !1083
  %105 = icmp eq i64 %104, 64
  br i1 %105, label %106, label %109

106:                                              ; preds = %97
  call fastcc void @uh_sha256_transform(ptr noundef nonnull %9, ptr noundef %77)
  %107 = load i64, ptr %75, align 16, !tbaa !1085
  %108 = add i64 %107, 512
  store i64 %108, ptr %75, align 16, !tbaa !1085
  store i64 0, ptr %74, align 8, !tbaa !1083
  br label %109

109:                                              ; preds = %106, %97
  %110 = phi i64 [ %104, %97 ], [ 0, %106 ]
  %111 = add nuw i64 %99, 1
  %112 = icmp eq i64 %111, %95
  br i1 %112, label %113, label %97, !llvm.loop !1086

113:                                              ; preds = %109, %94
  call fastcc void @uh_sha256_final(ptr noundef %9, ptr noundef %10)
  call void @llvm.lifetime.start.p0(i64 112, ptr nonnull %11) #36
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %12) #36
  %114 = getelementptr inbounds nuw i8, ptr %11, i64 104
  %115 = getelementptr inbounds nuw i8, ptr %11, i64 32
  store i64 0, ptr %115, align 16, !tbaa !1085
  store <4 x i32> <i32 1779033703, i32 -1150833019, i32 1013904242, i32 -1521486534>, ptr %11, align 16, !tbaa !26
  %116 = getelementptr inbounds nuw i8, ptr %11, i64 16
  store <4 x i32> <i32 1359893119, i32 -1694144372, i32 528734635, i32 1541459225>, ptr %116, align 16, !tbaa !26
  %117 = getelementptr inbounds nuw i8, ptr %11, i64 40
  br label %118

118:                                              ; preds = %130, %113
  %119 = phi i64 [ 0, %113 ], [ %131, %130 ]
  %120 = phi i64 [ 0, %113 ], [ %132, %130 ]
  %121 = getelementptr inbounds nuw i8, ptr %7, i64 %120
  %122 = load i8, ptr %121, align 1, !tbaa !76
  %123 = add i64 %119, 1
  store i64 %123, ptr %114, align 8, !tbaa !1083
  %124 = getelementptr inbounds nuw [64 x i8], ptr %117, i64 0, i64 %119
  store i8 %122, ptr %124, align 1, !tbaa !76
  %125 = load i64, ptr %114, align 8, !tbaa !1083
  %126 = icmp eq i64 %125, 64
  br i1 %126, label %127, label %130

127:                                              ; preds = %118
  call fastcc void @uh_sha256_transform(ptr noundef nonnull %11, ptr noundef %117)
  %128 = load i64, ptr %115, align 16, !tbaa !1085
  %129 = add i64 %128, 512
  store i64 %129, ptr %115, align 16, !tbaa !1085
  store i64 0, ptr %114, align 8, !tbaa !1083
  br label %130

130:                                              ; preds = %127, %118
  %131 = phi i64 [ %125, %118 ], [ 0, %127 ]
  %132 = add nuw nsw i64 %120, 1
  %133 = icmp eq i64 %132, 64
  br i1 %133, label %134, label %118, !llvm.loop !1086

134:                                              ; preds = %130, %146
  %135 = phi i64 [ %147, %146 ], [ %131, %130 ]
  %136 = phi i64 [ %148, %146 ], [ 0, %130 ]
  %137 = getelementptr inbounds nuw i8, ptr %10, i64 %136
  %138 = load i8, ptr %137, align 1, !tbaa !76
  %139 = add i64 %135, 1
  store i64 %139, ptr %114, align 8, !tbaa !1083
  %140 = getelementptr inbounds nuw [64 x i8], ptr %117, i64 0, i64 %135
  store i8 %138, ptr %140, align 1, !tbaa !76
  %141 = load i64, ptr %114, align 8, !tbaa !1083
  %142 = icmp eq i64 %141, 64
  br i1 %142, label %143, label %146

143:                                              ; preds = %134
  call fastcc void @uh_sha256_transform(ptr noundef nonnull %11, ptr noundef %117)
  %144 = load i64, ptr %115, align 16, !tbaa !1085
  %145 = add i64 %144, 512
  store i64 %145, ptr %115, align 16, !tbaa !1085
  store i64 0, ptr %114, align 8, !tbaa !1083
  br label %146

146:                                              ; preds = %143, %134
  %147 = phi i64 [ %141, %134 ], [ 0, %143 ]
  %148 = add nuw nsw i64 %136, 1
  %149 = icmp eq i64 %148, 32
  br i1 %149, label %150, label %134, !llvm.loop !1086

150:                                              ; preds = %146
  call fastcc void @uh_sha256_final(ptr noundef %11, ptr noundef %12)
  tail call void @free(ptr noundef %13) #36
  tail call void @free(ptr noundef %14) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1098)
  call void @llvm.lifetime.start.p0(i64 65, ptr nonnull %4) #36, !noalias !1098
  br label %159

151:                                              ; preds = %159
  %152 = getelementptr inbounds nuw i8, ptr %4, i64 64
  store i8 0, ptr %152, align 16, !tbaa !76, !noalias !1098
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1101)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1104
  %153 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %153, align 8, !tbaa !35, !alias.scope !1104
  %154 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %4) #33, !noalias !1104
  %155 = add i64 %154, 1
  %156 = tail call noalias ptr @malloc(i64 noundef %155) #34
  %157 = icmp eq ptr %156, null
  br i1 %157, label %169, label %158

158:                                              ; preds = %151
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %156, ptr nonnull readonly align 16 %4, i64 %155, i1 false), !noalias !1104
  br label %169

159:                                              ; preds = %159, %150
  %160 = phi i64 [ 0, %150 ], [ %167, %159 ]
  %161 = shl nuw nsw i64 %160, 1
  %162 = getelementptr inbounds nuw i8, ptr %4, i64 %161
  %163 = getelementptr inbounds nuw i8, ptr %12, i64 %160
  %164 = load i8, ptr %163, align 1, !tbaa !76, !noalias !1098
  %165 = zext i8 %164 to i32
  %166 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %162, i64 noundef 3, ptr noundef nonnull @.str.19, i32 noundef %165) #36, !noalias !1098
  %167 = add nuw nsw i64 %160, 1
  %168 = icmp eq i64 %167, 32
  br i1 %168, label %151, label %159, !llvm.loop !1094

169:                                              ; preds = %151, %158
  %170 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %156, ptr %170, align 8, !tbaa !46, !alias.scope !1104
  %171 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %171, i8 0, i64 16, i1 false), !alias.scope !1104
  call void @llvm.lifetime.end.p0(i64 65, ptr nonnull %4) #36, !noalias !1098
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %12) #36
  call void @llvm.lifetime.end.p0(i64 112, ptr nonnull %11) #36
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %10) #36
  call void @llvm.lifetime.end.p0(i64 112, ptr nonnull %9) #36
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %8) #36
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %7) #36
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #36
  br label %172

172:                                              ; preds = %169, %23
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_crypto_random_bytes(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1) local_unnamed_addr #12 {
  %3 = load i32, ptr %1, align 8, !tbaa !31
  %4 = icmp ne i32 %3, 0
  %5 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %6 = load double, ptr %5, align 8
  %7 = fcmp ole double %6, 0.000000e+00
  %8 = select i1 %4, i1 true, i1 %7
  br i1 %8, label %9, label %17

9:                                                ; preds = %2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1105)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1105
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %10, align 8, !tbaa !35, !alias.scope !1105
  %11 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %12 = icmp eq ptr %11, null
  br i1 %12, label %14, label %13

13:                                               ; preds = %9
  store i8 0, ptr %11, align 1, !noalias !1105
  br label %14

14:                                               ; preds = %9, %13
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %11, ptr %15, align 8, !tbaa !46, !alias.scope !1105
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %16, i8 0, i64 16, i1 false), !alias.scope !1105
  br label %99

17:                                               ; preds = %2
  %18 = fptoui double %6 to i64
  %19 = add i64 %18, 1
  %20 = tail call noalias ptr @malloc(i64 noundef %19) #34
  %21 = icmp eq ptr %20, null
  br i1 %21, label %22, label %30

22:                                               ; preds = %17
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1108)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1108
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %23, align 8, !tbaa !35, !alias.scope !1108
  %24 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %25 = icmp eq ptr %24, null
  br i1 %25, label %27, label %26

26:                                               ; preds = %22
  store i8 0, ptr %24, align 1, !noalias !1108
  br label %27

27:                                               ; preds = %22, %26
  %28 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %24, ptr %28, align 8, !tbaa !46, !alias.scope !1108
  %29 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %29, i8 0, i64 16, i1 false), !alias.scope !1108
  br label %99

30:                                               ; preds = %17
  %31 = tail call noalias ptr @fopen(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.1)
  %32 = icmp eq ptr %31, null
  br i1 %32, label %33, label %42

33:                                               ; preds = %30
  %34 = icmp eq i64 %18, 0
  br i1 %34, label %81, label %35

35:                                               ; preds = %33, %35
  %36 = phi i64 [ %40, %35 ], [ 0, %33 ]
  %37 = tail call i32 @rand() #36
  %38 = trunc i32 %37 to i8
  %39 = getelementptr inbounds nuw i8, ptr %20, i64 %36
  store i8 %38, ptr %39, align 1, !tbaa !76
  %40 = add nuw i64 %36, 1
  %41 = icmp eq i64 %40, %18
  br i1 %41, label %46, label %35, !llvm.loop !1111

42:                                               ; preds = %30
  %43 = tail call i64 @fread(ptr noundef nonnull %20, i64 noundef 1, i64 noundef %18, ptr noundef nonnull %31)
  %44 = tail call i32 @fclose(ptr noundef nonnull %31)
  %45 = icmp eq i64 %18, 0
  br i1 %45, label %81, label %46

46:                                               ; preds = %35, %42
  %47 = icmp ult i64 %18, 4
  br i1 %47, label %48, label %50

48:                                               ; preds = %66, %79, %46
  %49 = phi i64 [ 0, %46 ], [ %53, %66 ], [ %71, %79 ]
  br label %92

50:                                               ; preds = %46
  %51 = icmp ult i64 %18, 32
  br i1 %51, label %69, label %52

52:                                               ; preds = %50
  %53 = and i64 %18, -32
  br label %54

54:                                               ; preds = %54, %52
  %55 = phi i64 [ 0, %52 ], [ %62, %54 ]
  %56 = getelementptr inbounds nuw i8, ptr %20, i64 %55
  %57 = getelementptr inbounds nuw i8, ptr %56, i64 16
  %58 = load <16 x i8>, ptr %56, align 1, !tbaa !76
  %59 = load <16 x i8>, ptr %57, align 1, !tbaa !76
  %60 = tail call <16 x i8> @llvm.umax.v16i8(<16 x i8> %58, <16 x i8> splat (i8 1))
  %61 = tail call <16 x i8> @llvm.umax.v16i8(<16 x i8> %59, <16 x i8> splat (i8 1))
  store <16 x i8> %60, ptr %56, align 1
  store <16 x i8> %61, ptr %57, align 1
  %62 = add nuw i64 %55, 32
  %63 = icmp eq i64 %62, %53
  br i1 %63, label %64, label %54, !llvm.loop !1112

64:                                               ; preds = %54
  %65 = icmp eq i64 %53, %18
  br i1 %65, label %81, label %66

66:                                               ; preds = %64
  %67 = and i64 %18, 28
  %68 = icmp eq i64 %67, 0
  br i1 %68, label %48, label %69

69:                                               ; preds = %66, %50
  %70 = phi i64 [ %53, %66 ], [ 0, %50 ]
  %71 = and i64 %18, -4
  br label %72

72:                                               ; preds = %72, %69
  %73 = phi i64 [ %70, %69 ], [ %77, %72 ]
  %74 = getelementptr inbounds nuw i8, ptr %20, i64 %73
  %75 = load <4 x i8>, ptr %74, align 1, !tbaa !76
  %76 = tail call <4 x i8> @llvm.umax.v4i8(<4 x i8> %75, <4 x i8> splat (i8 1))
  store <4 x i8> %76, ptr %74, align 1
  %77 = add nuw i64 %73, 4
  %78 = icmp eq i64 %77, %71
  br i1 %78, label %79, label %72, !llvm.loop !1114

79:                                               ; preds = %72
  %80 = icmp eq i64 %71, %18
  br i1 %80, label %81, label %48

81:                                               ; preds = %92, %64, %79, %33, %42
  %82 = getelementptr inbounds nuw i8, ptr %20, i64 %18
  store i8 0, ptr %82, align 1, !tbaa !76
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1115)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1115
  %83 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %83, align 8, !tbaa !35, !alias.scope !1115
  %84 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %20) #33, !noalias !1115
  %85 = add i64 %84, 1
  %86 = tail call noalias ptr @malloc(i64 noundef %85) #34
  %87 = icmp eq ptr %86, null
  br i1 %87, label %89, label %88

88:                                               ; preds = %81
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %86, ptr nonnull readonly align 1 %20, i64 %85, i1 false), !noalias !1115
  br label %89

89:                                               ; preds = %81, %88
  %90 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %86, ptr %90, align 8, !tbaa !46, !alias.scope !1115
  %91 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %91, i8 0, i64 16, i1 false), !alias.scope !1115
  tail call void @free(ptr noundef nonnull %20) #36
  br label %99

92:                                               ; preds = %48, %92
  %93 = phi i64 [ %97, %92 ], [ %49, %48 ]
  %94 = getelementptr inbounds nuw i8, ptr %20, i64 %93
  %95 = load i8, ptr %94, align 1, !tbaa !76
  %96 = tail call i8 @llvm.umax.i8(i8 %95, i8 1)
  store i8 %96, ptr %94, align 1
  %97 = add nuw i64 %93, 1
  %98 = icmp eq i64 %97, %18
  br i1 %98, label %81, label %92, !llvm.loop !1118

99:                                               ; preds = %27, %89, %14
  ret void
}

; Function Attrs: nounwind
declare i32 @rand() local_unnamed_addr #23

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_crypto_encrypt_aes(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca [32 x i8], align 16
  %5 = alloca [16 x i8], align 16
  %6 = alloca %struct.UhAesCtx, align 1
  %7 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %8 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  %9 = icmp ne ptr %7, null
  %10 = icmp ne ptr %8, null
  %11 = select i1 %9, i1 %10, i1 false
  br i1 %11, label %20, label %12

12:                                               ; preds = %3
  tail call void @free(ptr noundef %7) #36
  tail call void @free(ptr noundef %8) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1119)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1119
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %13, align 8, !tbaa !35, !alias.scope !1119
  %14 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %15 = icmp eq ptr %14, null
  br i1 %15, label %17, label %16

16:                                               ; preds = %12
  store i8 0, ptr %14, align 1, !noalias !1119
  br label %17

17:                                               ; preds = %12, %16
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %14, ptr %18, align 8, !tbaa !46, !alias.scope !1119
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %19, i8 0, i64 16, i1 false), !alias.scope !1119
  br label %649

20:                                               ; preds = %3
  %21 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %7) #33
  %22 = and i64 %21, 15
  %23 = sub nuw nsw i64 16, %22
  %24 = add i64 %23, %21
  %25 = tail call noalias ptr @malloc(i64 noundef %24) #34
  %26 = icmp eq ptr %25, null
  br i1 %26, label %27, label %35

27:                                               ; preds = %20
  tail call void @free(ptr noundef nonnull %7) #36
  tail call void @free(ptr noundef nonnull %8) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1122)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1122
  %28 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %28, align 8, !tbaa !35, !alias.scope !1122
  %29 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %30 = icmp eq ptr %29, null
  br i1 %30, label %32, label %31

31:                                               ; preds = %27
  store i8 0, ptr %29, align 1, !noalias !1122
  br label %32

32:                                               ; preds = %27, %31
  %33 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %29, ptr %33, align 8, !tbaa !46, !alias.scope !1122
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %34, i8 0, i64 16, i1 false), !alias.scope !1122
  br label %649

35:                                               ; preds = %20
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %25, ptr nonnull align 1 %7, i64 %21, i1 false)
  %36 = icmp ult i64 %21, %24
  br i1 %36, label %37, label %40

37:                                               ; preds = %35
  %38 = trunc nuw nsw i64 %23 to i8
  %39 = getelementptr i8, ptr %25, i64 %21
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(1) %39, i8 %38, i64 %23, i1 false), !tbaa !76
  br label %40

40:                                               ; preds = %37, %35
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %4)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %5) #36
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %4, i8 0, i64 32, i1 false)
  %41 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %8) #33
  %42 = tail call i64 @llvm.umin.i64(i64 %41, i64 32)
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %4, ptr nonnull readonly align 1 %8, i64 %42, i1 false)
  %43 = tail call noalias ptr @fopen(ptr noundef nonnull @.str.54, ptr noundef nonnull @.str.1)
  %44 = icmp eq ptr %43, null
  br i1 %44, label %49, label %45

45:                                               ; preds = %40
  %46 = call i64 @fread(ptr noundef nonnull %5, i64 noundef 1, i64 noundef 16, ptr noundef nonnull %43)
  %47 = tail call i32 @fclose(ptr noundef nonnull %43)
  %48 = icmp eq i64 %46, 16
  br i1 %48, label %97, label %49

49:                                               ; preds = %45, %40
  %50 = tail call i32 @rand() #36
  %51 = trunc i32 %50 to i8
  store i8 %51, ptr %5, align 16, !tbaa !76
  %52 = tail call i32 @rand() #36
  %53 = trunc i32 %52 to i8
  %54 = getelementptr inbounds nuw i8, ptr %5, i64 1
  store i8 %53, ptr %54, align 1, !tbaa !76
  %55 = tail call i32 @rand() #36
  %56 = trunc i32 %55 to i8
  %57 = getelementptr inbounds nuw i8, ptr %5, i64 2
  store i8 %56, ptr %57, align 2, !tbaa !76
  %58 = tail call i32 @rand() #36
  %59 = trunc i32 %58 to i8
  %60 = getelementptr inbounds nuw i8, ptr %5, i64 3
  store i8 %59, ptr %60, align 1, !tbaa !76
  %61 = tail call i32 @rand() #36
  %62 = trunc i32 %61 to i8
  %63 = getelementptr inbounds nuw i8, ptr %5, i64 4
  store i8 %62, ptr %63, align 4, !tbaa !76
  %64 = tail call i32 @rand() #36
  %65 = trunc i32 %64 to i8
  %66 = getelementptr inbounds nuw i8, ptr %5, i64 5
  store i8 %65, ptr %66, align 1, !tbaa !76
  %67 = tail call i32 @rand() #36
  %68 = trunc i32 %67 to i8
  %69 = getelementptr inbounds nuw i8, ptr %5, i64 6
  store i8 %68, ptr %69, align 2, !tbaa !76
  %70 = tail call i32 @rand() #36
  %71 = trunc i32 %70 to i8
  %72 = getelementptr inbounds nuw i8, ptr %5, i64 7
  store i8 %71, ptr %72, align 1, !tbaa !76
  %73 = tail call i32 @rand() #36
  %74 = trunc i32 %73 to i8
  %75 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store i8 %74, ptr %75, align 8, !tbaa !76
  %76 = tail call i32 @rand() #36
  %77 = trunc i32 %76 to i8
  %78 = getelementptr inbounds nuw i8, ptr %5, i64 9
  store i8 %77, ptr %78, align 1, !tbaa !76
  %79 = tail call i32 @rand() #36
  %80 = trunc i32 %79 to i8
  %81 = getelementptr inbounds nuw i8, ptr %5, i64 10
  store i8 %80, ptr %81, align 2, !tbaa !76
  %82 = tail call i32 @rand() #36
  %83 = trunc i32 %82 to i8
  %84 = getelementptr inbounds nuw i8, ptr %5, i64 11
  store i8 %83, ptr %84, align 1, !tbaa !76
  %85 = tail call i32 @rand() #36
  %86 = trunc i32 %85 to i8
  %87 = getelementptr inbounds nuw i8, ptr %5, i64 12
  store i8 %86, ptr %87, align 4, !tbaa !76
  %88 = tail call i32 @rand() #36
  %89 = trunc i32 %88 to i8
  %90 = getelementptr inbounds nuw i8, ptr %5, i64 13
  store i8 %89, ptr %90, align 1, !tbaa !76
  %91 = tail call i32 @rand() #36
  %92 = trunc i32 %91 to i8
  %93 = getelementptr inbounds nuw i8, ptr %5, i64 14
  store i8 %92, ptr %93, align 2, !tbaa !76
  %94 = tail call i32 @rand() #36
  %95 = trunc i32 %94 to i8
  %96 = getelementptr inbounds nuw i8, ptr %5, i64 15
  store i8 %95, ptr %96, align 1, !tbaa !76
  br label %97

97:                                               ; preds = %45, %49
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %6) #36
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %6, ptr noundef nonnull readonly align 16 dereferenceable(32) %4, i64 32, i1 false)
  %98 = getelementptr i8, ptr %6, i64 -4
  %99 = getelementptr i8, ptr %6, i64 -32
  br label %100

100:                                              ; preds = %145, %97
  %101 = phi i64 [ 8, %97 ], [ %165, %145 ]
  %102 = shl nuw nsw i64 %101, 2
  %103 = getelementptr i8, ptr %98, i64 %102
  %104 = load i8, ptr %103, align 1, !tbaa !76
  %105 = getelementptr i8, ptr %6, i64 %102
  %106 = getelementptr i8, ptr %105, i64 -3
  %107 = load i8, ptr %106, align 1, !tbaa !76
  %108 = getelementptr i8, ptr %105, i64 -2
  %109 = load i8, ptr %108, align 1, !tbaa !76
  %110 = getelementptr i8, ptr %105, i64 -1
  %111 = load i8, ptr %110, align 1, !tbaa !76
  %112 = trunc nuw nsw i64 %101 to i32
  %113 = and i32 %112, 7
  switch i32 %113, label %145 [
    i32 0, label %114
    i32 4, label %132
  ]

114:                                              ; preds = %100
  %115 = zext i8 %107 to i64
  %116 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %115
  %117 = load i8, ptr %116, align 1, !tbaa !76
  %118 = zext i8 %109 to i64
  %119 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %118
  %120 = load i8, ptr %119, align 1, !tbaa !76
  %121 = zext i8 %111 to i64
  %122 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %121
  %123 = load i8, ptr %122, align 1, !tbaa !76
  %124 = zext i8 %104 to i64
  %125 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %124
  %126 = load i8, ptr %125, align 1, !tbaa !76
  %127 = lshr exact i64 %101, 3
  %128 = and i64 %127, 536870911
  %129 = getelementptr inbounds nuw [11 x i8], ptr @uh_aes_rcon, i64 0, i64 %128
  %130 = load i8, ptr %129, align 1, !tbaa !76
  %131 = xor i8 %130, %117
  br label %145

132:                                              ; preds = %100
  %133 = zext i8 %104 to i64
  %134 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %133
  %135 = load i8, ptr %134, align 1, !tbaa !76
  %136 = zext i8 %107 to i64
  %137 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %136
  %138 = load i8, ptr %137, align 1, !tbaa !76
  %139 = zext i8 %109 to i64
  %140 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %139
  %141 = load i8, ptr %140, align 1, !tbaa !76
  %142 = zext i8 %111 to i64
  %143 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %142
  %144 = load i8, ptr %143, align 1, !tbaa !76
  br label %145

145:                                              ; preds = %132, %114, %100
  %146 = phi i8 [ %126, %114 ], [ %144, %132 ], [ %111, %100 ]
  %147 = phi i8 [ %123, %114 ], [ %141, %132 ], [ %109, %100 ]
  %148 = phi i8 [ %120, %114 ], [ %138, %132 ], [ %107, %100 ]
  %149 = phi i8 [ %131, %114 ], [ %135, %132 ], [ %104, %100 ]
  %150 = getelementptr i8, ptr %99, i64 %102
  %151 = load i8, ptr %150, align 1, !tbaa !76
  %152 = xor i8 %151, %149
  store i8 %152, ptr %105, align 1, !tbaa !76
  %153 = getelementptr i8, ptr %105, i64 -31
  %154 = load i8, ptr %153, align 1, !tbaa !76
  %155 = xor i8 %154, %148
  %156 = getelementptr inbounds nuw i8, ptr %105, i64 1
  store i8 %155, ptr %156, align 1, !tbaa !76
  %157 = getelementptr i8, ptr %105, i64 -30
  %158 = load i8, ptr %157, align 1, !tbaa !76
  %159 = xor i8 %158, %147
  %160 = getelementptr inbounds nuw i8, ptr %105, i64 2
  store i8 %159, ptr %160, align 1, !tbaa !76
  %161 = getelementptr i8, ptr %105, i64 -29
  %162 = load i8, ptr %161, align 1, !tbaa !76
  %163 = xor i8 %162, %146
  %164 = getelementptr inbounds nuw i8, ptr %105, i64 3
  store i8 %163, ptr %164, align 1, !tbaa !76
  %165 = add nuw nsw i64 %101, 1
  %166 = icmp eq i64 %165, 60
  br i1 %166, label %167, label %100, !llvm.loop !1125

167:                                              ; preds = %145
  %168 = getelementptr inbounds nuw i8, ptr %6, i64 240
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(16) %168, ptr noundef nonnull readonly align 16 dereferenceable(16) %5, i64 16, i1 false)
  %169 = icmp eq i64 %24, 0
  br i1 %169, label %605, label %170

170:                                              ; preds = %167
  %171 = getelementptr inbounds nuw i8, ptr %6, i64 1
  %172 = getelementptr inbounds nuw i8, ptr %6, i64 2
  %173 = getelementptr inbounds nuw i8, ptr %6, i64 3
  %174 = getelementptr inbounds nuw i8, ptr %6, i64 4
  %175 = getelementptr inbounds nuw i8, ptr %6, i64 5
  %176 = getelementptr inbounds nuw i8, ptr %6, i64 6
  %177 = getelementptr inbounds nuw i8, ptr %6, i64 7
  %178 = getelementptr inbounds nuw i8, ptr %6, i64 8
  %179 = getelementptr inbounds nuw i8, ptr %6, i64 9
  %180 = getelementptr inbounds nuw i8, ptr %6, i64 10
  %181 = getelementptr inbounds nuw i8, ptr %6, i64 11
  %182 = getelementptr inbounds nuw i8, ptr %6, i64 12
  %183 = getelementptr inbounds nuw i8, ptr %6, i64 13
  %184 = getelementptr inbounds nuw i8, ptr %6, i64 14
  %185 = getelementptr inbounds nuw i8, ptr %6, i64 15
  %186 = getelementptr inbounds nuw i8, ptr %6, i64 224
  %187 = load i8, ptr %168, align 1, !tbaa !76
  %188 = load i8, ptr %6, align 1, !tbaa !76
  %189 = load i8, ptr %171, align 1, !tbaa !76
  %190 = load i8, ptr %172, align 1, !tbaa !76
  %191 = load i8, ptr %173, align 1, !tbaa !76
  %192 = load i8, ptr %174, align 1, !tbaa !76
  %193 = load i8, ptr %175, align 1, !tbaa !76
  %194 = load i8, ptr %176, align 1, !tbaa !76
  %195 = load i8, ptr %177, align 1, !tbaa !76
  %196 = load i8, ptr %178, align 1, !tbaa !76
  %197 = load i8, ptr %179, align 1, !tbaa !76
  %198 = load i8, ptr %180, align 1, !tbaa !76
  %199 = load i8, ptr %181, align 1, !tbaa !76
  %200 = load i8, ptr %182, align 1, !tbaa !76
  %201 = load i8, ptr %183, align 1, !tbaa !76
  %202 = load i8, ptr %184, align 1, !tbaa !76
  %203 = load i8, ptr %185, align 1, !tbaa !76
  %204 = load <16 x i8>, ptr %186, align 1, !tbaa !76
  br label %205

205:                                              ; preds = %536, %170
  %206 = phi i8 [ %187, %170 ], [ %604, %536 ]
  %207 = phi i64 [ 0, %170 ], [ %602, %536 ]
  %208 = phi ptr [ %168, %170 ], [ %209, %536 ]
  %209 = getelementptr inbounds nuw i8, ptr %25, i64 %207
  %210 = load i8, ptr %209, align 1, !tbaa !76
  %211 = xor i8 %210, %206
  store i8 %211, ptr %209, align 1, !tbaa !76
  %212 = getelementptr inbounds nuw i8, ptr %208, i64 1
  %213 = load i8, ptr %212, align 1, !tbaa !76
  %214 = getelementptr inbounds nuw i8, ptr %209, i64 1
  %215 = load i8, ptr %214, align 1, !tbaa !76
  %216 = xor i8 %215, %213
  store i8 %216, ptr %214, align 1, !tbaa !76
  %217 = getelementptr inbounds nuw i8, ptr %208, i64 2
  %218 = load i8, ptr %217, align 1, !tbaa !76
  %219 = getelementptr inbounds nuw i8, ptr %209, i64 2
  %220 = load i8, ptr %219, align 1, !tbaa !76
  %221 = xor i8 %220, %218
  store i8 %221, ptr %219, align 1, !tbaa !76
  %222 = getelementptr inbounds nuw i8, ptr %208, i64 3
  %223 = load i8, ptr %222, align 1, !tbaa !76
  %224 = getelementptr inbounds nuw i8, ptr %209, i64 3
  %225 = load i8, ptr %224, align 1, !tbaa !76
  %226 = xor i8 %225, %223
  store i8 %226, ptr %224, align 1, !tbaa !76
  %227 = getelementptr inbounds nuw i8, ptr %208, i64 4
  %228 = load i8, ptr %227, align 1, !tbaa !76
  %229 = getelementptr inbounds nuw i8, ptr %209, i64 4
  %230 = load i8, ptr %229, align 1, !tbaa !76
  %231 = xor i8 %230, %228
  store i8 %231, ptr %229, align 1, !tbaa !76
  %232 = getelementptr inbounds nuw i8, ptr %208, i64 5
  %233 = load i8, ptr %232, align 1, !tbaa !76
  %234 = getelementptr inbounds nuw i8, ptr %209, i64 5
  %235 = load i8, ptr %234, align 1, !tbaa !76
  %236 = xor i8 %235, %233
  store i8 %236, ptr %234, align 1, !tbaa !76
  %237 = getelementptr inbounds nuw i8, ptr %208, i64 6
  %238 = load i8, ptr %237, align 1, !tbaa !76
  %239 = getelementptr inbounds nuw i8, ptr %209, i64 6
  %240 = load i8, ptr %239, align 1, !tbaa !76
  %241 = xor i8 %240, %238
  store i8 %241, ptr %239, align 1, !tbaa !76
  %242 = getelementptr inbounds nuw i8, ptr %208, i64 7
  %243 = load i8, ptr %242, align 1, !tbaa !76
  %244 = getelementptr inbounds nuw i8, ptr %209, i64 7
  %245 = load i8, ptr %244, align 1, !tbaa !76
  %246 = xor i8 %245, %243
  store i8 %246, ptr %244, align 1, !tbaa !76
  %247 = getelementptr inbounds nuw i8, ptr %208, i64 8
  %248 = load i8, ptr %247, align 1, !tbaa !76
  %249 = getelementptr inbounds nuw i8, ptr %209, i64 8
  %250 = load i8, ptr %249, align 1, !tbaa !76
  %251 = xor i8 %250, %248
  store i8 %251, ptr %249, align 1, !tbaa !76
  %252 = getelementptr inbounds nuw i8, ptr %208, i64 9
  %253 = load i8, ptr %252, align 1, !tbaa !76
  %254 = getelementptr inbounds nuw i8, ptr %209, i64 9
  %255 = load i8, ptr %254, align 1, !tbaa !76
  %256 = xor i8 %255, %253
  store i8 %256, ptr %254, align 1, !tbaa !76
  %257 = getelementptr inbounds nuw i8, ptr %208, i64 10
  %258 = load i8, ptr %257, align 1, !tbaa !76
  %259 = getelementptr inbounds nuw i8, ptr %209, i64 10
  %260 = load i8, ptr %259, align 1, !tbaa !76
  %261 = xor i8 %260, %258
  store i8 %261, ptr %259, align 1, !tbaa !76
  %262 = getelementptr inbounds nuw i8, ptr %208, i64 11
  %263 = load i8, ptr %262, align 1, !tbaa !76
  %264 = getelementptr inbounds nuw i8, ptr %209, i64 11
  %265 = load i8, ptr %264, align 1, !tbaa !76
  %266 = xor i8 %265, %263
  store i8 %266, ptr %264, align 1, !tbaa !76
  %267 = getelementptr inbounds nuw i8, ptr %208, i64 12
  %268 = load i8, ptr %267, align 1, !tbaa !76
  %269 = getelementptr inbounds nuw i8, ptr %209, i64 12
  %270 = load i8, ptr %269, align 1, !tbaa !76
  %271 = xor i8 %270, %268
  store i8 %271, ptr %269, align 1, !tbaa !76
  %272 = getelementptr inbounds nuw i8, ptr %208, i64 13
  %273 = load i8, ptr %272, align 1, !tbaa !76
  %274 = getelementptr inbounds nuw i8, ptr %209, i64 13
  %275 = load i8, ptr %274, align 1, !tbaa !76
  %276 = xor i8 %275, %273
  store i8 %276, ptr %274, align 1, !tbaa !76
  %277 = getelementptr inbounds nuw i8, ptr %208, i64 14
  %278 = load i8, ptr %277, align 1, !tbaa !76
  %279 = getelementptr inbounds nuw i8, ptr %209, i64 14
  %280 = load i8, ptr %279, align 1, !tbaa !76
  %281 = xor i8 %280, %278
  store i8 %281, ptr %279, align 1, !tbaa !76
  %282 = getelementptr inbounds nuw i8, ptr %208, i64 15
  %283 = load i8, ptr %282, align 1, !tbaa !76
  %284 = getelementptr inbounds nuw i8, ptr %209, i64 15
  %285 = load i8, ptr %284, align 1, !tbaa !76
  %286 = xor i8 %285, %283
  %287 = xor i8 %188, %211
  %288 = xor i8 %189, %216
  %289 = xor i8 %190, %221
  %290 = xor i8 %191, %226
  %291 = xor i8 %192, %231
  %292 = xor i8 %193, %236
  %293 = xor i8 %194, %241
  %294 = xor i8 %195, %246
  %295 = xor i8 %196, %251
  %296 = xor i8 %197, %256
  %297 = xor i8 %198, %261
  %298 = xor i8 %199, %266
  %299 = xor i8 %200, %271
  %300 = xor i8 %201, %276
  %301 = xor i8 %202, %281
  %302 = xor i8 %203, %286
  br label %303

303:                                              ; preds = %303, %205
  %304 = phi i64 [ 1, %205 ], [ %534, %303 ]
  %305 = phi i8 [ %287, %205 ], [ %458, %303 ]
  %306 = phi i8 [ %288, %205 ], [ %463, %303 ]
  %307 = phi i8 [ %289, %205 ], [ %468, %303 ]
  %308 = phi i8 [ %290, %205 ], [ %473, %303 ]
  %309 = phi i8 [ %291, %205 ], [ %478, %303 ]
  %310 = phi i8 [ %292, %205 ], [ %483, %303 ]
  %311 = phi i8 [ %293, %205 ], [ %488, %303 ]
  %312 = phi i8 [ %294, %205 ], [ %493, %303 ]
  %313 = phi i8 [ %295, %205 ], [ %498, %303 ]
  %314 = phi i8 [ %296, %205 ], [ %503, %303 ]
  %315 = phi i8 [ %297, %205 ], [ %508, %303 ]
  %316 = phi i8 [ %298, %205 ], [ %513, %303 ]
  %317 = phi i8 [ %299, %205 ], [ %518, %303 ]
  %318 = phi i8 [ %300, %205 ], [ %523, %303 ]
  %319 = phi i8 [ %301, %205 ], [ %528, %303 ]
  %320 = phi i8 [ %302, %205 ], [ %533, %303 ]
  %321 = zext i8 %305 to i64
  %322 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %321
  %323 = load i8, ptr %322, align 1, !tbaa !76
  %324 = zext i8 %306 to i64
  %325 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %324
  %326 = load i8, ptr %325, align 1, !tbaa !76
  %327 = zext i8 %307 to i64
  %328 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %327
  %329 = load i8, ptr %328, align 1, !tbaa !76
  %330 = zext i8 %308 to i64
  %331 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %330
  %332 = load i8, ptr %331, align 1, !tbaa !76
  %333 = zext i8 %309 to i64
  %334 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %333
  %335 = load i8, ptr %334, align 1, !tbaa !76
  %336 = zext i8 %310 to i64
  %337 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %336
  %338 = load i8, ptr %337, align 1, !tbaa !76
  %339 = zext i8 %311 to i64
  %340 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %339
  %341 = load i8, ptr %340, align 1, !tbaa !76
  %342 = zext i8 %312 to i64
  %343 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %342
  %344 = load i8, ptr %343, align 1, !tbaa !76
  %345 = zext i8 %313 to i64
  %346 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %345
  %347 = load i8, ptr %346, align 1, !tbaa !76
  %348 = zext i8 %314 to i64
  %349 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %348
  %350 = load i8, ptr %349, align 1, !tbaa !76
  %351 = zext i8 %315 to i64
  %352 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %351
  %353 = load i8, ptr %352, align 1, !tbaa !76
  %354 = zext i8 %316 to i64
  %355 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %354
  %356 = load i8, ptr %355, align 1, !tbaa !76
  %357 = zext i8 %317 to i64
  %358 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %357
  %359 = load i8, ptr %358, align 1, !tbaa !76
  %360 = zext i8 %318 to i64
  %361 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %360
  %362 = load i8, ptr %361, align 1, !tbaa !76
  %363 = zext i8 %319 to i64
  %364 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %363
  %365 = load i8, ptr %364, align 1, !tbaa !76
  %366 = zext i8 %320 to i64
  %367 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %366
  %368 = load i8, ptr %367, align 1, !tbaa !76
  %369 = xor i8 %338, %323
  %370 = xor i8 %368, %353
  %371 = xor i8 %370, %369
  %372 = shl i8 %369, 1
  %373 = icmp slt i8 %369, 0
  %374 = select i1 %373, i8 27, i8 0
  %375 = xor i8 %372, %374
  %376 = xor i8 %353, %338
  %377 = shl i8 %376, 1
  %378 = icmp slt i8 %376, 0
  %379 = select i1 %378, i8 27, i8 0
  %380 = xor i8 %377, %379
  %381 = shl i8 %370, 1
  %382 = icmp slt i8 %370, 0
  %383 = select i1 %382, i8 27, i8 0
  %384 = xor i8 %381, %383
  %385 = xor i8 %368, %323
  %386 = shl i8 %385, 1
  %387 = icmp slt i8 %385, 0
  %388 = select i1 %387, i8 27, i8 0
  %389 = xor i8 %386, %388
  %390 = xor i8 %350, %335
  %391 = xor i8 %365, %332
  %392 = xor i8 %391, %390
  %393 = shl i8 %390, 1
  %394 = icmp slt i8 %390, 0
  %395 = select i1 %394, i8 27, i8 0
  %396 = xor i8 %393, %395
  %397 = xor i8 %365, %350
  %398 = shl i8 %397, 1
  %399 = icmp slt i8 %397, 0
  %400 = select i1 %399, i8 27, i8 0
  %401 = xor i8 %398, %400
  %402 = shl i8 %391, 1
  %403 = icmp slt i8 %391, 0
  %404 = select i1 %403, i8 27, i8 0
  %405 = xor i8 %402, %404
  %406 = xor i8 %335, %332
  %407 = shl i8 %406, 1
  %408 = icmp slt i8 %406, 0
  %409 = select i1 %408, i8 27, i8 0
  %410 = xor i8 %407, %409
  %411 = xor i8 %362, %347
  %412 = xor i8 %344, %329
  %413 = xor i8 %411, %412
  %414 = shl i8 %411, 1
  %415 = icmp slt i8 %411, 0
  %416 = select i1 %415, i8 27, i8 0
  %417 = xor i8 %414, %416
  %418 = xor i8 %362, %329
  %419 = shl i8 %418, 1
  %420 = icmp slt i8 %418, 0
  %421 = select i1 %420, i8 27, i8 0
  %422 = xor i8 %419, %421
  %423 = shl i8 %412, 1
  %424 = icmp slt i8 %412, 0
  %425 = select i1 %424, i8 27, i8 0
  %426 = xor i8 %423, %425
  %427 = xor i8 %347, %344
  %428 = shl i8 %427, 1
  %429 = icmp slt i8 %427, 0
  %430 = select i1 %429, i8 27, i8 0
  %431 = xor i8 %428, %430
  %432 = xor i8 %359, %326
  %433 = xor i8 %356, %341
  %434 = xor i8 %432, %433
  %435 = shl i8 %432, 1
  %436 = icmp slt i8 %432, 0
  %437 = select i1 %436, i8 27, i8 0
  %438 = xor i8 %435, %437
  %439 = xor i8 %341, %326
  %440 = shl i8 %439, 1
  %441 = icmp slt i8 %439, 0
  %442 = select i1 %441, i8 27, i8 0
  %443 = xor i8 %440, %442
  %444 = shl i8 %433, 1
  %445 = icmp slt i8 %433, 0
  %446 = select i1 %445, i8 27, i8 0
  %447 = xor i8 %444, %446
  %448 = xor i8 %359, %356
  %449 = shl i8 %448, 1
  %450 = icmp slt i8 %448, 0
  %451 = select i1 %450, i8 27, i8 0
  %452 = xor i8 %449, %451
  %453 = shl nuw i64 %304, 4
  %454 = getelementptr inbounds nuw i8, ptr %6, i64 %453
  %455 = load i8, ptr %454, align 1, !tbaa !76
  %456 = xor i8 %375, %455
  %457 = xor i8 %456, %323
  %458 = xor i8 %457, %371
  %459 = getelementptr inbounds nuw i8, ptr %454, i64 1
  %460 = load i8, ptr %459, align 1, !tbaa !76
  %461 = xor i8 %380, %460
  %462 = xor i8 %461, %338
  %463 = xor i8 %462, %371
  %464 = getelementptr inbounds nuw i8, ptr %454, i64 2
  %465 = load i8, ptr %464, align 1, !tbaa !76
  %466 = xor i8 %384, %465
  %467 = xor i8 %466, %353
  %468 = xor i8 %467, %371
  %469 = getelementptr inbounds nuw i8, ptr %454, i64 3
  %470 = load i8, ptr %469, align 1, !tbaa !76
  %471 = xor i8 %389, %470
  %472 = xor i8 %471, %368
  %473 = xor i8 %472, %371
  %474 = getelementptr inbounds nuw i8, ptr %454, i64 4
  %475 = load i8, ptr %474, align 1, !tbaa !76
  %476 = xor i8 %396, %475
  %477 = xor i8 %476, %335
  %478 = xor i8 %477, %392
  %479 = getelementptr inbounds nuw i8, ptr %454, i64 5
  %480 = load i8, ptr %479, align 1, !tbaa !76
  %481 = xor i8 %401, %480
  %482 = xor i8 %481, %350
  %483 = xor i8 %482, %392
  %484 = getelementptr inbounds nuw i8, ptr %454, i64 6
  %485 = load i8, ptr %484, align 1, !tbaa !76
  %486 = xor i8 %405, %485
  %487 = xor i8 %486, %365
  %488 = xor i8 %487, %392
  %489 = getelementptr inbounds nuw i8, ptr %454, i64 7
  %490 = load i8, ptr %489, align 1, !tbaa !76
  %491 = xor i8 %410, %490
  %492 = xor i8 %491, %332
  %493 = xor i8 %492, %392
  %494 = getelementptr inbounds nuw i8, ptr %454, i64 8
  %495 = load i8, ptr %494, align 1, !tbaa !76
  %496 = xor i8 %417, %495
  %497 = xor i8 %496, %347
  %498 = xor i8 %497, %413
  %499 = getelementptr inbounds nuw i8, ptr %454, i64 9
  %500 = load i8, ptr %499, align 1, !tbaa !76
  %501 = xor i8 %422, %500
  %502 = xor i8 %501, %362
  %503 = xor i8 %502, %413
  %504 = getelementptr inbounds nuw i8, ptr %454, i64 10
  %505 = load i8, ptr %504, align 1, !tbaa !76
  %506 = xor i8 %426, %505
  %507 = xor i8 %506, %329
  %508 = xor i8 %507, %413
  %509 = getelementptr inbounds nuw i8, ptr %454, i64 11
  %510 = load i8, ptr %509, align 1, !tbaa !76
  %511 = xor i8 %431, %510
  %512 = xor i8 %511, %344
  %513 = xor i8 %512, %413
  %514 = getelementptr inbounds nuw i8, ptr %454, i64 12
  %515 = load i8, ptr %514, align 1, !tbaa !76
  %516 = xor i8 %438, %515
  %517 = xor i8 %516, %359
  %518 = xor i8 %517, %434
  %519 = getelementptr inbounds nuw i8, ptr %454, i64 13
  %520 = load i8, ptr %519, align 1, !tbaa !76
  %521 = xor i8 %443, %520
  %522 = xor i8 %521, %326
  %523 = xor i8 %522, %434
  %524 = getelementptr inbounds nuw i8, ptr %454, i64 14
  %525 = load i8, ptr %524, align 1, !tbaa !76
  %526 = xor i8 %447, %525
  %527 = xor i8 %526, %341
  %528 = xor i8 %527, %434
  %529 = getelementptr inbounds nuw i8, ptr %454, i64 15
  %530 = load i8, ptr %529, align 1, !tbaa !76
  %531 = xor i8 %452, %530
  %532 = xor i8 %531, %356
  %533 = xor i8 %532, %434
  %534 = add nuw nsw i64 %304, 1
  %535 = icmp eq i64 %534, 14
  br i1 %535, label %536, label %303, !llvm.loop !1126

536:                                              ; preds = %303
  %537 = zext i8 %458 to i64
  %538 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %537
  %539 = load i8, ptr %538, align 1, !tbaa !76
  %540 = zext i8 %463 to i64
  %541 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %540
  %542 = load i8, ptr %541, align 1, !tbaa !76
  %543 = zext i8 %468 to i64
  %544 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %543
  %545 = load i8, ptr %544, align 1, !tbaa !76
  %546 = zext i8 %473 to i64
  %547 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %546
  %548 = load i8, ptr %547, align 1, !tbaa !76
  %549 = zext i8 %478 to i64
  %550 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %549
  %551 = load i8, ptr %550, align 1, !tbaa !76
  %552 = zext i8 %483 to i64
  %553 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %552
  %554 = load i8, ptr %553, align 1, !tbaa !76
  %555 = zext i8 %488 to i64
  %556 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %555
  %557 = load i8, ptr %556, align 1, !tbaa !76
  %558 = zext i8 %493 to i64
  %559 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %558
  %560 = load i8, ptr %559, align 1, !tbaa !76
  %561 = zext i8 %498 to i64
  %562 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %561
  %563 = load i8, ptr %562, align 1, !tbaa !76
  %564 = zext i8 %503 to i64
  %565 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %564
  %566 = load i8, ptr %565, align 1, !tbaa !76
  %567 = zext i8 %508 to i64
  %568 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %567
  %569 = load i8, ptr %568, align 1, !tbaa !76
  %570 = zext i8 %513 to i64
  %571 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %570
  %572 = load i8, ptr %571, align 1, !tbaa !76
  %573 = zext i8 %518 to i64
  %574 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %573
  %575 = load i8, ptr %574, align 1, !tbaa !76
  %576 = zext i8 %523 to i64
  %577 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %576
  %578 = load i8, ptr %577, align 1, !tbaa !76
  %579 = zext i8 %528 to i64
  %580 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %579
  %581 = load i8, ptr %580, align 1, !tbaa !76
  %582 = zext i8 %533 to i64
  %583 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %582
  %584 = load i8, ptr %583, align 1, !tbaa !76
  %585 = insertelement <16 x i8> poison, i8 %539, i64 0
  %586 = insertelement <16 x i8> %585, i8 %554, i64 1
  %587 = insertelement <16 x i8> %586, i8 %569, i64 2
  %588 = insertelement <16 x i8> %587, i8 %584, i64 3
  %589 = insertelement <16 x i8> %588, i8 %551, i64 4
  %590 = insertelement <16 x i8> %589, i8 %566, i64 5
  %591 = insertelement <16 x i8> %590, i8 %581, i64 6
  %592 = insertelement <16 x i8> %591, i8 %548, i64 7
  %593 = insertelement <16 x i8> %592, i8 %563, i64 8
  %594 = insertelement <16 x i8> %593, i8 %578, i64 9
  %595 = insertelement <16 x i8> %594, i8 %545, i64 10
  %596 = insertelement <16 x i8> %595, i8 %560, i64 11
  %597 = insertelement <16 x i8> %596, i8 %575, i64 12
  %598 = insertelement <16 x i8> %597, i8 %542, i64 13
  %599 = insertelement <16 x i8> %598, i8 %557, i64 14
  %600 = insertelement <16 x i8> %599, i8 %572, i64 15
  %601 = xor <16 x i8> %204, %600
  store <16 x i8> %601, ptr %209, align 1, !tbaa !76
  %602 = add nuw i64 %207, 16
  %603 = icmp ult i64 %602, %24
  %604 = extractelement <16 x i8> %601, i64 0
  br i1 %603, label %205, label %605, !llvm.loop !1127

605:                                              ; preds = %536, %167
  %606 = add i64 %24, 16
  %607 = tail call noalias ptr @malloc(i64 noundef %606) #34
  %608 = icmp eq ptr %607, null
  br i1 %608, label %609, label %617

609:                                              ; preds = %605
  tail call void @free(ptr noundef %25) #36
  tail call void @free(ptr noundef %7) #36
  tail call void @free(ptr noundef %8) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1128)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1128
  %610 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %610, align 8, !tbaa !35, !alias.scope !1128
  %611 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %612 = icmp eq ptr %611, null
  br i1 %612, label %614, label %613

613:                                              ; preds = %609
  store i8 0, ptr %611, align 1, !noalias !1128
  br label %614

614:                                              ; preds = %609, %613
  %615 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %611, ptr %615, align 8, !tbaa !46, !alias.scope !1128
  %616 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %616, i8 0, i64 16, i1 false), !alias.scope !1128
  br label %648

617:                                              ; preds = %605
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(16) %607, ptr noundef nonnull align 16 dereferenceable(16) %5, i64 16, i1 false)
  %618 = getelementptr inbounds nuw i8, ptr %607, i64 16
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %618, ptr nonnull align 1 %25, i64 %24, i1 false)
  %619 = shl i64 %606, 1
  %620 = or disjoint i64 %619, 1
  %621 = tail call noalias ptr @malloc(i64 noundef %620) #34
  %622 = icmp eq ptr %621, null
  br i1 %622, label %637, label %623

623:                                              ; preds = %617
  %624 = icmp eq i64 %606, 0
  br i1 %624, label %625, label %627

625:                                              ; preds = %627, %623
  %626 = getelementptr inbounds nuw i8, ptr %621, i64 %619
  store i8 0, ptr %626, align 1, !tbaa !76
  br label %637

627:                                              ; preds = %623, %627
  %628 = phi i64 [ %635, %627 ], [ 0, %623 ]
  %629 = shl i64 %628, 1
  %630 = getelementptr inbounds nuw i8, ptr %621, i64 %629
  %631 = getelementptr inbounds nuw i8, ptr %607, i64 %628
  %632 = load i8, ptr %631, align 1, !tbaa !76
  %633 = zext i8 %632 to i32
  %634 = tail call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %630, i64 noundef 3, ptr noundef nonnull @.str.19, i32 noundef %633) #36
  %635 = add nuw i64 %628, 1
  %636 = icmp eq i64 %635, %606
  br i1 %636, label %625, label %627, !llvm.loop !1131

637:                                              ; preds = %617, %625
  %638 = phi ptr [ @.str, %617 ], [ %621, %625 ]
  tail call void @free(ptr noundef nonnull %607) #36
  tail call void @free(ptr noundef %25) #36
  tail call void @free(ptr noundef %7) #36
  tail call void @free(ptr noundef %8) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1132)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1132
  %639 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %639, align 8, !tbaa !35, !alias.scope !1132
  %640 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %638) #33, !noalias !1132
  %641 = add i64 %640, 1
  %642 = tail call noalias ptr @malloc(i64 noundef %641) #34
  %643 = icmp eq ptr %642, null
  br i1 %643, label %645, label %644

644:                                              ; preds = %637
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %642, ptr nonnull readonly align 1 %638, i64 %641, i1 false), !noalias !1132
  br label %645

645:                                              ; preds = %637, %644
  %646 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %642, ptr %646, align 8, !tbaa !46, !alias.scope !1132
  %647 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %647, i8 0, i64 16, i1 false), !alias.scope !1132
  tail call void @free(ptr noundef %621) #36
  br label %648

648:                                              ; preds = %645, %614
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %6) #36
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %5) #36
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %4)
  br label %649

649:                                              ; preds = %32, %648, %17
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @uh_crypto_decrypt_aes(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %1, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %2) local_unnamed_addr #12 {
  %4 = alloca [16 x i8], align 16
  %5 = alloca i32, align 4
  %6 = alloca [32 x i8], align 16
  %7 = alloca %struct.UhAesCtx, align 16
  %8 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %1)
  %9 = tail call fastcc ptr @uh_value_to_cstr(ptr noundef nonnull byval(%struct.UhValue) align 8 %2)
  %10 = icmp ne ptr %8, null
  %11 = icmp ne ptr %9, null
  %12 = select i1 %10, i1 %11, i1 false
  br i1 %12, label %21, label %13

13:                                               ; preds = %3
  tail call void @free(ptr noundef %8) #36
  tail call void @free(ptr noundef %9) #36
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1135)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1135
  %14 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %14, align 8, !tbaa !35, !alias.scope !1135
  %15 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %16 = icmp eq ptr %15, null
  br i1 %16, label %18, label %17

17:                                               ; preds = %13
  store i8 0, ptr %15, align 1, !noalias !1135
  br label %18

18:                                               ; preds = %13, %17
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %15, ptr %19, align 8, !tbaa !46, !alias.scope !1135
  %20 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %20, i8 0, i64 16, i1 false), !alias.scope !1135
  br label %466

21:                                               ; preds = %3
  %22 = tail call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %8) #33
  %23 = and i64 %22, 1
  %24 = icmp eq i64 %23, 0
  br i1 %24, label %25, label %50

25:                                               ; preds = %21
  %26 = lshr exact i64 %22, 1
  %27 = tail call noalias ptr @malloc(i64 noundef %26) #34
  %28 = icmp eq ptr %27, null
  br i1 %28, label %50, label %29

29:                                               ; preds = %25
  %30 = icmp eq i64 %22, 0
  br i1 %30, label %50, label %31

31:                                               ; preds = %29, %37
  %32 = phi i64 [ %41, %37 ], [ 0, %29 ]
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #36
  %33 = shl nuw i64 %32, 1
  %34 = getelementptr inbounds nuw i8, ptr %8, i64 %33
  %35 = call i32 (ptr, ptr, ...) @__isoc99_sscanf(ptr noundef nonnull readonly %34, ptr noundef nonnull @.str.97, ptr noundef nonnull %5) #36
  %36 = icmp eq i32 %35, 1
  br i1 %36, label %37, label %43

37:                                               ; preds = %31
  %38 = load i32, ptr %5, align 4, !tbaa !26
  %39 = trunc i32 %38 to i8
  %40 = getelementptr inbounds nuw i8, ptr %27, i64 %32
  store i8 %39, ptr %40, align 1, !tbaa !76
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #36
  %41 = add nuw nsw i64 %32, 1
  %42 = icmp eq i64 %41, %26
  br i1 %42, label %44, label %31, !llvm.loop !1138

43:                                               ; preds = %31
  call void @free(ptr noundef %27) #36
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #36
  br label %50

44:                                               ; preds = %37
  %45 = icmp ult i64 %22, 32
  br i1 %45, label %50, label %46

46:                                               ; preds = %44
  %47 = add nsw i64 %26, -16
  %48 = and i64 %22, 30
  %49 = icmp eq i64 %48, 0
  br i1 %49, label %59, label %50

50:                                               ; preds = %29, %25, %43, %21, %46, %44
  %51 = phi ptr [ %27, %46 ], [ %27, %44 ], [ %27, %29 ], [ null, %25 ], [ null, %43 ], [ null, %21 ]
  call void @free(ptr noundef %8) #36
  call void @free(ptr noundef %9) #36
  call void @free(ptr noundef %51) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !1139)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1139
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %52, align 8, !tbaa !35, !alias.scope !1139
  %53 = call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %54 = icmp eq ptr %53, null
  br i1 %54, label %56, label %55

55:                                               ; preds = %50
  store i8 0, ptr %53, align 1, !noalias !1139
  br label %56

56:                                               ; preds = %50, %55
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %53, ptr %57, align 8, !tbaa !46, !alias.scope !1139
  %58 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %58, i8 0, i64 16, i1 false), !alias.scope !1139
  br label %466

59:                                               ; preds = %46
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %6)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %6, i8 0, i64 32, i1 false)
  %60 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %9) #33
  %61 = call i64 @llvm.umin.i64(i64 %60, i64 32)
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %6, ptr nonnull readonly align 1 %9, i64 %61, i1 false)
  %62 = call noalias ptr @malloc(i64 noundef %47) #34
  %63 = icmp eq ptr %62, null
  br i1 %63, label %64, label %72

64:                                               ; preds = %59
  call void @free(ptr noundef %8) #36
  call void @free(ptr noundef nonnull %9) #36
  call void @free(ptr noundef nonnull %27) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !1142)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1142
  %65 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %65, align 8, !tbaa !35, !alias.scope !1142
  %66 = call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %67 = icmp eq ptr %66, null
  br i1 %67, label %69, label %68

68:                                               ; preds = %64
  store i8 0, ptr %66, align 1, !noalias !1142
  br label %69

69:                                               ; preds = %64, %68
  %70 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %66, ptr %70, align 8, !tbaa !46, !alias.scope !1142
  %71 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %71, i8 0, i64 16, i1 false), !alias.scope !1142
  br label %465

72:                                               ; preds = %59
  %73 = getelementptr inbounds nuw i8, ptr %27, i64 16
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %62, ptr nonnull align 1 %73, i64 %47, i1 false)
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %7) #36
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %7, ptr noundef nonnull readonly align 16 dereferenceable(32) %6, i64 32, i1 false)
  %74 = getelementptr i8, ptr %7, i64 -4
  %75 = getelementptr i8, ptr %7, i64 -32
  br label %76

76:                                               ; preds = %121, %72
  %77 = phi i64 [ 8, %72 ], [ %141, %121 ]
  %78 = shl nuw nsw i64 %77, 2
  %79 = getelementptr i8, ptr %74, i64 %78
  %80 = load i8, ptr %79, align 4, !tbaa !76
  %81 = getelementptr i8, ptr %7, i64 %78
  %82 = getelementptr i8, ptr %81, i64 -3
  %83 = load i8, ptr %82, align 1, !tbaa !76
  %84 = getelementptr i8, ptr %81, i64 -2
  %85 = load i8, ptr %84, align 2, !tbaa !76
  %86 = getelementptr i8, ptr %81, i64 -1
  %87 = load i8, ptr %86, align 1, !tbaa !76
  %88 = trunc nuw nsw i64 %77 to i32
  %89 = and i32 %88, 7
  switch i32 %89, label %121 [
    i32 0, label %90
    i32 4, label %108
  ]

90:                                               ; preds = %76
  %91 = zext i8 %83 to i64
  %92 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %91
  %93 = load i8, ptr %92, align 1, !tbaa !76
  %94 = zext i8 %85 to i64
  %95 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %94
  %96 = load i8, ptr %95, align 1, !tbaa !76
  %97 = zext i8 %87 to i64
  %98 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %97
  %99 = load i8, ptr %98, align 1, !tbaa !76
  %100 = zext i8 %80 to i64
  %101 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %100
  %102 = load i8, ptr %101, align 1, !tbaa !76
  %103 = lshr exact i64 %77, 3
  %104 = and i64 %103, 536870911
  %105 = getelementptr inbounds nuw [11 x i8], ptr @uh_aes_rcon, i64 0, i64 %104
  %106 = load i8, ptr %105, align 1, !tbaa !76
  %107 = xor i8 %106, %93
  br label %121

108:                                              ; preds = %76
  %109 = zext i8 %80 to i64
  %110 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %109
  %111 = load i8, ptr %110, align 1, !tbaa !76
  %112 = zext i8 %83 to i64
  %113 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %112
  %114 = load i8, ptr %113, align 1, !tbaa !76
  %115 = zext i8 %85 to i64
  %116 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %115
  %117 = load i8, ptr %116, align 1, !tbaa !76
  %118 = zext i8 %87 to i64
  %119 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_sbox, i64 0, i64 %118
  %120 = load i8, ptr %119, align 1, !tbaa !76
  br label %121

121:                                              ; preds = %108, %90, %76
  %122 = phi i8 [ %102, %90 ], [ %120, %108 ], [ %87, %76 ]
  %123 = phi i8 [ %99, %90 ], [ %117, %108 ], [ %85, %76 ]
  %124 = phi i8 [ %96, %90 ], [ %114, %108 ], [ %83, %76 ]
  %125 = phi i8 [ %107, %90 ], [ %111, %108 ], [ %80, %76 ]
  %126 = getelementptr i8, ptr %75, i64 %78
  %127 = load i8, ptr %126, align 4, !tbaa !76
  %128 = xor i8 %127, %125
  store i8 %128, ptr %81, align 4, !tbaa !76
  %129 = getelementptr i8, ptr %81, i64 -31
  %130 = load i8, ptr %129, align 1, !tbaa !76
  %131 = xor i8 %130, %124
  %132 = getelementptr inbounds nuw i8, ptr %81, i64 1
  store i8 %131, ptr %132, align 1, !tbaa !76
  %133 = getelementptr i8, ptr %81, i64 -30
  %134 = load i8, ptr %133, align 2, !tbaa !76
  %135 = xor i8 %134, %123
  %136 = getelementptr inbounds nuw i8, ptr %81, i64 2
  store i8 %135, ptr %136, align 2, !tbaa !76
  %137 = getelementptr i8, ptr %81, i64 -29
  %138 = load i8, ptr %137, align 1, !tbaa !76
  %139 = xor i8 %138, %122
  %140 = getelementptr inbounds nuw i8, ptr %81, i64 3
  store i8 %139, ptr %140, align 1, !tbaa !76
  %141 = add nuw nsw i64 %77, 1
  %142 = icmp eq i64 %141, 60
  br i1 %142, label %143, label %76, !llvm.loop !1125

143:                                              ; preds = %121
  %144 = getelementptr inbounds nuw i8, ptr %7, i64 240
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %144, ptr noundef nonnull align 1 dereferenceable(16) %27, i64 16, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %4)
  %145 = icmp eq i64 %47, 0
  br i1 %145, label %429, label %146

146:                                              ; preds = %143
  %147 = getelementptr inbounds nuw i8, ptr %7, i64 224
  %148 = load <16 x i8>, ptr %147, align 16, !tbaa !76
  %149 = load <16 x i8>, ptr %7, align 16, !tbaa !76
  br label %150

150:                                              ; preds = %343, %146
  %151 = phi i64 [ 0, %146 ], [ %427, %343 ]
  %152 = getelementptr inbounds nuw i8, ptr %62, i64 %151
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %4, ptr noundef nonnull align 1 dereferenceable(16) %152, i64 16, i1 false)
  %153 = getelementptr inbounds nuw i8, ptr %152, i64 1
  %154 = getelementptr inbounds nuw i8, ptr %152, i64 2
  %155 = getelementptr inbounds nuw i8, ptr %152, i64 3
  %156 = getelementptr inbounds nuw i8, ptr %152, i64 4
  %157 = getelementptr inbounds nuw i8, ptr %152, i64 5
  %158 = getelementptr inbounds nuw i8, ptr %152, i64 6
  %159 = getelementptr inbounds nuw i8, ptr %152, i64 7
  %160 = getelementptr inbounds nuw i8, ptr %152, i64 8
  %161 = getelementptr inbounds nuw i8, ptr %152, i64 9
  %162 = getelementptr inbounds nuw i8, ptr %152, i64 10
  %163 = getelementptr inbounds nuw i8, ptr %152, i64 11
  %164 = getelementptr inbounds nuw i8, ptr %152, i64 12
  %165 = getelementptr inbounds nuw i8, ptr %152, i64 13
  %166 = getelementptr inbounds nuw i8, ptr %152, i64 14
  %167 = getelementptr inbounds nuw i8, ptr %152, i64 15
  %168 = load <16 x i8>, ptr %152, align 1, !tbaa !76
  %169 = xor <16 x i8> %168, %148
  store <16 x i8> %169, ptr %152, align 1, !tbaa !76
  br label %170

170:                                              ; preds = %170, %150
  %171 = phi i64 [ 13, %150 ], [ %341, %170 ]
  %172 = load i8, ptr %165, align 1, !tbaa !76
  %173 = load i8, ptr %161, align 1, !tbaa !76
  %174 = load i8, ptr %157, align 1, !tbaa !76
  %175 = load i8, ptr %153, align 1, !tbaa !76
  %176 = load i8, ptr %154, align 1, !tbaa !76
  %177 = load i8, ptr %162, align 1, !tbaa !76
  %178 = load i8, ptr %158, align 1, !tbaa !76
  %179 = load i8, ptr %166, align 1, !tbaa !76
  %180 = load i8, ptr %155, align 1, !tbaa !76
  %181 = load i8, ptr %159, align 1, !tbaa !76
  %182 = load i8, ptr %163, align 1, !tbaa !76
  %183 = load i8, ptr %167, align 1, !tbaa !76
  %184 = load i8, ptr %152, align 1, !tbaa !76
  %185 = zext i8 %184 to i64
  %186 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %185
  %187 = load i8, ptr %186, align 1, !tbaa !76
  %188 = zext i8 %172 to i64
  %189 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %188
  %190 = load i8, ptr %189, align 1, !tbaa !76
  %191 = zext i8 %177 to i64
  %192 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %191
  %193 = load i8, ptr %192, align 1, !tbaa !76
  %194 = zext i8 %181 to i64
  %195 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %194
  %196 = load i8, ptr %195, align 1, !tbaa !76
  %197 = load i8, ptr %156, align 1, !tbaa !76
  %198 = zext i8 %197 to i64
  %199 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %198
  %200 = load i8, ptr %199, align 1, !tbaa !76
  %201 = zext i8 %175 to i64
  %202 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %201
  %203 = load i8, ptr %202, align 1, !tbaa !76
  %204 = zext i8 %179 to i64
  %205 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %204
  %206 = load i8, ptr %205, align 1, !tbaa !76
  %207 = zext i8 %182 to i64
  %208 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %207
  %209 = load i8, ptr %208, align 1, !tbaa !76
  %210 = load i8, ptr %160, align 1, !tbaa !76
  %211 = zext i8 %210 to i64
  %212 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %211
  %213 = load i8, ptr %212, align 1, !tbaa !76
  %214 = zext i8 %174 to i64
  %215 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %214
  %216 = load i8, ptr %215, align 1, !tbaa !76
  %217 = zext i8 %176 to i64
  %218 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %217
  %219 = load i8, ptr %218, align 1, !tbaa !76
  %220 = zext i8 %183 to i64
  %221 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %220
  %222 = load i8, ptr %221, align 1, !tbaa !76
  %223 = load i8, ptr %164, align 1, !tbaa !76
  %224 = zext i8 %223 to i64
  %225 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %224
  %226 = load i8, ptr %225, align 1, !tbaa !76
  %227 = zext i8 %173 to i64
  %228 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %227
  %229 = load i8, ptr %228, align 1, !tbaa !76
  %230 = zext i8 %178 to i64
  %231 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %230
  %232 = load i8, ptr %231, align 1, !tbaa !76
  %233 = zext i8 %180 to i64
  %234 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %233
  %235 = load i8, ptr %234, align 1, !tbaa !76
  %236 = shl nuw nsw i64 %171, 4
  %237 = getelementptr inbounds nuw i8, ptr %7, i64 %236
  %238 = load <16 x i8>, ptr %237, align 16, !tbaa !76
  %239 = insertelement <16 x i8> poison, i8 %187, i64 0
  %240 = insertelement <16 x i8> %239, i8 %190, i64 1
  %241 = insertelement <16 x i8> %240, i8 %193, i64 2
  %242 = insertelement <16 x i8> %241, i8 %196, i64 3
  %243 = insertelement <16 x i8> %242, i8 %200, i64 4
  %244 = insertelement <16 x i8> %243, i8 %203, i64 5
  %245 = insertelement <16 x i8> %244, i8 %206, i64 6
  %246 = insertelement <16 x i8> %245, i8 %209, i64 7
  %247 = insertelement <16 x i8> %246, i8 %213, i64 8
  %248 = insertelement <16 x i8> %247, i8 %216, i64 9
  %249 = insertelement <16 x i8> %248, i8 %219, i64 10
  %250 = insertelement <16 x i8> %249, i8 %222, i64 11
  %251 = insertelement <16 x i8> %250, i8 %226, i64 12
  %252 = insertelement <16 x i8> %251, i8 %229, i64 13
  %253 = insertelement <16 x i8> %252, i8 %232, i64 14
  %254 = insertelement <16 x i8> %253, i8 %235, i64 15
  %255 = xor <16 x i8> %238, %254
  store <16 x i8> %255, ptr %152, align 1, !tbaa !76
  %256 = shufflevector <16 x i8> %255, <16 x i8> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %257 = shufflevector <16 x i8> %255, <16 x i8> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %258 = shufflevector <16 x i8> %255, <16 x i8> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %259 = shufflevector <16 x i8> %255, <16 x i8> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %260 = shl <4 x i8> %256, splat (i8 1)
  %261 = icmp slt <4 x i8> %256, zeroinitializer
  %262 = select <4 x i1> %261, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %263 = xor <4 x i8> %262, %260
  %264 = shl <4 x i8> %257, splat (i8 1)
  %265 = icmp slt <4 x i8> %257, zeroinitializer
  %266 = select <4 x i1> %265, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %267 = xor <4 x i8> %266, %264
  %268 = shl <4 x i8> %258, splat (i8 1)
  %269 = icmp slt <4 x i8> %258, zeroinitializer
  %270 = select <4 x i1> %269, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %271 = xor <4 x i8> %270, %268
  %272 = shl <4 x i8> %259, splat (i8 1)
  %273 = icmp slt <4 x i8> %259, zeroinitializer
  %274 = select <4 x i1> %273, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %275 = xor <4 x i8> %274, %272
  %276 = shl <4 x i8> %263, splat (i8 1)
  %277 = icmp slt <4 x i8> %260, zeroinitializer
  %278 = select <4 x i1> %277, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %279 = xor <4 x i8> %276, %278
  %280 = shl <4 x i8> %267, splat (i8 1)
  %281 = icmp slt <4 x i8> %264, zeroinitializer
  %282 = select <4 x i1> %281, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %283 = xor <4 x i8> %280, %282
  %284 = shl <4 x i8> %271, splat (i8 1)
  %285 = icmp slt <4 x i8> %268, zeroinitializer
  %286 = select <4 x i1> %285, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %287 = xor <4 x i8> %284, %286
  %288 = shl <4 x i8> %275, splat (i8 1)
  %289 = icmp slt <4 x i8> %272, zeroinitializer
  %290 = select <4 x i1> %289, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %291 = xor <4 x i8> %288, %290
  %292 = shl <4 x i8> %279, splat (i8 1)
  %293 = icmp slt <4 x i8> %276, zeroinitializer
  %294 = select <4 x i1> %293, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %295 = xor <4 x i8> %294, %292
  %296 = shl <4 x i8> %283, splat (i8 1)
  %297 = icmp slt <4 x i8> %280, zeroinitializer
  %298 = select <4 x i1> %297, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %299 = xor <4 x i8> %298, %296
  %300 = shl <4 x i8> %287, splat (i8 1)
  %301 = icmp slt <4 x i8> %284, zeroinitializer
  %302 = select <4 x i1> %301, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %303 = xor <4 x i8> %302, %300
  %304 = shl <4 x i8> %291, splat (i8 1)
  %305 = icmp slt <4 x i8> %288, zeroinitializer
  %306 = select <4 x i1> %305, <4 x i8> splat (i8 27), <4 x i8> zeroinitializer
  %307 = xor <4 x i8> %306, %304
  %308 = xor <4 x i8> %295, %279
  %309 = xor <4 x i8> %299, %283
  %310 = xor <4 x i8> %303, %287
  %311 = xor <4 x i8> %307, %291
  %312 = xor <4 x i8> %259, %258
  %313 = xor <4 x i8> %312, %267
  %314 = xor <4 x i8> %308, %299
  %315 = xor <4 x i8> %314, %257
  %316 = xor <4 x i8> %315, %263
  %317 = xor <4 x i8> %316, %313
  %318 = xor <4 x i8> %317, %307
  %319 = xor <4 x i8> %318, %310
  %320 = xor <4 x i8> %303, %295
  %321 = xor <4 x i8> %320, %256
  %322 = xor <4 x i8> %321, %313
  %323 = xor <4 x i8> %322, %271
  %324 = xor <4 x i8> %323, %309
  %325 = xor <4 x i8> %324, %311
  %326 = xor <4 x i8> %257, %256
  %327 = xor <4 x i8> %326, %275
  %328 = xor <4 x i8> %314, %259
  %329 = xor <4 x i8> %328, %271
  %330 = xor <4 x i8> %329, %327
  %331 = xor <4 x i8> %330, %307
  %332 = xor <4 x i8> %331, %310
  %333 = xor <4 x i8> %320, %258
  %334 = xor <4 x i8> %333, %263
  %335 = xor <4 x i8> %334, %327
  %336 = xor <4 x i8> %335, %309
  %337 = xor <4 x i8> %336, %311
  %338 = shufflevector <4 x i8> %319, <4 x i8> %325, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %339 = shufflevector <4 x i8> %332, <4 x i8> %337, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %340 = shufflevector <8 x i8> %338, <8 x i8> %339, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  store <16 x i8> %340, ptr %152, align 1, !tbaa !76
  %341 = add nsw i64 %171, -1
  %342 = icmp eq i64 %341, 0
  br i1 %342, label %343, label %170, !llvm.loop !1145

343:                                              ; preds = %170
  %344 = load i8, ptr %165, align 1, !tbaa !76
  %345 = load i8, ptr %161, align 1, !tbaa !76
  %346 = load i8, ptr %157, align 1, !tbaa !76
  %347 = load i8, ptr %153, align 1, !tbaa !76
  %348 = load i8, ptr %154, align 1, !tbaa !76
  %349 = load i8, ptr %162, align 1, !tbaa !76
  %350 = load i8, ptr %158, align 1, !tbaa !76
  %351 = load i8, ptr %166, align 1, !tbaa !76
  %352 = load i8, ptr %155, align 1, !tbaa !76
  %353 = load i8, ptr %159, align 1, !tbaa !76
  %354 = load i8, ptr %163, align 1, !tbaa !76
  %355 = load i8, ptr %167, align 1, !tbaa !76
  %356 = load i8, ptr %152, align 1, !tbaa !76
  %357 = zext i8 %356 to i64
  %358 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %357
  %359 = load i8, ptr %358, align 1, !tbaa !76
  %360 = zext i8 %344 to i64
  %361 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %360
  %362 = load i8, ptr %361, align 1, !tbaa !76
  %363 = zext i8 %349 to i64
  %364 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %363
  %365 = load i8, ptr %364, align 1, !tbaa !76
  %366 = zext i8 %353 to i64
  %367 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %366
  %368 = load i8, ptr %367, align 1, !tbaa !76
  %369 = load i8, ptr %156, align 1, !tbaa !76
  %370 = zext i8 %369 to i64
  %371 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %370
  %372 = load i8, ptr %371, align 1, !tbaa !76
  %373 = zext i8 %347 to i64
  %374 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %373
  %375 = load i8, ptr %374, align 1, !tbaa !76
  %376 = zext i8 %351 to i64
  %377 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %376
  %378 = load i8, ptr %377, align 1, !tbaa !76
  %379 = zext i8 %354 to i64
  %380 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %379
  %381 = load i8, ptr %380, align 1, !tbaa !76
  %382 = load i8, ptr %160, align 1, !tbaa !76
  %383 = zext i8 %382 to i64
  %384 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %383
  %385 = load i8, ptr %384, align 1, !tbaa !76
  %386 = zext i8 %346 to i64
  %387 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %386
  %388 = load i8, ptr %387, align 1, !tbaa !76
  %389 = zext i8 %348 to i64
  %390 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %389
  %391 = load i8, ptr %390, align 1, !tbaa !76
  %392 = zext i8 %355 to i64
  %393 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %392
  %394 = load i8, ptr %393, align 1, !tbaa !76
  %395 = load i8, ptr %164, align 1, !tbaa !76
  %396 = zext i8 %395 to i64
  %397 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %396
  %398 = load i8, ptr %397, align 1, !tbaa !76
  %399 = zext i8 %345 to i64
  %400 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %399
  %401 = load i8, ptr %400, align 1, !tbaa !76
  %402 = zext i8 %350 to i64
  %403 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %402
  %404 = load i8, ptr %403, align 1, !tbaa !76
  %405 = zext i8 %352 to i64
  %406 = getelementptr inbounds nuw [256 x i8], ptr @uh_aes_rsbox, i64 0, i64 %405
  %407 = load i8, ptr %406, align 1, !tbaa !76
  %408 = insertelement <16 x i8> poison, i8 %359, i64 0
  %409 = insertelement <16 x i8> %408, i8 %362, i64 1
  %410 = insertelement <16 x i8> %409, i8 %365, i64 2
  %411 = insertelement <16 x i8> %410, i8 %368, i64 3
  %412 = insertelement <16 x i8> %411, i8 %372, i64 4
  %413 = insertelement <16 x i8> %412, i8 %375, i64 5
  %414 = insertelement <16 x i8> %413, i8 %378, i64 6
  %415 = insertelement <16 x i8> %414, i8 %381, i64 7
  %416 = insertelement <16 x i8> %415, i8 %385, i64 8
  %417 = insertelement <16 x i8> %416, i8 %388, i64 9
  %418 = insertelement <16 x i8> %417, i8 %391, i64 10
  %419 = insertelement <16 x i8> %418, i8 %394, i64 11
  %420 = insertelement <16 x i8> %419, i8 %398, i64 12
  %421 = insertelement <16 x i8> %420, i8 %401, i64 13
  %422 = insertelement <16 x i8> %421, i8 %404, i64 14
  %423 = insertelement <16 x i8> %422, i8 %407, i64 15
  %424 = xor <16 x i8> %149, %423
  %425 = load <16 x i8>, ptr %144, align 16, !tbaa !76
  %426 = xor <16 x i8> %425, %424
  store <16 x i8> %426, ptr %152, align 1, !tbaa !76
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %144, ptr noundef nonnull align 16 dereferenceable(16) %4, i64 16, i1 false)
  %427 = add nuw i64 %151, 16
  %428 = icmp ult i64 %427, %47
  br i1 %428, label %150, label %429, !llvm.loop !1146

429:                                              ; preds = %343, %143
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %4)
  %430 = getelementptr i8, ptr %62, i64 %26
  %431 = getelementptr i8, ptr %430, i64 -17
  %432 = load i8, ptr %431, align 1, !tbaa !76
  %433 = add i8 %432, -17
  %434 = icmp ult i8 %433, -16
  %435 = select i1 %434, i8 0, i8 %432
  %436 = zext i8 %435 to i64
  %437 = icmp eq i8 %435, 0
  %438 = icmp ult i64 %47, %436
  %439 = select i1 %437, i1 true, i1 %438
  %440 = select i1 %439, i64 0, i64 %436
  %441 = sub nuw nsw i64 %47, %440
  %442 = add nsw i64 %441, 1
  %443 = call noalias ptr @malloc(i64 noundef %442) #34
  %444 = icmp eq ptr %443, null
  br i1 %444, label %445, label %453

445:                                              ; preds = %429
  call void @free(ptr noundef nonnull %62) #36
  call void @free(ptr noundef %8) #36
  call void @free(ptr noundef %9) #36
  call void @free(ptr noundef %27) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !1147)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1147
  %446 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %446, align 8, !tbaa !35, !alias.scope !1147
  %447 = call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %448 = icmp eq ptr %447, null
  br i1 %448, label %450, label %449

449:                                              ; preds = %445
  store i8 0, ptr %447, align 1, !noalias !1147
  br label %450

450:                                              ; preds = %445, %449
  %451 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %447, ptr %451, align 8, !tbaa !46, !alias.scope !1147
  %452 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %452, i8 0, i64 16, i1 false), !alias.scope !1147
  br label %464

453:                                              ; preds = %429
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %443, ptr nonnull align 1 %62, i64 %441, i1 false)
  %454 = getelementptr inbounds nuw i8, ptr %443, i64 %441
  store i8 0, ptr %454, align 1, !tbaa !76
  call void @free(ptr noundef nonnull %62) #36
  call void @free(ptr noundef %8) #36
  call void @free(ptr noundef %9) #36
  call void @free(ptr noundef %27) #36
  call void @llvm.experimental.noalias.scope.decl(metadata !1150)
  store i32 1, ptr %0, align 8, !tbaa !31, !alias.scope !1150
  %455 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %455, align 8, !tbaa !35, !alias.scope !1150
  %456 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %443) #33, !noalias !1150
  %457 = add i64 %456, 1
  %458 = call noalias ptr @malloc(i64 noundef %457) #34
  %459 = icmp eq ptr %458, null
  br i1 %459, label %461, label %460

460:                                              ; preds = %453
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %458, ptr nonnull readonly align 1 %443, i64 %457, i1 false), !noalias !1150
  br label %461

461:                                              ; preds = %453, %460
  %462 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %458, ptr %462, align 8, !tbaa !46, !alias.scope !1150
  %463 = getelementptr inbounds nuw i8, ptr %0, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %463, i8 0, i64 16, i1 false), !alias.scope !1150
  call void @free(ptr noundef nonnull %443) #36
  br label %464

464:                                              ; preds = %461, %450
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %7) #36
  br label %465

465:                                              ; preds = %464, %69
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %6)
  br label %466

466:                                              ; preds = %56, %465, %18
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define internal fastcc void @uh_json_parse_value(ptr dead_on_unwind noalias writable sret(%struct.UhValue) align 8 captures(address_is_null) %0, ptr noundef nonnull captures(none) %1) unnamed_addr #12 {
  %3 = alloca ptr, align 8
  %4 = alloca %struct.UhValue, align 8
  %5 = alloca ptr, align 8
  %6 = alloca %struct.UhValue, align 8
  %7 = alloca %struct.UhValue, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %8) #36
  %10 = load ptr, ptr %1, align 8, !tbaa !28
  br label %11

11:                                               ; preds = %14, %2
  %12 = phi ptr [ %10, %2 ], [ %15, %14 ]
  %13 = load i8, ptr %12, align 1, !tbaa !76
  switch i8 %13, label %16 [
    i8 32, label %14
    i8 9, label %14
    i8 10, label %14
    i8 13, label %14
  ]

14:                                               ; preds = %11, %11, %11, %11
  %15 = getelementptr inbounds nuw i8, ptr %12, i64 1
  br label %11, !llvm.loop !1153

16:                                               ; preds = %11
  store ptr %12, ptr %8, align 8, !tbaa !28
  switch i8 %13, label %132 [
    i8 34, label %17
    i8 123, label %19
    i8 91, label %72
  ]

17:                                               ; preds = %16
  call fastcc void @uh_json_parse_string(ptr dead_on_unwind writable sret(%struct.UhValue) align 8 %0, ptr noundef %8)
  %18 = load ptr, ptr %8, align 8, !tbaa !28
  store ptr %18, ptr %1, align 8, !tbaa !28
  br label %166

19:                                               ; preds = %16
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %5) #36, !noalias !1154
  %20 = getelementptr inbounds nuw i8, ptr %12, i64 1
  store ptr %20, ptr %5, align 8, !tbaa !28, !noalias !1154
  store i32 3, ptr %0, align 8, !tbaa !31, !alias.scope !1157
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %22 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 32
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %21, i8 0, i64 24, i1 false), !alias.scope !1157
  store ptr %22, ptr %23, align 8, !tbaa !48, !alias.scope !1157
  br label %24

24:                                               ; preds = %27, %19
  %25 = phi ptr [ %20, %19 ], [ %28, %27 ]
  %26 = load i8, ptr %25, align 1, !tbaa !76, !noalias !1154
  switch i8 %26, label %29 [
    i8 32, label %27
    i8 9, label %27
    i8 10, label %27
    i8 13, label %27
  ]

27:                                               ; preds = %24, %24, %24, %24
  %28 = getelementptr inbounds nuw i8, ptr %25, i64 1
  br label %24, !llvm.loop !1153

29:                                               ; preds = %24
  store ptr %25, ptr %5, align 8, !tbaa !28, !noalias !1154
  %30 = load i8, ptr %25, align 1, !tbaa !76
  switch i8 %30, label %33 [
    i8 125, label %31
    i8 0, label %70
  ]

31:                                               ; preds = %29
  %32 = getelementptr inbounds nuw i8, ptr %25, i64 1
  br label %70

33:                                               ; preds = %29, %67
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %6) #36, !noalias !1154
  call fastcc void @uh_json_parse_string(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %6, ptr noundef %5), !noalias !1154
  %34 = load ptr, ptr %5, align 8, !tbaa !28, !noalias !1154
  br label %35

35:                                               ; preds = %38, %33
  %36 = phi ptr [ %34, %33 ], [ %39, %38 ]
  %37 = load i8, ptr %36, align 1, !tbaa !76, !noalias !1154
  switch i8 %37, label %42 [
    i8 32, label %38
    i8 9, label %38
    i8 10, label %38
    i8 13, label %38
    i8 58, label %40
  ]

38:                                               ; preds = %35, %35, %35, %35
  %39 = getelementptr inbounds nuw i8, ptr %36, i64 1
  br label %35, !llvm.loop !1153

40:                                               ; preds = %35
  %41 = getelementptr inbounds nuw i8, ptr %36, i64 1
  br label %42

42:                                               ; preds = %35, %40
  %43 = phi ptr [ %41, %40 ], [ %36, %35 ]
  store ptr %43, ptr %5, align 8, !tbaa !28, !noalias !1154
  br label %44

44:                                               ; preds = %47, %42
  %45 = phi ptr [ %43, %42 ], [ %48, %47 ]
  %46 = load i8, ptr %45, align 1, !tbaa !76, !noalias !1154
  switch i8 %46, label %49 [
    i8 32, label %47
    i8 9, label %47
    i8 10, label %47
    i8 13, label %47
  ]

47:                                               ; preds = %44, %44, %44, %44
  %48 = getelementptr inbounds nuw i8, ptr %45, i64 1
  br label %44, !llvm.loop !1153

49:                                               ; preds = %44
  store ptr %45, ptr %5, align 8, !tbaa !28, !noalias !1154
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %7) #36, !noalias !1154
  call fastcc void @uh_json_parse_value(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %7, ptr noundef %5), !noalias !1154
  call void @uh_dict_set(ptr noundef nonnull align 8 %0, ptr noundef nonnull byval(%struct.UhValue) align 8 %6, ptr noundef nonnull byval(%struct.UhValue) align 8 %7)
  %50 = load ptr, ptr %5, align 8, !tbaa !28, !noalias !1154
  br label %51

51:                                               ; preds = %54, %49
  %52 = phi ptr [ %50, %49 ], [ %55, %54 ]
  %53 = load i8, ptr %52, align 1, !tbaa !76, !noalias !1154
  switch i8 %53, label %65 [
    i8 32, label %54
    i8 9, label %54
    i8 10, label %54
    i8 13, label %54
    i8 44, label %56
    i8 125, label %63
  ]

54:                                               ; preds = %51, %51, %51, %51
  %55 = getelementptr inbounds nuw i8, ptr %52, i64 1
  br label %51, !llvm.loop !1153

56:                                               ; preds = %51
  %57 = getelementptr inbounds nuw i8, ptr %52, i64 1
  store ptr %57, ptr %5, align 8, !tbaa !28, !noalias !1154
  br label %58

58:                                               ; preds = %61, %56
  %59 = phi ptr [ %57, %56 ], [ %62, %61 ]
  %60 = load i8, ptr %59, align 1, !tbaa !76
  switch i8 %60, label %67 [
    i8 32, label %61
    i8 9, label %61
    i8 10, label %61
    i8 13, label %61
  ]

61:                                               ; preds = %58, %58, %58, %58
  %62 = getelementptr inbounds nuw i8, ptr %59, i64 1
  br label %58, !llvm.loop !1153

63:                                               ; preds = %51
  %64 = getelementptr inbounds nuw i8, ptr %52, i64 1
  br label %65

65:                                               ; preds = %51, %63
  %66 = phi ptr [ %64, %63 ], [ %52, %51 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %7) #36, !noalias !1154
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %6) #36, !noalias !1154
  br label %70

67:                                               ; preds = %58
  store ptr %59, ptr %5, align 8, !tbaa !28, !noalias !1154
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %7) #36, !noalias !1154
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %6) #36, !noalias !1154
  %68 = load i8, ptr %59, align 1, !tbaa !76, !noalias !1154
  %69 = icmp eq i8 %68, 0
  br i1 %69, label %70, label %33

70:                                               ; preds = %67, %29, %65, %31
  %71 = phi ptr [ %32, %31 ], [ %66, %65 ], [ %25, %29 ], [ %59, %67 ]
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %5) #36, !noalias !1154
  store ptr %71, ptr %1, align 8, !tbaa !28
  br label %166

72:                                               ; preds = %16
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #36, !noalias !1160
  %73 = getelementptr inbounds nuw i8, ptr %12, i64 1
  store ptr %73, ptr %3, align 8, !tbaa !28, !noalias !1160
  store i32 2, ptr %0, align 8, !tbaa !31, !alias.scope !1163
  %74 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %75 = tail call dereferenceable_or_null(24) ptr @calloc(i64 1, i64 24)
  %76 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %74, i8 0, i64 16, i1 false), !alias.scope !1163
  store ptr %75, ptr %76, align 8, !tbaa !47, !alias.scope !1163
  %77 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store ptr null, ptr %77, align 8, !tbaa !48, !alias.scope !1163
  br label %78

78:                                               ; preds = %81, %72
  %79 = phi ptr [ %73, %72 ], [ %82, %81 ]
  %80 = load i8, ptr %79, align 1, !tbaa !76, !noalias !1160
  switch i8 %80, label %83 [
    i8 32, label %81
    i8 9, label %81
    i8 10, label %81
    i8 13, label %81
  ]

81:                                               ; preds = %78, %78, %78, %78
  %82 = getelementptr inbounds nuw i8, ptr %79, i64 1
  br label %78, !llvm.loop !1153

83:                                               ; preds = %78
  %84 = icmp eq ptr %75, null
  store ptr %79, ptr %3, align 8, !tbaa !28, !noalias !1160
  %85 = load i8, ptr %79, align 1, !tbaa !76
  switch i8 %85, label %86 [
    i8 93, label %89
    i8 0, label %130
  ]

86:                                               ; preds = %83
  %87 = getelementptr inbounds nuw i8, ptr %75, i64 8
  %88 = getelementptr inbounds nuw i8, ptr %75, i64 16
  br label %91

89:                                               ; preds = %83
  %90 = getelementptr inbounds nuw i8, ptr %79, i64 1
  br label %130

91:                                               ; preds = %86, %127
  call void @llvm.lifetime.start.p0(i64 40, ptr nonnull %4) #36, !noalias !1160
  call fastcc void @uh_json_parse_value(ptr dead_on_unwind nonnull writable sret(%struct.UhValue) align 8 %4, ptr noundef %3), !noalias !1160
  br i1 %84, label %109, label %92

92:                                               ; preds = %91
  %93 = load i64, ptr %87, align 8, !tbaa !49
  %94 = load i64, ptr %88, align 8, !tbaa !51
  %95 = icmp eq i64 %93, %94
  %96 = load ptr, ptr %75, align 8, !tbaa !52
  br i1 %95, label %97, label %104

97:                                               ; preds = %92
  %98 = icmp eq i64 %93, 0
  %99 = shl i64 %93, 1
  %100 = select i1 %98, i64 8, i64 %99
  %101 = mul i64 %100, 40
  %102 = call ptr @realloc(ptr noundef %96, i64 noundef %101) #35
  store ptr %102, ptr %75, align 8, !tbaa !52
  store i64 %100, ptr %88, align 8, !tbaa !51
  %103 = load i64, ptr %87, align 8, !tbaa !49
  br label %104

104:                                              ; preds = %97, %92
  %105 = phi i64 [ %103, %97 ], [ %93, %92 ]
  %106 = phi ptr [ %102, %97 ], [ %96, %92 ]
  %107 = add i64 %105, 1
  store i64 %107, ptr %87, align 8, !tbaa !49
  %108 = getelementptr inbounds nuw %struct.UhValue, ptr %106, i64 %105
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(40) %108, ptr noundef nonnull align 8 dereferenceable(40) %4, i64 40, i1 false)
  br label %109

109:                                              ; preds = %91, %104
  %110 = load ptr, ptr %3, align 8, !tbaa !28, !noalias !1160
  br label %111

111:                                              ; preds = %114, %109
  %112 = phi ptr [ %110, %109 ], [ %115, %114 ]
  %113 = load i8, ptr %112, align 1, !tbaa !76, !noalias !1160
  switch i8 %113, label %125 [
    i8 32, label %114
    i8 9, label %114
    i8 10, label %114
    i8 13, label %114
    i8 44, label %116
    i8 93, label %123
  ]

114:                                              ; preds = %111, %111, %111, %111
  %115 = getelementptr inbounds nuw i8, ptr %112, i64 1
  br label %111, !llvm.loop !1153

116:                                              ; preds = %111
  %117 = getelementptr inbounds nuw i8, ptr %112, i64 1
  store ptr %117, ptr %3, align 8, !tbaa !28, !noalias !1160
  br label %118

118:                                              ; preds = %121, %116
  %119 = phi ptr [ %117, %116 ], [ %122, %121 ]
  %120 = load i8, ptr %119, align 1, !tbaa !76
  switch i8 %120, label %127 [
    i8 32, label %121
    i8 9, label %121
    i8 10, label %121
    i8 13, label %121
  ]

121:                                              ; preds = %118, %118, %118, %118
  %122 = getelementptr inbounds nuw i8, ptr %119, i64 1
  br label %118, !llvm.loop !1153

123:                                              ; preds = %111
  %124 = getelementptr inbounds nuw i8, ptr %112, i64 1
  br label %125

125:                                              ; preds = %111, %123
  %126 = phi ptr [ %124, %123 ], [ %112, %111 ]
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4) #36, !noalias !1160
  br label %130

127:                                              ; preds = %118
  store ptr %119, ptr %3, align 8, !tbaa !28, !noalias !1160
  call void @llvm.lifetime.end.p0(i64 40, ptr nonnull %4) #36, !noalias !1160
  %128 = load i8, ptr %119, align 1, !tbaa !76, !noalias !1160
  %129 = icmp eq i8 %128, 0
  br i1 %129, label %130, label %91

130:                                              ; preds = %127, %83, %125, %89
  %131 = phi ptr [ %90, %89 ], [ %126, %125 ], [ %79, %83 ], [ %119, %127 ]
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #36, !noalias !1160
  store ptr %131, ptr %1, align 8, !tbaa !28
  br label %166

132:                                              ; preds = %16
  %133 = tail call i32 @strncmp(ptr noundef nonnull dereferenceable(1) %12, ptr noundef nonnull dereferenceable(5) @.str.98, i64 noundef 4) #33
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %135, label %139

135:                                              ; preds = %132
  %136 = getelementptr inbounds nuw i8, ptr %12, i64 4
  store ptr %136, ptr %1, align 8, !tbaa !28
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !1166
  %137 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 1.000000e+00, ptr %137, align 8, !tbaa !35, !alias.scope !1166
  %138 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %138, i8 0, i64 24, i1 false), !alias.scope !1166
  br label %166

139:                                              ; preds = %132
  %140 = tail call i32 @strncmp(ptr noundef nonnull dereferenceable(1) %12, ptr noundef nonnull dereferenceable(6) @.str.99, i64 noundef 5) #33
  %141 = icmp eq i32 %140, 0
  br i1 %141, label %142, label %145

142:                                              ; preds = %139
  %143 = getelementptr inbounds nuw i8, ptr %12, i64 5
  store ptr %143, ptr %1, align 8, !tbaa !28
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !1169
  %144 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %144, i8 0, i64 32, i1 false)
  br label %166

145:                                              ; preds = %139
  %146 = tail call i32 @strncmp(ptr noundef nonnull dereferenceable(1) %12, ptr noundef nonnull dereferenceable(5) @.str.12, i64 noundef 4) #33
  %147 = icmp eq i32 %146, 0
  br i1 %147, label %148, label %151

148:                                              ; preds = %145
  %149 = getelementptr inbounds nuw i8, ptr %12, i64 4
  store ptr %149, ptr %1, align 8, !tbaa !28
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !1172
  %150 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %150, i8 0, i64 32, i1 false), !alias.scope !1172
  br label %166

151:                                              ; preds = %145
  %152 = add i8 %13, -48
  %153 = icmp ult i8 %152, 10
  %154 = icmp eq i8 %13, 45
  %155 = or i1 %154, %153
  br i1 %155, label %156, label %164

156:                                              ; preds = %151
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %9) #36
  store ptr null, ptr %9, align 8, !tbaa !28
  %157 = call double @strtod(ptr noundef nonnull %12, ptr noundef nonnull %9) #36
  %158 = load ptr, ptr %9, align 8, !tbaa !28
  %159 = icmp eq ptr %158, %12
  br i1 %159, label %163, label %160

160:                                              ; preds = %156
  store ptr %158, ptr %1, align 8, !tbaa !28
  store i32 0, ptr %0, align 8, !tbaa !31, !alias.scope !1175
  %161 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double %157, ptr %161, align 8, !tbaa !35, !alias.scope !1175
  %162 = getelementptr inbounds nuw i8, ptr %0, i64 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %162, i8 0, i64 24, i1 false), !alias.scope !1175
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %9) #36
  br label %166

163:                                              ; preds = %156
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %9) #36
  br label %164

164:                                              ; preds = %151, %163
  store ptr %12, ptr %1, align 8, !tbaa !28
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !1178
  %165 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %165, i8 0, i64 32, i1 false), !alias.scope !1178
  br label %166

166:                                              ; preds = %160, %164, %148, %142, %135, %130, %70, %17
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %8) #36
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define internal fastcc void @uh_json_stringify_value(ptr noundef nonnull %0, ptr noundef nonnull %1, ptr noundef nonnull %2, ptr noundef readonly byval(%struct.UhValue) align 8 captures(none) %3) unnamed_addr #12 {
  %5 = alloca [64 x i8], align 16
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %5) #36
  %6 = load i32, ptr %3, align 8, !tbaa !31
  switch i32 %6, label %67 [
    i32 4, label %7
    i32 0, label %32
    i32 1, label %62
  ]

7:                                                ; preds = %4
  %8 = load i64, ptr %1, align 8, !tbaa !368
  %9 = add i64 %8, 5
  %10 = load i64, ptr %2, align 8, !tbaa !368
  %11 = icmp ugt i64 %9, %10
  br i1 %11, label %14, label %12

12:                                               ; preds = %7
  %13 = load ptr, ptr %0, align 8, !tbaa !28
  br label %26

14:                                               ; preds = %7
  %15 = icmp eq i64 %10, 0
  %16 = shl i64 %10, 1
  %17 = select i1 %15, i64 64, i64 %16
  br label %18

18:                                               ; preds = %18, %14
  %19 = phi i64 [ %17, %14 ], [ %21, %18 ]
  %20 = icmp ult i64 %19, %9
  %21 = shl i64 %19, 1
  br i1 %20, label %18, label %22, !llvm.loop !107

22:                                               ; preds = %18
  %23 = load ptr, ptr %0, align 8, !tbaa !28
  %24 = tail call ptr @realloc(ptr noundef %23, i64 noundef %19) #35
  store ptr %24, ptr %0, align 8, !tbaa !28
  store i64 %19, ptr %2, align 8, !tbaa !368
  %25 = load i64, ptr %1, align 8, !tbaa !368
  br label %26

26:                                               ; preds = %12, %22
  %27 = phi i64 [ %8, %12 ], [ %25, %22 ]
  %28 = phi ptr [ %13, %12 ], [ %24, %22 ]
  %29 = getelementptr inbounds nuw i8, ptr %28, i64 %27
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %29, ptr noundef nonnull align 1 dereferenceable(5) @.str.12, i64 5, i1 false)
  %30 = load i64, ptr %1, align 8, !tbaa !368
  %31 = add i64 %30, 4
  store i64 %31, ptr %1, align 8, !tbaa !368
  br label %311

32:                                               ; preds = %4
  %33 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %34 = load double, ptr %33, align 8, !tbaa !35
  %35 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr noundef nonnull dereferenceable(1) %5, i64 noundef 64, ptr noundef nonnull @.str.21, double noundef %34) #36
  %36 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %5) #33
  %37 = load i64, ptr %1, align 8, !tbaa !368
  %38 = add i64 %36, 1
  %39 = add i64 %38, %37
  %40 = load i64, ptr %2, align 8, !tbaa !368
  %41 = icmp ugt i64 %39, %40
  br i1 %41, label %44, label %42

42:                                               ; preds = %32
  %43 = load ptr, ptr %0, align 8, !tbaa !28
  br label %56

44:                                               ; preds = %32
  %45 = icmp eq i64 %40, 0
  %46 = shl i64 %40, 1
  %47 = select i1 %45, i64 64, i64 %46
  br label %48

48:                                               ; preds = %48, %44
  %49 = phi i64 [ %47, %44 ], [ %51, %48 ]
  %50 = icmp ult i64 %49, %39
  %51 = shl i64 %49, 1
  br i1 %50, label %48, label %52, !llvm.loop !107

52:                                               ; preds = %48
  %53 = load ptr, ptr %0, align 8, !tbaa !28
  %54 = tail call ptr @realloc(ptr noundef %53, i64 noundef %49) #35
  store ptr %54, ptr %0, align 8, !tbaa !28
  store i64 %49, ptr %2, align 8, !tbaa !368
  %55 = load i64, ptr %1, align 8, !tbaa !368
  br label %56

56:                                               ; preds = %42, %52
  %57 = phi i64 [ %37, %42 ], [ %55, %52 ]
  %58 = phi ptr [ %43, %42 ], [ %54, %52 ]
  %59 = getelementptr inbounds nuw i8, ptr %58, i64 %57
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %59, ptr nonnull readonly align 16 %5, i64 %38, i1 false)
  %60 = load i64, ptr %1, align 8, !tbaa !368
  %61 = add i64 %60, %36
  store i64 %61, ptr %1, align 8, !tbaa !368
  br label %311

62:                                               ; preds = %4
  %63 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %64 = load ptr, ptr %63, align 8, !tbaa !46
  %65 = icmp eq ptr %64, null
  %66 = select i1 %65, ptr @.str, ptr %64
  tail call fastcc void @uh_json_escape(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef nonnull %66)
  br label %311

67:                                               ; preds = %4
  %68 = icmp eq i32 %6, 2
  %69 = getelementptr inbounds nuw i8, ptr %3, i64 24
  %70 = load ptr, ptr %69, align 8
  %71 = icmp ne ptr %70, null
  %72 = select i1 %68, i1 %71, i1 false
  br i1 %72, label %73, label %164

73:                                               ; preds = %67
  %74 = load i64, ptr %1, align 8, !tbaa !368
  %75 = add i64 %74, 2
  %76 = load i64, ptr %2, align 8, !tbaa !368
  %77 = icmp ugt i64 %75, %76
  br i1 %77, label %80, label %78

78:                                               ; preds = %73
  %79 = load ptr, ptr %0, align 8, !tbaa !28
  br label %92

80:                                               ; preds = %73
  %81 = icmp eq i64 %76, 0
  %82 = shl i64 %76, 1
  %83 = select i1 %81, i64 64, i64 %82
  br label %84

84:                                               ; preds = %84, %80
  %85 = phi i64 [ %83, %80 ], [ %87, %84 ]
  %86 = icmp ult i64 %85, %75
  %87 = shl i64 %85, 1
  br i1 %86, label %84, label %88, !llvm.loop !107

88:                                               ; preds = %84
  %89 = load ptr, ptr %0, align 8, !tbaa !28
  %90 = tail call ptr @realloc(ptr noundef %89, i64 noundef %85) #35
  store ptr %90, ptr %0, align 8, !tbaa !28
  store i64 %85, ptr %2, align 8, !tbaa !368
  %91 = load i64, ptr %1, align 8, !tbaa !368
  br label %92

92:                                               ; preds = %78, %88
  %93 = phi i64 [ %74, %78 ], [ %91, %88 ]
  %94 = phi ptr [ %79, %78 ], [ %90, %88 ]
  %95 = getelementptr inbounds nuw i8, ptr %94, i64 %93
  store i16 91, ptr %95, align 1
  %96 = load i64, ptr %1, align 8, !tbaa !368
  %97 = add i64 %96, 1
  store i64 %97, ptr %1, align 8, !tbaa !368
  %98 = getelementptr inbounds nuw i8, ptr %70, i64 8
  %99 = load i64, ptr %98, align 8, !tbaa !49
  %100 = icmp eq i64 %99, 0
  br i1 %100, label %103, label %128

101:                                              ; preds = %161
  %102 = load i64, ptr %1, align 8, !tbaa !368
  br label %103

103:                                              ; preds = %101, %92
  %104 = phi i64 [ %102, %101 ], [ %97, %92 ]
  %105 = add i64 %104, 2
  %106 = load i64, ptr %2, align 8, !tbaa !368
  %107 = icmp ugt i64 %105, %106
  br i1 %107, label %110, label %108

108:                                              ; preds = %103
  %109 = load ptr, ptr %0, align 8, !tbaa !28
  br label %122

110:                                              ; preds = %103
  %111 = icmp eq i64 %106, 0
  %112 = shl i64 %106, 1
  %113 = select i1 %111, i64 64, i64 %112
  br label %114

114:                                              ; preds = %114, %110
  %115 = phi i64 [ %113, %110 ], [ %117, %114 ]
  %116 = icmp ult i64 %115, %105
  %117 = shl i64 %115, 1
  br i1 %116, label %114, label %118, !llvm.loop !107

118:                                              ; preds = %114
  %119 = load ptr, ptr %0, align 8, !tbaa !28
  %120 = tail call ptr @realloc(ptr noundef %119, i64 noundef %115) #35
  store ptr %120, ptr %0, align 8, !tbaa !28
  store i64 %115, ptr %2, align 8, !tbaa !368
  %121 = load i64, ptr %1, align 8, !tbaa !368
  br label %122

122:                                              ; preds = %108, %118
  %123 = phi i64 [ %104, %108 ], [ %121, %118 ]
  %124 = phi ptr [ %109, %108 ], [ %120, %118 ]
  %125 = getelementptr inbounds nuw i8, ptr %124, i64 %123
  store i16 93, ptr %125, align 1
  %126 = load i64, ptr %1, align 8, !tbaa !368
  %127 = add i64 %126, 1
  store i64 %127, ptr %1, align 8, !tbaa !368
  br label %311

128:                                              ; preds = %92, %161
  %129 = phi i64 [ %132, %161 ], [ 0, %92 ]
  %130 = load ptr, ptr %70, align 8, !tbaa !52
  %131 = getelementptr inbounds nuw %struct.UhValue, ptr %130, i64 %129
  tail call fastcc void @uh_json_stringify_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef byval(%struct.UhValue) align 8 %131)
  %132 = add nuw i64 %129, 1
  %133 = load i64, ptr %98, align 8, !tbaa !49
  %134 = icmp ult i64 %132, %133
  br i1 %134, label %135, label %161

135:                                              ; preds = %128
  %136 = load i64, ptr %1, align 8, !tbaa !368
  %137 = add i64 %136, 2
  %138 = load i64, ptr %2, align 8, !tbaa !368
  %139 = icmp ugt i64 %137, %138
  br i1 %139, label %142, label %140

140:                                              ; preds = %135
  %141 = load ptr, ptr %0, align 8, !tbaa !28
  br label %154

142:                                              ; preds = %135
  %143 = icmp eq i64 %138, 0
  %144 = shl i64 %138, 1
  %145 = select i1 %143, i64 64, i64 %144
  br label %146

146:                                              ; preds = %146, %142
  %147 = phi i64 [ %145, %142 ], [ %149, %146 ]
  %148 = icmp ult i64 %147, %137
  %149 = shl i64 %147, 1
  br i1 %148, label %146, label %150, !llvm.loop !107

150:                                              ; preds = %146
  %151 = load ptr, ptr %0, align 8, !tbaa !28
  %152 = tail call ptr @realloc(ptr noundef %151, i64 noundef %147) #35
  store ptr %152, ptr %0, align 8, !tbaa !28
  store i64 %147, ptr %2, align 8, !tbaa !368
  %153 = load i64, ptr %1, align 8, !tbaa !368
  br label %154

154:                                              ; preds = %140, %150
  %155 = phi i64 [ %136, %140 ], [ %153, %150 ]
  %156 = phi ptr [ %141, %140 ], [ %152, %150 ]
  %157 = getelementptr inbounds nuw i8, ptr %156, i64 %155
  store i16 44, ptr %157, align 1
  %158 = load i64, ptr %1, align 8, !tbaa !368
  %159 = add i64 %158, 1
  store i64 %159, ptr %1, align 8, !tbaa !368
  %160 = load i64, ptr %98, align 8, !tbaa !49
  br label %161

161:                                              ; preds = %128, %154
  %162 = phi i64 [ %133, %128 ], [ %160, %154 ]
  %163 = icmp ult i64 %132, %162
  br i1 %163, label %128, label %101, !llvm.loop !1181

164:                                              ; preds = %67
  %165 = icmp eq i32 %6, 3
  %166 = getelementptr inbounds nuw i8, ptr %3, i64 32
  %167 = load ptr, ptr %166, align 8
  %168 = icmp ne ptr %167, null
  %169 = select i1 %165, i1 %168, i1 false
  %170 = load i64, ptr %1, align 8, !tbaa !368
  %171 = load i64, ptr %2, align 8, !tbaa !368
  br i1 %169, label %172, label %288

172:                                              ; preds = %164
  %173 = add i64 %170, 2
  %174 = icmp ugt i64 %173, %171
  br i1 %174, label %177, label %175

175:                                              ; preds = %172
  %176 = load ptr, ptr %0, align 8, !tbaa !28
  br label %189

177:                                              ; preds = %172
  %178 = icmp eq i64 %171, 0
  %179 = shl i64 %171, 1
  %180 = select i1 %178, i64 64, i64 %179
  br label %181

181:                                              ; preds = %181, %177
  %182 = phi i64 [ %180, %177 ], [ %184, %181 ]
  %183 = icmp ult i64 %182, %173
  %184 = shl i64 %182, 1
  br i1 %183, label %181, label %185, !llvm.loop !107

185:                                              ; preds = %181
  %186 = load ptr, ptr %0, align 8, !tbaa !28
  %187 = tail call ptr @realloc(ptr noundef %186, i64 noundef %182) #35
  store ptr %187, ptr %0, align 8, !tbaa !28
  store i64 %182, ptr %2, align 8, !tbaa !368
  %188 = load i64, ptr %1, align 8, !tbaa !368
  br label %189

189:                                              ; preds = %175, %185
  %190 = phi i64 [ %170, %175 ], [ %188, %185 ]
  %191 = phi ptr [ %176, %175 ], [ %187, %185 ]
  %192 = getelementptr inbounds nuw i8, ptr %191, i64 %190
  store i16 123, ptr %192, align 1
  %193 = load i64, ptr %1, align 8, !tbaa !368
  %194 = add i64 %193, 1
  store i64 %194, ptr %1, align 8, !tbaa !368
  %195 = getelementptr inbounds nuw i8, ptr %167, i64 8
  %196 = load i64, ptr %195, align 8, !tbaa !65
  %197 = icmp eq i64 %196, 0
  br i1 %197, label %200, label %225

198:                                              ; preds = %285
  %199 = load i64, ptr %1, align 8, !tbaa !368
  br label %200

200:                                              ; preds = %198, %189
  %201 = phi i64 [ %199, %198 ], [ %194, %189 ]
  %202 = add i64 %201, 2
  %203 = load i64, ptr %2, align 8, !tbaa !368
  %204 = icmp ugt i64 %202, %203
  br i1 %204, label %207, label %205

205:                                              ; preds = %200
  %206 = load ptr, ptr %0, align 8, !tbaa !28
  br label %219

207:                                              ; preds = %200
  %208 = icmp eq i64 %203, 0
  %209 = shl i64 %203, 1
  %210 = select i1 %208, i64 64, i64 %209
  br label %211

211:                                              ; preds = %211, %207
  %212 = phi i64 [ %210, %207 ], [ %214, %211 ]
  %213 = icmp ult i64 %212, %202
  %214 = shl i64 %212, 1
  br i1 %213, label %211, label %215, !llvm.loop !107

215:                                              ; preds = %211
  %216 = load ptr, ptr %0, align 8, !tbaa !28
  %217 = tail call ptr @realloc(ptr noundef %216, i64 noundef %212) #35
  store ptr %217, ptr %0, align 8, !tbaa !28
  store i64 %212, ptr %2, align 8, !tbaa !368
  %218 = load i64, ptr %1, align 8, !tbaa !368
  br label %219

219:                                              ; preds = %205, %215
  %220 = phi i64 [ %201, %205 ], [ %218, %215 ]
  %221 = phi ptr [ %206, %205 ], [ %217, %215 ]
  %222 = getelementptr inbounds nuw i8, ptr %221, i64 %220
  store i16 125, ptr %222, align 1
  %223 = load i64, ptr %1, align 8, !tbaa !368
  %224 = add i64 %223, 1
  store i64 %224, ptr %1, align 8, !tbaa !368
  br label %311

225:                                              ; preds = %189, %285
  %226 = phi i64 [ %256, %285 ], [ 0, %189 ]
  %227 = load ptr, ptr %167, align 8, !tbaa !68
  %228 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %227, i64 %226
  %229 = load ptr, ptr %228, align 8, !tbaa !70
  tail call fastcc void @uh_json_escape(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %229)
  %230 = load i64, ptr %1, align 8, !tbaa !368
  %231 = add i64 %230, 2
  %232 = load i64, ptr %2, align 8, !tbaa !368
  %233 = icmp ugt i64 %231, %232
  br i1 %233, label %236, label %234

234:                                              ; preds = %225
  %235 = load ptr, ptr %0, align 8, !tbaa !28
  br label %248

236:                                              ; preds = %225
  %237 = icmp eq i64 %232, 0
  %238 = shl i64 %232, 1
  %239 = select i1 %237, i64 64, i64 %238
  br label %240

240:                                              ; preds = %240, %236
  %241 = phi i64 [ %239, %236 ], [ %243, %240 ]
  %242 = icmp ult i64 %241, %231
  %243 = shl i64 %241, 1
  br i1 %242, label %240, label %244, !llvm.loop !107

244:                                              ; preds = %240
  %245 = load ptr, ptr %0, align 8, !tbaa !28
  %246 = tail call ptr @realloc(ptr noundef %245, i64 noundef %241) #35
  store ptr %246, ptr %0, align 8, !tbaa !28
  store i64 %241, ptr %2, align 8, !tbaa !368
  %247 = load i64, ptr %1, align 8, !tbaa !368
  br label %248

248:                                              ; preds = %234, %244
  %249 = phi i64 [ %230, %234 ], [ %247, %244 ]
  %250 = phi ptr [ %235, %234 ], [ %246, %244 ]
  %251 = getelementptr inbounds nuw i8, ptr %250, i64 %249
  store i16 58, ptr %251, align 1
  %252 = load i64, ptr %1, align 8, !tbaa !368
  %253 = add i64 %252, 1
  store i64 %253, ptr %1, align 8, !tbaa !368
  %254 = load ptr, ptr %167, align 8, !tbaa !68
  %255 = getelementptr inbounds nuw %struct.UhDictEntry, ptr %254, i64 %226, i32 1
  tail call fastcc void @uh_json_stringify_value(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef nonnull byval(%struct.UhValue) align 8 %255)
  %256 = add nuw i64 %226, 1
  %257 = load i64, ptr %195, align 8, !tbaa !65
  %258 = icmp ult i64 %256, %257
  br i1 %258, label %259, label %285

259:                                              ; preds = %248
  %260 = load i64, ptr %1, align 8, !tbaa !368
  %261 = add i64 %260, 2
  %262 = load i64, ptr %2, align 8, !tbaa !368
  %263 = icmp ugt i64 %261, %262
  br i1 %263, label %266, label %264

264:                                              ; preds = %259
  %265 = load ptr, ptr %0, align 8, !tbaa !28
  br label %278

266:                                              ; preds = %259
  %267 = icmp eq i64 %262, 0
  %268 = shl i64 %262, 1
  %269 = select i1 %267, i64 64, i64 %268
  br label %270

270:                                              ; preds = %270, %266
  %271 = phi i64 [ %269, %266 ], [ %273, %270 ]
  %272 = icmp ult i64 %271, %261
  %273 = shl i64 %271, 1
  br i1 %272, label %270, label %274, !llvm.loop !107

274:                                              ; preds = %270
  %275 = load ptr, ptr %0, align 8, !tbaa !28
  %276 = tail call ptr @realloc(ptr noundef %275, i64 noundef %271) #35
  store ptr %276, ptr %0, align 8, !tbaa !28
  store i64 %271, ptr %2, align 8, !tbaa !368
  %277 = load i64, ptr %1, align 8, !tbaa !368
  br label %278

278:                                              ; preds = %264, %274
  %279 = phi i64 [ %260, %264 ], [ %277, %274 ]
  %280 = phi ptr [ %265, %264 ], [ %276, %274 ]
  %281 = getelementptr inbounds nuw i8, ptr %280, i64 %279
  store i16 44, ptr %281, align 1
  %282 = load i64, ptr %1, align 8, !tbaa !368
  %283 = add i64 %282, 1
  store i64 %283, ptr %1, align 8, !tbaa !368
  %284 = load i64, ptr %195, align 8, !tbaa !65
  br label %285

285:                                              ; preds = %248, %278
  %286 = phi i64 [ %257, %248 ], [ %284, %278 ]
  %287 = icmp ult i64 %256, %286
  br i1 %287, label %225, label %198, !llvm.loop !1182

288:                                              ; preds = %164
  %289 = add i64 %170, 5
  %290 = icmp ugt i64 %289, %171
  br i1 %290, label %293, label %291

291:                                              ; preds = %288
  %292 = load ptr, ptr %0, align 8, !tbaa !28
  br label %305

293:                                              ; preds = %288
  %294 = icmp eq i64 %171, 0
  %295 = shl i64 %171, 1
  %296 = select i1 %294, i64 64, i64 %295
  br label %297

297:                                              ; preds = %297, %293
  %298 = phi i64 [ %296, %293 ], [ %300, %297 ]
  %299 = icmp ult i64 %298, %289
  %300 = shl i64 %298, 1
  br i1 %299, label %297, label %301, !llvm.loop !107

301:                                              ; preds = %297
  %302 = load ptr, ptr %0, align 8, !tbaa !28
  %303 = tail call ptr @realloc(ptr noundef %302, i64 noundef %298) #35
  store ptr %303, ptr %0, align 8, !tbaa !28
  store i64 %298, ptr %2, align 8, !tbaa !368
  %304 = load i64, ptr %1, align 8, !tbaa !368
  br label %305

305:                                              ; preds = %291, %301
  %306 = phi i64 [ %170, %291 ], [ %304, %301 ]
  %307 = phi ptr [ %292, %291 ], [ %303, %301 ]
  %308 = getelementptr inbounds nuw i8, ptr %307, i64 %306
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %308, ptr noundef nonnull align 1 dereferenceable(5) @.str.12, i64 5, i1 false)
  %309 = load i64, ptr %1, align 8, !tbaa !368
  %310 = add i64 %309, 4
  store i64 %310, ptr %1, align 8, !tbaa !368
  br label %311

311:                                              ; preds = %305, %219, %122, %62, %56, %26
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %5) #36
  ret void
}

declare i32 @curl_global_init(i64 noundef) local_unnamed_addr #22

; Function Attrs: nounwind
declare i32 @pthread_mutex_init(ptr noundef, ptr noundef) local_unnamed_addr #23

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr noundef, i32 noundef, i64 noundef) local_unnamed_addr #15

; Function Attrs: nofree norecurse nosync nounwind sspstrong memory(argmem: readwrite) uwtable
define internal fastcc void @uh_sha1_final(ptr noundef nonnull captures(none) %0, ptr noundef nonnull writeonly captures(none) initializes((0, 20)) %1) unnamed_addr #29 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 96
  %4 = load i64, ptr %3, align 8, !tbaa !907
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %6 = add i64 %4, 1
  %7 = getelementptr inbounds nuw [64 x i8], ptr %5, i64 0, i64 %4
  store i8 -128, ptr %7, align 1, !tbaa !76
  %8 = icmp ugt i64 %6, 56
  br i1 %8, label %9, label %16

9:                                                ; preds = %2
  %10 = icmp ult i64 %6, 64
  br i1 %10, label %11, label %15

11:                                               ; preds = %9
  %12 = getelementptr i8, ptr %0, i64 %4
  %13 = getelementptr i8, ptr %12, i64 33
  %14 = sub nuw nsw i64 63, %4
  tail call void @llvm.memset.p0.i64(ptr align 1 %13, i8 0, i64 %14, i1 false), !tbaa !76
  br label %15

15:                                               ; preds = %9, %11
  tail call fastcc void @uh_sha1_transform(ptr noundef %0, ptr noundef %5)
  br label %18

16:                                               ; preds = %2
  %17 = icmp eq i64 %6, 56
  br i1 %17, label %23, label %18

18:                                               ; preds = %15, %16
  %19 = phi i64 [ 0, %15 ], [ %6, %16 ]
  %20 = getelementptr i8, ptr %0, i64 %19
  %21 = getelementptr i8, ptr %20, i64 32
  %22 = sub nuw nsw i64 56, %19
  tail call void @llvm.memset.p0.i64(ptr align 1 %21, i8 0, i64 %22, i1 false), !tbaa !76
  br label %23

23:                                               ; preds = %18, %16
  %24 = load i64, ptr %3, align 8, !tbaa !907
  %25 = shl i64 %24, 3
  %26 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %27 = load i64, ptr %26, align 8, !tbaa !909
  %28 = add i64 %27, %25
  store i64 %28, ptr %26, align 8, !tbaa !909
  %29 = lshr i64 %28, 56
  %30 = trunc nuw i64 %29 to i8
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 88
  store i8 %30, ptr %31, align 8, !tbaa !76
  %32 = lshr i64 %28, 48
  %33 = trunc i64 %32 to i8
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 89
  store i8 %33, ptr %34, align 1, !tbaa !76
  %35 = lshr i64 %28, 40
  %36 = trunc i64 %35 to i8
  %37 = getelementptr inbounds nuw i8, ptr %0, i64 90
  store i8 %36, ptr %37, align 2, !tbaa !76
  %38 = lshr i64 %28, 32
  %39 = trunc i64 %38 to i8
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 91
  store i8 %39, ptr %40, align 1, !tbaa !76
  %41 = lshr i64 %28, 24
  %42 = trunc i64 %41 to i8
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 92
  store i8 %42, ptr %43, align 4, !tbaa !76
  %44 = lshr i64 %28, 16
  %45 = trunc i64 %44 to i8
  %46 = getelementptr inbounds nuw i8, ptr %0, i64 93
  store i8 %45, ptr %46, align 1, !tbaa !76
  %47 = lshr i64 %28, 8
  %48 = trunc i64 %47 to i8
  %49 = getelementptr inbounds nuw i8, ptr %0, i64 94
  store i8 %48, ptr %49, align 2, !tbaa !76
  %50 = trunc i64 %28 to i8
  %51 = getelementptr inbounds nuw i8, ptr %0, i64 95
  store i8 %50, ptr %51, align 1, !tbaa !76
  tail call fastcc void @uh_sha1_transform(ptr noundef %0, ptr noundef %5)
  %52 = load i32, ptr %0, align 4, !tbaa !26
  %53 = lshr i32 %52, 24
  %54 = trunc nuw i32 %53 to i8
  store i8 %54, ptr %1, align 1, !tbaa !76
  %55 = load i32, ptr %0, align 4, !tbaa !26
  %56 = lshr i32 %55, 16
  %57 = trunc i32 %56 to i8
  %58 = getelementptr inbounds nuw i8, ptr %1, i64 1
  store i8 %57, ptr %58, align 1, !tbaa !76
  %59 = load i32, ptr %0, align 4, !tbaa !26
  %60 = lshr i32 %59, 8
  %61 = trunc i32 %60 to i8
  %62 = getelementptr inbounds nuw i8, ptr %1, i64 2
  store i8 %61, ptr %62, align 1, !tbaa !76
  %63 = load i32, ptr %0, align 4, !tbaa !26
  %64 = trunc i32 %63 to i8
  %65 = getelementptr inbounds nuw i8, ptr %1, i64 3
  store i8 %64, ptr %65, align 1, !tbaa !76
  %66 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %67 = load i32, ptr %66, align 4, !tbaa !26
  %68 = lshr i32 %67, 24
  %69 = trunc nuw i32 %68 to i8
  %70 = getelementptr inbounds nuw i8, ptr %1, i64 4
  store i8 %69, ptr %70, align 1, !tbaa !76
  %71 = load i32, ptr %66, align 4, !tbaa !26
  %72 = lshr i32 %71, 16
  %73 = trunc i32 %72 to i8
  %74 = getelementptr inbounds nuw i8, ptr %1, i64 5
  store i8 %73, ptr %74, align 1, !tbaa !76
  %75 = load i32, ptr %66, align 4, !tbaa !26
  %76 = lshr i32 %75, 8
  %77 = trunc i32 %76 to i8
  %78 = getelementptr inbounds nuw i8, ptr %1, i64 6
  store i8 %77, ptr %78, align 1, !tbaa !76
  %79 = load i32, ptr %66, align 4, !tbaa !26
  %80 = trunc i32 %79 to i8
  %81 = getelementptr inbounds nuw i8, ptr %1, i64 7
  store i8 %80, ptr %81, align 1, !tbaa !76
  %82 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %83 = load i32, ptr %82, align 4, !tbaa !26
  %84 = lshr i32 %83, 24
  %85 = trunc nuw i32 %84 to i8
  %86 = getelementptr inbounds nuw i8, ptr %1, i64 8
  store i8 %85, ptr %86, align 1, !tbaa !76
  %87 = load i32, ptr %82, align 4, !tbaa !26
  %88 = lshr i32 %87, 16
  %89 = trunc i32 %88 to i8
  %90 = getelementptr inbounds nuw i8, ptr %1, i64 9
  store i8 %89, ptr %90, align 1, !tbaa !76
  %91 = load i32, ptr %82, align 4, !tbaa !26
  %92 = lshr i32 %91, 8
  %93 = trunc i32 %92 to i8
  %94 = getelementptr inbounds nuw i8, ptr %1, i64 10
  store i8 %93, ptr %94, align 1, !tbaa !76
  %95 = load i32, ptr %82, align 4, !tbaa !26
  %96 = trunc i32 %95 to i8
  %97 = getelementptr inbounds nuw i8, ptr %1, i64 11
  store i8 %96, ptr %97, align 1, !tbaa !76
  %98 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %99 = load i32, ptr %98, align 4, !tbaa !26
  %100 = lshr i32 %99, 24
  %101 = trunc nuw i32 %100 to i8
  %102 = getelementptr inbounds nuw i8, ptr %1, i64 12
  store i8 %101, ptr %102, align 1, !tbaa !76
  %103 = load i32, ptr %98, align 4, !tbaa !26
  %104 = lshr i32 %103, 16
  %105 = trunc i32 %104 to i8
  %106 = getelementptr inbounds nuw i8, ptr %1, i64 13
  store i8 %105, ptr %106, align 1, !tbaa !76
  %107 = load i32, ptr %98, align 4, !tbaa !26
  %108 = lshr i32 %107, 8
  %109 = trunc i32 %108 to i8
  %110 = getelementptr inbounds nuw i8, ptr %1, i64 14
  store i8 %109, ptr %110, align 1, !tbaa !76
  %111 = load i32, ptr %98, align 4, !tbaa !26
  %112 = trunc i32 %111 to i8
  %113 = getelementptr inbounds nuw i8, ptr %1, i64 15
  store i8 %112, ptr %113, align 1, !tbaa !76
  %114 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %115 = load i32, ptr %114, align 4, !tbaa !26
  %116 = lshr i32 %115, 24
  %117 = trunc nuw i32 %116 to i8
  %118 = getelementptr inbounds nuw i8, ptr %1, i64 16
  store i8 %117, ptr %118, align 1, !tbaa !76
  %119 = load i32, ptr %114, align 4, !tbaa !26
  %120 = lshr i32 %119, 16
  %121 = trunc i32 %120 to i8
  %122 = getelementptr inbounds nuw i8, ptr %1, i64 17
  store i8 %121, ptr %122, align 1, !tbaa !76
  %123 = load i32, ptr %114, align 4, !tbaa !26
  %124 = lshr i32 %123, 8
  %125 = trunc i32 %124 to i8
  %126 = getelementptr inbounds nuw i8, ptr %1, i64 18
  store i8 %125, ptr %126, align 1, !tbaa !76
  %127 = load i32, ptr %114, align 4, !tbaa !26
  %128 = trunc i32 %127 to i8
  %129 = getelementptr inbounds nuw i8, ptr %1, i64 19
  store i8 %128, ptr %129, align 1, !tbaa !76
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind sspstrong memory(argmem: readwrite) uwtable
define internal fastcc void @uh_sha1_transform(ptr noundef nonnull captures(none) %0, ptr noundef nonnull readonly captures(none) %1) unnamed_addr #29 {
  %3 = alloca [80 x i32], align 16
  call void @llvm.lifetime.start.p0(i64 320, ptr nonnull %3) #36
  br label %4

4:                                                ; preds = %2, %4
  %5 = phi i64 [ 0, %2 ], [ %26, %4 ]
  %6 = shl nuw nsw i64 %5, 2
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 %6
  %8 = load i8, ptr %7, align 1, !tbaa !76
  %9 = zext i8 %8 to i32
  %10 = shl nuw i32 %9, 24
  %11 = getelementptr inbounds nuw i8, ptr %7, i64 1
  %12 = load i8, ptr %11, align 1, !tbaa !76
  %13 = zext i8 %12 to i32
  %14 = shl nuw nsw i32 %13, 16
  %15 = or disjoint i32 %14, %10
  %16 = getelementptr inbounds nuw i8, ptr %7, i64 2
  %17 = load i8, ptr %16, align 1, !tbaa !76
  %18 = zext i8 %17 to i32
  %19 = shl nuw nsw i32 %18, 8
  %20 = or disjoint i32 %15, %19
  %21 = getelementptr inbounds nuw i8, ptr %7, i64 3
  %22 = load i8, ptr %21, align 1, !tbaa !76
  %23 = zext i8 %22 to i32
  %24 = or disjoint i32 %20, %23
  %25 = getelementptr inbounds nuw [80 x i32], ptr %3, i64 0, i64 %5
  store i32 %24, ptr %25, align 4, !tbaa !26
  %26 = add nuw nsw i64 %5, 1
  %27 = icmp eq i64 %26, 16
  br i1 %27, label %38, label %4, !llvm.loop !1183

28:                                               ; preds = %38
  %29 = load i32, ptr %0, align 8, !tbaa !26
  %30 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %31 = load i32, ptr %30, align 4, !tbaa !26
  %32 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %33 = load i32, ptr %32, align 8, !tbaa !26
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %35 = load i32, ptr %34, align 4, !tbaa !26
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %37 = load i32, ptr %36, align 8, !tbaa !26
  br label %65

38:                                               ; preds = %4, %38
  %39 = phi i64 [ %57, %38 ], [ 16, %4 ]
  %40 = add nsw i64 %39, -3
  %41 = getelementptr inbounds [80 x i32], ptr %3, i64 0, i64 %40
  %42 = load i32, ptr %41, align 4, !tbaa !26
  %43 = add nsw i64 %39, -8
  %44 = getelementptr inbounds [80 x i32], ptr %3, i64 0, i64 %43
  %45 = load i32, ptr %44, align 4, !tbaa !26
  %46 = xor i32 %45, %42
  %47 = add nsw i64 %39, -14
  %48 = getelementptr inbounds [80 x i32], ptr %3, i64 0, i64 %47
  %49 = load i32, ptr %48, align 4, !tbaa !26
  %50 = xor i32 %46, %49
  %51 = add nsw i64 %39, -16
  %52 = getelementptr inbounds [80 x i32], ptr %3, i64 0, i64 %51
  %53 = load i32, ptr %52, align 4, !tbaa !26
  %54 = xor i32 %50, %53
  %55 = tail call noundef i32 @llvm.fshl.i32(i32 %54, i32 %54, i32 1)
  %56 = getelementptr inbounds nuw [80 x i32], ptr %3, i64 0, i64 %39
  store i32 %55, ptr %56, align 4, !tbaa !26
  %57 = add nuw nsw i64 %39, 1
  %58 = icmp eq i64 %57, 80
  br i1 %58, label %28, label %38, !llvm.loop !1184

59:                                               ; preds = %93
  %60 = add i32 %102, %29
  store i32 %60, ptr %0, align 8, !tbaa !26
  %61 = add i32 %71, %31
  store i32 %61, ptr %30, align 4, !tbaa !26
  %62 = add i32 %103, %33
  store i32 %62, ptr %32, align 8, !tbaa !26
  %63 = add i32 %69, %35
  store i32 %63, ptr %34, align 4, !tbaa !26
  %64 = add i32 %68, %37
  store i32 %64, ptr %36, align 8, !tbaa !26
  call void @llvm.lifetime.end.p0(i64 320, ptr nonnull %3) #36
  ret void

65:                                               ; preds = %28, %93
  %66 = phi i64 [ 0, %28 ], [ %104, %93 ]
  %67 = phi i32 [ %37, %28 ], [ %68, %93 ]
  %68 = phi i32 [ %35, %28 ], [ %69, %93 ]
  %69 = phi i32 [ %33, %28 ], [ %103, %93 ]
  %70 = phi i32 [ %31, %28 ], [ %71, %93 ]
  %71 = phi i32 [ %29, %28 ], [ %102, %93 ]
  %72 = icmp samesign ult i64 %66, 20
  br i1 %72, label %73, label %78

73:                                               ; preds = %65
  %74 = and i32 %69, %70
  %75 = xor i32 %70, -1
  %76 = and i32 %68, %75
  %77 = or i32 %76, %74
  br label %93

78:                                               ; preds = %65
  %79 = icmp samesign ult i64 %66, 40
  br i1 %79, label %80, label %83

80:                                               ; preds = %78
  %81 = xor i32 %69, %70
  %82 = xor i32 %81, %68
  br label %93

83:                                               ; preds = %78
  %84 = icmp samesign ult i64 %66, 60
  br i1 %84, label %85, label %90

85:                                               ; preds = %83
  %86 = or i32 %68, %69
  %87 = and i32 %86, %70
  %88 = and i32 %68, %69
  %89 = or i32 %87, %88
  br label %93

90:                                               ; preds = %83
  %91 = xor i32 %69, %70
  %92 = xor i32 %91, %68
  br label %93

93:                                               ; preds = %80, %90, %85, %73
  %94 = phi i32 [ %77, %73 ], [ %82, %80 ], [ %89, %85 ], [ %92, %90 ]
  %95 = phi i32 [ 1518500249, %73 ], [ 1859775393, %80 ], [ -1894007588, %85 ], [ -899497514, %90 ]
  %96 = tail call noundef i32 @llvm.fshl.i32(i32 %71, i32 %71, i32 5)
  %97 = getelementptr inbounds nuw [80 x i32], ptr %3, i64 0, i64 %66
  %98 = load i32, ptr %97, align 4, !tbaa !26
  %99 = add i32 %67, %96
  %100 = add i32 %99, %94
  %101 = add i32 %100, %95
  %102 = add i32 %101, %98
  %103 = tail call noundef i32 @llvm.fshl.i32(i32 %70, i32 %70, i32 30)
  %104 = add nuw nsw i64 %66, 1
  %105 = icmp eq i64 %104, 80
  br i1 %105, label %59, label %65, !llvm.loop !1185
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(readwrite, inaccessiblemem: none) uwtable
define internal i64 @uh_smtp_read_cb(ptr noundef writeonly captures(none) %0, i64 noundef %1, i64 noundef %2, ptr noundef captures(none) %3) #8 {
  %5 = mul i64 %2, %1
  %6 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %7 = load i64, ptr %6, align 8, !tbaa !1070
  %8 = getelementptr inbounds nuw i8, ptr %3, i64 8
  %9 = load i64, ptr %8, align 8, !tbaa !1069
  %10 = tail call i64 @llvm.usub.sat.i64(i64 %9, i64 %7)
  %11 = tail call i64 @llvm.umin.i64(i64 %10, i64 %5)
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %18, label %13

13:                                               ; preds = %4
  %14 = load ptr, ptr %3, align 8, !tbaa !600
  %15 = getelementptr inbounds nuw i8, ptr %14, i64 %7
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %0, ptr align 1 %15, i64 %11, i1 false)
  %16 = load i64, ptr %6, align 8, !tbaa !1070
  %17 = add i64 %16, %11
  store i64 %17, ptr %6, align 8, !tbaa !1070
  br label %18

18:                                               ; preds = %13, %4
  ret i64 %11
}

; Function Attrs: nofree norecurse nosync nounwind sspstrong memory(argmem: readwrite) uwtable
define internal fastcc void @uh_sha256_transform(ptr noundef nonnull captures(none) %0, ptr noundef nonnull readonly captures(none) %1) unnamed_addr #29 {
  %3 = alloca [64 x i32], align 16
  call void @llvm.lifetime.start.p0(i64 256, ptr nonnull %3) #36
  br label %4

4:                                                ; preds = %2, %4
  %5 = phi i64 [ 0, %2 ], [ %26, %4 ]
  %6 = shl nuw nsw i64 %5, 2
  %7 = getelementptr inbounds nuw i8, ptr %1, i64 %6
  %8 = load i8, ptr %7, align 1, !tbaa !76
  %9 = zext i8 %8 to i32
  %10 = shl nuw i32 %9, 24
  %11 = getelementptr inbounds nuw i8, ptr %7, i64 1
  %12 = load i8, ptr %11, align 1, !tbaa !76
  %13 = zext i8 %12 to i32
  %14 = shl nuw nsw i32 %13, 16
  %15 = or disjoint i32 %14, %10
  %16 = getelementptr inbounds nuw i8, ptr %7, i64 2
  %17 = load i8, ptr %16, align 1, !tbaa !76
  %18 = zext i8 %17 to i32
  %19 = shl nuw nsw i32 %18, 8
  %20 = or disjoint i32 %15, %19
  %21 = getelementptr inbounds nuw i8, ptr %7, i64 3
  %22 = load i8, ptr %21, align 1, !tbaa !76
  %23 = zext i8 %22 to i32
  %24 = or disjoint i32 %20, %23
  %25 = getelementptr inbounds nuw [64 x i32], ptr %3, i64 0, i64 %5
  store i32 %24, ptr %25, align 4, !tbaa !26
  %26 = add nuw nsw i64 %5, 1
  %27 = icmp eq i64 %26, 16
  br i1 %27, label %28, label %4, !llvm.loop !1186

28:                                               ; preds = %4
  %29 = load i32, ptr %3, align 16, !tbaa !26
  br label %46

30:                                               ; preds = %46
  %31 = load i32, ptr %0, align 8, !tbaa !26
  %32 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %33 = load i32, ptr %32, align 4, !tbaa !26
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %35 = load i32, ptr %34, align 8, !tbaa !26
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %37 = load i32, ptr %36, align 4, !tbaa !26
  %38 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %39 = load i32, ptr %38, align 8, !tbaa !26
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 20
  %41 = load i32, ptr %40, align 4, !tbaa !26
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %43 = load i32, ptr %42, align 8, !tbaa !26
  %44 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %45 = load i32, ptr %44, align 4, !tbaa !26
  br label %83

46:                                               ; preds = %28, %46
  %47 = phi i32 [ %29, %28 ], [ %51, %46 ]
  %48 = phi i64 [ 16, %28 ], [ %72, %46 ]
  %49 = add nsw i64 %48, -15
  %50 = getelementptr inbounds [64 x i32], ptr %3, i64 0, i64 %49
  %51 = load i32, ptr %50, align 4, !tbaa !26
  %52 = tail call i32 @llvm.fshl.i32(i32 %51, i32 %51, i32 25)
  %53 = tail call i32 @llvm.fshl.i32(i32 %51, i32 %51, i32 14)
  %54 = xor i32 %52, %53
  %55 = lshr i32 %51, 3
  %56 = xor i32 %54, %55
  %57 = add nsw i64 %48, -2
  %58 = getelementptr inbounds [64 x i32], ptr %3, i64 0, i64 %57
  %59 = load i32, ptr %58, align 4, !tbaa !26
  %60 = tail call i32 @llvm.fshl.i32(i32 %59, i32 %59, i32 15)
  %61 = tail call i32 @llvm.fshl.i32(i32 %59, i32 %59, i32 13)
  %62 = xor i32 %60, %61
  %63 = lshr i32 %59, 10
  %64 = xor i32 %62, %63
  %65 = add i32 %56, %47
  %66 = add nsw i64 %48, -7
  %67 = getelementptr inbounds [64 x i32], ptr %3, i64 0, i64 %66
  %68 = load i32, ptr %67, align 4, !tbaa !26
  %69 = add i32 %65, %68
  %70 = add i32 %69, %64
  %71 = getelementptr inbounds nuw [64 x i32], ptr %3, i64 0, i64 %48
  store i32 %70, ptr %71, align 4, !tbaa !26
  %72 = add nuw nsw i64 %48, 1
  %73 = icmp eq i64 %72, 64
  br i1 %73, label %30, label %46, !llvm.loop !1187

74:                                               ; preds = %83
  %75 = add i32 %121, %31
  store i32 %75, ptr %0, align 8, !tbaa !26
  %76 = add i32 %85, %33
  store i32 %76, ptr %32, align 4, !tbaa !26
  %77 = add i32 %86, %35
  store i32 %77, ptr %34, align 8, !tbaa !26
  %78 = add i32 %87, %37
  store i32 %78, ptr %36, align 4, !tbaa !26
  %79 = add i32 %120, %39
  store i32 %79, ptr %38, align 8, !tbaa !26
  %80 = add i32 %92, %41
  store i32 %80, ptr %40, align 4, !tbaa !26
  %81 = add i32 %91, %43
  store i32 %81, ptr %42, align 8, !tbaa !26
  %82 = add i32 %90, %45
  store i32 %82, ptr %44, align 4, !tbaa !26
  call void @llvm.lifetime.end.p0(i64 256, ptr nonnull %3) #36
  ret void

83:                                               ; preds = %30, %83
  %84 = phi i64 [ 0, %30 ], [ %122, %83 ]
  %85 = phi i32 [ %31, %30 ], [ %121, %83 ]
  %86 = phi i32 [ %33, %30 ], [ %85, %83 ]
  %87 = phi i32 [ %35, %30 ], [ %86, %83 ]
  %88 = phi i32 [ %37, %30 ], [ %87, %83 ]
  %89 = phi i32 [ %45, %30 ], [ %90, %83 ]
  %90 = phi i32 [ %43, %30 ], [ %91, %83 ]
  %91 = phi i32 [ %41, %30 ], [ %92, %83 ]
  %92 = phi i32 [ %39, %30 ], [ %120, %83 ]
  %93 = tail call i32 @llvm.fshl.i32(i32 %92, i32 %92, i32 26)
  %94 = tail call i32 @llvm.fshl.i32(i32 %92, i32 %92, i32 21)
  %95 = xor i32 %93, %94
  %96 = tail call i32 @llvm.fshl.i32(i32 %92, i32 %92, i32 7)
  %97 = xor i32 %95, %96
  %98 = and i32 %91, %92
  %99 = xor i32 %92, -1
  %100 = and i32 %90, %99
  %101 = or i32 %100, %98
  %102 = add i32 %89, %97
  %103 = add i32 %102, %101
  %104 = getelementptr inbounds nuw [64 x i32], ptr @uh_sha256_transform.k, i64 0, i64 %84
  %105 = load i32, ptr %104, align 4, !tbaa !26
  %106 = add i32 %103, %105
  %107 = getelementptr inbounds nuw [64 x i32], ptr %3, i64 0, i64 %84
  %108 = load i32, ptr %107, align 4, !tbaa !26
  %109 = add i32 %106, %108
  %110 = tail call i32 @llvm.fshl.i32(i32 %85, i32 %85, i32 30)
  %111 = tail call i32 @llvm.fshl.i32(i32 %85, i32 %85, i32 19)
  %112 = xor i32 %110, %111
  %113 = tail call i32 @llvm.fshl.i32(i32 %85, i32 %85, i32 10)
  %114 = xor i32 %112, %113
  %115 = xor i32 %86, %87
  %116 = and i32 %85, %115
  %117 = and i32 %86, %87
  %118 = xor i32 %116, %117
  %119 = add i32 %114, %118
  %120 = add i32 %109, %88
  %121 = add i32 %119, %109
  %122 = add nuw nsw i64 %84, 1
  %123 = icmp eq i64 %122, 64
  br i1 %123, label %74, label %83, !llvm.loop !1188
}

; Function Attrs: nofree nounwind
declare noundef i32 @__isoc99_sscanf(ptr noundef readonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #16

; Function Attrs: nounwind sspstrong uwtable
define internal fastcc void @uh_json_parse_string(ptr dead_on_unwind noalias writable writeonly sret(%struct.UhValue) align 8 captures(none) %0, ptr noundef nonnull captures(none) %1) unnamed_addr #12 {
  %3 = alloca [2 x i8], align 1
  %4 = load ptr, ptr %1, align 8, !tbaa !28
  %5 = load i8, ptr %4, align 1, !tbaa !76
  %6 = icmp eq i8 %5, 34
  br i1 %6, label %9, label %7

7:                                                ; preds = %2
  store i32 4, ptr %0, align 8, !tbaa !31, !alias.scope !1189
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %8, i8 0, i64 32, i1 false), !alias.scope !1189
  br label %63

9:                                                ; preds = %2
  %10 = getelementptr inbounds nuw i8, ptr %4, i64 1
  %11 = getelementptr inbounds nuw i8, ptr %3, i64 1
  br label %12

12:                                               ; preds = %44, %9
  %13 = phi ptr [ null, %9 ], [ %45, %44 ]
  %14 = phi i64 [ 0, %9 ], [ %48, %44 ]
  %15 = phi i64 [ 0, %9 ], [ %46, %44 ]
  %16 = phi ptr [ %10, %9 ], [ %29, %44 ]
  %17 = load i8, ptr %16, align 1, !tbaa !76
  switch i8 %17, label %18 [
    i8 0, label %49
    i8 34, label %49
  ]

18:                                               ; preds = %12
  %19 = getelementptr inbounds nuw i8, ptr %16, i64 1
  %20 = icmp eq i8 %17, 92
  br i1 %20, label %21, label %27

21:                                               ; preds = %18
  %22 = getelementptr inbounds nuw i8, ptr %16, i64 2
  %23 = load i8, ptr %19, align 1, !tbaa !76
  switch i8 %23, label %26 [
    i8 110, label %27
    i8 114, label %24
    i8 116, label %25
  ]

24:                                               ; preds = %21
  br label %27

25:                                               ; preds = %21
  br label %27

26:                                               ; preds = %21
  br label %27

27:                                               ; preds = %25, %26, %24, %21, %18
  %28 = phi i8 [ %17, %18 ], [ 13, %24 ], [ 9, %25 ], [ %23, %26 ], [ 10, %21 ]
  %29 = phi ptr [ %19, %18 ], [ %22, %24 ], [ %22, %25 ], [ %22, %26 ], [ %22, %21 ]
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %3) #36
  store i8 %28, ptr %3, align 1, !tbaa !76
  store i8 0, ptr %11, align 1, !tbaa !76
  %30 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %3) #33
  %31 = add i64 %30, 1
  %32 = add i64 %31, %14
  %33 = icmp ugt i64 %32, %15
  br i1 %33, label %34, label %44

34:                                               ; preds = %27
  %35 = icmp eq i64 %15, 0
  %36 = shl i64 %15, 1
  %37 = select i1 %35, i64 64, i64 %36
  br label %38

38:                                               ; preds = %38, %34
  %39 = phi i64 [ %37, %34 ], [ %41, %38 ]
  %40 = icmp ult i64 %39, %32
  %41 = shl i64 %39, 1
  br i1 %40, label %38, label %42, !llvm.loop !107

42:                                               ; preds = %38
  %43 = tail call ptr @realloc(ptr noundef %13, i64 noundef %39) #35
  br label %44

44:                                               ; preds = %27, %42
  %45 = phi ptr [ %43, %42 ], [ %13, %27 ]
  %46 = phi i64 [ %39, %42 ], [ %15, %27 ]
  %47 = getelementptr inbounds nuw i8, ptr %45, i64 %14
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %47, ptr nonnull readonly align 1 %3, i64 %31, i1 false)
  %48 = add i64 %30, %14
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %3) #36
  br label %12, !llvm.loop !1192

49:                                               ; preds = %12, %12
  %50 = icmp eq i8 %17, 34
  %51 = zext i1 %50 to i64
  %52 = getelementptr inbounds nuw i8, ptr %16, i64 %51
  store ptr %52, ptr %1, align 8, !tbaa !28
  store i32 1, ptr %0, align 8, !tbaa !31
  %53 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store double 0.000000e+00, ptr %53, align 8, !tbaa !35
  %54 = icmp eq ptr %13, null
  br i1 %54, label %55, label %59

55:                                               ; preds = %49
  %56 = tail call noalias dereferenceable_or_null(1) ptr @malloc(i64 noundef 1) #34
  %57 = icmp eq ptr %56, null
  br i1 %57, label %59, label %58

58:                                               ; preds = %55
  store i8 0, ptr %56, align 1
  br label %59

59:                                               ; preds = %58, %55, %49
  %60 = phi ptr [ %13, %49 ], [ %56, %58 ], [ null, %55 ]
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store ptr %60, ptr %61, align 8, !tbaa !46
  %62 = getelementptr inbounds nuw i8, ptr %0, i64 24
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %62, i8 0, i64 16, i1 false)
  br label %63

63:                                               ; preds = %59, %7
  ret void
}

; Function Attrs: nounwind sspstrong uwtable
define internal fastcc void @uh_json_escape(ptr noundef nonnull captures(none) %0, ptr noundef nonnull captures(none) %1, ptr noundef nonnull captures(none) %2, ptr noundef readonly captures(none) %3) unnamed_addr #12 {
  %5 = alloca [2 x i8], align 1
  %6 = load i64, ptr %1, align 8, !tbaa !368
  %7 = add i64 %6, 2
  %8 = load i64, ptr %2, align 8, !tbaa !368
  %9 = icmp ugt i64 %7, %8
  br i1 %9, label %12, label %10

10:                                               ; preds = %4
  %11 = load ptr, ptr %0, align 8, !tbaa !28
  br label %24

12:                                               ; preds = %4
  %13 = icmp eq i64 %8, 0
  %14 = shl i64 %8, 1
  %15 = select i1 %13, i64 64, i64 %14
  br label %16

16:                                               ; preds = %16, %12
  %17 = phi i64 [ %15, %12 ], [ %19, %16 ]
  %18 = icmp ult i64 %17, %7
  %19 = shl i64 %17, 1
  br i1 %18, label %16, label %20, !llvm.loop !107

20:                                               ; preds = %16
  %21 = load ptr, ptr %0, align 8, !tbaa !28
  %22 = tail call ptr @realloc(ptr noundef %21, i64 noundef %17) #35
  store ptr %22, ptr %0, align 8, !tbaa !28
  store i64 %17, ptr %2, align 8, !tbaa !368
  %23 = load i64, ptr %1, align 8, !tbaa !368
  br label %24

24:                                               ; preds = %10, %20
  %25 = phi i64 [ %6, %10 ], [ %23, %20 ]
  %26 = phi ptr [ %11, %10 ], [ %22, %20 ]
  %27 = getelementptr inbounds nuw i8, ptr %26, i64 %25
  store i16 34, ptr %27, align 1
  %28 = load i64, ptr %1, align 8, !tbaa !368
  %29 = add i64 %28, 1
  store i64 %29, ptr %1, align 8, !tbaa !368
  %30 = getelementptr inbounds nuw i8, ptr %5, i64 1
  br label %31

31:                                               ; preds = %205, %24
  %32 = phi i64 [ %29, %24 ], [ %206, %205 ]
  %33 = phi ptr [ %3, %24 ], [ %207, %205 ]
  %34 = load i8, ptr %33, align 1, !tbaa !76
  switch i8 %34, label %179 [
    i8 0, label %35
    i8 92, label %59
    i8 34, label %83
    i8 10, label %107
    i8 13, label %131
    i8 9, label %155
  ]

35:                                               ; preds = %31
  %36 = add i64 %32, 2
  %37 = load i64, ptr %2, align 8, !tbaa !368
  %38 = icmp ugt i64 %36, %37
  br i1 %38, label %41, label %39

39:                                               ; preds = %35
  %40 = load ptr, ptr %0, align 8, !tbaa !28
  br label %53

41:                                               ; preds = %35
  %42 = icmp eq i64 %37, 0
  %43 = shl i64 %37, 1
  %44 = select i1 %42, i64 64, i64 %43
  br label %45

45:                                               ; preds = %45, %41
  %46 = phi i64 [ %44, %41 ], [ %48, %45 ]
  %47 = icmp ult i64 %46, %36
  %48 = shl i64 %46, 1
  br i1 %47, label %45, label %49, !llvm.loop !107

49:                                               ; preds = %45
  %50 = load ptr, ptr %0, align 8, !tbaa !28
  %51 = tail call ptr @realloc(ptr noundef %50, i64 noundef %46) #35
  store ptr %51, ptr %0, align 8, !tbaa !28
  store i64 %46, ptr %2, align 8, !tbaa !368
  %52 = load i64, ptr %1, align 8, !tbaa !368
  br label %53

53:                                               ; preds = %39, %49
  %54 = phi i64 [ %32, %39 ], [ %52, %49 ]
  %55 = phi ptr [ %40, %39 ], [ %51, %49 ]
  %56 = getelementptr inbounds nuw i8, ptr %55, i64 %54
  store i16 34, ptr %56, align 1
  %57 = load i64, ptr %1, align 8, !tbaa !368
  %58 = add i64 %57, 1
  store i64 %58, ptr %1, align 8, !tbaa !368
  ret void

59:                                               ; preds = %31
  %60 = add i64 %32, 3
  %61 = load i64, ptr %2, align 8, !tbaa !368
  %62 = icmp ugt i64 %60, %61
  br i1 %62, label %65, label %63

63:                                               ; preds = %59
  %64 = load ptr, ptr %0, align 8, !tbaa !28
  br label %77

65:                                               ; preds = %59
  %66 = icmp eq i64 %61, 0
  %67 = shl i64 %61, 1
  %68 = select i1 %66, i64 64, i64 %67
  br label %69

69:                                               ; preds = %69, %65
  %70 = phi i64 [ %68, %65 ], [ %72, %69 ]
  %71 = icmp ult i64 %70, %60
  %72 = shl i64 %70, 1
  br i1 %71, label %69, label %73, !llvm.loop !107

73:                                               ; preds = %69
  %74 = load ptr, ptr %0, align 8, !tbaa !28
  %75 = tail call ptr @realloc(ptr noundef %74, i64 noundef %70) #35
  store ptr %75, ptr %0, align 8, !tbaa !28
  store i64 %70, ptr %2, align 8, !tbaa !368
  %76 = load i64, ptr %1, align 8, !tbaa !368
  br label %77

77:                                               ; preds = %63, %73
  %78 = phi i64 [ %32, %63 ], [ %76, %73 ]
  %79 = phi ptr [ %64, %63 ], [ %75, %73 ]
  %80 = getelementptr inbounds nuw i8, ptr %79, i64 %78
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %80, ptr noundef nonnull align 1 dereferenceable(3) @.str.101, i64 3, i1 false)
  %81 = load i64, ptr %1, align 8, !tbaa !368
  %82 = add i64 %81, 2
  store i64 %82, ptr %1, align 8, !tbaa !368
  br label %205

83:                                               ; preds = %31
  %84 = add i64 %32, 3
  %85 = load i64, ptr %2, align 8, !tbaa !368
  %86 = icmp ugt i64 %84, %85
  br i1 %86, label %89, label %87

87:                                               ; preds = %83
  %88 = load ptr, ptr %0, align 8, !tbaa !28
  br label %101

89:                                               ; preds = %83
  %90 = icmp eq i64 %85, 0
  %91 = shl i64 %85, 1
  %92 = select i1 %90, i64 64, i64 %91
  br label %93

93:                                               ; preds = %93, %89
  %94 = phi i64 [ %92, %89 ], [ %96, %93 ]
  %95 = icmp ult i64 %94, %84
  %96 = shl i64 %94, 1
  br i1 %95, label %93, label %97, !llvm.loop !107

97:                                               ; preds = %93
  %98 = load ptr, ptr %0, align 8, !tbaa !28
  %99 = tail call ptr @realloc(ptr noundef %98, i64 noundef %94) #35
  store ptr %99, ptr %0, align 8, !tbaa !28
  store i64 %94, ptr %2, align 8, !tbaa !368
  %100 = load i64, ptr %1, align 8, !tbaa !368
  br label %101

101:                                              ; preds = %87, %97
  %102 = phi i64 [ %32, %87 ], [ %100, %97 ]
  %103 = phi ptr [ %88, %87 ], [ %99, %97 ]
  %104 = getelementptr inbounds nuw i8, ptr %103, i64 %102
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %104, ptr noundef nonnull align 1 dereferenceable(3) @.str.102, i64 3, i1 false)
  %105 = load i64, ptr %1, align 8, !tbaa !368
  %106 = add i64 %105, 2
  store i64 %106, ptr %1, align 8, !tbaa !368
  br label %205

107:                                              ; preds = %31
  %108 = add i64 %32, 3
  %109 = load i64, ptr %2, align 8, !tbaa !368
  %110 = icmp ugt i64 %108, %109
  br i1 %110, label %113, label %111

111:                                              ; preds = %107
  %112 = load ptr, ptr %0, align 8, !tbaa !28
  br label %125

113:                                              ; preds = %107
  %114 = icmp eq i64 %109, 0
  %115 = shl i64 %109, 1
  %116 = select i1 %114, i64 64, i64 %115
  br label %117

117:                                              ; preds = %117, %113
  %118 = phi i64 [ %116, %113 ], [ %120, %117 ]
  %119 = icmp ult i64 %118, %108
  %120 = shl i64 %118, 1
  br i1 %119, label %117, label %121, !llvm.loop !107

121:                                              ; preds = %117
  %122 = load ptr, ptr %0, align 8, !tbaa !28
  %123 = tail call ptr @realloc(ptr noundef %122, i64 noundef %118) #35
  store ptr %123, ptr %0, align 8, !tbaa !28
  store i64 %118, ptr %2, align 8, !tbaa !368
  %124 = load i64, ptr %1, align 8, !tbaa !368
  br label %125

125:                                              ; preds = %111, %121
  %126 = phi i64 [ %32, %111 ], [ %124, %121 ]
  %127 = phi ptr [ %112, %111 ], [ %123, %121 ]
  %128 = getelementptr inbounds nuw i8, ptr %127, i64 %126
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %128, ptr noundef nonnull align 1 dereferenceable(3) @.str.103, i64 3, i1 false)
  %129 = load i64, ptr %1, align 8, !tbaa !368
  %130 = add i64 %129, 2
  store i64 %130, ptr %1, align 8, !tbaa !368
  br label %205

131:                                              ; preds = %31
  %132 = add i64 %32, 3
  %133 = load i64, ptr %2, align 8, !tbaa !368
  %134 = icmp ugt i64 %132, %133
  br i1 %134, label %137, label %135

135:                                              ; preds = %131
  %136 = load ptr, ptr %0, align 8, !tbaa !28
  br label %149

137:                                              ; preds = %131
  %138 = icmp eq i64 %133, 0
  %139 = shl i64 %133, 1
  %140 = select i1 %138, i64 64, i64 %139
  br label %141

141:                                              ; preds = %141, %137
  %142 = phi i64 [ %140, %137 ], [ %144, %141 ]
  %143 = icmp ult i64 %142, %132
  %144 = shl i64 %142, 1
  br i1 %143, label %141, label %145, !llvm.loop !107

145:                                              ; preds = %141
  %146 = load ptr, ptr %0, align 8, !tbaa !28
  %147 = tail call ptr @realloc(ptr noundef %146, i64 noundef %142) #35
  store ptr %147, ptr %0, align 8, !tbaa !28
  store i64 %142, ptr %2, align 8, !tbaa !368
  %148 = load i64, ptr %1, align 8, !tbaa !368
  br label %149

149:                                              ; preds = %135, %145
  %150 = phi i64 [ %32, %135 ], [ %148, %145 ]
  %151 = phi ptr [ %136, %135 ], [ %147, %145 ]
  %152 = getelementptr inbounds nuw i8, ptr %151, i64 %150
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %152, ptr noundef nonnull align 1 dereferenceable(3) @.str.104, i64 3, i1 false)
  %153 = load i64, ptr %1, align 8, !tbaa !368
  %154 = add i64 %153, 2
  store i64 %154, ptr %1, align 8, !tbaa !368
  br label %205

155:                                              ; preds = %31
  %156 = add i64 %32, 3
  %157 = load i64, ptr %2, align 8, !tbaa !368
  %158 = icmp ugt i64 %156, %157
  br i1 %158, label %161, label %159

159:                                              ; preds = %155
  %160 = load ptr, ptr %0, align 8, !tbaa !28
  br label %173

161:                                              ; preds = %155
  %162 = icmp eq i64 %157, 0
  %163 = shl i64 %157, 1
  %164 = select i1 %162, i64 64, i64 %163
  br label %165

165:                                              ; preds = %165, %161
  %166 = phi i64 [ %164, %161 ], [ %168, %165 ]
  %167 = icmp ult i64 %166, %156
  %168 = shl i64 %166, 1
  br i1 %167, label %165, label %169, !llvm.loop !107

169:                                              ; preds = %165
  %170 = load ptr, ptr %0, align 8, !tbaa !28
  %171 = tail call ptr @realloc(ptr noundef %170, i64 noundef %166) #35
  store ptr %171, ptr %0, align 8, !tbaa !28
  store i64 %166, ptr %2, align 8, !tbaa !368
  %172 = load i64, ptr %1, align 8, !tbaa !368
  br label %173

173:                                              ; preds = %159, %169
  %174 = phi i64 [ %32, %159 ], [ %172, %169 ]
  %175 = phi ptr [ %160, %159 ], [ %171, %169 ]
  %176 = getelementptr inbounds nuw i8, ptr %175, i64 %174
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %176, ptr noundef nonnull align 1 dereferenceable(3) @.str.105, i64 3, i1 false)
  %177 = load i64, ptr %1, align 8, !tbaa !368
  %178 = add i64 %177, 2
  store i64 %178, ptr %1, align 8, !tbaa !368
  br label %205

179:                                              ; preds = %31
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %5) #36
  store i8 %34, ptr %5, align 1, !tbaa !76
  store i8 0, ptr %30, align 1, !tbaa !76
  %180 = call i64 @strlen(ptr noundef nonnull readonly dereferenceable(1) %5) #33
  %181 = add i64 %180, 1
  %182 = add i64 %181, %32
  %183 = load i64, ptr %2, align 8, !tbaa !368
  %184 = icmp ugt i64 %182, %183
  br i1 %184, label %187, label %185

185:                                              ; preds = %179
  %186 = load ptr, ptr %0, align 8, !tbaa !28
  br label %199

187:                                              ; preds = %179
  %188 = icmp eq i64 %183, 0
  %189 = shl i64 %183, 1
  %190 = select i1 %188, i64 64, i64 %189
  br label %191

191:                                              ; preds = %191, %187
  %192 = phi i64 [ %190, %187 ], [ %194, %191 ]
  %193 = icmp ult i64 %192, %182
  %194 = shl i64 %192, 1
  br i1 %193, label %191, label %195, !llvm.loop !107

195:                                              ; preds = %191
  %196 = load ptr, ptr %0, align 8, !tbaa !28
  %197 = tail call ptr @realloc(ptr noundef %196, i64 noundef %192) #35
  store ptr %197, ptr %0, align 8, !tbaa !28
  store i64 %192, ptr %2, align 8, !tbaa !368
  %198 = load i64, ptr %1, align 8, !tbaa !368
  br label %199

199:                                              ; preds = %185, %195
  %200 = phi i64 [ %32, %185 ], [ %198, %195 ]
  %201 = phi ptr [ %186, %185 ], [ %197, %195 ]
  %202 = getelementptr inbounds nuw i8, ptr %201, i64 %200
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %202, ptr nonnull readonly align 1 %5, i64 %181, i1 false)
  %203 = load i64, ptr %1, align 8, !tbaa !368
  %204 = add i64 %203, %180
  store i64 %204, ptr %1, align 8, !tbaa !368
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %5) #36
  br label %205

205:                                              ; preds = %101, %149, %199, %173, %125, %77
  %206 = phi i64 [ %106, %101 ], [ %154, %149 ], [ %204, %199 ], [ %178, %173 ], [ %130, %125 ], [ %82, %77 ]
  %207 = getelementptr inbounds nuw i8, ptr %33, i64 1
  br label %31, !llvm.loop !1193
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smax.i64(i64, i64) #30

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.bswap.i16(i16) #30

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umin.i64(i64, i64) #30

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fshl.i32(i32, i32, i32) #30

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #31

; Function Attrs: nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #32

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #30

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare range(i32 -1, 2) i32 @llvm.scmp.i32.i32(i32, i32) #30

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.usub.sat.i64(i64, i64) #30

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i8 @llvm.umax.i8(i8, i8) #30

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <16 x i8> @llvm.umax.v16i8(<16 x i8>, <16 x i8>) #30

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x i8> @llvm.umax.v4i8(<4 x i8>, <4 x i8>) #30

attributes #0 = { mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(argmem: write) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree norecurse nounwind sspstrong memory(readwrite, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nofree nounwind sspstrong uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { mustprogress nounwind sspstrong willreturn uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(readwrite, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { mustprogress nofree nounwind sspstrong willreturn uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { mustprogress nofree nounwind sspstrong willreturn memory(argmem: write, inaccessiblemem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(read, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #12 = { nounwind sspstrong uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #13 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #14 = { nofree norecurse nosync nounwind sspstrong memory(read, argmem: readwrite, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #15 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #16 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #17 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #18 = { mustprogress nofree norecurse nounwind sspstrong willreturn uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #19 = { mustprogress nocallback nofree nounwind willreturn "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #20 = { mustprogress nofree nosync nounwind willreturn memory(none) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #21 = { mustprogress nofree norecurse nounwind sspstrong willreturn memory(read, argmem: readwrite, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #22 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #23 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #24 = { mustprogress nofree norecurse nounwind sspstrong willreturn memory(argmem: readwrite, errnomem: write) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #25 = { mustprogress nocallback nofree nounwind willreturn memory(errnomem: write) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #26 = { nofree nounwind sspstrong memory(read, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #27 = { mustprogress nofree norecurse nosync nounwind sspstrong willreturn memory(write, argmem: none, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #28 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #29 = { nofree norecurse nosync nounwind sspstrong memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #30 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #31 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #32 = { nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #33 = { nounwind willreturn memory(read) }
attributes #34 = { nounwind allocsize(0) }
attributes #35 = { nounwind allocsize(1) }
attributes #36 = { nounwind }
attributes #37 = { nounwind willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"clang version 21.1.6"}
!5 = !{!6, !7, i64 0}
!6 = !{!"UhEnv", !7, i64 0, !11, i64 8}
!7 = !{!"p1 _ZTS5UhEnv", !8, i64 0}
!8 = !{!"any pointer", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = !{!"p1 _ZTS5UhVar", !8, i64 0}
!12 = !{!6, !11, i64 8}
!13 = !{!11, !11, i64 0}
!14 = !{!15, !16, i64 0}
!15 = !{!"UhVar", !16, i64 0, !17, i64 8, !11, i64 48}
!16 = !{!"p1 omnipotent char", !8, i64 0}
!17 = !{!"UhValue", !18, i64 0, !19, i64 8, !16, i64 16, !20, i64 24, !21, i64 32}
!18 = !{!"int", !9, i64 0}
!19 = !{!"double", !9, i64 0}
!20 = !{!"p1 _ZTS7UhArray", !8, i64 0}
!21 = !{!"p1 _ZTS6UhDict", !8, i64 0}
!22 = distinct !{!22, !23}
!23 = !{!"llvm.loop.mustprogress"}
!24 = distinct !{!24, !23}
!25 = !{i64 0, i64 4, !26, i64 8, i64 8, !27, i64 16, i64 8, !28, i64 24, i64 8, !29, i64 32, i64 8, !30}
!26 = !{!18, !18, i64 0}
!27 = !{!19, !19, i64 0}
!28 = !{!16, !16, i64 0}
!29 = !{!20, !20, i64 0}
!30 = !{!21, !21, i64 0}
!31 = !{!17, !18, i64 0}
!32 = !{!33}
!33 = distinct !{!33, !34, !"uh_num: argument 0"}
!34 = distinct !{!34, !"uh_num"}
!35 = !{!17, !19, i64 8}
!36 = !{!15, !11, i64 48}
!37 = !{!38, !40, i64 8}
!38 = !{!"", !39, i64 0, !40, i64 8, !40, i64 16}
!39 = !{!"p1 _ZTS7UhValue", !8, i64 0}
!40 = !{!"long", !9, i64 0}
!41 = !{!38, !40, i64 16}
!42 = !{!38, !39, i64 0}
!43 = !{!44}
!44 = distinct !{!44, !45, !"uh_num: argument 0"}
!45 = distinct !{!45, !"uh_num"}
!46 = !{!17, !16, i64 16}
!47 = !{!17, !20, i64 24}
!48 = !{!17, !21, i64 32}
!49 = !{!50, !40, i64 8}
!50 = !{!"UhArray", !39, i64 0, !40, i64 8, !40, i64 16}
!51 = !{!50, !40, i64 16}
!52 = !{!50, !39, i64 0}
!53 = !{!54}
!54 = distinct !{!54, !55, !"uh_null: argument 0"}
!55 = distinct !{!55, !"uh_null"}
!56 = !{!57}
!57 = distinct !{!57, !58, !"uh_null: argument 0"}
!58 = distinct !{!58, !"uh_null"}
!59 = !{!60}
!60 = distinct !{!60, !61, !"uh_null: argument 0"}
!61 = distinct !{!61, !"uh_null"}
!62 = !{!63}
!63 = distinct !{!63, !64, !"uh_null: argument 0"}
!64 = distinct !{!64, !"uh_null"}
!65 = !{!66, !40, i64 8}
!66 = !{!"UhDict", !67, i64 0, !40, i64 8, !40, i64 16}
!67 = !{!"p1 _ZTS11UhDictEntry", !8, i64 0}
!68 = !{!66, !67, i64 0}
!69 = distinct !{!69, !23}
!70 = !{!71, !16, i64 0}
!71 = !{!"UhDictEntry", !16, i64 0, !17, i64 8}
!72 = !{!73}
!73 = distinct !{!73, !74, !"uh_null: argument 0"}
!74 = distinct !{!74, !"uh_null"}
!75 = !{!66, !40, i64 16}
!76 = !{!9, !9, i64 0}
!77 = distinct !{!77, !23}
!78 = !{!79}
!79 = distinct !{!79, !80, !"uh_num: argument 0"}
!80 = distinct !{!80, !"uh_num"}
!81 = !{!82}
!82 = distinct !{!82, !83, !"uh_num: argument 0"}
!83 = distinct !{!83, !"uh_num"}
!84 = !{!85}
!85 = distinct !{!85, !86, !"uh_num: argument 0"}
!86 = distinct !{!86, !"uh_num"}
!87 = !{!88}
!88 = distinct !{!88, !89, !"uh_num: argument 0"}
!89 = distinct !{!89, !"uh_num"}
!90 = !{!91}
!91 = distinct !{!91, !92, !"uh_arr_new: argument 0"}
!92 = distinct !{!92, !"uh_arr_new"}
!93 = !{!94}
!94 = distinct !{!94, !95, !"uh_str: argument 0"}
!95 = distinct !{!95, !"uh_str"}
!96 = distinct !{!96, !23}
!97 = !{!98}
!98 = distinct !{!98, !99, !"uh_str: argument 0"}
!99 = distinct !{!99, !"uh_str"}
!100 = distinct !{!100, !23}
!101 = !{!102}
!102 = distinct !{!102, !103, !"uh_str: argument 0"}
!103 = distinct !{!103, !"uh_str"}
!104 = !{!105}
!105 = distinct !{!105, !106, !"uh_str: argument 0"}
!106 = distinct !{!106, !"uh_str"}
!107 = distinct !{!107, !23}
!108 = distinct !{!108, !23}
!109 = !{!110}
!110 = distinct !{!110, !111, !"uh_str: argument 0"}
!111 = distinct !{!111, !"uh_str"}
!112 = distinct !{!112, !23}
!113 = distinct !{!113, !23}
!114 = !{!115}
!115 = distinct !{!115, !116, !"uh_str: argument 0"}
!116 = distinct !{!116, !"uh_str"}
!117 = !{!118}
!118 = distinct !{!118, !119, !"uh_str: argument 0"}
!119 = distinct !{!119, !"uh_str"}
!120 = distinct !{!120, !23}
!121 = !{!122}
!122 = distinct !{!122, !123, !"uh_str: argument 0"}
!123 = distinct !{!123, !"uh_str"}
!124 = !{!125}
!125 = distinct !{!125, !126, !"uh_str: argument 0"}
!126 = distinct !{!126, !"uh_str"}
!127 = !{!128}
!128 = distinct !{!128, !129, !"uh_str: argument 0"}
!129 = distinct !{!129, !"uh_str"}
!130 = !{!131}
!131 = distinct !{!131, !132, !"uh_str: argument 0"}
!132 = distinct !{!132, !"uh_str"}
!133 = !{!134}
!134 = distinct !{!134, !135, !"uh_str: argument 0"}
!135 = distinct !{!135, !"uh_str"}
!136 = !{!137}
!137 = distinct !{!137, !138, !"uh_str: argument 0"}
!138 = distinct !{!138, !"uh_str"}
!139 = !{!140}
!140 = distinct !{!140, !141, !"uh_str: argument 0"}
!141 = distinct !{!141, !"uh_str"}
!142 = !{!143}
!143 = distinct !{!143, !144, !"uh_str: argument 0"}
!144 = distinct !{!144, !"uh_str"}
!145 = !{!146}
!146 = distinct !{!146, !147, !"uh_str: argument 0"}
!147 = distinct !{!147, !"uh_str"}
!148 = !{!149}
!149 = distinct !{!149, !150, !"uh_str: argument 0"}
!150 = distinct !{!150, !"uh_str"}
!151 = !{!152}
!152 = distinct !{!152, !153, !"uh_num: argument 0"}
!153 = distinct !{!153, !"uh_num"}
!154 = !{!155}
!155 = distinct !{!155, !156, !"uh_num: argument 0"}
!156 = distinct !{!156, !"uh_num"}
!157 = !{!158}
!158 = distinct !{!158, !159, !"uh_num: argument 0"}
!159 = distinct !{!159, !"uh_num"}
!160 = !{!161}
!161 = distinct !{!161, !162, !"uh_null: argument 0"}
!162 = distinct !{!162, !"uh_null"}
!163 = !{!164}
!164 = distinct !{!164, !165, !"uh_dict_new: argument 0"}
!165 = distinct !{!165, !"uh_dict_new"}
!166 = !{!167}
!167 = distinct !{!167, !168, !"uh_str: argument 0"}
!168 = distinct !{!168, !"uh_str"}
!169 = !{!170}
!170 = distinct !{!170, !171, !"uh_str: argument 0"}
!171 = distinct !{!171, !"uh_str"}
!172 = !{!173}
!173 = distinct !{!173, !174, !"uh_str: argument 0"}
!174 = distinct !{!174, !"uh_str"}
!175 = !{!176}
!176 = distinct !{!176, !177, !"uh_str: argument 0"}
!177 = distinct !{!177, !"uh_str"}
!178 = !{!179}
!179 = distinct !{!179, !180, !"uh_str: argument 0"}
!180 = distinct !{!180, !"uh_str"}
!181 = !{!182}
!182 = distinct !{!182, !183, !"uh_dict_get: argument 0"}
!183 = distinct !{!183, !"uh_dict_get"}
!184 = !{!185}
!185 = distinct !{!185, !186, !"uh_file_read: argument 0"}
!186 = distinct !{!186, !"uh_file_read"}
!187 = !{!188}
!188 = distinct !{!188, !189, !"uh_str: argument 0"}
!189 = distinct !{!189, !"uh_str"}
!190 = !{!188, !185}
!191 = !{!192}
!192 = distinct !{!192, !193, !"uh_str: argument 0"}
!193 = distinct !{!193, !"uh_str"}
!194 = !{!192, !185}
!195 = !{!196}
!196 = distinct !{!196, !197, !"uh_file_read: argument 0"}
!197 = distinct !{!197, !"uh_file_read"}
!198 = !{!199}
!199 = distinct !{!199, !200, !"uh_str: argument 0"}
!200 = distinct !{!200, !"uh_str"}
!201 = !{!199, !196}
!202 = !{!203}
!203 = distinct !{!203, !204, !"uh_str: argument 0"}
!204 = distinct !{!204, !"uh_str"}
!205 = !{!203, !196}
!206 = !{!207}
!207 = distinct !{!207, !208, !"uh_str: argument 0"}
!208 = distinct !{!208, !"uh_str"}
!209 = !{!210}
!210 = distinct !{!210, !211, !"uh_num: argument 0"}
!211 = distinct !{!211, !"uh_num"}
!212 = !{!213}
!213 = distinct !{!213, !214, !"uh_str: argument 0"}
!214 = distinct !{!214, !"uh_str"}
!215 = !{!216}
!216 = distinct !{!216, !217, !"uh_dict_get: argument 0"}
!217 = distinct !{!217, !"uh_dict_get"}
!218 = !{!219}
!219 = distinct !{!219, !220, !"uh_num: argument 0"}
!220 = distinct !{!220, !"uh_num"}
!221 = !{!222}
!222 = distinct !{!222, !223, !"uh_num: argument 0"}
!223 = distinct !{!223, !"uh_num"}
!224 = !{!225}
!225 = distinct !{!225, !226, !"uh_str: argument 0"}
!226 = distinct !{!226, !"uh_str"}
!227 = !{!228}
!228 = distinct !{!228, !229, !"uh_null: argument 0"}
!229 = distinct !{!229, !"uh_null"}
!230 = !{!231}
!231 = distinct !{!231, !232, !"uh_str: argument 0"}
!232 = distinct !{!232, !"uh_str"}
!233 = !{!234}
!234 = distinct !{!234, !235, !"uh_null: argument 0"}
!235 = distinct !{!235, !"uh_null"}
!236 = !{!237}
!237 = distinct !{!237, !238, !"uh_str: argument 0"}
!238 = distinct !{!238, !"uh_str"}
!239 = distinct !{!239, !23}
!240 = !{!241}
!241 = distinct !{!241, !242, !"uh_arr_new: argument 0"}
!242 = distinct !{!242, !"uh_arr_new"}
!243 = distinct !{!243, !23}
!244 = distinct !{!244, !23}
!245 = !{!246}
!246 = distinct !{!246, !247, !"uh_str: argument 0"}
!247 = distinct !{!247, !"uh_str"}
!248 = !{!249}
!249 = distinct !{!249, !250, !"uh_num: argument 0"}
!250 = distinct !{!250, !"uh_num"}
!251 = !{!252}
!252 = distinct !{!252, !253, !"uh_num: argument 0"}
!253 = distinct !{!253, !"uh_num"}
!254 = !{!255}
!255 = distinct !{!255, !256, !"uh_arr_new: argument 0"}
!256 = distinct !{!256, !"uh_arr_new"}
!257 = distinct !{!257, !23}
!258 = distinct !{!258, !23}
!259 = distinct !{!259, !23}
!260 = !{!261}
!261 = distinct !{!261, !262, !"uh_num: argument 0"}
!262 = distinct !{!262, !"uh_num"}
!263 = !{!264}
!264 = distinct !{!264, !265, !"uh_num: argument 0"}
!265 = distinct !{!265, !"uh_num"}
!266 = !{!267}
!267 = distinct !{!267, !268, !"uh_num: argument 0"}
!268 = distinct !{!268, !"uh_num"}
!269 = !{!270}
!270 = distinct !{!270, !271, !"uh_num: argument 0"}
!271 = distinct !{!271, !"uh_num"}
!272 = !{!273}
!273 = distinct !{!273, !274, !"uh_num: argument 0"}
!274 = distinct !{!274, !"uh_num"}
!275 = !{!276}
!276 = distinct !{!276, !277, !"uh_num: argument 0"}
!277 = distinct !{!277, !"uh_num"}
!278 = !{!279}
!279 = distinct !{!279, !280, !"uh_str: argument 0"}
!280 = distinct !{!280, !"uh_str"}
!281 = !{!282}
!282 = distinct !{!282, !283, !"uh_str: argument 0"}
!283 = distinct !{!283, !"uh_str"}
!284 = !{!285}
!285 = distinct !{!285, !286, !"uh_str: argument 0"}
!286 = distinct !{!286, !"uh_str"}
!287 = !{!288}
!288 = distinct !{!288, !289, !"uh_str: argument 0"}
!289 = distinct !{!289, !"uh_str"}
!290 = !{!291}
!291 = distinct !{!291, !292, !"uh_str: argument 0"}
!292 = distinct !{!292, !"uh_str"}
!293 = !{!294}
!294 = distinct !{!294, !295, !"uh_str: argument 0"}
!295 = distinct !{!295, !"uh_str"}
!296 = !{!297}
!297 = distinct !{!297, !298, !"uh_str: argument 0"}
!298 = distinct !{!298, !"uh_str"}
!299 = !{!300}
!300 = distinct !{!300, !301, !"uh_num: argument 0"}
!301 = distinct !{!301, !"uh_num"}
!302 = !{!303}
!303 = distinct !{!303, !304, !"uh_num: argument 0"}
!304 = distinct !{!304, !"uh_num"}
!305 = !{!306}
!306 = distinct !{!306, !307, !"uh_num: argument 0"}
!307 = distinct !{!307, !"uh_num"}
!308 = !{!309}
!309 = distinct !{!309, !310, !"uh_num: argument 0"}
!310 = distinct !{!310, !"uh_num"}
!311 = !{!312}
!312 = distinct !{!312, !313, !"uh_num: argument 0"}
!313 = distinct !{!313, !"uh_num"}
!314 = !{!315}
!315 = distinct !{!315, !316, !"uh_str: argument 0"}
!316 = distinct !{!316, !"uh_str"}
!317 = !{!318, !318, i64 0}
!318 = !{!"p1 int", !8, i64 0}
!319 = !{!320}
!320 = distinct !{!320, !321, !"uh_str: argument 0"}
!321 = distinct !{!321, !"uh_str"}
!322 = distinct !{!322, !323}
!323 = !{!"llvm.loop.unroll.disable"}
!324 = !{!325}
!325 = distinct !{!325, !326, !"uh_str: argument 0"}
!326 = distinct !{!326, !"uh_str"}
!327 = distinct !{!327, !23}
!328 = !{!329}
!329 = distinct !{!329, !330, !"uh_str: argument 0"}
!330 = distinct !{!330, !"uh_str"}
!331 = !{!332}
!332 = distinct !{!332, !333, !"uh_str: argument 0"}
!333 = distinct !{!333, !"uh_str"}
!334 = distinct !{!334, !323}
!335 = !{!336}
!336 = distinct !{!336, !337, !"uh_str: argument 0"}
!337 = distinct !{!337, !"uh_str"}
!338 = distinct !{!338, !23}
!339 = !{!340}
!340 = distinct !{!340, !341, !"uh_num: argument 0"}
!341 = distinct !{!341, !"uh_num"}
!342 = !{!343}
!343 = distinct !{!343, !344, !"uh_num: argument 0"}
!344 = distinct !{!344, !"uh_num"}
!345 = !{!346}
!346 = distinct !{!346, !347, !"uh_num: argument 0"}
!347 = distinct !{!347, !"uh_num"}
!348 = !{!349}
!349 = distinct !{!349, !350, !"uh_arr_new: argument 0"}
!350 = distinct !{!350, !"uh_arr_new"}
!351 = !{!352}
!352 = distinct !{!352, !353, !"uh_arr_new: argument 0"}
!353 = distinct !{!353, !"uh_arr_new"}
!354 = distinct !{!354, !23}
!355 = !{!356}
!356 = distinct !{!356, !357, !"uh_stringify: argument 0"}
!357 = distinct !{!357, !"uh_stringify"}
!358 = !{!359}
!359 = distinct !{!359, !360, !"uh_str: argument 0"}
!360 = distinct !{!360, !"uh_str"}
!361 = !{!362}
!362 = distinct !{!362, !363, !"uh_str: argument 0"}
!363 = distinct !{!363, !"uh_str"}
!364 = !{!365}
!365 = distinct !{!365, !366, !"uh_str: argument 0"}
!366 = distinct !{!366, !"uh_str"}
!367 = distinct !{!367, !23}
!368 = !{!40, !40, i64 0}
!369 = !{!370}
!370 = distinct !{!370, !371, !"uh_str: argument 0"}
!371 = distinct !{!371, !"uh_str"}
!372 = !{!373}
!373 = distinct !{!373, !374, !"uh_null: argument 0"}
!374 = distinct !{!374, !"uh_null"}
!375 = !{!376}
!376 = distinct !{!376, !377, !"uh_num: argument 0"}
!377 = distinct !{!377, !"uh_num"}
!378 = !{!379}
!379 = distinct !{!379, !380, !"uh_num: argument 0"}
!380 = distinct !{!380, !"uh_num"}
!381 = !{!382}
!382 = distinct !{!382, !383, !"uh_num: argument 0"}
!383 = distinct !{!383, !"uh_num"}
!384 = !{!385}
!385 = distinct !{!385, !386, !"uh_num: argument 0"}
!386 = distinct !{!386, !"uh_num"}
!387 = !{!388}
!388 = distinct !{!388, !389, !"uh_null: argument 0"}
!389 = distinct !{!389, !"uh_null"}
!390 = !{!391}
!391 = distinct !{!391, !392, !"uh_arr_new: argument 0"}
!392 = distinct !{!392, !"uh_arr_new"}
!393 = distinct !{!393, !23}
!394 = distinct !{!394, !23}
!395 = !{!396}
!396 = distinct !{!396, !397, !"uh_null: argument 0"}
!397 = distinct !{!397, !"uh_null"}
!398 = !{!399}
!399 = distinct !{!399, !400, !"uh_num: argument 0"}
!400 = distinct !{!400, !"uh_num"}
!401 = !{!402}
!402 = distinct !{!402, !403, !"uh_num: argument 0"}
!403 = distinct !{!403, !"uh_num"}
!404 = !{!405}
!405 = distinct !{!405, !406, !"uh_num: argument 0"}
!406 = distinct !{!406, !"uh_num"}
!407 = !{!408}
!408 = distinct !{!408, !409, !"uh_num: argument 0"}
!409 = distinct !{!409, !"uh_num"}
!410 = !{!411}
!411 = distinct !{!411, !412, !"uh_null: argument 0"}
!412 = distinct !{!412, !"uh_null"}
!413 = !{!414}
!414 = distinct !{!414, !415, !"uh_arr_new: argument 0"}
!415 = distinct !{!415, !"uh_arr_new"}
!416 = distinct !{!416, !23}
!417 = distinct !{!417, !23}
!418 = !{!419}
!419 = distinct !{!419, !420, !"uh_arr_new: argument 0"}
!420 = distinct !{!420, !"uh_arr_new"}
!421 = distinct !{!421, !23}
!422 = !{!423}
!423 = distinct !{!423, !424, !"uh_str: argument 0"}
!424 = distinct !{!424, !"uh_str"}
!425 = distinct !{!425, !23}
!426 = !{!427}
!427 = distinct !{!427, !428, !"uh_str: argument 0"}
!428 = distinct !{!428, !"uh_str"}
!429 = !{!430}
!430 = distinct !{!430, !431, !"uh_null: argument 0"}
!431 = distinct !{!431, !"uh_null"}
!432 = !{!433}
!433 = distinct !{!433, !434, !"uh_null: argument 0"}
!434 = distinct !{!434, !"uh_null"}
!435 = !{!436}
!436 = distinct !{!436, !437, !"uh_str: argument 0"}
!437 = distinct !{!437, !"uh_str"}
!438 = !{!439}
!439 = distinct !{!439, !440, !"uh_num: argument 0"}
!440 = distinct !{!440, !"uh_num"}
!441 = !{!442}
!442 = distinct !{!442, !443, !"uh_num: argument 0"}
!443 = distinct !{!443, !"uh_num"}
!444 = !{!445}
!445 = distinct !{!445, !446, !"uh_num: argument 0"}
!446 = distinct !{!446, !"uh_num"}
!447 = !{!448}
!448 = distinct !{!448, !449, !"uh_num: argument 0"}
!449 = distinct !{!449, !"uh_num"}
!450 = !{!451}
!451 = distinct !{!451, !452, !"uh_null: argument 0"}
!452 = distinct !{!452, !"uh_null"}
!453 = !{!454}
!454 = distinct !{!454, !455, !"uh_arr_new: argument 0"}
!455 = distinct !{!455, !"uh_arr_new"}
!456 = distinct !{!456, !23}
!457 = distinct !{!457, !23}
!458 = !{!459}
!459 = distinct !{!459, !460, !"uh_null: argument 0"}
!460 = distinct !{!460, !"uh_null"}
!461 = distinct !{!461, !23}
!462 = !{!463}
!463 = distinct !{!463, !464, !"uh_null: argument 0"}
!464 = distinct !{!464, !"uh_null"}
!465 = !{i64 4, i64 8, !27, i64 12, i64 8, !28, i64 20, i64 8, !29, i64 28, i64 8, !30}
!466 = distinct !{!466, !23}
!467 = !{!468}
!468 = distinct !{!468, !469, !"uh_null: argument 0"}
!469 = distinct !{!469, !"uh_null"}
!470 = !{!471}
!471 = distinct !{!471, !472, !"uh_arr_new: argument 0"}
!472 = distinct !{!472, !"uh_arr_new"}
!473 = !{!474}
!474 = distinct !{!474, !475, !"uh_arr_new: argument 0"}
!475 = distinct !{!475, !"uh_arr_new"}
!476 = distinct !{!476, !23}
!477 = distinct !{!477, !23}
!478 = !{!479}
!479 = distinct !{!479, !480, !"uh_null: argument 0"}
!480 = distinct !{!480, !"uh_null"}
!481 = distinct !{!481, !23}
!482 = distinct !{!482, !23}
!483 = distinct !{!483, !23}
!484 = distinct !{!484, !23}
!485 = !{!8, !8, i64 0}
!486 = distinct !{!486, !23}
!487 = distinct !{!487, !23}
!488 = distinct !{!488, !23}
!489 = !{!490}
!490 = distinct !{!490, !491, !"uh_arr_get: argument 0"}
!491 = distinct !{!491, !"uh_arr_get"}
!492 = !{!493, !490}
!493 = distinct !{!493, !494, !"uh_null: argument 0"}
!494 = distinct !{!494, !"uh_null"}
!495 = !{!496, !490}
!496 = distinct !{!496, !497, !"uh_null: argument 0"}
!497 = distinct !{!497, !"uh_null"}
!498 = !{!499}
!499 = distinct !{!499, !500, !"uh_dict_get: argument 0"}
!500 = distinct !{!500, !"uh_dict_get"}
!501 = !{!502, !499}
!502 = distinct !{!502, !503, !"uh_null: argument 0"}
!503 = distinct !{!503, !"uh_null"}
!504 = !{!505, !499}
!505 = distinct !{!505, !506, !"uh_null: argument 0"}
!506 = distinct !{!506, !"uh_null"}
!507 = !{!508, !499}
!508 = distinct !{!508, !509, !"uh_null: argument 0"}
!509 = distinct !{!509, !"uh_null"}
!510 = !{!511}
!511 = distinct !{!511, !512, !"uh_null: argument 0"}
!512 = distinct !{!512, !"uh_null"}
!513 = !{!514, !514, i64 0}
!514 = !{!"p1 _ZTS8_IO_FILE", !8, i64 0}
!515 = !{!516}
!516 = distinct !{!516, !517, !"uh_arr_new: argument 0"}
!517 = distinct !{!517, !"uh_arr_new"}
!518 = !{!519}
!519 = distinct !{!519, !520, !"uh_str: argument 0"}
!520 = distinct !{!520, !"uh_str"}
!521 = distinct !{!521, !23}
!522 = !{!7, !7, i64 0}
!523 = !{!524}
!524 = distinct !{!524, !525, !"uh_dict_new: argument 0"}
!525 = distinct !{!525, !"uh_dict_new"}
!526 = !{!527}
!527 = distinct !{!527, !528, !"uh_str: argument 0"}
!528 = distinct !{!528, !"uh_str"}
!529 = !{!530}
!530 = distinct !{!530, !531, !"uh_dict_new: argument 0"}
!531 = distinct !{!531, !"uh_dict_new"}
!532 = !{!533, !533, i64 0}
!533 = !{!"p2 omnipotent char", !534, i64 0}
!534 = !{!"any p2 pointer", !8, i64 0}
!535 = !{!536}
!536 = distinct !{!536, !537, !"uh_str: argument 0"}
!537 = distinct !{!537, !"uh_str"}
!538 = !{!539}
!539 = distinct !{!539, !540, !"uh_str: argument 0"}
!540 = distinct !{!540, !"uh_str"}
!541 = distinct !{!541, !23}
!542 = !{!543}
!543 = distinct !{!543, !544, !"uh_str: argument 0"}
!544 = distinct !{!544, !"uh_str"}
!545 = !{!546}
!546 = distinct !{!546, !547, !"uh_str: argument 0"}
!547 = distinct !{!547, !"uh_str"}
!548 = !{!549, !18, i64 24}
!549 = !{!"stat", !40, i64 0, !40, i64 8, !40, i64 16, !18, i64 24, !18, i64 28, !18, i64 32, !18, i64 36, !40, i64 40, !40, i64 48, !40, i64 56, !40, i64 64, !550, i64 72, !550, i64 88, !550, i64 104, !9, i64 120}
!550 = !{!"timespec", !40, i64 0, !40, i64 8}
!551 = !{!552}
!552 = distinct !{!552, !553, !"uh_str: argument 0"}
!553 = distinct !{!553, !"uh_str"}
!554 = !{!555}
!555 = distinct !{!555, !556, !"uh_str: argument 0"}
!556 = distinct !{!556, !"uh_str"}
!557 = !{!558}
!558 = distinct !{!558, !559, !"uh_str: argument 0"}
!559 = distinct !{!559, !"uh_str"}
!560 = !{!561}
!561 = distinct !{!561, !562, !"uh_null: argument 0"}
!562 = distinct !{!562, !"uh_null"}
!563 = !{!564}
!564 = distinct !{!564, !565, !"uh_dict_get_key: argument 0"}
!565 = distinct !{!565, !"uh_dict_get_key"}
!566 = !{!567}
!567 = distinct !{!567, !568, !"uh_dict_get_key: argument 0"}
!568 = distinct !{!568, !"uh_dict_get_key"}
!569 = !{!570}
!570 = distinct !{!570, !571, !"uh_dict_get_key: argument 0"}
!571 = distinct !{!571, !"uh_dict_get_key"}
!572 = !{!573}
!573 = distinct !{!573, !574, !"uh_dict_get_key: argument 0"}
!574 = distinct !{!574, !"uh_dict_get_key"}
!575 = !{!576, !573}
!576 = distinct !{!576, !577, !"uh_null: argument 0"}
!577 = distinct !{!577, !"uh_null"}
!578 = !{!579}
!579 = distinct !{!579, !580, !"uh_dict_new: argument 0"}
!580 = distinct !{!580, !"uh_dict_new"}
!581 = !{!582}
!582 = distinct !{!582, !583, !"uh_dict_new: argument 0"}
!583 = distinct !{!583, !"uh_dict_new"}
!584 = distinct !{!584, !23}
!585 = !{!586}
!586 = distinct !{!586, !587, !"uh_dict_new: argument 0"}
!587 = distinct !{!587, !"uh_dict_new"}
!588 = !{!589}
!589 = distinct !{!589, !590, !"uh_str: argument 0"}
!590 = distinct !{!590, !"uh_str"}
!591 = !{!592}
!592 = distinct !{!592, !593, !"uh_num: argument 0"}
!593 = distinct !{!593, !"uh_num"}
!594 = !{!595}
!595 = distinct !{!595, !596, !"uh_str: argument 0"}
!596 = distinct !{!596, !"uh_str"}
!597 = !{!598}
!598 = distinct !{!598, !599, !"uh_str: argument 0"}
!599 = distinct !{!599, !"uh_str"}
!600 = !{!601, !16, i64 0}
!601 = !{!"", !16, i64 0, !40, i64 8, !40, i64 16}
!602 = !{!603}
!603 = distinct !{!603, !604, !"uh_str: argument 0"}
!604 = distinct !{!604, !"uh_str"}
!605 = !{!606}
!606 = distinct !{!606, !607, !"uh_str: argument 0"}
!607 = distinct !{!607, !"uh_str"}
!608 = !{!609}
!609 = distinct !{!609, !610, !"uh_num: argument 0"}
!610 = distinct !{!610, !"uh_num"}
!611 = !{!612}
!612 = distinct !{!612, !613, !"uh_str: argument 0"}
!613 = distinct !{!613, !"uh_str"}
!614 = distinct !{!614, !23}
!615 = !{!616, !16, i64 0}
!616 = !{!"", !16, i64 0, !16, i64 8}
!617 = !{!616, !16, i64 8}
!618 = !{!619}
!619 = distinct !{!619, !620, !"uh_null: argument 0"}
!620 = distinct !{!620, !"uh_null"}
!621 = distinct !{!621, !23}
!622 = !{!623}
!623 = distinct !{!623, !624, !"uh_num: argument 0"}
!624 = distinct !{!624, !"uh_num"}
!625 = !{!626}
!626 = distinct !{!626, !627, !"uh_num: argument 0"}
!627 = distinct !{!627, !"uh_num"}
!628 = distinct !{!628, !23}
!629 = !{!630}
!630 = distinct !{!630, !631, !"uh_http_build_req: argument 0"}
!631 = distinct !{!631, !"uh_http_build_req"}
!632 = !{!633, !630}
!633 = distinct !{!633, !634, !"uh_dict_new: argument 0"}
!634 = distinct !{!634, !"uh_dict_new"}
!635 = !{!636}
!636 = distinct !{!636, !637, !"uh_str: argument 0"}
!637 = distinct !{!637, !"uh_str"}
!638 = !{!636, !630}
!639 = !{!640}
!640 = distinct !{!640, !641, !"uh_str: argument 0"}
!641 = distinct !{!641, !"uh_str"}
!642 = !{!640, !630}
!643 = !{!644}
!644 = distinct !{!644, !645, !"uh_str: argument 0"}
!645 = distinct !{!645, !"uh_str"}
!646 = !{!644, !630}
!647 = !{!648}
!648 = distinct !{!648, !649, !"uh_str: argument 0"}
!649 = distinct !{!649, !"uh_str"}
!650 = !{!648, !630}
!651 = !{!652}
!652 = distinct !{!652, !653, !"uh_str: argument 0"}
!653 = distinct !{!653, !"uh_str"}
!654 = !{!652, !630}
!655 = !{!656}
!656 = distinct !{!656, !657, !"uh_str: argument 0"}
!657 = distinct !{!657, !"uh_str"}
!658 = !{!656, !630}
!659 = !{!660}
!660 = distinct !{!660, !661, !"uh_http_build_res: argument 0"}
!661 = distinct !{!661, !"uh_http_build_res"}
!662 = !{!663, !660}
!663 = distinct !{!663, !664, !"uh_dict_new: argument 0"}
!664 = distinct !{!664, !"uh_dict_new"}
!665 = !{!666}
!666 = distinct !{!666, !667, !"uh_str: argument 0"}
!667 = distinct !{!667, !"uh_str"}
!668 = !{!666, !660}
!669 = !{!670}
!670 = distinct !{!670, !671, !"uh_num: argument 0"}
!671 = distinct !{!671, !"uh_num"}
!672 = !{!673}
!673 = distinct !{!673, !674, !"uh_str: argument 0"}
!674 = distinct !{!674, !"uh_str"}
!675 = !{!673, !660}
!676 = !{!677}
!677 = distinct !{!677, !678, !"uh_str: argument 0"}
!678 = distinct !{!678, !"uh_str"}
!679 = !{!677, !660}
!680 = !{!681}
!681 = distinct !{!681, !682, !"uh_dict_new: argument 0"}
!682 = distinct !{!682, !"uh_dict_new"}
!683 = !{!684}
!684 = distinct !{!684, !685, !"uh_str: argument 0"}
!685 = distinct !{!685, !"uh_str"}
!686 = !{!684, !660}
!687 = !{!688}
!688 = distinct !{!688, !689, !"uh_str: argument 0"}
!689 = distinct !{!689, !"uh_str"}
!690 = !{!688, !660}
!691 = !{!692}
!692 = distinct !{!692, !693, !"uh_str: argument 0"}
!693 = distinct !{!693, !"uh_str"}
!694 = !{!692, !660}
!695 = !{!696}
!696 = distinct !{!696, !697, !"uh_str: argument 0"}
!697 = distinct !{!697, !"uh_str"}
!698 = !{!699}
!699 = distinct !{!699, !700, !"uh_num: argument 0"}
!700 = distinct !{!700, !"uh_num"}
!701 = !{!702}
!702 = distinct !{!702, !703, !"uh_str: argument 0"}
!703 = distinct !{!703, !"uh_str"}
!704 = !{!705}
!705 = distinct !{!705, !706, !"uh_str: argument 0"}
!706 = distinct !{!706, !"uh_str"}
!707 = !{!708, !710}
!708 = distinct !{!708, !709, !"uh_null: argument 0"}
!709 = distinct !{!709, !"uh_null"}
!710 = distinct !{!710, !711, !"uh_dict_get_key: argument 0"}
!711 = distinct !{!711, !"uh_dict_get_key"}
!712 = !{!713}
!713 = distinct !{!713, !714, !"uh_dict_get_key: argument 0"}
!714 = distinct !{!714, !"uh_dict_get_key"}
!715 = !{!710}
!716 = !{!717, !710}
!717 = distinct !{!717, !718, !"uh_null: argument 0"}
!718 = distinct !{!718, !"uh_null"}
!719 = !{!720}
!720 = distinct !{!720, !721, !"uh_dict_get_key: argument 0"}
!721 = distinct !{!721, !"uh_dict_get_key"}
!722 = !{!723}
!723 = distinct !{!723, !724, !"uh_dict_get_key: argument 0"}
!724 = distinct !{!724, !"uh_dict_get_key"}
!725 = !{!726}
!726 = distinct !{!726, !727, !"uh_dict_get_key: argument 0"}
!727 = distinct !{!727, !"uh_dict_get_key"}
!728 = !{!729}
!729 = distinct !{!729, !730, !"uh_str: argument 0"}
!730 = distinct !{!730, !"uh_str"}
!731 = !{!732}
!732 = distinct !{!732, !733, !"uh_dict_get_key: argument 0"}
!733 = distinct !{!733, !"uh_dict_get_key"}
!734 = !{!735}
!735 = distinct !{!735, !736, !"uh_json_parse: argument 0"}
!736 = distinct !{!736, !"uh_json_parse"}
!737 = !{!738}
!738 = distinct !{!738, !739, !"uh_null: argument 0"}
!739 = distinct !{!739, !"uh_null"}
!740 = !{!741}
!741 = distinct !{!741, !742, !"uh_dict_get_key: argument 0"}
!742 = distinct !{!742, !"uh_dict_get_key"}
!743 = !{!744}
!744 = distinct !{!744, !745, !"uh_str: argument 0"}
!745 = distinct !{!745, !"uh_str"}
!746 = !{!747}
!747 = distinct !{!747, !748, !"uh_json_stringify: argument 0"}
!748 = distinct !{!748, !"uh_json_stringify"}
!749 = !{!750}
!750 = distinct !{!750, !751, !"uh_str: argument 0"}
!751 = distinct !{!751, !"uh_str"}
!752 = !{!750, !747}
!753 = !{!754}
!754 = distinct !{!754, !755, !"uh_str: argument 0"}
!755 = distinct !{!755, !"uh_str"}
!756 = !{!757}
!757 = distinct !{!757, !758, !"uh_null: argument 0"}
!758 = distinct !{!758, !"uh_null"}
!759 = !{!760}
!760 = distinct !{!760, !761, !"uh_null: argument 0"}
!761 = distinct !{!761, !"uh_null"}
!762 = !{!763}
!763 = distinct !{!763, !764, !"uh_str: argument 0"}
!764 = distinct !{!764, !"uh_str"}
!765 = !{!766}
!766 = distinct !{!766, !767, !"uh_dict_get_key: argument 0"}
!767 = distinct !{!767, !"uh_dict_get_key"}
!768 = !{!769}
!769 = distinct !{!769, !770, !"uh_dict_get_key: argument 0"}
!770 = distinct !{!770, !"uh_dict_get_key"}
!771 = !{!772, !772, i64 0}
!772 = !{!"p1 _ZTS7sqlite3", !8, i64 0}
!773 = !{!774}
!774 = distinct !{!774, !775, !"uh_null: argument 0"}
!775 = distinct !{!775, !"uh_null"}
!776 = !{!777}
!777 = distinct !{!777, !778, !"uh_null: argument 0"}
!778 = distinct !{!778, !"uh_null"}
!779 = !{!780}
!780 = distinct !{!780, !781, !"uh_dict_new: argument 0"}
!781 = distinct !{!781, !"uh_dict_new"}
!782 = !{!783}
!783 = distinct !{!783, !784, !"uh_str: argument 0"}
!784 = distinct !{!784, !"uh_str"}
!785 = !{!786}
!786 = distinct !{!786, !787, !"uh_num: argument 0"}
!787 = distinct !{!787, !"uh_num"}
!788 = !{!789}
!789 = distinct !{!789, !790, !"uh_dict_get_key: argument 0"}
!790 = distinct !{!790, !"uh_dict_get_key"}
!791 = !{!792, !772, i64 0}
!792 = !{!"", !772, i64 0, !16, i64 8}
!793 = !{!794}
!794 = distinct !{!794, !795, !"uh_num: argument 0"}
!795 = distinct !{!795, !"uh_num"}
!796 = !{!797}
!797 = distinct !{!797, !798, !"uh_num: argument 0"}
!798 = distinct !{!798, !"uh_num"}
!799 = !{!800}
!800 = distinct !{!800, !801, !"uh_num: argument 0"}
!801 = distinct !{!801, !"uh_num"}
!802 = !{!803}
!803 = distinct !{!803, !804, !"uh_dict_get_key: argument 0"}
!804 = distinct !{!804, !"uh_dict_get_key"}
!805 = !{!806}
!806 = distinct !{!806, !807, !"uh_arr_new: argument 0"}
!807 = distinct !{!807, !"uh_arr_new"}
!808 = !{!809}
!809 = distinct !{!809, !810, !"uh_arr_new: argument 0"}
!810 = distinct !{!810, !"uh_arr_new"}
!811 = !{!812, !812, i64 0}
!812 = !{!"p1 _ZTS12sqlite3_stmt", !8, i64 0}
!813 = !{!814}
!814 = distinct !{!814, !815, !"uh_dict_new: argument 0"}
!815 = distinct !{!815, !"uh_dict_new"}
!816 = distinct !{!816, !23}
!817 = !{!818}
!818 = distinct !{!818, !819, !"uh_null: argument 0"}
!819 = distinct !{!819, !"uh_null"}
!820 = !{!821}
!821 = distinct !{!821, !822, !"uh_str: argument 0"}
!822 = distinct !{!822, !"uh_str"}
!823 = !{!824}
!824 = distinct !{!824, !825, !"uh_null: argument 0"}
!825 = distinct !{!825, !"uh_null"}
!826 = !{!827}
!827 = distinct !{!827, !828, !"uh_str: argument 0"}
!828 = distinct !{!828, !"uh_str"}
!829 = distinct !{!829, !23}
!830 = !{!831}
!831 = distinct !{!831, !832, !"uh_str: argument 0"}
!832 = distinct !{!832, !"uh_str"}
!833 = !{!834}
!834 = distinct !{!834, !835, !"uh_str: argument 0"}
!835 = distinct !{!835, !"uh_str"}
!836 = !{!837}
!837 = distinct !{!837, !838, !"uh_null: argument 0"}
!838 = distinct !{!838, !"uh_null"}
!839 = !{!840}
!840 = distinct !{!840, !841, !"uh_null: argument 0"}
!841 = distinct !{!841, !"uh_null"}
!842 = !{!843, !16, i64 8}
!843 = !{!"", !40, i64 0, !16, i64 8, !17, i64 16}
!844 = !{!534, !534, i64 0}
!845 = !{!846}
!846 = distinct !{!846, !847, !"uh_null: argument 0"}
!847 = distinct !{!847, !"uh_null"}
!848 = !{!849}
!849 = distinct !{!849, !850, !"uh_null: argument 0"}
!850 = distinct !{!850, !"uh_null"}
!851 = !{!852}
!852 = distinct !{!852, !853, !"uh_dict_new: argument 0"}
!853 = distinct !{!853, !"uh_dict_new"}
!854 = !{!855}
!855 = distinct !{!855, !856, !"uh_str: argument 0"}
!856 = distinct !{!856, !"uh_str"}
!857 = !{!858}
!858 = distinct !{!858, !859, !"uh_num: argument 0"}
!859 = distinct !{!859, !"uh_num"}
!860 = !{!861}
!861 = distinct !{!861, !862, !"uh_dict_get_key: argument 0"}
!862 = distinct !{!862, !"uh_dict_get_key"}
!863 = !{!843, !40, i64 0}
!864 = distinct !{!864, !23}
!865 = !{!866, !21, i64 0}
!866 = !{!"", !21, i64 0, !9, i64 8}
!867 = !{!868}
!868 = distinct !{!868, !869, !"uh_dict_get_key: argument 0"}
!869 = distinct !{!869, !"uh_dict_get_key"}
!870 = !{!871}
!871 = distinct !{!871, !872, !"uh_dict_get_key: argument 0"}
!872 = distinct !{!872, !"uh_dict_get_key"}
!873 = !{!874}
!874 = distinct !{!874, !875, !"uh_dict_get_key: argument 0"}
!875 = distinct !{!875, !"uh_dict_get_key"}
!876 = !{!877}
!877 = distinct !{!877, !878, !"uh_dict_get_key: argument 0"}
!878 = distinct !{!878, !"uh_dict_get_key"}
!879 = !{!880}
!880 = distinct !{!880, !881, !"uh_null: argument 0"}
!881 = distinct !{!881, !"uh_null"}
!882 = !{!883}
!883 = distinct !{!883, !884, !"uh_null: argument 0"}
!884 = distinct !{!884, !"uh_null"}
!885 = !{!886}
!886 = distinct !{!886, !887, !"uh_null: argument 0"}
!887 = distinct !{!887, !"uh_null"}
!888 = !{!889, !18, i64 8}
!889 = !{!"addrinfo", !18, i64 0, !18, i64 4, !18, i64 8, !18, i64 12, !18, i64 16, !890, i64 24, !16, i64 32, !891, i64 40}
!890 = !{!"p1 _ZTS8sockaddr", !8, i64 0}
!891 = !{!"p1 _ZTS8addrinfo", !8, i64 0}
!892 = !{!891, !891, i64 0}
!893 = !{!894}
!894 = distinct !{!894, !895, !"uh_null: argument 0"}
!895 = distinct !{!895, !"uh_null"}
!896 = !{!889, !18, i64 4}
!897 = !{!889, !18, i64 12}
!898 = !{!889, !890, i64 24}
!899 = !{!889, !18, i64 16}
!900 = !{!889, !891, i64 40}
!901 = distinct !{!901, !23}
!902 = !{!903}
!903 = distinct !{!903, !904, !"uh_null: argument 0"}
!904 = distinct !{!904, !"uh_null"}
!905 = distinct !{!905, !23}
!906 = distinct !{!906, !23}
!907 = !{!908, !40, i64 96}
!908 = !{!"", !9, i64 0, !40, i64 24, !9, i64 32, !40, i64 96}
!909 = !{!908, !40, i64 24}
!910 = distinct !{!910, !23}
!911 = !{!912}
!912 = distinct !{!912, !913, !"uh_null: argument 0"}
!913 = distinct !{!913, !"uh_null"}
!914 = !{!915}
!915 = distinct !{!915, !916, !"uh_ws_conn: argument 0"}
!916 = distinct !{!916, !"uh_ws_conn"}
!917 = !{!918, !915}
!918 = distinct !{!918, !919, !"uh_dict_new: argument 0"}
!919 = distinct !{!919, !"uh_dict_new"}
!920 = !{!921}
!921 = distinct !{!921, !922, !"uh_str: argument 0"}
!922 = distinct !{!922, !"uh_str"}
!923 = !{!921, !915}
!924 = !{!925}
!925 = distinct !{!925, !926, !"uh_num: argument 0"}
!926 = distinct !{!926, !"uh_num"}
!927 = !{!928}
!928 = distinct !{!928, !929, !"uh_dict_get_key: argument 0"}
!929 = distinct !{!929, !"uh_dict_get_key"}
!930 = !{!931}
!931 = distinct !{!931, !932, !"uh_null: argument 0"}
!932 = distinct !{!932, !"uh_null"}
!933 = !{!934}
!934 = distinct !{!934, !935, !"uh_null: argument 0"}
!935 = distinct !{!935, !"uh_null"}
!936 = !{!937}
!937 = distinct !{!937, !938, !"uh_null: argument 0"}
!938 = distinct !{!938, !"uh_null"}
!939 = !{!940}
!940 = distinct !{!940, !941, !"uh_null: argument 0"}
!941 = distinct !{!941, !"uh_null"}
!942 = !{!943}
!943 = distinct !{!943, !944, !"uh_null: argument 0"}
!944 = distinct !{!944, !"uh_null"}
!945 = !{!946}
!946 = distinct !{!946, !947, !"uh_null: argument 0"}
!947 = distinct !{!947, !"uh_null"}
!948 = !{!949}
!949 = distinct !{!949, !950, !"uh_null: argument 0"}
!950 = distinct !{!950, !"uh_null"}
!951 = !{!952}
!952 = distinct !{!952, !953, !"uh_null: argument 0"}
!953 = distinct !{!953, !"uh_null"}
!954 = distinct !{!954, !23, !955}
!955 = !{!"llvm.loop.isvectorized", i32 1}
!956 = !{!957}
!957 = distinct !{!957, !958, !"uh_null: argument 0"}
!958 = distinct !{!958, !"uh_null"}
!959 = !{!960}
!960 = distinct !{!960, !961, !"uh_str: argument 0"}
!961 = distinct !{!961, !"uh_str"}
!962 = !{!963}
!963 = distinct !{!963, !964, !"uh_dict_get_key: argument 0"}
!964 = distinct !{!964, !"uh_dict_get_key"}
!965 = !{!966}
!966 = distinct !{!966, !967, !"uh_dict_get_key: argument 0"}
!967 = distinct !{!967, !"uh_dict_get_key"}
!968 = !{!969}
!969 = distinct !{!969, !970, !"uh_num: argument 0"}
!970 = distinct !{!970, !"uh_num"}
!971 = !{!972}
!972 = distinct !{!972, !973, !"uh_num: argument 0"}
!973 = distinct !{!973, !"uh_num"}
!974 = distinct !{!974, !23}
!975 = distinct !{!975, !23}
!976 = !{!977}
!977 = distinct !{!977, !978, !"uh_ws_conn: argument 0"}
!978 = distinct !{!978, !"uh_ws_conn"}
!979 = !{!980, !977}
!980 = distinct !{!980, !981, !"uh_dict_new: argument 0"}
!981 = distinct !{!981, !"uh_dict_new"}
!982 = !{!983}
!983 = distinct !{!983, !984, !"uh_str: argument 0"}
!984 = distinct !{!984, !"uh_str"}
!985 = !{!983, !977}
!986 = !{!987}
!987 = distinct !{!987, !988, !"uh_num: argument 0"}
!988 = distinct !{!988, !"uh_num"}
!989 = !{!990}
!990 = distinct !{!990, !991, !"uh_dict_new: argument 0"}
!991 = distinct !{!991, !"uh_dict_new"}
!992 = !{!993}
!993 = distinct !{!993, !994, !"uh_str: argument 0"}
!994 = distinct !{!994, !"uh_str"}
!995 = !{!996}
!996 = distinct !{!996, !997, !"uh_num: argument 0"}
!997 = distinct !{!997, !"uh_num"}
!998 = !{!999}
!999 = distinct !{!999, !1000, !"uh_str: argument 0"}
!1000 = distinct !{!1000, !"uh_str"}
!1001 = distinct !{!1001, !23}
!1002 = !{!1003}
!1003 = distinct !{!1003, !1004, !"uh_null: argument 0"}
!1004 = distinct !{!1004, !"uh_null"}
!1005 = !{!1006}
!1006 = distinct !{!1006, !1007, !"uh_dict_get_key: argument 0"}
!1007 = distinct !{!1007, !"uh_dict_get_key"}
!1008 = !{!1009}
!1009 = distinct !{!1009, !1010, !"uh_json_stringify: argument 0"}
!1010 = distinct !{!1010, !"uh_json_stringify"}
!1011 = !{!1012, !1009}
!1012 = distinct !{!1012, !1013, !"uh_str: argument 0"}
!1013 = distinct !{!1013, !"uh_str"}
!1014 = !{!1015}
!1015 = distinct !{!1015, !1016, !"uh_null: argument 0"}
!1016 = distinct !{!1016, !"uh_null"}
!1017 = !{!1018}
!1018 = distinct !{!1018, !1019, !"uh_dict_get_key: argument 0"}
!1019 = distinct !{!1019, !"uh_dict_get_key"}
!1020 = !{!1021}
!1021 = distinct !{!1021, !1022, !"uh_smtp_send: argument 0"}
!1022 = distinct !{!1022, !"uh_smtp_send"}
!1023 = !{!1024, !1021}
!1024 = distinct !{!1024, !1025, !"uh_dict_get_key: argument 0"}
!1025 = distinct !{!1025, !"uh_dict_get_key"}
!1026 = !{!1027, !1021}
!1027 = distinct !{!1027, !1028, !"uh_dict_get_key: argument 0"}
!1028 = distinct !{!1028, !"uh_dict_get_key"}
!1029 = !{!1030, !1021}
!1030 = distinct !{!1030, !1031, !"uh_dict_get_key: argument 0"}
!1031 = distinct !{!1031, !"uh_dict_get_key"}
!1032 = !{!1033, !1021}
!1033 = distinct !{!1033, !1034, !"uh_dict_get_key: argument 0"}
!1034 = distinct !{!1034, !"uh_dict_get_key"}
!1035 = !{!1036, !1021}
!1036 = distinct !{!1036, !1037, !"uh_dict_get_key: argument 0"}
!1037 = distinct !{!1037, !"uh_dict_get_key"}
!1038 = !{!1039, !1021}
!1039 = distinct !{!1039, !1040, !"uh_dict_get_key: argument 0"}
!1040 = distinct !{!1040, !"uh_dict_get_key"}
!1041 = !{!1042, !1021}
!1042 = distinct !{!1042, !1043, !"uh_dict_get_key: argument 0"}
!1043 = distinct !{!1043, !"uh_dict_get_key"}
!1044 = !{!1045, !1021}
!1045 = distinct !{!1045, !1046, !"uh_dict_get_key: argument 0"}
!1046 = distinct !{!1046, !"uh_dict_get_key"}
!1047 = !{!1048, !1021}
!1048 = distinct !{!1048, !1049, !"uh_dict_get_key: argument 0"}
!1049 = distinct !{!1049, !"uh_dict_get_key"}
!1050 = !{!1051, !1021}
!1051 = distinct !{!1051, !1052, !"uh_dict_get_key: argument 0"}
!1052 = distinct !{!1052, !"uh_dict_get_key"}
!1053 = !{!1054, !1021}
!1054 = distinct !{!1054, !1055, !"uh_dict_get_key: argument 0"}
!1055 = distinct !{!1055, !"uh_dict_get_key"}
!1056 = !{!1057, !1021}
!1057 = distinct !{!1057, !1058, !"uh_dict_get_key: argument 0"}
!1058 = distinct !{!1058, !"uh_dict_get_key"}
!1059 = !{!1060, !1021}
!1060 = distinct !{!1060, !1061, !"uh_dict_get_key: argument 0"}
!1061 = distinct !{!1061, !"uh_dict_get_key"}
!1062 = !{!1063, !1021}
!1063 = distinct !{!1063, !1064, !"uh_num: argument 0"}
!1064 = distinct !{!1064, !"uh_num"}
!1065 = distinct !{!1065, !23}
!1066 = distinct !{!1066, !23}
!1067 = distinct !{!1067, !23}
!1068 = distinct !{!1068, !23}
!1069 = !{!601, !40, i64 8}
!1070 = !{!601, !40, i64 16}
!1071 = !{!1072, !1021}
!1072 = distinct !{!1072, !1073, !"uh_num: argument 0"}
!1073 = distinct !{!1073, !"uh_num"}
!1074 = !{!1075, !1021}
!1075 = distinct !{!1075, !1076, !"uh_num: argument 0"}
!1076 = distinct !{!1076, !"uh_num"}
!1077 = !{!1078}
!1078 = distinct !{!1078, !1079, !"uh_null: argument 0"}
!1079 = distinct !{!1079, !"uh_null"}
!1080 = !{!1081}
!1081 = distinct !{!1081, !1082, !"uh_str: argument 0"}
!1082 = distinct !{!1082, !"uh_str"}
!1083 = !{!1084, !40, i64 104}
!1084 = !{!"", !9, i64 0, !40, i64 32, !9, i64 40, !40, i64 104}
!1085 = !{!1084, !40, i64 32}
!1086 = distinct !{!1086, !23}
!1087 = !{!1088}
!1088 = distinct !{!1088, !1089, !"uh_sha256_hex: argument 0"}
!1089 = distinct !{!1089, !"uh_sha256_hex"}
!1090 = !{!1091}
!1091 = distinct !{!1091, !1092, !"uh_str: argument 0"}
!1092 = distinct !{!1092, !"uh_str"}
!1093 = !{!1091, !1088}
!1094 = distinct !{!1094, !23}
!1095 = !{!1096}
!1096 = distinct !{!1096, !1097, !"uh_str: argument 0"}
!1097 = distinct !{!1097, !"uh_str"}
!1098 = !{!1099}
!1099 = distinct !{!1099, !1100, !"uh_sha256_hex: argument 0"}
!1100 = distinct !{!1100, !"uh_sha256_hex"}
!1101 = !{!1102}
!1102 = distinct !{!1102, !1103, !"uh_str: argument 0"}
!1103 = distinct !{!1103, !"uh_str"}
!1104 = !{!1102, !1099}
!1105 = !{!1106}
!1106 = distinct !{!1106, !1107, !"uh_str: argument 0"}
!1107 = distinct !{!1107, !"uh_str"}
!1108 = !{!1109}
!1109 = distinct !{!1109, !1110, !"uh_str: argument 0"}
!1110 = distinct !{!1110, !"uh_str"}
!1111 = distinct !{!1111, !23}
!1112 = distinct !{!1112, !23, !955, !1113}
!1113 = !{!"llvm.loop.unroll.runtime.disable"}
!1114 = distinct !{!1114, !23, !955, !1113}
!1115 = !{!1116}
!1116 = distinct !{!1116, !1117, !"uh_str: argument 0"}
!1117 = distinct !{!1117, !"uh_str"}
!1118 = distinct !{!1118, !23, !1113, !955}
!1119 = !{!1120}
!1120 = distinct !{!1120, !1121, !"uh_str: argument 0"}
!1121 = distinct !{!1121, !"uh_str"}
!1122 = !{!1123}
!1123 = distinct !{!1123, !1124, !"uh_str: argument 0"}
!1124 = distinct !{!1124, !"uh_str"}
!1125 = distinct !{!1125, !23}
!1126 = distinct !{!1126, !23}
!1127 = distinct !{!1127, !23}
!1128 = !{!1129}
!1129 = distinct !{!1129, !1130, !"uh_str: argument 0"}
!1130 = distinct !{!1130, !"uh_str"}
!1131 = distinct !{!1131, !23}
!1132 = !{!1133}
!1133 = distinct !{!1133, !1134, !"uh_str: argument 0"}
!1134 = distinct !{!1134, !"uh_str"}
!1135 = !{!1136}
!1136 = distinct !{!1136, !1137, !"uh_str: argument 0"}
!1137 = distinct !{!1137, !"uh_str"}
!1138 = distinct !{!1138, !23}
!1139 = !{!1140}
!1140 = distinct !{!1140, !1141, !"uh_str: argument 0"}
!1141 = distinct !{!1141, !"uh_str"}
!1142 = !{!1143}
!1143 = distinct !{!1143, !1144, !"uh_str: argument 0"}
!1144 = distinct !{!1144, !"uh_str"}
!1145 = distinct !{!1145, !23}
!1146 = distinct !{!1146, !23}
!1147 = !{!1148}
!1148 = distinct !{!1148, !1149, !"uh_str: argument 0"}
!1149 = distinct !{!1149, !"uh_str"}
!1150 = !{!1151}
!1151 = distinct !{!1151, !1152, !"uh_str: argument 0"}
!1152 = distinct !{!1152, !"uh_str"}
!1153 = distinct !{!1153, !23}
!1154 = !{!1155}
!1155 = distinct !{!1155, !1156, !"uh_json_parse_object: argument 0"}
!1156 = distinct !{!1156, !"uh_json_parse_object"}
!1157 = !{!1158}
!1158 = distinct !{!1158, !1159, !"uh_dict_new: argument 0"}
!1159 = distinct !{!1159, !"uh_dict_new"}
!1160 = !{!1161}
!1161 = distinct !{!1161, !1162, !"uh_json_parse_array: argument 0"}
!1162 = distinct !{!1162, !"uh_json_parse_array"}
!1163 = !{!1164}
!1164 = distinct !{!1164, !1165, !"uh_arr_new: argument 0"}
!1165 = distinct !{!1165, !"uh_arr_new"}
!1166 = !{!1167}
!1167 = distinct !{!1167, !1168, !"uh_num: argument 0"}
!1168 = distinct !{!1168, !"uh_num"}
!1169 = !{!1170}
!1170 = distinct !{!1170, !1171, !"uh_num: argument 0"}
!1171 = distinct !{!1171, !"uh_num"}
!1172 = !{!1173}
!1173 = distinct !{!1173, !1174, !"uh_null: argument 0"}
!1174 = distinct !{!1174, !"uh_null"}
!1175 = !{!1176}
!1176 = distinct !{!1176, !1177, !"uh_num: argument 0"}
!1177 = distinct !{!1177, !"uh_num"}
!1178 = !{!1179}
!1179 = distinct !{!1179, !1180, !"uh_null: argument 0"}
!1180 = distinct !{!1180, !"uh_null"}
!1181 = distinct !{!1181, !23}
!1182 = distinct !{!1182, !23}
!1183 = distinct !{!1183, !23}
!1184 = distinct !{!1184, !23}
!1185 = distinct !{!1185, !23}
!1186 = distinct !{!1186, !23}
!1187 = distinct !{!1187, !23}
!1188 = distinct !{!1188, !23}
!1189 = !{!1190}
!1190 = distinct !{!1190, !1191, !"uh_null: argument 0"}
!1191 = distinct !{!1191, !"uh_null"}
!1192 = distinct !{!1192, !23}
!1193 = distinct !{!1193, !23}
