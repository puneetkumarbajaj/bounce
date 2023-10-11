import 'package:flutter/material.dart';

void main() => runApp(Bounce());

class Bounce extends StatefulWidget {
  @override
  _Bounce createState() => _Bounce();
}

class _Bounce extends State<Bounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ballPosition;

  double _ballSpeed = 1.0;
  Color _ballColor = Colors.red;
  bool _sliderStatus = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _ballPosition = Tween<double>(begin: -1.5, end: 0.5).animate(_controller);
  }

  void startBouncing() {
    setState(() {
      _controller.forward();
      _sliderStatus = false;
    });
  }

  void pauseBouncing() {
    setState(() {
      _controller.stop();
      _sliderStatus = true;
    });
  }

  void updateAnimationSpeed(double value) {
    _ballSpeed = value;
    _controller.duration = Duration(seconds: 6-value.toInt());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bouncy Bounce'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.teal,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Change the ball's color",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _ballColor = Colors.red;
                      });
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _ballColor = Colors.blue;
                      });
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _ballColor = Colors.green;
                      });
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 300,
                    height: 300,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 5),
                      curve: Curves.easeInOut,
                      child: Align(
                        alignment: Alignment(0, 0.5 + _ballPosition.value),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: _ballColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: startBouncing,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    child: const Text('Bouncy Bounce'),
                  ),
                  ElevatedButton(
                    onPressed: pauseBouncing,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    child: const Text('No more Bounce :/'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Speedy Speed: ${_ballSpeed.toInt()}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              Slider(
                value: _ballSpeed,
                onChanged: !_sliderStatus
                    ? null
                    : (value) {
                        setState(() {
                          _ballSpeed = value;
                        });
                        updateAnimationSpeed(value);
                      },
                min: 1.0,
                max: 5.0,
                activeColor: Colors.grey,
                inactiveColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}