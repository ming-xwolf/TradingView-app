import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/view/home/service/test_tushare_connection.dart';

class TestTusharePage extends StatefulWidget {
  const TestTusharePage({super.key});

  @override
  State<TestTusharePage> createState() => _TestTusharePageState();
}

class _TestTusharePageState extends State<TestTusharePage> {
  bool _isLoading = false;
  String _result = '点击按钮开始测试Tushare连接';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.haiti,
      appBar: AppBar(
        title: const Text('Tushare测试'),
        backgroundColor: ProjectColors.haiti,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: ProjectColors.royalBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      '测试Tushare连接',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _testBasicInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: ProjectColors.royalBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      '测试基础信息API',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ProjectColors.ebonyClay,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ProjectColors.royalBlue.withOpacity(0.3)),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _result = '正在测试Tushare连接...\n';
    });

    try {
      await TestTushareConnection.testConnection();
      setState(() {
        _result += '\n✅ 测试完成！';
      });
    } catch (e) {
      setState(() {
        _result += '\n❌ 测试失败: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testBasicInfo() async {
    setState(() {
      _isLoading = true;
      _result = '正在测试基础信息API...\n';
    });

    try {
      await TestTushareConnection.testBasicInfo();
      setState(() {
        _result += '\n✅ 基础信息API测试完成！';
      });
    } catch (e) {
      setState(() {
        _result += '\n❌ 基础信息API测试失败: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
