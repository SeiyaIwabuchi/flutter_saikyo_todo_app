/*
Apiのインタフェース
Apiの実装は気分で変わる可能性があるので、
依存性逆転しておく
 */

abstract interface class ApiClient<A, R> {
  Future<R> rpc({required String rpcName, A arg});

  R get instance;
  set init(R impl);
}