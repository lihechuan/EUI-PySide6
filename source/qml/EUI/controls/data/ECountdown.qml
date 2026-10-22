import EUI 1.0
import QtQuick 2.15

EStatistic {
    signal finish()

    countdown: true

    onFinished: finish()
}
